------------------------------------------------------------------------------------
--Project : DIC 3BHEL 
--Author  : Gr�bner
--Date    : 15/05/2018
--File    : DE10_Lite.vhd
--Design  : Terasic DE10 Board
------------------------------------------------------------------------------------
-- Description: Button Up/Down Counter, Decimal
------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

use work.DE10_Lite_const_pkg.ALL;

--=======================================================================================================
entity DE10_Lite is
  port (
        MAX10_CLK1_50 :  in std_logic;
        ---------------------------------------------------------------
        KEY           :  in std_logic_vector(    keys_c - 1 downto 0);
        SW            :  in std_logic_vector(switches_c - 1 downto 0);
        LEDR          : out std_logic_vector(    leds_c - 1 downto 0);
        ---------------------------------------------------------------
        HEX0          : out std_logic_vector(7 downto 0);
        HEX1          : out std_logic_vector(7 downto 0);
        HEX2          : out std_logic_vector(7 downto 0);
        HEX3          : out std_logic_vector(7 downto 0);
        HEX4          : out std_logic_vector(7 downto 0);
        HEX5          : out std_logic_vector(7 downto 0)
        ---------------------------------------------------------------
       );
end DE10_Lite;
--=======================================================================================================

architecture rtl of DE10_Lite is
  --=====================================================================================================
  alias CLK: std_logic is MAX10_CLK1_50;
  --=====================================================================================================
  -- Parameters for Debounce
  constant clock_period_c    : time :=  20 ns;
  constant sample_period_c   : time := 500 us;
  constant mintime_pressed_c : time :=  10 ms;
  --=====================================================================================================
  signal reset_n    : std_logic;
  signal key_db     : std_logic_vector(keys_c - 1 downto 0);
  signal pulse_up   : std_logic;
  signal pulse_down : std_logic;
  --=====================================================================================================
  constant counter_width_c : natural := 20;
  constant counter_max_c   : natural := 999999;
  signal counter_nat       : natural range 0 to counter_max_c;
  signal counter_bin       : unsigned(counter_width_c - 1 downto 0);
  --=====================================================================================================
  signal bcd : unsigned(4 * digits_c - 1 downto 0);
  --=====================================================================================================
begin
  --=====================================================================================================
  HEX0(7) <= '1';
  HEX1(7) <= '1';
  HEX2(7) <= '1';
  HEX3(7) <= '1';
  HEX4(7) <= '1';
  HEX5(7) <= '1';
  --=====================================================================================================
  I_DEBOUNCE_KEY1: entity work.debounce(rtl) generic map (
                                                          clock_period    => clock_period_c,
                                                          sample_period   => sample_period_c,
                                                          mintime_pressed => mintime_pressed_c
                                                         )
                                             port map (
                                                       CLK        => CLK,
                                                       BUTTON_in  => KEY(1),
                                                       BUTTON_out => key_db(1)
                                                      );
  --=====================================================================================================
  I_DEBOUNCE_KEY0: entity work.debounce(rtl) generic map (
                                                          clock_period    => clock_period_c,
                                                          sample_period   => sample_period_c,
                                                          mintime_pressed => mintime_pressed_c
                                                         )
                                             port map (
                                                       CLK        => CLK,
                                                       BUTTON_in  => KEY(0),
                                                       BUTTON_out => key_db(0)
                                                      );
  --=====================================================================================================
  I_PulseGen_BTN0: entity work.pulse_gen(rtl) port map (
                                                        RESET_n   => reset_n,
                                                        CLK_50MHz => CLK,
                                                        BUTTON_in => key_db(1),
                                                        PULSE_out => pulse_up
                                                       );
  --=====================================================================================================
  I_PulseGen_BTN2: entity work.pulse_gen(rtl) port map (
                                                        RESET_n   => reset_n,
                                                        CLK_50MHz => CLK,
                                                        BUTTON_in => key_db(0),
                                                        PULSE_out => pulse_down
                                                       );
  --=====================================================================================================
  I_BIN2BCD: entity work.bin2bcd_n(rtl) generic map (bits_g       => counter_width_c,
                                                     bcd_digits_g => digits_c)
                                        port map (
                                                  CLK     => CLK,
                                                  RESET_n => reset_n,
                                                  BIN_in  => counter_bin,
                                                  BCD_out => bcd 
                                                 );
  --=====================================================================================================

  --=====================================================================================================
  reset_n <= not (key_db(0) and key_db(1));
  --=====================================================================================================

  --=====================================================================================================
  HexCounter: process (CLK, reset_n)
  begin
    --===================================================================================================
    if (reset_n = '0') then
      counter_nat <= 0;
    elsif (CLK'event and CLK = '1') then
      if (pulse_up = '1') then
        if (counter_nat < counter_max_c) then
          counter_nat <= counter_nat + 1;
        else
          counter_nat <= 0;
        end if;
      elsif (pulse_down = '1') then
        if (counter_nat > 0) then
          counter_nat <= counter_nat - 1;
        end if;
      end if;
    end if;
    --===================================================================================================
  end process HexCounter;
  --=====================================================================================================

  --=====================================================================================================
  counter_bin <= TO_UNSIGNED(counter_nat, counter_width_c);

  HEX0(6 downto 0) <= (others => '0'), not (disp_array_c(TO_INTEGER(bcd( 3 downto  0)))) after 1 ms;
  HEX1(6 downto 0) <= (others => '0'), not (disp_array_c(TO_INTEGER(bcd( 7 downto  4)))) after 1 ms;
  HEX2(6 downto 0) <= (others => '0'), not (disp_array_c(TO_INTEGER(bcd(11 downto  8)))) after 1 ms;
  HEX3(6 downto 0) <= (others => '0'), not (disp_array_c(TO_INTEGER(bcd(15 downto 12)))) after 1 ms;
  HEX4(6 downto 0) <= (others => '0'), not (disp_array_c(TO_INTEGER(bcd(19 downto 16)))) after 1 ms;
  HEX5(6 downto 0) <= (others => '0'), not (disp_array_c(TO_INTEGER(bcd(23 downto 20)))) after 1 ms;

  LEDR <= std_logic_vector (counter_bin(leds_c - 1 downto 0));
  --=====================================================================================================
end rtl;
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
