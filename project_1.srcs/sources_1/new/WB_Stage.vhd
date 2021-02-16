----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology
-- Engineer: Dhruv Rajpurohit (dar1972@rit.edu)
-- 
-- Create Date: 10/24/2020 4:12:55 PM
-- Design Name: Writeback Stage
-- Module Name: WB_Stage - Behavioral
-- Project Name: Memory & Writeback Stage
-- Target Devices: Basys3
--  Description:   The following is the entity and architectural description of a
--                 Writeback stage module
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity WB_Stage is
generic ( RAM_WIDTH : integer := 32);
  Port (
       RegWrite : IN std_logic;
       MemtoReg : IN std_logic;
       AluResult : IN std_logic_vector(RAM_WIDTH-1 downto 0);
       ReadData : IN std_logic_vector(RAM_WIDTH-1 downto 0);
       WriteReg : IN std_logic_vector(4 downto 0);
       RegWriteOut : OUT std_logic;
       WriteRegOut : OUT std_logic_vector(4 downto 0);
       Result : OUT std_logic_vector(RAM_WIDTH-1 downto 0)
  );
end WB_Stage;

architecture Behavioral of WB_Stage is

begin

process (MemtoReg,AluResult,ReadData,RegWrite,WriteReg) is
begin
  case MemtoReg is 
    when '1' =>
      Result <= ReadData;
    when others =>
      Result <= AluResult;
  end case;
end process;

WriteRegOut <= WriteReg;
RegWriteOut <= RegWrite;

end Behavioral;

