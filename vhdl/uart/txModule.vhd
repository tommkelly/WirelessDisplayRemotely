LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY txModule IS
GENERIC (CLKS_PER_TICK : INTEGER);
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
    SIGNAL startsig : STD_LOGIC ;
    SIGNAL stopsig  : STD_LOGIC ;
    SIGNAL index_enable : STD_LOGIC ;
    
    SIGNAL dataReadyIn_2 : STD_LOGIC;
    
    SIGNAL clk_count : INTEGER RANGE 0 TO CLKS_PER_TICK-1;
    SIGNAL index : STD_LOGIC_VECTOR(2 DOWNTO 0);
    
    COMPONENT txDatapath
    GENERIC (CLKS_PER_TICK : INTEGER);
    PORT (
        counter_reset : IN STD_LOGIC ;
        tx_active : IN STD_LOGIC ;
        startsig : IN STD_LOGIC ;
        stopsig : IN STD_LOGIC ;
        index_enable : IN STD_LOGIC ;
        --clk_reset : IN STD_LOGIC ;
        
        clk_count : OUT INTEGER RANGE 0 TO CLKS_PER_TICK-1 ;
        index : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        
        dataReadyIn_2 : OUT STD_LOGIC;
        
        clk : IN STD_LOGIC ;
        dataIn : IN STD_LOGIC_VECTOR(7 DOWNTO 0) ;
        dataReadyIn : IN STD_LOGIC ;
        tx : OUT STD_LOGIC );
     END COMPONENT ;
    
    COMPONENT txControl
    GENERIC (CLKS_PER_TICK : INTEGER);
    PORT (
        clk : IN STD_LOGIC ;
        dataReadyIn : IN STD_LOGIC ;
        clk_count : IN INTEGER RANGE 0 TO CLKS_PER_TICK-1 ;
        index : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        
        counter_reset : OUT STD_LOGIC ;
        tx_active : OUT STD_LOGIC ;
        startsig : OUT STD_LOGIC ;
        stopsig : OUT STD_LOGIC ;
        index_enable : OUT STD_LOGIC );
    END COMPONENT ;
BEGIN
    --clk0 <= clk;
    --dataIn0 <= dataIn;
    --dataReadyIn0 <= dataReadyIn;
    --tx <= tx0;

    mydatapath: txDatapath
    GENERIC MAP (CLKS_PER_TICK => CLKS_PER_TICK)
    PORT MAP (counter_reset,tx_active,startsig,stopsig,index_enable,clk_count,index,dataReadyIn_2,clk,dataIn,dataReadyIn,tx);
    
    mycontrol: txControl
    GENERIC MAP (CLKS_PER_TICK => CLKS_PER_TICK)
    PORT MAP (clk,dataReadyIn_2,clk_count,index,counter_reset,tx_active,startsig,stopsig,index_enable);
END mine;
