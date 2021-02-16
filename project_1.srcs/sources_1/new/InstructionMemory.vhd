----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology
-- Engineer: Dhruv Rajpurohit(dar1972@rit.edu)
-- 
-- Create Date: 09/12/2020 06:31:25 PM
-- Design Name: InstructionMemory
-- Module Name: InstructionMemory - Behavioral
-- Project Name: InstructionFetch
-- Target Devices: Basys3 
-- Description: This is a Instruction Memory module which holds the 
-- instructions which will be fetched.  
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity InstructionMemory is
    Port ( clk      : IN std_logic;
           addr     : IN std_logic_vector(27 downto 0);
           d_out    : OUT std_logic_vector(31 downto 0)
          );
end InstructionMemory;

architecture Behavioral of InstructionMemory is

type rom_type is array (0 to 1023) of std_logic_vector(7 downto 0);
signal ROM : rom_type := (
                          x"00",x"00",x"00",x"00",
                          x"11",x"11",x"11",x"11",
                          x"22",x"22",x"22",x"22",
                          x"3f",x"5e",x"1d",x"2c",
                          x"12",x"25",x"8b",x"49",
                          x"20",x"1f",x"df",x"6c",
                          x"3f",x"33",x"22",x"18",
                          x"0e",x"da",x"bc",x"88",
                          x"08",x"7c",x"fc",x"b8",
                          others =>(others =>'0')
                          );

signal constant1 : unsigned(27 downto 0) := x"0000000";
signal constant2 : unsigned(27 downto 0) := x"0000000";
signal constant3 : unsigned(27 downto 0) := x"0000000";

begin

constant1 <= unsigned(addr) + "01";
constant2 <= unsigned(addr) + "10";
constant3 <= unsigned(addr) + "11";

process(clk)

begin
    if (rising_edge(clk)) then
        d_out(7 downto 0) <= ROM(to_integer(unsigned(constant3)));
        d_out(15 downto 8) <= ROM(to_integer(unsigned(constant2)));
        d_out(23 downto 16) <= ROM(to_integer(unsigned(constant1)));
        d_out(31 downto 24) <= ROM(to_integer(unsigned(addr)));
    end if;
end process;

end Behavioral;



















