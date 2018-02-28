--Control for Tx and Rx in UART

LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


entity control_uart is
GENERIC (CLKS_PER_TICK : INTEGER);
PORT (clk : IN STD_LOGIC ;
      Rx : IN STD_LOGIC  ;
      clk_count : IN INTEGER RANGE 0 TO CLKS_PER_TICK-1;
      index : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      index_reset : OUT STD_LOGIC;
      clk_reset : OUT STD_LOGIC;
      bit_read_enable : OUT STD_LOGIC;
      data_ready : OUT STD_LOGIC);
end control_uart;

architecture Behavioral of control_uart is

TYPE states IS ( IDLE, START, READ, STOP);

SIGNAL state : states := IDLE;
SIGNAL next_state : states := IDLE;



begin

--Implement the state register
clkd : PROCESS(clk)
begin
IF (clk'EVENT AND clk='1') THEN
 state <= next_state;
 end if;
end PROCESS clkd;


--State Transistions
state_trans : PROCESS(state, Rx, clk_count, index)
begin
  next_state <= state;

  Case state IS
    WHEN IDLE => if (Rx = '0') then
                   next_state <= START;
                 else
                   next_state <= IDLE;
                 end if;
                   
    WHEN START => if ( Rx = '1' ) then
                    next_state <= IDLE;
                  elsif ( clk_count = CLKS_PER_TICK/2 ) then
                    next_state <= READ;
                  else
                    next_state <= START;
                  end if;
                  
    WHEN READ => if ( (clk_count = CLKS_PER_TICK-1  and index = 7 ) ) then
                   next_state <= STOP;
                 else
                   next_state <= READ;
                 end if;
                 
    WHEN STOP => if ( clk_count = CLKS_PER_TICK-1 ) then
                   next_state <= IDLE;
                 else 
                   next_state <= STOP;
                 end if;
    
    end Case;
end PROCESS state_trans ;


--Define Outputs
output : PROCESS(clk_count, state)
begin
  Case state IS
  
  WHEN IDLE => index_reset <= '1';
               clk_reset <= '1';
               bit_read_enable <= '0';
               data_ready <= '0';
               
  WHEN START => if ( clk_count = CLKS_PER_TICK/2) then
                  clk_reset <= '1';
                else
                  clk_reset <= '0';
                end if;
                index_reset <= '0';
                bit_read_enable <= '0';
                data_ready <= '0';
                
  WHEN READ => if ( clk_count = CLKS_PER_TICK-1 ) then
                 bit_read_enable <= '1';
               else
                 bit_read_enable <= '0';
               end if;
               index_reset <= '0';
               clk_reset <= '0';
               data_ready <= '0';
               
  WHEN STOP => if ( clk_count = CLKS_PER_TICK-1 ) then
                 data_ready <= '1';
               else
                 data_ready <= '0';
               end if;
               bit_read_enable <= '0';
               index_reset <= '0';
               clk_reset <= '0';
               
  end Case;

end PROCESS output;

end Behavioral;
