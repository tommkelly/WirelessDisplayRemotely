LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY loopbackFull IS
PORT (clk : IN STD_LOGIC ;
	r		 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
	g		 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
	b		 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
	hs		 : OUT STD_LOGIC ;
	vs		 : OUT STD_LOGIC ;
	rx_sig : IN STD_LOGIC ;
	tx_sig : OUT STD_LOGIC) ;
END loopbackFull;

ARCHITECTURE structural of loopbackFull IS

	COMPONENT loopback
		PORT (
			clk         : IN STD_LOGIC ;
			rx_sig      : IN STD_LOGIC ;
			tx_sig      : OUT STD_LOGIC) ;
	END COMPONENT;
	
	COMPONENT vga
		PORT (
			clk	: IN STD_LOGIC ;
			addra	: IN STD_LOGIC_VECTOR(11 DOWNTO 0) ;
			dina	: IN STD_LOGIC_VECTOR(7 DOWNTO 0) ;
			ena	: IN STD_LOGIC ;
			wea	: IN STD_LOGIC_VECTOR(0 DOWNTO 0) ;
			r		: OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
			g		: OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
			b		: OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ;
			hs		: OUT STD_LOGIC ;
			vs		: OUT STD_LOGIC);
	END COMPONENT;

BEGIN

	myloopback: loopback
	PORT MAP (
		clk => clk,
		rx_sig => rx_sig,
		tx_sig => tx_sig
	);
	
	myvga: vga 
	PORT MAP (
		clk => clk,
		addra => "000000000000",
		dina => "00000000",
		ena => '1',
		wea => "0",
		r => r,
		g => g,
		b => b,
		hs => hs,
		vs => vs
	);

END structural;