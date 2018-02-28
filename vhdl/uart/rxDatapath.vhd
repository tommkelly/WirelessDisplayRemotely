LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL ;
USE IEEE.STD_LOGIC_UNSIGNED.ALL ;

ENTITY rx_datapath IS
    GENERIC (CLKS_PER_TICK : INTEGER);
	PORT (	-- Thou shalt have no other clk before it.
			clk				: IN STD_LOGIC ;
			
			-- Control Inputs
			clk_reset		: IN STD_LOGIC ;
			index_reset		: IN STD_LOGIC ;
			bit_read_en		: IN STD_LOGIC ;
			data_ready		: IN STD_LOGIC ;
			
			-- Control Outputs
			clk_count_outl	: OUT INTEGER RANGE 0 TO CLKS_PER_TICK-1 ;
			index_outl		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0) ;
			
			-- Datapath Inputs
			rx				: IN STD_LOGIC ;
			clr_data_ready  : IN STD_LOGIC ;
			
			-- Datapath Outputs
            data_ready_outl : OUT STD_LOGIC := '0';
			data_out		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		 );
END rx_datapath;

ARCHITECTURE structural OF rx_datapath IS

	-- Back-to-back flip-flops on the asynchronous input
	SIGNAL rx_a			: STD_LOGIC ;
	SIGNAL rx_b			: STD_LOGIC ;
	-- One-hot index for data register
	SIGNAL index_1h		: STD_LOGIC_VECTOR(7 DOWNTO 0) ;
	-- Enable signals for data register
	SIGNAL data_en		: STD_LOGIC_VECTOR(7 DOWNTO 0) ;
	-- Internal copies of outputs
	SIGNAL clk_count    : INTEGER RANGE 0 TO CLKS_PER_TICK-1 ;
	SIGNAL index        : STD_LOGIC_VECTOR(2 DOWNTO 0) ;
	
BEGIN
    -- linking external to internal copies of outputs
    index_outl <= index ;
    clk_count_outl <= clk_count ;
    
	-- Demultiplexer that generates index_1h
	WITH index SELECT
        index_1h <= "00000001" WHEN "000" ,
                    "00000010" WHEN "001" ,
                    "00000100" WHEN "010" ,
                    "00001000" WHEN "011" ,
                    "00010000" WHEN "100" ,
                    "00100000" WHEN "101" ,
                    "01000000" WHEN "110" ,
                    "10000000" WHEN "111" ,
                    "00000000" WHEN OTHERS ;
	
	-- AND gates that generate data_en
	data_en(0) <= index_1h(0) AND bit_read_en ;
    data_en(1) <= index_1h(1) AND bit_read_en ;
    data_en(2) <= index_1h(2) AND bit_read_en ;
    data_en(3) <= index_1h(3) AND bit_read_en ;
    data_en(4) <= index_1h(4) AND bit_read_en ;
    data_en(5) <= index_1h(5) AND bit_read_en ;
    data_en(6) <= index_1h(6) AND bit_read_en ;
    data_en(7) <= index_1h(7) AND bit_read_en ;
	
	-- Fucking flip-flop that I forgot and was the only reason my code wasn't perfect
	data_ready_flop: PROCESS(clk)
	BEGIN
	   IF (clk'EVENT AND clk = '1') THEN
	       IF (clr_data_ready = '1') THEN
	           data_ready_outl <= '0' ;
	       ELSIF (data_ready = '1') THEN
	           data_ready_outl <= '1' ;
	       END IF ;
	   END IF ;
    END PROCESS data_ready_flop ;
	
	-- Back-to-back flip-flops for asynchronous rx input
	rx_flops: PROCESS(clk)
	BEGIN
		IF (clk'EVENT AND clk = '1') THEN
			rx_a <= rx;
			rx_b <= rx_a;
		END IF ;
	END PROCESS rx_flops ;
	
	-- Index counter (counts 8 bits per word)
	index_counter: PROCESS(clk)
	BEGIN
		IF (clk'EVENT AND clk = '1') THEN
			IF (index_reset = '1') THEN
				index <= "000" ;
			ELSIF (bit_read_en = '1') THEN
				index <= index + 1 ;
			END IF ;
		END IF ;
	END PROCESS index_counter ;
	
	-- Clock counter (counts 8 clock ticks per bit)
	clock_counter: PROCESS(clk)
	BEGIN
		IF (clk'EVENT AND clk = '1') THEN
			IF (clk_reset = '1' OR clk_count = CLKS_PER_TICK-1) THEN
				clk_count <= 0 ;
			ELSE
				clk_count <= clk_count + 1 ;
			END IF ;
		END IF ;
	END PROCESS clock_counter ;
	
	-- Data register
	data_register: PROCESS(clk)
	BEGIN
		IF (clk'EVENT AND clk = '1') THEN
			IF (data_en(0) = '1') THEN
				data_out(0) <= rx_b ;
			ELSIF (data_en(1) = '1') THEN
				data_out(1) <= rx_b ;
			ELSIF (data_en(2) = '1') THEN
				data_out(2) <= rx_b ;
			ELSIF (data_en(3) = '1') THEN
				data_out(3) <= rx_b ;
			ELSIF (data_en(4) = '1') THEN
				data_out(4) <= rx_b ;
			ELSIF (data_en(5) = '1') THEN
				data_out(5) <= rx_b ;
			ELSIF (data_en(6) = '1') THEN
				data_out(6) <= rx_b ;
			ELSIF (data_en(7) = '1') THEN
				data_out(7) <= rx_b ;
			END IF ;
		END IF ;
	END PROCESS data_register ;
END structural ;