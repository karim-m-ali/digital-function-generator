-- Test Bench of Generic Function Generator
-- See LICENSE file for copyright and license details.

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity top_tb is
end entity top_tb;

architecture behav of top_tb is

  component top is
    generic (
      -- samples per clock cycle length (maximum samples is 2^P - 1)
      -- must be less than or equal N
      P: positive := 2;
      -- input length: power of samples per signal period (2^N samples)
      N: positive := 8;
      -- output length: resolution of wave (2^M levels)
      M: positive := 8
    );
    port (
      -- clock: external clock to be divided
      clk: in std_logic;
      -- active low reset: reset signal to time zero, used to synchronize
      nrst: in std_logic;
      -- waveform: selects either 0:sine, 1:square, 3:triangular, or 4:sawtooth
      wf: in std_logic_vector(1 downto 0);
      -- function output compare: sets duty cycle of square wave
      oc: in std_logic_vector(N - 1 downto 0);
      -- phase offset: shifts wave
      po: in std_logic_vector(N - 1 downto 0);
      -- samples per clock cycle: 0:stop, 1:lowest frequency, 2..:higher freq.
      spc: in std_logic_vector(P - 1 downto 0);
      -- wave: digital value which is connected to a DAC circuit for example
      w: out std_logic_vector(M - 1 downto 0)
    );
  end component;

  constant CLK_DUTY: real := 0.30;
  constant CLK_DELAY: time := 1 ns;
  signal clk_need: boolean := true;

  constant P: positive := 2;
  constant N: positive := 8;
  constant M: positive := 8;

  constant CYCLES_PER_TEST: positive := 5;

  constant SPC_MAX: integer := 2 ** P - 1;
  constant X_OVF: integer := 2 ** N;
  constant X_MAX: integer := 2 ** N - 1;

  signal s_clk: std_logic := '0';
  signal s_nrst: std_logic := '0';
  signal s_oc: std_logic_vector(N - 1 downto 0) := std_logic_vector(
    to_unsigned(X_OVF / 2, N));
  signal s_po: std_logic_vector(N - 1 downto 0) := (others => '0');
  signal s_spc: std_logic_vector(P - 1 downto 0) := (others => '0');

  -- sine
  signal dut1_s_w: std_logic_vector(M - 1 downto 0);

  -- square
  signal dut2_s_w: std_logic_vector(M - 1 downto 0);

  -- triangular
  signal dut3_s_w: std_logic_vector(M - 1 downto 0);

  -- sawtooth
  signal dut4_s_w: std_logic_vector(M - 1 downto 0);

begin
  dut1: top generic map(P, N, M) port map(s_clk, s_nrst, "00", s_oc, s_po,
                                          s_spc, dut1_s_w);

  dut2: top generic map(P, N, M) port map(s_clk, s_nrst, "01", s_oc, s_po,
                                          s_spc, dut2_s_w);

  dut3: top generic map(P, N, M) port map(s_clk, s_nrst, "10", s_oc, s_po,
                                          s_spc, dut3_s_w);

  dut4: top generic map(P, N, M) port map(s_clk, s_nrst, "11", s_oc, s_po,
                                          s_spc, dut4_s_w);

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
    for s_po_i in 0 to 3 loop
      s_po <= std_logic_vector(to_unsigned(s_po_i * X_OVF / 4, s_po'length));

      for t_spc in 1 to SPC_MAX loop
        s_spc <= std_logic_vector(to_unsigned(t_spc, s_spc'length));

        s_nrst <= '0';
        for t in 0 to X_MAX loop
          wait until rising_edge(s_clk);
        end loop;
        s_nrst <= '1';

        for t in 1 to CYCLES_PER_TEST loop
          for i in 0 to X_MAX loop
            wait until rising_edge(s_clk);
          end loop;
        end loop;

      end loop;
    end loop;

    clk_need <= false;
    wait;
  end process;

end behav;
