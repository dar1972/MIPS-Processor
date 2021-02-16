----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology (RIT)
-- Engineer: Dhruv Rajpurohit (dar1972@rit.edu)
-- 
-- Create Date: 09/25/2020 02:39:42 PM
-- Design Name: generic_decoder
-- Module Name: generic_decoder - Behavioral
-- Project Name: InstructionDecoder
-- Target Devices: Basys3
-- 
-- Description: The following is the entity and description of a 
--              fully generated generic decoder
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity generic_decoder is
    generic(
            LOG_PORT_DEPTH : integer := 3); -- log port width
    Port (
            Addr_3      : IN std_logic_vector(LOG_PORT_DEPTH-1 downto 0);
            and_output  : OUT std_logic_vector(2**LOG_PORT_DEPTH-1 downto 0) 
        );
end generic_decoder;

architecture Behavioral of generic_decoder is

begin

    process(Addr_3)
    begin
    and_output <= (others => '0');
    and_output(to_integer(unsigned(Addr_3))) <= '1';

end process;
end Behavioral;
