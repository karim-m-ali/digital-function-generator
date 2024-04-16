-- Test Bench of Sine Function
-- See LICENSE file for copyright and license details.

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.math_real.all;

entity f_sine_tb is
end entity f_sine_tb;

architecture tb of f_sine_tb is
  -- f(x) = A * sin(2πx/T)
  -- A: Amplitude of the wave
  -- T: Period of the wave
  component f_sine is
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
  end component;

  constant N: positive := 8;
  constant M: positive := 8;

  signal s_x: std_logic_vector(N - 1 downto 0) := (others => '0');
  signal s_f: std_logic_vector(M - 1 downto 0);

  constant X_MAX: integer := 2 ** N - 1;
  constant F_MAX: integer := 2 ** M - 1;

begin
  dut: f_sine generic map(N, M) port map(s_x, s_f);

  process
  begin
    for t_x in 0 to X_MAX loop
      s_x <= std_logic_vector(to_unsigned(t_x, N));
      wait for 1 ns;
      assert s_f = std_logic_vector(to_unsigned(integer(round(
        real(F_MAX) * (sin(real(t_x) / real(X_MAX) * MATH_2_PI) + 1.0) / 2.0
        )), M)) severity error;
    end loop;

    wait;
  end process;

end tb;
