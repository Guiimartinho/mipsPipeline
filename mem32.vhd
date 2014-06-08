library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity mem32 is
	generic(	width:	integer:=32;
			depth:	integer:=256;
			addr:	integer:=32
	);

	port(	clock:		in std_logic;	
		mem_read:	in std_logic;
		mem_write:	in std_logic;
		address: 	in std_logic_vector(addr-1 downto 0); 
		data_in: 	in std_logic_vector(width-1 downto 0);
		data_out: 	out std_logic_vector(width-1 downto 0)
	);
end mem32;


architecture arq_mem32 of mem32 is


	type ram_type is array (0 to depth-1) of std_logic_vector(width-1 downto 0);
	signal tmp_ram: ram_type;

	signal address_select: std_logic_vector(29 downto 0);
	
begin	
	address_select <= address(31 downto 2);
			   
    	READ: process(clock, mem_read)
    	begin
	
		if mem_read='1' then
			data_out <= tmp_ram(conv_integer(address_select)); 
		else
			data_out <= (data_out'range => 'Z');
			
		end if;
		
	end process;
	
    	WRITE: process(clock, mem_write)
    	begin
		if falling_edge(clock) then
			if mem_write='1' then
		    		tmp_ram(conv_integer(address_select)) <= data_in;
			end if;
		end if;
    	end process;

	--data_out <= tmp_ram(conv_integer(address_select)); 
	

end arq_mem32;

