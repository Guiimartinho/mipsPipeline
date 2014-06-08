library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.p_MI0.all;

entity mux3 is
       generic(
                size: integer := 32
        );
       port(
                sel: in std_logic_vector(1 downto 0);
                a, b, c: in std_logic_vector(size-1 downto 0);
                f: out std_logic_vector(size-1 downto 0)
           );
end mux3;

architecture arq_mux3 of mux3 is

        signal ab: std_logic_vector(size-1 downto 0);
begin

    MX2_1: entity work.mux2 port map(sel(0), a, b, ab);
    MX2_2: entity work.mux2 port map(sel(1), ab,c, f);

end arq_mux3;

