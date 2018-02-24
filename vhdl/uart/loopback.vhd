library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY loopback IS
PORT (
    clk         : IN STD_LOGIC ;
    rx_sig      : IN STD_LOGIC ;
    tx_sig      : OUT STD_LOGIC) ;
END loopback;

ARCHITECTURE structural OF loopback IS

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
    
    SIGNAL data             : STD_LOGIC_VECTOR(7 DOWNTO 0) ;
    SIGNAL data_ready       : STD_LOGIC ;
    SIGNAL clr_data_ready   : STD_LOGIC ;
    
BEGIN
    
	uartBlock : uart
	GENERIC MAP (CLKS_PER_TICK => 217)
	PORT MAP (
		clk				=> clk ,
		rx				=> rx_sig ,
		tx				=> tx_sig ,
		data_out		=> data ,
		data_in			=> data ,
		data_ready_out	=> data_ready ,
		data_ready_in	=> data_ready ,
		clr_data_ready_out	=> clr_data_ready
	) ;
	
    clr_data_ready <= data_ready ;
    
END structural;
