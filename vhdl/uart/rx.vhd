----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/14/2018 12:21:48 AM
-- Design Name: 
-- Module Name: testbench - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY rx IS
PORT (
    clk             : IN STD_LOGIC ;
    rx              : IN STD_LOGIC ;
    data_out        : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    data_ready      : OUT STD_LOGIC ;
    clr_data_ready  : IN STD_LOGIC );
END rx;

ARCHITECTURE structural OF rx IS
    COMPONENT control_uart
        PORT (  
                clk         : IN STD_LOGIC ;
                Rx          : IN STD_LOGIC  ;
                clk_count   : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
                index       : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
                index_reset : OUT STD_LOGIC;
                clk_reset   : OUT STD_LOGIC;
                bit_read_enable: OUT STD_LOGIC;
                data_ready  : OUT STD_LOGIC);
    END COMPONENT ;
    COMPONENT rx_datapath
            PORT (
                clk          : IN STD_LOGIC ;
                clk_reset        : IN STD_LOGIC ;
                index_reset        : IN STD_LOGIC ;
                bit_read_en        : IN STD_LOGIC ;
                data_ready        : IN STD_LOGIC ;
                clk_count_outl        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) ;
                index_outl            : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) ;
                rx                : IN STD_LOGIC ;
                data_ready_outl    : OUT STD_LOGIC ;
                data_out        : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
                clr_data_ready  : IN STD_LOGIC
         );
    END COMPONENT ;
    
    SIGNAL clk_count    : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL index        : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL index_reset  : STD_LOGIC;
    SIGNAL clk_reset    : STD_LOGIC;
    SIGNAL bit_read_en  : STD_LOGIC;
    SIGNAL data_ready_inl: STD_LOGIC;
    
BEGIN
    rxControlBlock: control_uart
        PORT MAP (  
            clk         => clk,
            Rx          => rx,
            clk_count   => clk_count,
            index       => index,
            index_reset => index_reset,
            clk_reset   => clk_reset,
            bit_read_enable => bit_read_en,
            data_ready  => data_ready_inl);
                    
    rxDatapathBlock: rx_datapath
        PORT MAP (
            clk         => clk,
            clk_reset   => clk_reset,
            index_reset => index_reset,
            bit_read_en => bit_read_en,
            data_ready  => data_ready_inl,
            clk_count_outl   => clk_count,
            index_outl       => index,
            rx          => rx,
            data_ready_outl => data_ready,
            data_out    => data_out,
            clr_data_ready => clr_data_ready
        );
END structural ;
