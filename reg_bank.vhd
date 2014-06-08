--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Banco de registradores - 31 registradores de uso geral - reg(0): cte 0
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE;
use IEEE.Std_Logic_1164.all;
use ieee.STD_LOGIC_UNSIGNED.all;   
use work.p_MI0.all;

entity reg_bank is
       port( ck, rst, wreg :    in std_logic;
             AdRs, AdRt, adRD : in std_logic_vector( 4 downto 0);
             RA, RB: out reg32;
	     RW : in reg32
           );
end reg_bank;

architecture reg_bank of reg_bank is
   type bank is array(0 to 31) of reg32;
   signal reg : bank;                            
   signal wen : reg32;
begin            

    g1: for i in 0 to 31 generate        

        wen(i) <= '1' when i/=0 and adRD=i and wreg='1' else '0';
         
        rx: entity work.reg32_ce
			port map(ck=>ck, rst=>rst, ce=>wen(i), D=>RW, Q=>reg(i));                   
        
    end generate g1;      

    RA <= reg(CONV_INTEGER(AdRs));    -- seleção do fonte 1  

    RB <= reg(CONV_INTEGER(AdRt));    -- seleção do fonte 2 
   
end reg_bank;
