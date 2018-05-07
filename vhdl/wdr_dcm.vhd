LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY wdr_dcm IS
PORT (clk : IN STD_LOGIC ;
	r		 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
	g		 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
	b		 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
	hs		 : OUT STD_LOGIC ;
	vs		 : OUT STD_LOGIC ;
	rx_sig : IN STD_LOGIC ;
	tx_sig : OUT STD_LOGIC) ;
END wdr_dcm;

ARCHITECTURE structural OF wdr_dcm IS
	COMPONENT wdr IS
	PORT (clk : IN STD_LOGIC ;
		r		 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
		g		 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
		b		 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
		hs		 : OUT STD_LOGIC ;
		vs		 : OUT STD_LOGIC ;
		rx_sig : IN STD_LOGIC ;
		tx_sig : OUT STD_LOGIC) ;
	END COMPONENT;
	
	COMPONENT clk_wiz_0 IS
	PORT (clk_in1 : IN STD_LOGIC ;
		clk_out1 : OUT STD_LOGIC ) ;
	END COMPONENT;
	
	SIGNAL clk_intl : STD_LOGIC;
	
BEGIN

	wdrBlock: wdr
	PORT MAP(
		clk => clk_intl,
		r => r,
		g => g,
		b => b,
		hs => hs,
		vs => vs,
		rx_sig => rx_sig,
		tx_sig => tx_sig
	);
	
	clkBlock: clk_wiz_0
	PORT MAP(
		clk_in1 => clk,
		clk_out1 => clk_intl
	);
	
END structural;