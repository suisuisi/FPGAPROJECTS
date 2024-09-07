----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2024 08:58:38 AM
-- Design Name: 
-- Module Name: count_down - Behavioral
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
use IEEE.numeric_std.ALL;


entity count is
    Port ( 
        rst: in std_logic;
        clk : in std_logic;
        count_out : out std_logic_vector(3 downto 0);
        led_rgb : out std_logic_vector(2 downto 0);
        S_BSCAN_drck : in std_logic;
        S_BSCAN_shift : in std_logic;
        S_BSCAN_tdi : in std_logic;
        S_BSCAN_update : in std_logic;
        S_BSCAN_sel: in std_logic;
        S_BSCAN_tdo: out std_logic;
        S_BSCAN_tms: in std_logic;
        S_BSCAN_tck: in std_logic;
        S_BSCAN_runtest: in std_logic;
        S_BSCAN_reset: in std_logic;
        S_BSCAN_capture: in std_logic;
        S_BSCAN_bscanid_en: in std_logic  
    );
end count;

architecture rtl of count is

	component ila_count_down is
	port (
		clk : in std_logic;
		probe0 : in std_logic_vector(3 downto 0)
	);
	end component;

	constant G_WIDTH : natural := 32;
	constant G_CLK_FREQ : natural := 250000000;

	subtype t_count is natural; -- range 0 to 2**(G_WIDTH-1)-1;

	signal period_count : t_count := 0; 

	signal pwm_period : std_logic_vector(G_WIDTH-1 downto 0) := std_logic_vector(to_unsigned(G_CLK_FREQ, G_WIDTH));
	signal pwm_duty : std_logic_vector(G_WIDTH-1 downto 0) := std_logic_vector(to_unsigned(G_CLK_FREQ/2, G_WIDTH));
	signal pwm : std_logic := '0';

begin

	proc_count: process(clk)
	begin
		if(rising_edge(clk)) then
			if(period_count < to_integer(unsigned(pwm_period)-1)) then
				period_count <= period_count + 1;
			else
				period_count <= 0;
			end if;
		end if;
	end process;


	proc_out: process(clk)
	begin
		if(rising_edge(clk)) then
			if(period_count < to_integer(unsigned(pwm_duty))) then
				pwm <= '0';
			else
				pwm <= '1';
			end if;
		end if;
	end process;
	
	count_out <= std_logic_vector(to_unsigned(period_count, count_out'length));
	led_rgb <= '0' & '0' & pwm;

	inst_ila: component ila_count_down
	port map (
		clk => clk,
		probe0 => std_logic_vector(to_unsigned(period_count, count_out'length))
	);

end rtl;
