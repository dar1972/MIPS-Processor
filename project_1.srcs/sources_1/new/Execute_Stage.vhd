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

entity Execute_Stage is
    generic (N : INTEGER := 32);
    Port ( RegWrite      : in STD_LOGIC;
           MemtoReg      : in STD_LOGIC;
           MemWrite      : in STD_LOGIC;
           ALUControl    : in STD_LOGIC_VECTOR(3 downto 0);
           ALUSrc        : in STD_LOGIC;
           RegDst        : in STD_LOGIC;
           RegSrcA       : in STD_LOGIC_VECTOR(N-1 downto 0);
           RegSrcB       : in STD_LOGIC_VECTOR(N-1 downto 0);
           RtDest        : in STD_LOGIC_VECTOR(4 downto 0);
           RdDest        : in STD_LOGIC_VECTOR(4 downto 0);
           SignImm       : in STD_LOGIC_VECTOR(N-1 downto 0);
           RegWriteOut   : out STD_LOGIC;
           MemtoRegOut   : out STD_LOGIC;
           MemtoWriteOut : out STD_LOGIC;
           ALUResult     : out STD_LOGIC_VECTOR(N-1 downto 0);
           WriteData     : out STD_LOGIC_VECTOR(N-1 downto 0);
           WriteReg      : out STD_LOGIC_VECTOR(4 downto 0)
           );
end Execute_Stage;

architecture Behavioral of Execute_Stage is

Component Mux is
    generic( N: INTEGER := 4);
    Port ( A   : in STD_LOGIC_VECTOR (N-1 downto 0);
           B   : in STD_LOGIC_VECTOR (N-1 downto 0);
           Sel : in STD_LOGIC;
           Y   : out STD_LOGIC_VECTOR (N-1 downto 0));
end Component;

 
 Component  alu4 is
 GENERIC (N : INTEGER  := 32; D : INTEGER := 2); --bit  width
 PORT (in1           : IN  std_logic_vector(N-1  downto  0);
       in2           : IN  std_logic_vector(N-1  downto  0);
       control       : IN std_logic_vector(3 downto 0);
       out1          : OUT  std_logic_vector(N-1  downto  0));
 end  Component;
 
 signal SrcB : std_logic_vector(N-1 downto 0);

begin

RegWriteOut <= RegWrite;  
MemtoRegOut  <= MemtoReg;
MemtoWriteOut <= MemWrite;
WriteData    <= RegSrcB;

mux1 : Mux 
    generic map( N => 5)
    port map( A   => RtDest,
              B   => RdDest,
              Sel => RegDst,
              Y   => WriteReg
            );
             
mux2 : Mux
    generic map( N => 32)
    port map( A   => RegSrcB,
              B   => SignImm,
              Sel => ALUSrc,
              Y   => SrcB
            );
 ALU: alu4
     generic map (N => 32,D => 2)
     port map ( in1     => RegSrcA,
                in2     => SrcB,
                control => ALUControl,
                out1    => ALuResult
              );
                
         


end Behavioral;