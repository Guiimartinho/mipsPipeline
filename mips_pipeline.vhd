library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_bit.all;
use work.p_MI0.all;

entity mips_pipeline is
	port (
		clk: in std_logic;
		reset: in std_logic
	);
end mips_pipeline;


architecture arq_mips_pipeline of mips_pipeline is
   

    -- ********************************************************************
    --                              Signal Declarations
    -- ********************************************************************
     
    -- IF Signal Declarations
    
    signal IF_instr, IF_pc, IF_pc_next, IF_pc4 : reg32 := (others => '0');

    -- ID Signal Declarations

    signal ID_instr, ID_pc4 :reg32;  -- pipeline register values from EX
    signal ID_op, ID_funct: std_logic_vector(5 downto 0);
    signal ID_rs, ID_rt, ID_rd: std_logic_vector(4 downto 0);
    signal ID_immed: std_logic_vector(15 downto 0);
    signal ID_extend, ID_A, ID_B: reg32;
    signal ID_RegWrite, ID_Branch, ID_RegDst, ID_MemtoReg, ID_MemRead, ID_MemWrite, ID_ALUSrc: std_logic; --ID Control Signals
    signal ID_ALUOp: std_logic_vector(1 downto 0);

    -- EX Signals

    signal EX_pc4, EX_extend, EX_A, EX_B: reg32;
    signal EX_offset, EX_btgt, EX_alub, EX_ALUOut: reg32;
    signal EX_rt, EX_rd: std_logic_vector(4 downto 0);
    signal EX_RegRd: std_logic_vector(4 downto 0);
    signal EX_funct: std_logic_vector(5 downto 0);
    signal EX_RegWrite, EX_Branch, EX_RegDst, EX_MemtoReg, EX_MemRead, EX_MemWrite, EX_ALUSrc: std_logic;  -- EX Control Signals
    signal EX_Zero: std_logic;
    signal EX_ALUOp: std_logic_vector(1 downto 0);
    signal EX_Operation: std_logic_vector(2 downto 0);

    

   -- MEM Signals

    signal MEM_PCSrc: std_logic;
    signal MEM_RegWrite, MEM_Branch, MEM_MemtoReg, MEM_MemRead, MEM_MemWrite, MEM_Zero: std_logic;
    signal MEM_btgt, MEM_ALUOut, MEM_B: reg32;
    signal MEM_memout: reg32;
    signal MEM_RegRd: std_logic_vector(4 downto 0);
   

    -- WB Signals

    signal WB_RegWrite, WB_MemtoReg: std_logic;  -- WB Control Signals
    signal WB_memout, WB_ALUOut: reg32;
    signal WB_wd: reg32;
    signal WB_RegRd: std_logic_vector(4 downto 0);



