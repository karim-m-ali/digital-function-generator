-- Test Bench of Counter
-- See LICENSE file for copyright and license details.

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity counter_tb is
end entity counter_tb;

architecture tb of counter_tb is
  component counter is
    generic (
      -- length of counter output
      N: positive := 8
    );
    port (
      -- clock
      clk: in std_logic;
      -- active low reset
      nrst: in std_logic;
      -- increment
      i: in std_logic_vector(N - 1 downto 0);
      -- start
      s: in std_logic_vector(N - 1 downto 0);
      -- count
      c: out std_logic_vector(N - 1 downto 0)
    );
  end component;

  constant CLK_DUTY: real := 0.30;
  constant CLK_DELAY: time := 1 ns;
  signal clk_need: boolean := true;

  constant N: positive := 4;
  constant C_MAX: integer := 2 ** N - 1;

  signal s_clk: std_logic;
  signal s_nrst: std_logic;
  signal s_i: std_logic_vector(N - 1 downto 0);
  signal s_s: std_logic_vector(N - 1 downto 0);
  signal s_c: std_logic_vector(N - 1 downto 0);

begin
  dut: counter generic map(N) port map(s_clk, s_nrst, s_i, s_s, s_c);

  process
  begin
    while clk_need loop
      s_clk <= '1';
      wait for CLK_DUTY * CLK_DELAY;
      s_clk <= '0';
      wait for (1.0 - CLK_DUTY) * CLK_DELAY;
    end loop;
    wait;
  end process;

  process
  begin
    for t_i in 0 to C_MAX loop
      s_i <= std_logic_vector(to_unsigned(t_i, s_s'length));
      for t_s in 0 to C_MAX loop
        s_s <= std_logic_vector(to_unsigned(t_s, s_s'length));
        s_nrst <= '0';
        wait until rising_edge(s_clk);

        assert s_c = std_logic_vector(to_unsigned(t_s, s_c'length))
          severity error;
        s_nrst <= '1';
        wait until rising_edge(s_clk);

        for i in 0 to C_MAX loop
          assert s_c = std_logic_vector(to_unsigned(
            (t_s + t_i * i) rem (C_MAX + 1), s_c'length)) severity error;
          wait until rising_edge(s_clk);
        end loop;
      end loop;
    end loop;

    clk_need <= false;
    wait;
  end process;

end tb;
