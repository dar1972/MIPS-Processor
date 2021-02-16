----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/12/2020 06:46:08 PM
-- Design Name: 
-- Module Name: and_gate - Behavioral
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

entity two_and is
PORT ( 
      A           : IN STD_LOGIC;
      we          : IN STD_LOGIC;
      Y      : OUT STD_LOGIC
      );
end two_and;

architecture Behavioral of two_and is

begin

Y <= A AND we;

end Behavioral;
