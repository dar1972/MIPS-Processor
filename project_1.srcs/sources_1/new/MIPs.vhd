---------------------------------------------------------------------
--Company: Rochester Institute of Technology
--Engineer: Dhruv Rajpurohit (dar1972@rit.edu)
--
--Create Date: 11/07/2020
--Design Name: MIPs 
--Module Name: MIPs - structural
--Project Name: Piplined MIPS Processor
--Target Device: Basys3
--
--Description: This is a Piplined MIPS Processor entity
---------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPs is
generic ( N : INTEGER := 32);
Port (
       clk             : IN std_logic;
       rst             : IN std_logic;
       switches        : IN std_logic_vector(15 downto 0);
       SevenSegDis     : OUT std_logic_vector(6 downto 0);
       ALUResult       : OUT std_logic_vector(31 downto 0)
      );
end MIPs;

architecture Structural of MIPs is

-- fetch

component InstructionFetch is
Port ( clk         : IN std_logic;
       rst         : IN std_logic;
       Instruction : OUT std_logic_vector(31 downto 0) 
      );
end component;

-- Decode 

component instruction_decoder is
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
end component;

-- Execute 

component Execute_Stage is
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
end component;

-- Memory 

component Memory_Stage is
generic ( RAM_WIDTH : integer := 32);
  Port ( 
       clk             : IN std_logic;
       RegWrite        : IN std_logic;
       MemtoReg        : IN std_logic;
       WriteReg        : IN std_logic_vector(4 downto 0);
       MemWrite        : IN std_logic;
       AluResult       : IN std_logic_vector(RAM_WIDTH-1 downto 0);
       WriteData       : IN std_logic_vector(RAM_WIDTH-1 downto 0);
       Switches        : IN std_logic_vector(15 downto 0);
       RegWriteOut     : OUT std_logic;
       MemtoRegOut     : OUT std_logic;
       WriteRegOut     : OUT std_logic_vector(4 downto 0);
       MemOut          : OUT std_logic_vector(RAM_WIDTH-1 downto 0);
       AluResultOut    : OUT std_logic_vector(RAM_WIDTH-1 downto 0);
       Active_Digit    : OUT std_logic_vector(3 downto 0);
       Seven_Seg_Digit : OUT std_logic_vector(6 downto 0)

  );
end component;

--WriteBack

component WB_Stage is
generic ( RAM_WIDTH : integer := 32);
  Port (
       RegWrite    : IN std_logic;
       MemtoReg    : IN std_logic;
       AluResult   : IN std_logic_vector(RAM_WIDTH-1 downto 0);
       ReadData    : IN std_logic_vector(RAM_WIDTH-1 downto 0);
       WriteReg    : IN std_logic_vector(4 downto 0);
       RegWriteOut : OUT std_logic;
       WriteRegOut : OUT std_logic_vector(4 downto 0);
       Result      : OUT std_logic_vector(RAM_WIDTH-1 downto 0)
  );
end component;

-- Fetch Stage signals 
signal InstD_in : std_logic_vector(N-1 downto 0);

-- Decode Stage signals
signal InstD_out   : std_logic_vector(N-1 downto 0);
signal RegWriteD   : std_logic; 
signal MemtoRegD   : std_logic; 
signal MemWriteD   : std_logic; 
signal ALUControlD : std_logic_vector(3 downto 0); 
signal ALUSrcD     : std_logic; 
signal RegDstD     : std_logic; 
signal RD1         : std_logic_vector(N-1 downto 0);
signal RD2         : std_logic_vector(N-1 downto 0);
signal RtD         : std_logic_vector(4 downto 0);
signal RdD         : std_logic_vector(4 downto 0);
signal SignImmD : std_logic_vector(N-1 downto 0);

-- Execute Stage signals
signal RegWriteEin   : std_logic; 
signal RegWriteEout   : std_logic; 
signal MemtoRegEin   : std_logic; 
signal MemtoRegEout   : std_logic; 
signal MemWriteEin   : std_logic; 
signal MemWriteEout   : std_logic; 
signal ALUControlE : std_logic_vector(3 downto 0); 
signal ALUSrcE     : std_logic; 
signal RegDstE     : std_logic;
signal SrcAE       : std_logic_vector(N-1 downto 0);
signal SrcBE       : std_logic_vector(N-1 downto 0);
signal ALUOutE     : std_logic_vector(N-1 downto 0);
signal RtE         : std_logic_vector(4 downto 0);
signal RdE         : std_logic_vector(4 downto 0);
signal SignImmE    : std_logic_vector(N-1 downto 0);
signal WriteDataE  : std_logic_vector(N-1 downto 0);
signal WriteRegE   : std_logic_vector(4 downto 0);

--Memory Stage signals 
signal RegWriteMin   : std_logic; 
signal RegWriteMout   : std_logic; 
signal MemtoRegMin   : std_logic; 
signal MemtoRegMout   : std_logic; 
signal MemWriteMin   : std_logic; 
--signal MemWriteMout   : std_logic; 
signal ALUOutMin     : std_logic_vector(N-1 downto 0);
signal ALUOutMout     : std_logic_vector(N-1 downto 0);
signal WriteDataM  : std_logic_vector(N-1 downto 0);
signal WriteRegMin   : std_logic_vector(4 downto 0);
signal WriteRegMout   : std_logic_vector(4 downto 0);
signal ReadDataM   : std_logic_vector(N-1 downto 0);
--signal ReadDataM   : std_logic_vector(N-1 downto 0);
signal ActiveDigit : std_logic_vector(3 downto 0);

