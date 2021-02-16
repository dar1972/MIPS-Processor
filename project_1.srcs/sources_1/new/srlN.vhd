---------------------------------------------------------------------
--Company: Rochester Institute of Technology
--Engineer: Dhruv Rajpurohit (dar1972@rit.edu)
--
--Create Date: 10/02/2020
--Design Name: srl
--Module Name: srl - behavioral
--Project Name: Execute Stage
--Target Device: Basys3
--
--Description: N-bit logical right shift (SRL) unit
---------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use  IEEE.NUMERIC_STD.ALL;

entity srlN is
 GENERIC (N : INTEGER  := 4; D : INTEGER := 5); --bit  width
PORT (A           : IN  std_logic_vector(N-1  downto  0);
     SHIFT_AMT    : IN  std_logic_vector(D-1  downto  0);
     Y           : OUT  std_logic_vector(N-1  downto  0));
end srlN;

architecture Behavioral of srlN is

type  shifty_array  is  array(N-1  downto  0) of  std_logic_vector(N-1 downto  0);
signal  aSRL : shifty_array;

begin

generateSRL: for i in 0 to N-1  generate
    aSRL(i)(N-1-i  downto 0) <= A(N-1 downto  i);
    right_fill: if i > 0 generate
    aSRL(i)(N-1  downto  N-i)  <= (others =>  '0');
   end generate right_fill;
 end generate generateSRL;
 
   Y <= aSRL(to_integer(unsigned(shift_AMT)));

end Behavioral;