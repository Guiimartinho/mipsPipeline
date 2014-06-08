library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;   
use work.p_MI0.all;

entity mux2 is
       generic(
		size: integer := 32
	);
       port( 
		sel: in std_logic;
		a, b: in std_logic_vector(size-1 downto 0);
             	f: out std_logic_vector(size-1 downto 0) 
           );
end mux2;

architecture arq_mux2 of mux2 is

begin            

    M: process(a,b,sel)
    begin
	if sel = '0' then
		f <= a; 
	else
		f <= b;
	end if;

    end process;
   
end arq_mux2;
