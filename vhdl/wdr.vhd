LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY wdr IS
PORT (clk : IN STD_LOGIC ;
	r		 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
	g		 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
	b		 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
	hs		 : OUT STD_LOGIC ;
	vs		 : OUT STD_LOGIC ;
	rx_sig : IN STD_LOGIC ;
	tx_sig : OUT STD_LOGIC) ;
END wdr;

ARCHITECTURE structural OF wdr IS
	COMPONENT uart
		GENERIC(CLKS_PER_TICK : INTEGER) ;
		PORT (
			clk      : IN STD_LOGIC ;
			rx       : IN STD_LOGIC ;
			tx       : OUT STD_LOGIC ;
			data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) ;
			data_in  : IN STD_LOGIC_VECTOR(7 DOWNTO 0) ;
			data_ready_out     : OUT STD_LOGIC ;
			data_ready_in      : IN  STD_LOGIC ;
			clr_data_ready_out : IN  STD_LOGIC);
	END COMPONENT;
	
	COMPONENT vga
		PORT (
			clk	: IN STD_LOGIC ;
			addra	: IN STD_LOGIC_VECTOR(11 DOWNTO 0) ;
			offset  : IN STD_LOGIC_VECTOR(11 DOWNTO 0) ;
			dina	: IN STD_LOGIC_VECTOR(7 DOWNTO 0) ;
			ena	: IN STD_LOGIC ;
			wea	: IN STD_LOGIC_VECTOR(0 DOWNTO 0) ;
			r		: OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
			g		: OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
			b		: OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
			hs		: OUT STD_LOGIC ;
			vs		: OUT STD_LOGIC);
	END COMPONENT;
	
	SIGNAL data : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL data_ready : STD_LOGIC;
	SIGNAL reset : STD_LOGIC;
	SIGNAL wea : STD_LOGIC_VECTOR(0 DOWNTO 0);
	
	SIGNAL addr_counter : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000000000";
	SIGNAL scrolling : STD_LOGIC := '0';
	SIGNAL offset : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000000000";
BEGIN
	uartBlock: uart
	GENERIC MAP(CLKS_PER_TICK => 217)
	PORT MAP(
		clk => clk,
		rx => rx_sig,
		tx => tx_sig,
		data_out => data,
		data_in => "00000000",
		data_ready_out => data_ready,
		data_ready_in => '0',
		clr_data_ready_out => data_ready
	);
	
	vgaBlock: vga
	PORT MAP(
		clk => clk,
		addra => addr_counter,
		offset => offset,
		dina => data,
		ena => '1',
		wea => wea,
		r => r,
		g => g,
		b => b,
		hs => hs,
		vs => vs
	);
	
	counter: PROCESS(clk)
	BEGIN
		IF (clk = '1' AND clk'EVENT) THEN
			IF (data_ready = '1') THEN
				addr_counter <= addr_counter + 1;
				IF (scrolling = '1' AND addr_counter(6 DOWNTO 0) = "0000000") THEN
				    offset <= offset + 128;
				    IF (offset >= 3840) THEN
				        offset <= "000000000000";
				    END IF;
				END IF;
				IF (addr_counter >= 3840) THEN
					addr_counter <= "000000000000";
					scrolling <= '1';
				END IF;
			END IF;
			IF (reset = '1') THEN
				addr_counter <= "000000000000";
				offset <= "000000000000";
				scrolling <= '0';
			END IF;
		END IF;
	END PROCESS;
	
	reset <= '1' WHEN data = "00000000" ELSE '0';
	wea <= "" & (data_ready AND (NOT reset));
END structural;