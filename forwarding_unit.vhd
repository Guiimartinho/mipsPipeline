library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.p_MI0.all;

entity forwarding_unit is
	port 	(
			ExMem_RegWr: in std_logic;
			ExMem_Rd: in std_logic_vector(4 downto 0);

			MemWb_RegWr: in std_logic;
			MemWb_Rd: in std_logic_vector(4 downto 0);

			IdEx_Rs: in std_logic_vector(4 downto 0);
			IdEx_Rt: in std_logic_vector(4 downto 0);

			ForwA: out std_logic_vector(1 downto 0);
			ForwB: out std_logic_vector(1 downto 0)
		);
end forwarding_unit;


architecture arq_forwarding_unit of forwarding_unit is



    --input		ExMem_RegWr  -  Sinal de controle do estágio Ex
    --input	[5:0]	ExMem_Rd  -  Endereço do registrador de escrita no estágio Ex

    --input		MemWb_RegWr  -  Sinal de controle do estágio Mem
    --input	[5:0]	MemWb_Rd  -  Endereço do registrador de escrita no estágio Mem
 


   --output RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch;
    --output [1:0] ALUOp;
    --reg    RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch;
    --reg    [1:0] ALUOp;

begin
 process (ExMem_RegWr, ExMem_Rd, MemWb_RegWr, MemWb_Rd, IdEx_Rs, IdEx_Rt)

	begin

	--	ENTRADA A DA ULA
	--	Ex hazard
		if (ExMem_RegWr = '1') 
		and (ExMem_Rd /= "00000") 
		and (ExMem_Rd = IdEx_Rs) then
			ForwA <= "10" ;
	--	Mem hazard
		else 
			if (MemWb_RegWr = '1') 
			and (MemWb_Rd /= "00000") 
			and (ExMem_Rd /= IdEx_Rs)
			and (MemWb_Rd = IdEx_Rs)
			then
				ForwA <= "01" ;
			else
				ForwA <= "00" ;
			end if;
		end if;

	--	ENTRADA B DA ULA
	--	Ex hazard
		if (ExMem_RegWr = '1') 
		and (ExMem_Rd /= "00000") 
		and (ExMem_Rd = IdEx_Rt) 
		then
			ForwB <= "10" ;
	--	Mem hazard
		else 
			if (MemWb_RegWr = '1') 
			and (MemWb_Rd /= "00000") 
			and (ExMem_Rd /= IdEx_Rt)
			and (MemWb_Rd = IdEx_Rt) 
			then
				ForwB <= "01" ;
			else
				ForwB <= "00" ;
			end if;
		end if;
	end process ;

end arq_forwarding_unit;
