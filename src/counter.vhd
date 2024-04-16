-- Counter
-- See LICENSE file for copyright and license details.

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

entity counter is
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
end entity counter;

architecture behav of counter is
  signal cb: std_logic_vector(N - 1 downto 0);

begin
  process (clk, nrst)
  begin
    if nrst = '0' then
      cb <= s;
    elsif rising_edge(clk) then
      cb <= cb + i;
    end if;
  end process;

  c <= cb;

end behav;
