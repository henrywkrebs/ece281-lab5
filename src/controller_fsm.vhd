----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:42:49 PM
-- Design Name: 
-- Module Name: controller_fsm - FSM
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller_fsm is
    Port ( i_reset : in STD_LOGIC;
           i_clk   : in STD_LOGIC;
           i_adv   : in STD_LOGIC;
           o_cycle : out STD_LOGIC_VECTOR (3 downto 0));
end controller_fsm;

architecture FSM of controller_fsm is

    type t_state is (s_idle, s_load1, s_load2, s_result);
    signal f_state  : t_state := s_idle;
    signal f_adv_d  : std_logic := '0';

begin

    state_reg : process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            f_state <= s_idle;
            f_adv_d <= '0';
        elsif rising_edge(i_clk) then
            f_adv_d <= i_adv;
            if i_adv = '1' and f_adv_d = '0' then
                case f_state is
                    when s_idle   => f_state <= s_load1;
                    when s_load1  => f_state <= s_load2;
                    when s_load2  => f_state <= s_result;
                    when s_result => f_state <= s_idle;
                end case;
            end if;
        end if;
    end process state_reg;

    o_cycle <= "0001" when f_state = s_idle   else
               "0010" when f_state = s_load1  else
               "0100" when f_state = s_load2  else
               "1000";

end FSM;
