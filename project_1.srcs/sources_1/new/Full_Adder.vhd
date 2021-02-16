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


entity Full_Adder is
  Port ( 
        A    : IN std_logic;
        B    : IN std_logic;
        Cin  : IN std_logic;
        Sum  : OUT std_logic; 
        Cout : OUT std_logic
       );
end Full_Adder;

Architecture Behavior of Full_Adder is
begin 

Sum <= A xor B xor Cin;
Cout <= (A and B) OR (B and Cin) OR (A and Cin);

end Behavior;
