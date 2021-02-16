----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology (RIT)
-- Engineer: Dhruv Rajpurohit (dar1972@rit.edu)
-- 
-- Create Date: 09/25/2020 02:39:42 PM
-- Design Name: register_file
-- Module Name: register_file - Behavioral
-- Project Name: InstructionDecoder
-- Target Devices: Basys3
-- 
-- Description: The following is the entity and description of a 
--              register file which follows two-read, one-write format.
--              The file contains 2 to the power LOG_PORT_DEPTH (2^LOG_PORT_DEPTH)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity register_file is
Generic ( 
            BIT_DEPTH : integer := 8;
            LOG_PORT_DEPTH : integer := 3
        );

PORT(
    Addr1,Addr2,Addr3   : IN std_logic_vector(LOG_PORT_DEPTH-1 downto 0);
    wd                  : IN std_logic_vector(BIT_DEPTH-1 downto 0);
    clk_n,we            : IN std_logic;
    RD1, RD2            : OUT std_logic_vector(BIT_DEPTH-1 downto 0)
    );

end register_file;

architecture Behavioral of register_file is

Component generic_decoder is
    generic(
            LOG_PORT_DEPTH : integer := 3);
    Port (
            Addr_3      : IN std_logic_vector(LOG_PORT_DEPTH-1 downto 0);
            and_output  : OUT std_logic_vector(2**LOG_PORT_DEPTH-1 downto 0) 
        );
end Component;

Component generic_mux is
	generic(
            BIT_DEPTH : integer := 8; --Bit depth of signals
            LOG_PORT_DEPTH : integer := 3 --log_2 of the signal width
	);
	port(
            X	: in std_logic_vector(((2**LOG_PORT_DEPTH) * BIT_DEPTH)-1 downto 0);
            Sel : in std_logic_vector(LOG_PORT_DEPTH-1 downto 0);
            Y	: out std_logic_vector(BIT_DEPTH-1 downto 0)
	);
end Component;

Component two_and is
    PORT ( 
              A         : IN STD_LOGIC;
              we        : IN STD_LOGIC;
              Y         : OUT STD_LOGIC
          );
end Component;

Component register_module is
    Generic (BIT_DEPTH : integer := 8);
    Port (
            input   : IN std_logic_vector(BIT_DEPTH - 1 downto 0);
            clk_n   : IN std_logic;
            we      : IN std_logic;
            output  : OUT std_logic_vector(BIT_DEPTH - 1 downto 0)
        );
end Component;

signal output_decoder  : std_logic_vector(2**LOG_PORT_DEPTH - 1 downto 0);
signal output_and      : std_logic_vector(2**LOG_PORT_DEPTH - 1 downto 0);
signal output_register : std_logic_vector(((2**LOG_PORT_DEPTH)*BIT_DEPTH)-1 downto 0);

begin

decode : generic_decoder
 GENERIC MAP ( LOG_PORT_DEPTH => 5)
 PORT MAP ( 
            Addr_3        => Addr3,
            and_output => output_decoder
          );
          
 and_gen : FOR I IN 0 TO 2**LOG_PORT_DEPTH - 1 GENERATE
    and_gate : two_and
        PORT MAP (
                A      => output_decoder(I),
                we     => we,
                Y      => output_and(I)
                );
 END GENERATE and_gen;
          
module_gen : FOR I IN 0 TO 2**LOG_PORT_DEPTH - 1 GENERATE
    module : register_module
    Generic Map( BIT_DEPTH => 32)
    Port Map( 
      input  => wd,
      clk_n  => clk_n,
      we     => output_and(I),
      output => output_register(((i+1) * BIT_DEPTH) - 1 downto (i * BIT_DEPTH))
     );
END GENERATE module_gen;


mux1 : generic_mux 
GENERIC MAP (
        BIT_DEPTH => 32,
		LOG_PORT_DEPTH => 5
		)
PORT MAP (
		X   => output_register,
        Sel => Addr1,
        Y   => RD1
        );
        
mux2 : generic_mux 
        GENERIC MAP (
                BIT_DEPTH => 32,
                LOG_PORT_DEPTH => 5
                )
        PORT MAP (
                X   => output_register,
                Sel => Addr2,
                Y   => RD2
                );

end Behavioral;

