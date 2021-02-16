----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology (RIT)
-- Engineer: Dhruv Rajpurohit (dar1972@rit.edu)
-- 
-- Create Date: 09/25/2020 02:39:42 PM
-- Design Name: register_module
-- Module Name: register_module - Behavioral
-- Project Name: InstructionDecoder
-- Target Devices: Basys3
-- 
-- Description: The following is the entity and description of a 
--              register module
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity register_module is
    Generic (BIT_DEPTH : integer := 8); -- log port width
    Port (
            input   : IN std_logic_vector(BIT_DEPTH - 1 downto 0);
            clk_n   : IN std_logic;
            we      : IN std_logic;
            output  : OUT std_logic_vector(BIT_DEPTH - 1 downto 0)
        );
end register_module;

architecture Behavioral of register_module is

begin

process (clk_n)
begin
    if falling_edge(clk_n) then
        if (we = '1') then
            output <= input;
        end if;
    end if;
end process;

end Behavioral;
