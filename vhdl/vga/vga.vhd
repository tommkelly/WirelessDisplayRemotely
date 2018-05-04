LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY vga IS
PORT (clk	: IN STD_LOGIC ;
	addra	: IN STD_LOGIC_VECTOR(11 DOWNTO 0) ;
	offset  : IN STD_LOGIC_VECTOR(11 DOWNTO 0) ;
	dina	: IN STD_LOGIC_VECTOR(7 DOWNTO 0) ;
	ena		: IN STD_LOGIC ;
	wea		: IN STD_LOGIC_VECTOR(0 DOWNTO 0) ;
	r		: OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
	g		: OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
	b		: OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
	hs		: OUT STD_LOGIC ;
	vs		: OUT STD_LOGIC);
END vga ;

ARCHITECTURE mine OF vga IS
	SIGNAL h : STD_LOGIC_VECTOR(9 DOWNTO 0) := "0000000000" ;
	SIGNAL v : STD_LOGIC_VECTOR(9 DOWNTO 0) := "0000000000" ;
	SIGNAL addrb12 : STD_LOGIC_VECTOR(11 DOWNTO 0) ;
	SIGNAL addrb12_intl : STD_LOGIC_VECTOR(11 DOWNTO 0) ;
	SIGNAL addra14 : STD_LOGIC_VECTOR(13 DOWNTO 0) ;
	SIGNAL douta : STD_LOGIC_VECTOR(0 DOWNTO 0) ;
	SIGNAL vc : STD_LOGIC_VECTOR(9 DOWNTO 0) ;
	SIGNAL hc : STD_LOGIC_VECTOR(9 DOWNTO 0) ;
	SIGNAL hcc : STD_LOGIC_VECTOR(2 DOWNTO 0) ;
	SIGNAL achar : STD_LOGIC_VECTOR(7 DOWNTO 0) ;

	COMPONENT my_char_rom
	PORT (CLKA : IN STD_LOGIC;
		ADDRA : IN STD_LOGIC_VECTOR(13 DOWNTO 0 );
		DOUTA : OUT STD_LOGIC_VECTOR(0 DOWNTO 0 ));
	END COMPONENT;

	COMPONENT my_text_rom
	PORT (CLKA : IN STD_LOGIC;
		CLKB : IN STD_LOGIC;
		ADDRA : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		DINA  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		ENA   : IN STD_LOGIC ;
		WEA	  : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		ADDRB : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		DOUTB : OUT STD_LOGIC_VECTOR(7 DOWNTO 0 ));
	END COMPONENT;	
BEGIN
			 
	vc <= v - 35 ;
	hc <= h - 140 ;
	
	-- addrb12 <= (vc(8 DOWNTO 4) & hc(9 DOWNTO 3)) + offset;
	textaddr:PROCESS(vc, hc, offset)
	BEGIN
	   addrb12_intl <= (vc(8 DOWNTO 4) & hc(9 DOWNTO 3)) + offset;
	   IF (addrb12_intl >= 3840) THEN
	       addrb12 <= addrb12_intl - 3840;
	   ELSE
	       addrb12 <= addrb12_intl;
	   END IF;
	END PROCESS ;
	
	myrom1:my_text_rom
		PORT MAP(CLKA => clk ,
		CLKB => clk,
		ADDRA => addra,
		DINA => dina,
		ENA => ena,
		WEA => wea,
		ADDRB => addrb12 ,
		DOUTB => achar) ;
				 
	hcc <= hc(2 DOWNTO 0) - 2 ;
	addra14 <= (achar(6 DOWNTO 0) & vc(3 DOWNTO 0) & hcc(2 DOWNTO 0)) ;
	
	myrom2:my_char_rom
		PORT MAP(CLKA => clk ,
		ADDRA => addra14 ,
		DOUTA => douta) ;

	horizontal:PROCESS(clk)
	BEGIN
		IF (clk = '1' AND clk'EVENT) THEN
			IF h = 799 THEN
				h <= "0000000000" ;
			ELSE
				h <= h + 1 ;
			END IF ;
		END IF ;
	END PROCESS ;
	
	vertical:PROCESS(clk)
	BEGIN
		IF (clk = '1' AND clk'EVENT) THEN
			IF h = 799 THEN
				IF v = 524 THEN
					v <= "0000000000" ;
				ELSE
					v <= v + 1 ;
				END IF ;
			END IF ;
		END IF ;
	END PROCESS ;

	sync:PROCESS(clk)
	BEGIN
		IF (clk = '1' AND clk'EVENT) THEN
			IF h < 96 THEN
				hs <= '0' ;
			ELSE
				hs <= '1' ;
			END IF ;
			IF v < 523 THEN
				vs <= '1' ;
			ELSE
				vs <= '0' ;
			END IF ;
		END IF ;
		END PROCESS ;
		
		rgb:PROCESS(clk)
		BEGIN
			IF (clk = '1' AND clk'EVENT) THEN
				IF (h > 143) AND (h < 784) AND (v > 34) AND (v < 515) THEN
					r <= douta & douta & douta & douta ;
					b <= douta & douta & douta & douta ;
					g <= douta & douta & douta & douta ;
				ELSE
					r <= "0000" ;
					g <= "0000" ;
					b <= "0000" ;
				END IF ;
			END IF ;
	END PROCESS ;
END mine ;