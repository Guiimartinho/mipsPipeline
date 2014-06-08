library IEEE;
use IEEE.std_logic_1164.all;
use work.p_MI0.all;

entity shift_left is
	generic( 
		size: integer := 32
	);
	
	port (
		a: in reg32;
		num: in integer;
		f: out reg32
	);
end shift_left;



architecture arq_shift_left of shift_left is

	signal temp: reg32 := (others => '0');
begin
	process(a, num)
	begin
		for  i  in 0 to size-(num+1)  loop
			temp(i+num) <= a(i);
	        end loop;      
	end process;

	f <= temp;

end arq_shift_left;	
