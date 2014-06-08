library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.p_MI0.all;

entity mux4 is
       generic(
                size: integer := 32
        );
       port(
                sel: in std_logic_vector(1 downto 0);
                a, b, c, d: in std_logic_vector(size-1 downto 0);
                f: out std_logic_vector(size-1 downto 0)
           );
end mux4;

architecture arq_mux4 of mux4 is

        signal ab: std_logic_vector(size-1 downto 0);
        signal cd: std_logic_vector(size-1 downto 0);
begin

    MX2_1: entity work.mux2 port map(sel(0), a, b, ab);
    MX2_2: entity work.mux2 port map(sel(0), c, d, cd);
    MX2_3: entity work.mux2 port map(sel(1), ab,cd, f);

end arq_mux4;

