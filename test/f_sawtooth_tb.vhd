-- Test Bench of Sawtooth Function
-- See LICENSE file for copyright and license details.

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity f_sawtooth_tb is
end entity f_sawtooth_tb;

architecture tb of f_sawtooth_tb is
  -- f(x) = (2A/π) * arctan(tan(πx/T))
  -- A: Amplitude of the wave
  -- T: Period of the wave
  component f_sawtooth is
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
  end component;

  -- DUT1: N > M
  constant DUT1_N: positive := 8;
  constant DUT1_M: positive := 6;

  -- DUT2: N < M
  constant DUT2_N: positive := 6;
  constant DUT2_M: positive := 8;

  -- DUT3: N = M
  constant DUT3_N: positive := 8;
  constant DUT3_M: positive := 8;

  signal dut1_s_x: std_logic_vector(DUT1_N - 1 downto 0);
  signal dut1_s_f: std_logic_vector(DUT1_M - 1 downto 0);

  signal dut2_s_x: std_logic_vector(DUT2_N - 1 downto 0);
  signal dut2_s_f: std_logic_vector(DUT2_M - 1 downto 0);

  signal dut3_s_x: std_logic_vector(DUT3_N - 1 downto 0);
  signal dut3_s_f: std_logic_vector(DUT3_M - 1 downto 0);

  constant DUT1_X_MAX: integer := 2 ** DUT1_N - 1;
  constant DUT1_F_MAX: integer := 2 ** DUT1_M - 1;

  constant DUT2_X_MAX: integer := 2 ** DUT2_N - 1;
  constant DUT2_F_MAX: integer := 2 ** DUT2_M - 1;

  constant DUT3_X_MAX: integer := 2 ** DUT3_N - 1;
  constant DUT3_F_MAX: integer := 2 ** DUT3_M - 1;

begin
  dut1: f_sawtooth generic map(DUT1_N, DUT1_M) port map(dut1_s_x, dut1_s_f);
  dut2: f_sawtooth generic map(DUT2_N, DUT2_M) port map(dut2_s_x, dut2_s_f);
  dut3: f_sawtooth generic map(DUT3_N, DUT3_M) port map(dut3_s_x, dut3_s_f);

  -- DUT1: N > M
  process
  begin
    for t_x in 0 to DUT1_X_MAX loop
      dut1_s_x <= std_logic_vector(to_unsigned(t_x, DUT1_N));
      wait for 1 ns;
      assert dut1_s_f = std_logic_vector(to_unsigned(
        t_x / 2 ** (DUT1_N - DUT1_M), DUT1_M)) severity error;
    end loop;
    wait;
  end process;

  -- DUT1: N < M
  process
  begin
    for t_x in 0 to DUT2_X_MAX loop
      dut2_s_x <= std_logic_vector(to_unsigned(t_x, DUT2_N));
      wait for 1 ns;
      assert dut2_s_f = std_logic_vector(to_unsigned(
        t_x * 2 ** (DUT2_M - DUT2_N), DUT2_M)) severity error;
    end loop;
    wait;
  end process;

  -- DUT1: N = M
  process
  begin
    for t_x in 0 to DUT3_X_MAX loop
      dut3_s_x <= std_logic_vector(to_unsigned(t_x, DUT3_N));
      wait for 1 ns;
      assert dut3_s_f = std_logic_vector(to_unsigned(
        t_x, DUT3_M)) severity error;
    end loop;
    wait;
  end process;

end tb;
