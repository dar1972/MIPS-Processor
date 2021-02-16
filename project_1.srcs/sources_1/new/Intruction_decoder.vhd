----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology (RIT)
-- Engineer: Dhruv Rajpurohit (dar1972@rit.edu)
-- 
-- Create Date: 09/25/2020 02:39:42 PM
-- Design Name: intruction_decoder
-- Module Name: instruction_decoder - Behavioral
-- Project Name: InstructionDecoder
-- Target Devices: Basys3
-- 
-- Description: The following is the entity and description of a 
--              a control unit
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity instruction_decoder is
  Port ( 
         clk          : IN std_logic;
         Instruction  : IN std_logic_vector(31 downto 0);
         RegWriteAddr : IN std_logic_vector(4 downto 0);
         RegWriteData : IN std_logic_vector(31 downto 0);
         RegWriteEn   : IN std_logic;
         RegWrite     : OUT std_logic;
         MemtoReg     : OUT std_logic;
         MemWrite     : OUT std_logic;
         ALUControl   : OUT std_logic_vector(3 downto 0);
         ALUSrc       : OUT std_logic;
         RegDst       : OUT std_logic;
         RD1          : OUT std_logic_vector(31 downto 0);
         RD2          : OUT std_logic_vector(31 downto 0);
         RtDest       : OUT std_logic_vector(4 downto 0);
         RdDest       : OUT std_logic_vector(4 downto 0);
         Immout       : OUT std_logic_vector(31 downto 0)
   
       );
end instruction_decoder;

architecture Behavioral of instruction_decoder is

Component register_file is
generic(
		BIT_DEPTH      : integer := 32; -- 32 Bit depth of signals
		LOG_PORT_DEPTH : integer := 5 -- 5 bit of the signal width
	);
	
PORT( 
     Addr1      : IN std_logic_vector(LOG_PORT_DEPTH-1 downto 0);
     Addr2      : IN std_logic_vector(LOG_PORT_DEPTH-1 downto 0);
     Addr3      : IN std_logic_vector(LOG_PORT_DEPTH-1 downto 0);
     wd         : IN std_logic_vector(BIT_DEPTH-1 downto 0);
     clk_n      : IN std_logic;
     we         : IN std_logic;
     RD1        : OUT std_logic_vector(BIT_DEPTH-1 downto 0);
     RD2        : OUT std_logic_vector(BIT_DEPTH-1 downto 0)
    );
end component; 	

Component control_unit is
Port ( 
       Opcode     : IN std_logic_vector(5 downto 0);
       Funct      : IN std_logic_vector(5 downto 0);
       RegWrite   : OUT std_logic;
       MemtoReg   : OUT std_logic;
       MemWrite   : OUT std_logic;
       ALUControl : OUT std_logic_vector(3 downto 0);
       ALUSrc     : OUT std_logic;
       RegDst     : OUT std_logic
     );
end Component;

begin

regfile : register_file
generic map (
             BIT_DEPTH     => 32,
		     LOG_PORT_DEPTH => 5 
		    )
port map    (
              Addr1   => Instruction(25 downto 21),
              Addr2   => Instruction(20 downto 16),
              Addr3   => RegWriteAddr,
              wd      => RegWriteData,
              clk_n   => clk,
              we      => RegWriteEn,
              RD1     => RD1,
              RD2     => RD2
             );
             
           
controlUnit : control_unit

port map (
          Opcode    => Instruction(31 downto 26),              
          Funct     => Instruction(5 downto 0),  
          RegWrite  => RegWrite,   
          MemtoReg  => MemtoReg,
          MemWrite  => MemWrite,
          ALUControl=> ALUControl,
          ALUSrc    => ALUSrc,
          RegDst    => RegDst
         );
         
RtDest <= Instruction(20 downto 16);
RdDest <= Instruction(15 downto 11);

ImmOut(15 downto 0) <=  Instruction(15 downto 0);
ImmOut(31 downto 16) <= (others => Instruction(15));


end Behavioral;
