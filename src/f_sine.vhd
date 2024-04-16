-- Sine Function
-- See LICENSE file for copyright and license details.

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.math_real.all;

-- f(x) = A * sin(2πx/T)
-- A: Amplitude of the wave
-- T: Period of the wave
entity f_sine is
  generic (
    -- length of input word
    N: positive := 8;
    -- length of output word
    M: positive := 8
  );
  port (
    -- input of sine
    x: in std_logic_vector(N - 1 downto 0);
    -- output of sine
    f: out std_logic_vector(M - 1 downto 0)
  );
end entity f_sine;

architecture behav of f_sine is
  -- lookup table
  type lut_t is array(2 ** N - 1 downto 0) of std_logic_vector(f'range);
  signal lut: lut_t;

  constant X_MAX: integer := 2 ** N - 1;
  constant F_MAX: integer := 2 ** M - 1;

begin
  -- the LUT should be generated in compile time
  gen_lut: for i in lut'range generate
    lut(i) <= std_logic_vector(to_unsigned(
              integer(
                real(F_MAX) * 
                (sin(real(i) / real(X_MAX) * MATH_2_PI) + 1.0) / 2.0
              ), 
              lut(i)'length
            ));
  end generate gen_lut;

  f <= lut(to_integer(unsigned(x)));

end behav;
