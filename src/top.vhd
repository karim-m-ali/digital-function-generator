-- Generic Function Generator
-- See LICENSE file for copyright and license details.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

-- Top of Generic Function Generator
entity top is
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
end entity top;

architecture behav of top is

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
      -- output of sine: sin(x/(2**N-1)*2*pi)
      f: out std_logic_vector(M - 1 downto 0)
    );
  end component; 

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
     
  component f_triangular is
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
  end component;

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

  -- input signal
  signal x: std_logic_vector(N - 1 downto 0);

  signal f_sine_f, f_square_f, f_triangular_f, f_sawtooth_f: 
    std_logic_vector(M - 1 downto 0);

  signal i: std_logic_vector(N - 1 downto 0);

begin
  i(N - 1 downto P) <= (others => '0');
  i(P - 1 downto 0) <= spc;

  u_counter: counter generic map(N) port map(clk, nrst, i, po, x);

  u_f_sine: f_sine generic map(N, M) port map(x, f_sine_f);
  u_f_square: f_square generic map(N, M) port map(x, oc, f_square_f);
  u_f_triangular: f_triangular generic map(N, M) port map(x, f_triangular_f);
  u_f_sawtooth: f_sawtooth generic map(N, M) port map(x, f_sawtooth_f);

  with wf select
    w <= f_sine_f when "00",
         f_square_f when "01",
         f_triangular_f when "10",
         f_sawtooth_f when others;

end behav;
