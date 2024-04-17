-- Triangular Function
-- See LICENSE file for copyright and license details.

library IEEE;
use IEEE.std_logic_1164.ALL;

-- f(x) = (2A/T) * |x - T/2|
-- A: Amplitude of the wave
-- T: Period of the wave
entity f_triangular is
  generic (
    -- length of input word
    N: positive := 8;
    -- length of output word
    M: positive := 8
  );
  port (
    -- input of triangular
    x: in std_logic_vector(N - 1 downto 0);
    -- output of triangular
    f: out std_logic_vector(M - 1 downto 0)
  );
end entity f_triangular;

architecture behav of f_triangular is
begin
  f(M - 1) <= not x(N - 1);

  gen_f: if M >= N generate
    with x(N - 1) xor x(N - 2) select
      f(M - 2 downto M - N + 1) <= x(N - 3 downto 0) when '0',
                                   not x(N - 3 downto 0) when others;
      f(M - N downto 0) <= (others => '0');
  else generate
    with x(N - 1) xor x(N - 2) select
      f(M - 2 downto 0) <= x(N - 3 downto N - M - 1) when '0',
                           not x(N - 3 downto N - M - 1) when others;
  end generate;

end behav;
