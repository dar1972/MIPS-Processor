----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology (RIT)
-- Engineer: Dhruv Rajpurohit (dar1972@rit.edu)
-- 
-- Create Date: 09/25/2020 02:39:42 PM
-- Design Name: control_unit
-- Module Name: control_unit - Behavioral
-- Project Name: InstructionDecoder
-- Target Devices: Basys3
-- 
-- Description: The following is the entity and description of a 
--              a control unit
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Entity for the control unit
entity control_unit is
Port ( Opcode     : IN std_logic_vector(5 downto 0);
       Funct      : IN std_logic_vector(5 downto 0);
       RegWrite   : OUT std_logic;
       MemtoReg   : OUT std_logic;
       MemWrite   : OUT std_logic;
       ALUControl : OUT std_logic_vector(3 downto 0);
       ALUSrc     : OUT std_logic;
       RegDst     : OUT std_logic
     );
end control_unit;

architecture Behavioral of control_unit is

begin

--process to determine if register writing is required
RegWrite_proc: process(Opcode, Funct)
begin
Case Opcode is
    when "101011" => RegWrite <= '0'; --SW
    when others   => RegWrite <= '1'; 
end case;
end process;

--process to determine if memory is required 
MemtoReg_proc: process(Opcode, Funct)
begin 
Case Opcode is 
    when "100011" => MemtoReg <= '1'; --LW
    when others   => MemtoReg <= '0'; 
end case;
end process;

--process to write the to memory if required
MemWrite_proc: process(Opcode, Funct)
begin
Case Opcode is
    when "101011" => MemWrite <= '1'; --SW
    when others   => MemWrite <= '0';
end case;
end process;

--process to determine the opcode which is specific for ALU
ALUControl_proc: process(Opcode, Funct)
begin
Case Opcode is
    when "000000" =>
        Case Funct is
            when "100000" => ALUControl <= "0100"; -- ADD
            when "100100" => ALUControl <= "1010"; --AND
            when "011001" => ALUControl <= "0110"; --MULTU
            when "100101" => ALUControl <= "1000"; --OR
            when "000000" => ALUControl <= "1100"; --SLL
            when "000011" => ALUControl <= "1110"; --SRA
            when "000010" => ALUControl <= "1101"; --SRL
            when "100010" => ALUControl <= "0101"; --SUB
            when "100110" => ALUControl <= "1011"; --XOR
            when others   => ALUControl <= "0000";
         end case;
    when "001000" => ALUControl <= "0100"; --ADDI
    when "001100" => ALUControl <= "1010"; --ANDI
    when "001101" => ALUControl <= "1000"; --ORI
    when "001110" => ALUControl <= "1011"; --XORI
    when others   => ALUControl <= "0000"; 
end case;
end process;

--procces to set if the ALU will use an immediate
AluSrc_proc: process(Opcode, Funct)
begin
Case Opcode is
    when "001000" => AluSrc <= '1'; -- ADDI
    when "001100" => AluSrc <= '1'; -- ANDI
    when "001101" => AluSrc <= '1'; -- ORI
    when "001110" => AluSrc <= '1'; --XORI
    when "101011" => AluSrc <= '1'; --SW
    when "100011" => AluSrc <= '1'; --LW
    when others   => AluSrc <= '0';
end case;
end process;

--process to determine which register will be used as a destination
RegDst_proc: process(Opcode, Funct)
begin
Case Opcode is
    when "001000" => RegDst <= '0'; --ADDI
    when "001100" => RegDst <= '0'; --ANDI
    when "001101" => RegDst <= '0'; --ORI
    when "001110" => RegDst <= '0'; --XORI
    when "101011" => RegDst <= '0'; --SW
    when "100011" => RegDst <= '0'; --LW
    when others   => RegDst <= '1'; 
end case;
end process;

end Behavioral;
