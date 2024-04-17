-- Test Bench of Square Function
-- See LICENSE file for copyright and license details.

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity f_square_tb is
end entity f_square_tb;

architecture tb of f_square_tb is
  -- f(x) = {
  --   A if 0 ≤ x % T < T/2
  --   -A if T/2 ≤ x % T < T
  -- }
  -- A: Amplitude of the wave
  -- T: Period of the wave
  component f_square is
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
  end component;

  constant N: positive := 8;
  constant M: positive := 8;

  signal s_x: std_logic_vector(N - 1 downto 0) := (others => '0');
  signal s_xc: std_logic_vector(N - 1 downto 0) := (others => '0');
  signal s_f: std_logic_vector(M - 1 downto 0);

  constant X_MAX: integer := 2 ** N - 1;
  constant F_MID: integer := 2 ** (M - 1);
  constant F_MAX: integer := 2 ** M - 1;

begin
  dut: f_square generic map(N, M) port map(s_x, s_xc, s_f);

  process
  begin
    for t_xc in 0 to X_MAX loop
      s_xc <= std_logic_vector(to_unsigned(t_xc, N));
      for t_x in 0 to X_MAX loop
        s_x <= std_logic_vector(to_unsigned(t_x, N));
        wait for 1 ns;
        if t_x < t_xc then
          assert s_f = std_logic_vector(to_unsigned(F_MAX, M)) severity error;
        else
          assert s_f = std_logic_vector(to_unsigned(0, M)) severity error;
        end if;
      end loop;
    end loop;
    wait;
  end process;

end tb;
