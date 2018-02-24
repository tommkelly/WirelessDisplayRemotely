LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY txModule IS
PORT (
    clk : IN STD_LOGIC ;
	dataIn : IN STD_LOGIC_VECTOR(7 DOWNTO 0) ;
	dataReadyIn : IN STD_LOGIC ;
	tx : OUT STD_LOGIC );
END txModule;

ARCHITECTURE mine OF txModule IS

    --SIGNAL clk0 : STD_LOGIC ;
	--SIGNAL dataIn0 : STD_LOGIC_VECTOR(7 DOWNTO 0) ;
	--SIGNAL dataReadyIn0 : STD_LOGIC ;
	--SIGNAL tx0 : STD_LOGIC ;

    SIGNAL counter_reset : STD_LOGIC ;
    SIGNAL tx_active : STD_LOGIC ;
    SIGNAL start_stop : STD_LOGIC ;
    SIGNAL index_enable : STD_LOGIC ;
    
    SIGNAL dataReadyIn_2 : STD_LOGIC;
    
    SIGNAL clk_count : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL index : STD_LOGIC_VECTOR(2 DOWNTO 0);
    
    COMPONENT txDatapath
    PORT (
        counter_reset : IN STD_LOGIC ;
        tx_active : IN STD_LOGIC ;
        start_stop : IN STD_LOGIC ;
        index_enable : IN STD_LOGIC ;
        --clk_reset : IN STD_LOGIC ;
        
        clk_count : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) ;
        index : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        
        dataReadyIn_2 : OUT STD_LOGIC;
        
        clk : IN STD_LOGIC ;
        dataIn : IN STD_LOGIC_VECTOR(7 DOWNTO 0) ;
        dataReadyIn : IN STD_LOGIC ;
        tx : OUT STD_LOGIC );
     END COMPONENT ;
    
    COMPONENT txControl
    PORT (
        clk : IN STD_LOGIC ;
        dataReadyIn : IN STD_LOGIC ;
        clk_count : IN STD_LOGIC_VECTOR(2 DOWNTO 0) ;
        index : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        
        counter_reset : OUT STD_LOGIC ;
        tx_active : OUT STD_LOGIC ;
        start_stop : OUT STD_LOGIC ;
        index_enable : OUT STD_LOGIC );
    END COMPONENT ;
BEGIN
    --clk0 <= clk;
    --dataIn0 <= dataIn;
    --dataReadyIn0 <= dataReadyIn;
    --tx <= tx0;

    mydatapath: txDatapath
    PORT MAP (counter_reset,tx_active,start_stop,index_enable,clk_count,index,dataReadyIn_2,clk,dataIn,dataReadyIn,tx);
    
    mycontrol: txControl
    PORT MAP (clk,dataReadyIn_2,clk_count,index,counter_reset,tx_active,start_stop,index_enable);
END mine;