-- WriteBack Stage signals
signal RegWriteWin   : std_logic; 
signal RegWriteWout   : std_logic; 
signal MemtoRegW   : std_logic;
signal ALUOutW     : std_logic_vector(31 downto 0);
signal ReadDataW   : std_logic_vector(31 downto 0);
signal ResultW     : std_logic_vector(31 downto 0);
signal WriteRegWin   : std_logic_vector(4 downto 0);
signal WriteRegWout   : std_logic_vector(4 downto 0);


begin

--------------------------- fetch stage process --------------------
FetchStage : InstructionFetch
Port map (     clk => clk,
               rst => rst,
               Instruction => InstD_in
         );

InstructionFetchproc : process(clk) is
begin
  if (rising_edge(clk)) then
    InstD_out <= InstD_in;
  end if;
end process;

-- Decode stage process 
InstructionDecode : instruction_decoder
  Port map( 
         clk          => clk,
         Instruction  => InstD_out,
         RegWriteAddr => WriteRegWout,
         RegWriteData => ResultW,
         RegWriteEn   => RegWriteWout,
         RegWrite     => RegWriteD,
         MemtoReg     => MemtoRegD,
         MemWrite     => MemWriteD,
         ALUControl   => ALUControlD,
         ALUSrc       => ALUSrcD,
         RegDst       => RegDstD,
         RD1          => RD1,
         RD2          => RD2,
         RtDest       => RtD,
         RdDest       => RdD,
         Immout       => SignImmD
       );
  
InstructionDecodeproc : process(clk) is
begin
  if (rising_edge(clk)) then
    RegWriteEin   <= RegWriteD;
    MemtoRegEin   <= MemtoRegD;
    MemWriteEin   <= MemWriteD;
    ALUControlE <= ALUControlD;
    ALUSrcE     <= ALUSrcD;
    RegDstE     <= RegDstD;
    SrcAE       <= RD1;
    SrcBE       <= RD2;
    RtE         <= RtD;
    RdE         <= RdD;
    SignImmE    <= SignImmD;
  end if;
end process; 
-- Execute stage process
InstructionExecute : Execute_Stage
      generic map(N =>  32)
      Port map( 
             RegWrite      => RegWriteEin,
             MemtoReg      => MemtoRegEin,
             MemWrite      => MemWriteEin,
             ALUControl    => ALUControlE,
             ALUSrc        => ALUSrcE,
             RegDst        => RegDstE,
             RegSrcA       => SrcAE,
             RegSrcB       => SrcBE,
             RtDest        => RtE,
             RdDest        => RdE,
             SignImm       => SignImmE,
             RegWriteOut   => RegWriteEout,
             MemtoRegOut   => MemtoRegEout,
             MemtoWriteOut => MemWriteEout,
             ALUResult     => ALUOutE,
             WriteData     => WriteDataE,
             WriteReg      => WriteRegE
            );
            
ALUResult <= ALUOutE;

InstructionExecuteproc : process(clk) is
begin
    if (rising_edge(clk)) then
        RegWriteMin  <= RegWriteEout;
        MemtoRegMin  <= MemtoRegEout;
        MemWriteMin  <= MemWriteEout;
        ALUOutMin    <= ALUOutE;
        WriteDataM <= WriteDataE;
        WriteRegMin  <= WriteRegE;
    end if;
end process;

-- Memory stage process
InstructionMemory: Memory_Stage 
    generic map( RAM_WIDTH => 32)
       Port map ( 
             clk             => clk,
             RegWrite        => RegWriteMin,
             MemtoReg        => MemtoRegMin,
             WriteReg        => WriteRegMin,
             MemWrite        => MemWriteMin,
             AluResult       => ALUOutMin,
             WriteData       => WriteDataM,
             Switches        => Switches,
             RegWriteOut     => RegWriteMout,
             MemtoRegOut     => MemtoRegMout,
             WriteRegOut     => WriteRegMout,
             MemOut          => ReadDataM,
             AluResultOut    => ALUOutMout,
             Active_Digit    => ActiveDigit,
             Seven_Seg_Digit => SevenSegDis
            
            );

InstructionMemoryStage : process(clk) is
begin
    if (rising_edge(clk)) then
        RegWriteWin  <= RegWriteMout;
        MemtoRegW  <= MemtoRegMout;
        ALUOutW    <= ALUOutMout;
        ReadDataW  <= ReadDataM;
        WriteRegWin  <= WriteRegMout;
    end if;
end process;

-- WriteBack stage process 
WriteBack : WB_Stage
     generic map( RAM_WIDTH => 32)
       Port map(
            RegWrite    => RegWriteWin,
            MemtoReg    => MemtoRegW,
            AluResult   => ALUOutW,
            ReadData    => ReadDataW,
            WriteReg    => WriteRegWin,
            RegWriteOut => RegWriteWout,
            WriteRegOut => WriteRegWout,
            Result      => ResultW
           ); 



end Structural;