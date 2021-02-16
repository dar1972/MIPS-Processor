---------------------------------------------------------------------
--Company: Rochester Institute of Technology
--Engineer: Dhruv Rajpurohit (dar1972@rit.edu)
--
--Create Date: 10/02/2020
--Design Name: and
--Module Name: and - behavioral
--Project Name: Execute Stage
--Target Device: Basys3
--
--Description: N-bit bitwise AND Logic unit
---------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Mux is
    generic( N: INTEGER := 4);
    Port ( A   : in STD_LOGIC_VECTOR (N-1 downto 0);
           B   : in STD_LOGIC_VECTOR (N-1 downto 0);
           Sel : in STD_LOGIC;
           Y   : out STD_LOGIC_VECTOR (N-1 downto 0));
end Mux;

architecture Behavioral of Mux is

begin

process(A,B,Sel) is
begin

Case Sel is
    when '0' => Y <= A;
    when '1' => Y <= B;
    when others => Y <= (others => '0');
end case;
end process;
end Behavioral;
