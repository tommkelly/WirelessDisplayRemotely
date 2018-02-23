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
    COMPONENT rx
        PORT (
            clk             : IN STD_LOGIC ;
            rx              : IN STD_LOGIC ;
            data_out        : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) ;
            data_ready      : OUT STD_LOGIC ;
            clr_data_ready  : IN STD_LOGIC) ;
    END COMPONENT ;
    
    COMPONENT tx
        PORT (
            clk             : IN STD_LOGIC ;
            tx              : OUT STD_LOGIC ;
            dataIn          : IN STD_LOGIC_VECTOR(7 DOWNTO 0) ;
            dataReadyIn     : IN STD_LOGIC) ;
    END COMPONENT ;
    
    SIGNAL data             : STD_LOGIC_VECTOR(7 DOWNTO 0) ;
    SIGNAL data_ready       : STD_LOGIC ;
    SIGNAL clr_data_ready   : STD_LOGIC ;
    
BEGIN
    rxBlock: rx
    PORT MAP (
        clk             => clk ,
        rx              => rx_sig ,
        data_out        => data ,
        data_ready      => data_ready ,
        clr_data_ready  => clr_data_ready
    ) ;
    
    txBlock: tx
    PORT MAP (
        clk             => clk ,
        tx              => tx_sig ,
        dataIn          => data ,
        dataReadyIn     => data_ready
    ) ;
    
    clr_data_ready <= data_ready ;
    
END structural;
