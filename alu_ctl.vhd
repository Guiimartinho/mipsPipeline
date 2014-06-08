library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.p_MI0.all;


entity alu_ctl is 
	port (
		ALUOp: in std_logic_vector(1 downto 0);
		Funct: in std_logic_vector(5 downto 0);
		ALUOperation: out std_logic_vector(2 downto 0)
	);
end alu_ctl;

architecture arq_alu_ctl of alu_ctl is
    -- symbolic constants for instruction function code
    constant F_add : std_logic_vector(5 downto 0) := "100000";
    constant F_sub : std_logic_vector(5 downto 0) := "100010";
    constant F_and : std_logic_vector(5 downto 0) := "100100";
    constant F_or  : std_logic_vector(5 downto 0) := "100101";
    constant F_slt : std_logic_vector(5 downto 0) := "101010";

    -- symbolic constants for ALU Operations
    constant ALU_add : std_logic_vector(2 downto 0) := "010";
    constant ALU_sub : std_logic_vector(2 downto 0) := "110";
    constant ALU_and : std_logic_vector(2 downto 0) := "000";
    constant ALU_or  : std_logic_vector(2 downto 0) := "001";
    constant ALU_slt : std_logic_vector(2 downto 0) := "111";

begin

    process (ALUOp, Funct)
    begin
        case ALUOp is 
            when "00" => ALUOperation <= ALU_add;
            when "01" => ALUOperation <= ALU_sub;
            when "10" => 
			case Funct is 
                        	when F_add  => ALUOperation <= ALU_add;
                        	when F_sub  => ALUOperation <= ALU_sub;
                        	when F_and  => ALUOperation <= ALU_and;
                        	when F_or   => ALUOperation <= ALU_or;
                        	when F_slt  => ALUOperation <= ALU_slt;
                        	when others => ALUOperation <= "XXX";
                    	end case;
            when others => ALUOperation <= "XXX";
        end case;
    end process;

end arq_alu_ctl;

