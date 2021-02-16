----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology
-- Engineer: Dhruv Rajpurohit(dar1972@rit.edu)
-- 
-- Create Date: 09/12/2020 06:31:25 PM
-- Design Name: InstructionFetch
-- Module Name: InstructionFetch - Behavioral
-- Project Name: InstructionFetch
-- Target Devices: Basys3
-- Description: this is an intruction fetch module which fetches the instruction
-- from the memory at specified address.
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity InstructionFetch is
Port ( clk         : IN std_logic;
       rst         : IN std_logic;
       Instruction : OUT std_logic_vector(31 downto 0) 
      );
end InstructionFetch;

architecture Behavioral of InstructionFetch is

Component InstructionMemory is
    Port ( clk      : IN std_logic;
           addr     : IN std_logic_vector(27 downto 0);
           d_out    : OUT std_logic_vector(31 downto 0)
          );
end Component;

signal pcOut : unsigned(27 downto 0) := x"0000000";

begin
       
 Process(clk,rst)
 begin
    if (rst = '1') then
        pcOut <= x"0000000";
    elsif(rising_edge(clk)) then
        pcOut <= pcOut + "0100";
    end if;
 end process;
 

 Instmem:InstructionMemory
 PORT MAP(
           clk   => clk,  
           addr  => std_logic_vector(pcOut), 
           d_out => Instruction  
        );
        
 
end Behavioral;
