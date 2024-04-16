-- Square Function
-- See LICENSE file for copyright and license details.

library IEEE;
use IEEE.std_logic_1164.ALL;

-- f(x) = {
--   A if 0 ≤ x % T < T/2
--   -A if T/2 ≤ x % T < T
-- }
-- A: Amplitude of the wave
-- T: Period of the wave
entity f_square is
  generic (
    -- length of input word
    N: positive := 8;
    -- length of output word
    M: positive := 8
  );
  port (
    -- input of square
    x: in std_logic_vector(N - 1 downto 0);
    -- input compare of square
    xc: in std_logic_vector(N - 1 downto 0);
    -- output of square
    f: out std_logic_vector(M - 1 downto 0)
  );
end entity f_square;

architecture behav of f_square is

begin
  f <= (others => '1') when x < xc else (others => '0');

end behav;
