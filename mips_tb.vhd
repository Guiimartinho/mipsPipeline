library IEEE;
use IEEE.std_logic_1164.all;
use work.p_MI0.all;


entity mips_tb is
end mips_tb;

architecture behav of mips_tb is
	
       	component mips_pipeline is
		port(  	
			clk, reset : in std_logic
        	);
	end component mips_pipeline;
	
	signal clock: std_logic := '0';
	signal reset: std_logic;	
	
begin
	clock <= not clock after 200 NS;
	
	reset <= '1', '0' after 250 NS;
	
	A: mips_pipeline port map (clock, reset);
	
end behav;

