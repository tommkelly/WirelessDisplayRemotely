library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY uart IS
GENERIC (CLKS_PER_TICK : INTEGER);
PORT (
    clk      : IN STD_LOGIC ;
    rx       : IN STD_LOGIC ;
    tx       : OUT STD_LOGIC ;
	data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) ;
	data_in  : IN STD_LOGIC_VECTOR(7 DOWNTO 0) ;
	data_ready_out     : OUT STD_LOGIC ;
	data_ready_in      : IN  STD_LOGIC ;
	clr_data_ready_out : IN  STD_LOGIC);
END uart;

ARCHITECTURE structural OF uart IS
    COMPONENT rxModule
        GENERIC (CLKS_PER_TICK : INTEGER);
        PORT (
            clk             : IN STD_LOGIC ;
            rx              : IN STD_LOGIC ;
            data_out        : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) ;
            data_ready      : OUT STD_LOGIC ;
            clr_data_ready  : IN STD_LOGIC) ;
    END COMPONENT ;
    
    COMPONENT txModule
        GENERIC (CLKS_PER_TICK : INTEGER);
        PORT (
            clk             : IN STD_LOGIC ;
            tx              : OUT STD_LOGIC ;
            dataIn          : IN STD_LOGIC_VECTOR(7 DOWNTO 0) ;
            dataReadyIn     : IN STD_LOGIC) ;
    END COMPONENT ;
    
BEGIN
    rxBlock: rxModule
    GENERIC MAP (CLKS_PER_TICK => CLKS_PER_TICK)
    PORT MAP (
        clk             => clk ,
        rx              => rx ,
        data_out        => data_out ,
        data_ready      => data_ready_out ,
        clr_data_ready  => clr_data_ready_out
    ) ;
    
    txBlock: txModule
    GENERIC MAP (CLKS_PER_TICK => CLKS_PER_TICK)
    PORT MAP (
        clk             => clk ,
        tx              => tx ,
        dataIn          => data_in ,
        dataReadyIn     => data_ready_in
    ) ;
        
END structural;