begin -- BEGIN MIPS_PIPELINE ARCHITECTURE

    -- ********************************************************************
    --                              IF Stage
    -- ********************************************************************

    -- IF Hardware

    PC: entity work.reg port map (clk, reset, IF_pc_next, IF_pc);

    PC4: entity work.add32 port map (IF_pc, x"00000004", IF_pc4);

    MX2: entity work.mux2 port map (MEM_PCSrc, IF_pc4, MEM_btgt, IF_pc_next);

    ROM_INST: entity work.rom32 port map (IF_pc, IF_instr);

    IF_s: process(clk)
    begin     			-- IF/ID Pipeline Register
    	if rising_edge(clk) then
        	if reset = '1' then
            		ID_instr <= (others => '0');
            		ID_pc4   <= (others => '0');
        	else
            		ID_instr <= IF_instr;
            		ID_pc4   <= IF_pc4;
        	end if;
	end if;
    end process;



    -- ********************************************************************
    --                              ID Stage
    -- ********************************************************************

    ID_op <= ID_instr(31 downto 26);
    ID_rs <= ID_instr(25 downto 21);
    ID_rt <= ID_instr(20 downto 16);
    ID_rd <= ID_instr(15 downto 11);
    ID_immed <= ID_instr(15 downto 0);


    REG_FILE: entity work.reg_bank port map ( clk, reset, WB_RegWrite, ID_rs, ID_rt, WB_RegRd, ID_A, ID_B, WB_wd);


    -- sign-extender
    EXT: process(ID_immed)
    begin
	if ID_immed(15) = '1' then
		ID_extend <= x"FFFF" & ID_immed(15 downto 0);
	else
		ID_extend <= x"0000" & ID_immed(15 downto 0);
	end if;
    end process;
    

    CTRL: entity work.control_pipeline port map (ID_op, ID_RegDst, ID_ALUSrc, ID_MemtoReg, ID_RegWrite, ID_MemRead, ID_MemWrite, ID_Branch, ID_ALUOp);


    ID_EX_pip: process(clk)		    -- ID/EX Pipeline Register
    begin
	if rising_edge(clk) then
        	if reset = '1' then
            		EX_RegDst   <= '0';
	    		EX_ALUOp    <= (others => '0');
            		EX_ALUSrc   <= '0';
		    	EX_Branch   <= '0';
			EX_MemRead  <= '0';
			EX_MemWrite <= '0';
			EX_RegWrite <= '0';
			EX_MemtoReg <= '0';

			EX_pc4      <= (others => '0');
			EX_A        <= (others => '0');
			EX_B        <= (others => '0');
			EX_extend   <= (others => '0');
			EX_rt       <= (others => '0');
			EX_rd       <= (others => '0');
        	else 
            		EX_RegDst   <= ID_RegDst;
            		EX_ALUOp    <= ID_ALUOp;
            		EX_ALUSrc   <= ID_ALUSrc;
            		EX_Branch   <= ID_Branch;
            		EX_MemRead  <= ID_MemRead;
            		EX_MemWrite <= ID_MemWrite;
            		EX_RegWrite <= ID_RegWrite;
            		EX_MemtoReg <= ID_MemtoReg;
          
            		EX_pc4      <= ID_pc4;
            		EX_A        <= ID_A;
            		EX_B        <= ID_B;
            		EX_extend   <= ID_extend;
            		EX_rt       <= ID_rt;
            		EX_rd       <= ID_rd;
        	end if;
	end if;
    end process;

    -- ********************************************************************
    --                              EX Stage
    -- ********************************************************************

    -- branch offset shifter
    SIGN_EXT: entity work.shift_left port map (EX_extend, 2, EX_offset);

    EX_funct <= EX_extend(5 downto 0);  

    BRANCH_ADD: entity work.add32 port map (EX_pc4, EX_offset, EX_btgt);

    ALU_MUX_A: entity work.mux2 port map (EX_ALUSrc, EX_B, EX_extend, EX_alub);

    ALU_h: entity work.alu port map (EX_Operation, EX_A, EX_alub, EX_ALUOut, EX_Zero);

    DEST_MUX2: entity work.mux2 generic map (5) port map (EX_RegDst, EX_rt, EX_rd, EX_RegRd);

    ALU_c: entity work.alu_ctl port map (EX_ALUOp, EX_funct, EX_Operation);

    EX_MEM_pip: process (clk)		    -- EX/MEM Pipeline Register
    begin
	if rising_edge(clk) then
        	if reset = '1' then
        
            		MEM_Branch   <= '0';
            		MEM_MemRead  <= '0';
            		MEM_MemWrite <= '0';
            		MEM_RegWrite <= '0';
            		MEM_MemtoReg <= '0';
            		MEM_Zero     <= '0';

            		MEM_btgt     <= (others => '0');
            		MEM_ALUOut   <= (others => '0');
            		MEM_B        <= (others => '0');
            		MEM_RegRd    <= (others => '0');
        	else
            		MEM_Branch   <= EX_Branch;
            		MEM_MemRead  <= EX_MemRead;
            		MEM_MemWrite <= EX_MemWrite;
            		MEM_RegWrite <= EX_RegWrite;
            		MEM_MemtoReg <= EX_MemtoReg;
            		MEM_Zero     <= EX_Zero;

            		MEM_btgt     <= EX_btgt;
            		MEM_ALUOut   <= EX_ALUOut;
            		MEM_B        <= EX_B;
            		MEM_RegRd    <= EX_RegRd;
        	end if;
	end if;
    end process;

    -- ********************************************************************
    --                              MEM Stage
    -- ********************************************************************

    MEM_ACCESS: entity work.mem32 port map (clk, MEM_MemRead, MEM_MemWrite, MEM_ALUOut, MEM_B, MEM_memout);

    MEM_PCSrc <= MEM_Branch and MEM_Zero;

    MEM_WB_pip: process (clk)		-- MEM/WB Pipeline Register
    begin
	if rising_edge(clk) then
	        if reset = '1' then
            		WB_RegWrite <= '0';
            		WB_MemtoReg <= '0';
            		WB_ALUOut   <= (others => '0');
            		WB_memout   <= (others => '0');
            		WB_RegRd    <= (others => '0');
        	else
            		WB_RegWrite <= MEM_RegWrite;
            		WB_MemtoReg <= MEM_MemtoReg;
            		WB_ALUOut   <= MEM_ALUOut;
            		WB_memout   <= MEM_memout;
            		WB_RegRd    <= MEM_RegRd;
        	end if;
	end if;
    end process;       

    -- ********************************************************************
    --                              WB Stage
    -- ********************************************************************

    MUX_DEST: entity work.mux2 port map (WB_MemtoReg, WB_ALUOut, WB_memout, WB_wd);
    
    --REG_FILE: reg_bank port map (clk, reset, WB_RegWrite, ID_rs, ID_rt, WB_RegRd, ID_A, ID_B, WB_wd); *instance is the same of that in the ID stage


end arq_mips_pipeline;

