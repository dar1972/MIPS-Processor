---------------------------------------------------------------------
--Company: Rochester Institute of Technology
--Engineer: Dhruv Rajpurohit (dar1972@rit.edu)
--
--Create Date: 10/02/2020
--Design Name: alu4
--Module Name: alu4 - structural
--Project Name: Introduction to Vivado & Simple ALU
--Target Device: Basys3
--
--Description: Parial 4-bit Arithmetic Logic unit
---------------------------------------------------------------------

library  IEEE;
 use  IEEE.STD_LOGIC_1164.ALL;
 use  IEEE.NUMERIC_STD.ALL;
 
 entity  alu4 is
 GENERIC (N : INTEGER  := 4; D : INTEGER := 2); --bit  width
 PORT (in1           : IN  std_logic_vector(N-1  downto  0);
       in2            : IN  std_logic_vector(N-1  downto  0);
       control           : IN std_logic_vector(3 downto 0);
       out1            : OUT  std_logic_vector(N-1  downto  0));
 end  alu4;
 
architecture  structural  of alu4 is

   Component alu_and is
            GENERIC (N : INTEGER := 4);
       PORT(
           A : IN std_logic_vector(N-1 downto 0);
           B : IN std_logic_vector(N-1 downto 0);
           Y : OUT std_logic_vector(N-1 downto 0)
       );
end  Component;

   Component alu_or is
            GENERIC (N : INTEGER := 4);
       PORT(
           A : IN std_logic_vector(N-1 downto 0);
           B : IN std_logic_vector(N-1 downto 0);
           Y : OUT std_logic_vector(N-1 downto 0)
       );
end  Component;

   Component alu_xor is
            GENERIC (N : INTEGER := 4);
       PORT(
           A : IN std_logic_vector(N-1 downto 0);
           B : IN std_logic_vector(N-1 downto 0);
           Y : OUT std_logic_vector(N-1 downto 0)
       );
end  Component;
   
   Component sllN is
      GENERIC (N : INTEGER  := 4; D : INTEGER := 5); --bit  width        
      PORT (A           : IN  std_logic_vector(N-1  downto  0);
           SHIFT_AMT    : IN  std_logic_vector(D-1   downto  0);
            Y           : OUT  std_logic_vector(N-1  downto  0)
           );
end  Component;
    
   Component srlN is
       GENERIC (N : INTEGER  := 4;D : INTEGER := 5); --bit  width         
       PORT (A           : IN  std_logic_vector(N-1  downto  0);
            SHIFT_AMT    : IN  std_logic_vector(D-1  downto  0);
             Y           : OUT  std_logic_vector(N-1  downto  0)
            );
end  Component;
     
    Component sraN is
       GENERIC (N : INTEGER  := 4; D : INTEGER := 5); --bit  width          
        PORT (A           : IN  std_logic_vector(N-1  downto  0);
             SHIFT_AMT    : IN  std_logic_vector(D-1  downto  0);
              Y           : OUT  std_logic_vector(N-1  downto  0)
             );
end  Component;

Component RippleCarryFullAdder is
  generic( N : integer:= 32);
  Port ( 
         A   : IN std_logic_vector(N-1 downto 0);
         B   : IN std_logic_vector(N-1 downto 0);
         OP  : IN std_logic;
         Sum : OUT std_logic_vector(N-1 downto 0)   
  );
end Component;

Component Multiplier is
  generic (N : integer := 32);
  Port (
        A : IN std_logic_vector((N/2) - 1 downto 0); 
        B : IN std_logic_vector((N/2)-1 downto 0);
        Product : OUT std_logic_vector(N-1 downto 0)  
       );
end Component;

signal not_result : std_logic_vector(N-1 downto 0);
signal sll_result : std_logic_vector(N-1 downto 0);
signal srl_result : std_logic_vector(N-1 downto 0);
signal sra_result : std_logic_vector(N-1 downto 0);
signal and_result : std_logic_vector(N-1 downto 0);
signal or_result  : std_logic_vector(N-1 downto 0);
signal xor_result : std_logic_vector(N-1 downto 0);
signal fullAdder_result : std_logic_vector(N-1 downto 0);
signal Multiplier_result : std_logic_vector(N-1 downto 0);

begin
    
 sll_comp: sllN
        generic map ( N => N,D =>2)
        port map ( A => in1, SHIFT_AMT => in2(D-1 downto 0), Y => sll_result );
        
 srl_comp: srlN
        generic map ( N => N,D=>2)
        port map ( A => in1, SHIFT_AMT => in2(D-1 downto 0), Y => srl_result );
               
 sra_comp: sraN
        generic map ( N => N,D=>2)
        port map ( A => in1, SHIFT_AMT => in2(D-1 downto 0), Y => sra_result );
                      
 and_comp: alu_and
        generic map ( N => N)
        port map ( A => in1, B => in2, Y => and_result );
        
 or_comp: alu_or
        generic map ( N => N)
        port map ( A => in1, B => in2, Y => or_result );
               
 xor_comp: alu_xor
        generic map ( N => N)
        port map ( A => in1, B => in2, Y => xor_result );
                      
addorsub : RippleCarryFullAdder 
       generic map ( N => N)
       port map ( A => in1, B => in2, OP => Control(0), Sum =>  fullAdder_result);

multiply : Multiplier
       generic map (N => N)
       port map (A => in1((N/2) - 1 downto 0),B=> in2((N/2)-1 downto 0),Product=> Multiplier_result);
        
       out1 <= or_result    when control = "1000" else 
            and_result      when control = "1010" else
            xor_result      when control = "1011" else
            sll_result      when control = "1100" else
            srl_result      when control = "1101" else
            sra_result      when control = "1110" else
            fullAdder_result when control = "0100" else -- Add
            fullAdder_result when control = "0101" else --Sub
            Multiplier_result;
            
end structural;