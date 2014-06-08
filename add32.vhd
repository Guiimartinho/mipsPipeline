library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.p_MI0.all;

entity add32 is
       	   port( 
			a, b : in  reg32;
			result :   out reg32
           );
end add32;

architecture add32_arq of add32 is 

begin
	
	result <= a + b;

end add32_arq;
