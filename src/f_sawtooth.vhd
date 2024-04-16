-- Sawtooth Function
-- See LICENSE file for copyright and license details.

library IEEE;
use IEEE.std_logic_1164.ALL;

-- f(x) = (2A/π) * arctan(tan(πx/T))
-- A: Amplitude of the wave
-- T: Period of the wave
entity f_sawtooth is
  generic (
    -- length of input word
    N: positive := 8;
    -- length of output word
    M: positive := 8
  );
  port (
    -- input of sawtooth
    x: in std_logic_vector(N - 1 downto 0);
    -- output of sawtooth
    f: out std_logic_vector(M - 1 downto 0)
  );
end entity f_sawtooth;

architecture behav of f_sawtooth is
begin
  gen_f: if M >= N generate
    f(M - 1 downto M - N) <= x;
    f(M - N - 1 downto 0) <= (others => '0');
  else generate
    f <= x(N - 1 downto N - M);
  end generate;

end behav;
