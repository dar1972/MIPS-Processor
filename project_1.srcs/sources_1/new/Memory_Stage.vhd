----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology
-- Engineer: Dhruv Rajpurohit (dar1972@rit.edu)
-- 
-- Create Date: 10/16/2020 2:00:35 PM
-- Design Name: Memory Stage
-- Module Name: Memory_Stage - Behavioral
-- Project Name: Memory & Writeback Stage
-- Target Devices: Basys3
--  Description:   The following is the entity and architectural description of a
--                 memory stage module
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Memory_Stage is
generic ( RAM_WIDTH : integer := 32);
  Port ( 
       clk      : IN std_logic;
       RegWrite : IN std_logic;
       MemtoReg : IN std_logic;
       WriteReg : IN std_logic_vector(4 downto 0);
       MemWrite : IN std_logic;
       AluResult : IN std_logic_vector(RAM_WIDTH-1 downto 0);
       WriteData : IN std_logic_vector(RAM_WIDTH-1 downto 0);
       Switches : IN std_logic_vector(15 downto 0);
       RegWriteOut : OUT std_logic;
       MemtoRegOut : OUT std_logic;
       WriteRegOut : OUT std_logic_vector(4 downto 0);
       MemOut : OUT std_logic_vector(RAM_WIDTH-1 downto 0);
       AluResultOut : OUT std_logic_vector(RAM_WIDTH-1 downto 0);
       Active_Digit : OUT std_logic_vector(3 downto 0);
       Seven_Seg_Digit : OUT std_logic_vector(6 downto 0)

  );
end Memory_Stage;

architecture Behavioral of Memory_Stage is

Component Data_Memory is
generic ( RAM_WIDTH : integer := 32;
          ADDR_SPACE : integer := 10);
 port(
      clk  : IN std_logic;
      we   : IN std_logic;
	  addr : IN std_logic_vector(ADDR_SPACE-1 downto 0);
	  d_in : IN std_logic_vector(RAM_WIDTH-1 downto 0);
	  switches   : IN std_logic_vector(15 downto 0);
	  d_out : OUT std_logic_vector(RAM_WIDTH-1 downto 0);
	  seven_seg : OUT std_logic_vector(15 downto 0)
	  );
end component;

Component SevenSegController is
	port(
	clk            : in std_logic;
	rst            : in std_logic;
	display_number : in std_logic_vector(15 downto 0);
	active_segment : out std_logic_vector(3 downto 0);
	led_out        : out std_logic_vector(6 downto 0)
	);
end component;
signal sevensegsig : std_logic_vector(15 downto 0);
begin


mem : Data_Memory 
generic map (RAM_WIDTH => 32,
          ADDR_SPACE => 10)
Port map (      
          clk       => clk,
          we        => MemWrite,
	      addr      => ALUResult(9 downto 0),
	      d_in      => WriteData,
	      switches  => Switches,
	      d_out     => MemOut,
	      seven_seg => sevensegsig
          );

sevenseg : SevenSegController
port map (
	     clk            => clk,
	     rst            => '0',
	     display_number => sevensegsig,
	     active_segment => Active_Digit,
	     led_out        => Seven_Seg_Digit
         );
              
RegWriteOut <= RegWrite;
MemtoRegOut <= MemtoReg;
WriteRegOut <= WriteReg;
AluResultOut <= AluResult;

end Behavioral;
