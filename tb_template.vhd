-- name:    [top_entity].vhd
-- author:  [author]
-- date:    [date]
-- content: testbench for:
--          [description]

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity [top_entity] is
end [top_entity];

architecture bhv of [top_entity] is
  signal reset_n: std_logic;
  signal clk: std_logic := '0';
begin
  I_[project]: entity work.[project](rtl)
    port map(RESET_n  => reset_n,
             CLK      => clk);
  reset_n <= '0', '1' after 5 ns;
  clk <= not clk after 10 ns;
end bhv;