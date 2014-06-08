--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- package com tipos básicos
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE;
use IEEE.Std_Logic_1164.all;

package p_MI0 is  
  
  subtype reg32 is std_logic_vector(31 downto 0);  
  -- tipo para os barramentos de 32 bits
  
  --type inst_type is (ADDU, SUBU, AAND, OOR, XXOR, NNOR, LW, SW, ORI, invalid_instruction);
  constant ADDU: std_logic_vector(2 downto 0) := "010";
  constant SUBU: std_logic_vector(2 downto 0) := "110";
  constant AAND: std_logic_vector(2 downto 0) := "000";
  constant OOR: std_logic_vector(2 downto 0) := "001";
  constant SLT: std_logic_vector(2 downto 0) := "111";

  constant R_FORMAT: std_logic_vector(5 downto 0) := "000000";
  constant LW: std_logic_vector(5 downto 0) := "100101";
  constant SW: std_logic_vector(5 downto 0) := "101011";
  constant BEQ: std_logic_vector(5 downto 0) := "000100";


  type microinstruction is record
    ce:    std_logic;       -- ce e rw são os controles da memória
    rw:    std_logic;
  --  i:     inst_type;        
    wreg:  std_logic;       -- wreg diz se o banco de registradores
			    -- deve ou não ser escrito
  end record;
    
end p_MI0;
