library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.p_MI0.all;

entity alu is
       	   port( 
			ctl: in std_logic_vector(2 downto 0);
			a, b : in  reg32;
			result :   out reg32; 
	   		zero : out std_logic
           );
end alu;

architecture alu_arq of alu is 

	signal intReg	: reg32;

begin
	process(a, b, ctl)
	begin
		
		case ctl is
			when  SUBU => intReg <= a - b;
			when  AAND => intReg <= a and b;
			when  OOR  => intReg <= a or b;
			when  ADDU => intReg <= a + b;
			when  SLT  => 
				if a < b then
					intReg <= (0 => '1', others => '0');
				else
					intReg <= (others => '0');
				end if;
			when  others => intReg <= (others => 'X');
		end case;
	end process;

	zero <= '1' when intReg=x"00000000" else '0';
	
	result <= intReg;

end alu_arq;
