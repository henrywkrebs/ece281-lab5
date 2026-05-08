----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:50:18 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( i_A : in STD_LOGIC_VECTOR (7 downto 0);
           i_B : in STD_LOGIC_VECTOR (7 downto 0);
           i_op : in STD_LOGIC_VECTOR (2 downto 0);
           o_result : out STD_LOGIC_VECTOR (7 downto 0);
           o_flags : out STD_LOGIC_VECTOR (3 downto 0));
end ALU;

architecture Behavioral of ALU is
    signal w_result  : std_logic_vector(7 downto 0);
    signal w_sum9    : std_logic_vector(8 downto 0);
    signal w_B_op    : std_logic_vector(7 downto 0);
    signal w_cin     : std_logic;
    signal w_sum8    : std_logic_vector(7 downto 0);
    signal w_cout    : std_logic;
    signal w_carry6  : std_logic;
begin

    w_cin   <= i_op(0);
    w_B_op  <= not i_B when i_op(0) = '1' else i_B;

    w_sum9  <= std_logic_vector(('0' & unsigned(i_A)) + ('0' & unsigned(w_B_op)) + (x"0" & w_cin));
    w_sum8  <= w_sum9(7 downto 0);
    w_cout  <= w_sum9(8);

    w_carry6 <= std_logic_vector(('0' & unsigned(i_A(6 downto 0))) + ('0' & unsigned(w_B_op(6 downto 0))) + (x"0" & w_cin))(7);

    w_result <= w_sum8          when (i_op = "000" or i_op = "001") else
                i_A and i_B     when i_op = "010" else
                i_A or  i_B     when i_op = "011" else
                (others => '0');

    o_result <= w_result;

    o_flags(3) <= w_result(7);
    o_flags(2) <= '1' when w_result = "00000000" else '0';
    o_flags(1) <= w_cout when (i_op = "000" or i_op = "001") else '0';
    o_flags(0) <= w_cout xor w_carry6 when (i_op = "000" or i_op = "001") else '0';

end Behavioral;