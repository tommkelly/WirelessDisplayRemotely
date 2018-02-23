LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY txControl IS
PORT (
    clk : IN STD_LOGIC ;
    dataReadyIn : IN STD_LOGIC ;
    clk_count : IN STD_LOGIC_VECTOR(2 DOWNTO 0) ;
    index : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    
    counter_reset : OUT STD_LOGIC ;
    tx_active : OUT STD_LOGIC ;
    start_stop : OUT STD_LOGIC ;
    index_enable : OUT STD_LOGIC );
END txControl;

ARCHITECTURE mine OF txControl IS
    TYPE states IS (idle, start, write, stopst);
    SIGNAL state : states := idle;
    SIGNAL nxt_state : states := idle;
BEGIN

    clkd: PROCESS(clk)
    BEGIN
        IF (clk'EVENT AND clk='1') THEN
            state <= nxt_state;
        END IF;
    END PROCESS clkd ;
    
    state_trans: PROCESS (dataReadyIn, clk_count, index)
    BEGIN
        nxt_state <= state;
        CASE state IS
            WHEN idle => IF (dataReadyIn = '1') THEN
                            nxt_state <= start;
                         END IF;
            WHEN start => IF (clk_count = "111") THEN
                            nxt_state <= write;
                          END IF;
            WHEN write => IF (clk_count = "111" and index = "111") THEN
                            nxt_state <= stopst;
                          END IF;
            WHEN stopst => IF (clk_count = "111") THEN
                            nxt_state <= idle;
                          END IF;
         END CASE;
    END PROCESS state_trans;
    
    counter_reset <= '1' WHEN (state=idle and dataReadyIn='0') ELSE '0';
    tx_active <= '1' WHEN 
        (state=idle and dataReadyIn='1') or 
        (state=start) or
        (state=write) or
        (state=stopst) ELSE '0';
    start_stop <= '1' WHEN 
        (state=idle and dataReadyIn='1') or
        (state=start) or
        (state=stopst) ELSE '0';
    index_enable <= '1' WHEN
        (state=write and clk_count="111") ELSE '0';
    --clk_reset <= '1' WHEN (state=idle and dataReadyIn='0') ELSE '0';
END mine;
