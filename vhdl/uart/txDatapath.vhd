LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY txDatapath IS
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
END txDatapath ;

ARCHITECTURE mine OF txDatapath IS
	SIGNAL dataIn_1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL dataIn_2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	SIGNAL dataReadyIn_1 : STD_LOGIC ;
	SIGNAL dataReadyIn_2_0 : STD_LOGIC ;
	
	SIGNAL clk_count0 : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL index0 : STD_LOGIC_VECTOR(2 DOWNTO 0);
		
BEGIN

    clk_count <= clk_count0;
    index <= index0;
    dataReadyIn_2 <= dataReadyIn_2_0;
    
	datainflops: PROCESS(clk)
	BEGIN
		IF (clk'EVENT AND clk='1') THEN
			dataIn_1 <= dataIn;
			dataIn_2 <= dataIn_1;
		END IF ;
	END PROCESS datainflops ;
	
	datareadyflops: PROCESS(clk)
	BEGIN
		IF (clk'EVENT AND clk='1') THEN
			dataReadyIn_1 <= dataReadyIn;
			dataReadyIn_2_0 <= dataReadyIn_1;
		END IF ;
	END PROCESS datareadyflops ;
	
	clkcounter: PROCESS(clk)
	BEGIN
		IF (clk'EVENT AND clk='1') THEN
			IF (counter_reset = '1') THEN
				clk_count0 <= "000";
			ELSE
				clk_count0 <= clk_count0 + 1;
			END IF;
		END IF ;
	END PROCESS clkcounter ;
	
	indexcounter: PROCESS(clk)
	BEGIN
		IF (clk'EVENT AND clk='1') THEN
			IF (counter_reset = '1') THEN
				index0 <= "000";
			END IF;
			IF (index_enable = '1') THEN
				index0 <= index0 + 1;
			END IF;
		END IF ;
	END PROCESS indexcounter ;
	
	txproc: PROCESS(clk)
	   VARIABLE data_bit : STD_LOGIC;
	BEGIN 
	   WITH index0 SELECT
	       data_bit := dataIn_2(0) WHEN "000",
	                   dataIn_2(1) WHEN "001",
                       dataIn_2(2) WHEN "010",
	                   dataIn_2(3) WHEN "011",
	                   dataIn_2(4) WHEN "100",
	                   dataIn_2(5) WHEN "101",
	                   dataIn_2(6) WHEN "110",
	                   dataIn_2(7) WHEN "111" ,
	                   dataIn_2(0) WHEN OTHERS;
	   IF (clk'EVENT AND clk='1') THEN
	       tx <= (not start_stop) and ((not tx_active) or data_bit);
	   END IF ;
	END PROCESS txproc ;

END mine;