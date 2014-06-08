library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.p_MI0.all;

entity hazard_unit is
	port(
			ID_rt, ID_rs, EX_rt: in std_logic_vector(4 downto 0);
			EX_MemRead: in std_logic;
			PCWrite, ID_Flush: out std_logic
		);	
end hazard_unit;

architecture hazard_unit_arq of hazard_unit is 
begin

	process(ID_rt, ID_rs, EX_rt, EX_MemRead)
	begin
		if (EX_MemRead = '1') and ((ID_rt = EX_rt) or (ID_rs = EX_rt)) then
			PCWrite <= '0';
			--ID_Write <= '0';
			ID_Flush <= '1';
		else
			PCWrite <= '1';
			--ID_Write <= '1';
			ID_Flush <= '0';
		end if;

	end process;

end hazard_unit_arq;
