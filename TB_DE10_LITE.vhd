------------------------------------------------------------------------------------
-- Project : [project]
-- Author  : [author]
-- Date    : [date]
-- File    : TB_DE10_LITE.vhd
-- Design  : Terasic DE10 Board
------------------------------------------------------------------------------------
-- Description: [description]
------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

use work.DE10_Lite_const_pkg.ALL;

--=======================================================================================================
entity TB_DE10_Lite is
end TB_DE10_Lite;
--=======================================================================================================

architecture rtl of TB_DE10_Lite is
  --=====================================================================================================
  signal CLK: std_logic := '0';
  --=====================================================================================================
begin
  --=====================================================================================================
  CLK <= not CLK after de10_cycle_time_c / 2;
  --=====================================================================================================
  I_DE10_Lite:  entity work.DE10_Lite(rtl) port map (
    MAX10_CLK1_50 => CLK,
    KEY => (others => '0'),
    SW => (others => '0')
  );
end rtl;
