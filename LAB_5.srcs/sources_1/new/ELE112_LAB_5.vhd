----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.02.2016 07:47:55
-- Design Name: 
-- Module Name: ELE112_LAB_5 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.components.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ELE112_LAB_5 is
GENERIC( N : INTEGER :=8; TS : INTEGER :=24);
    Port ( LED_sel : in STD_LOGIC_VECTOR (1 downto 0);
           MODE : in STD_LOGIC_VECTOR (3 downto 0);
           START : in STD_LOGIC;
           STARTED : inout STD_LOGIC;
           DONE : inout STD_LOGIC;
           LED : out STD_LOGIC_VECTOR (7 downto 0);
           MOSI : out STD_LOGIC;
           MISO : in STD_LOGIC;
           SS : out STD_LOGIC;
           SCLK : inout STD_LOGIC;
           Reset:in STD_LOGIC;
           CLK : in STD_LOGIC);
end ELE112_LAB_5;

architecture Behavioral of ELE112_LAB_5 is
  TYPE State_type IS (S0, S1, S2, S3, S4, S5);  -- You may need more states to this FSM
  SIGNAL State : State_type;
  
  SIGNAL TX_register : std_logic_vector (TS-1 downto 0);
  SIGNAL S_register : std_logic_vector (TS-1 downto 0);
  SIGNAL X_register : std_logic_vector (N-1 downto 0);
  SIGNAL Y_register : std_logic_vector (N-1 downto 0);
  SIGNAL Z_register : std_logic_vector (N-1 downto 0);
  SIGNAL Count : std_logic_vector (7 downto 0);
  SIGNAL Z : STD_LOGIC := '0';
  SIGNAL LC : STD_LOGIC := '0';
  SIGNAL LS : STD_LOGIC := '0';
  SIGNAL ES : STD_LOGIC := '0';
  SIGNAL LD_X : STD_LOGIC := '0';
  SIGNAL LD_Y : STD_LOGIC := '0';
  SIGNAL LD_Z : STD_LOGIC := '0';
  SIGNAL  MISO_int : STD_LOGIC := '0';
  --
  CONSTANT InstRead      : std_logic_vector (7 downto 0) := x"0B";
  CONSTANT InstWrite     : std_logic_vector (7 downto 0) := x"0A";
  CONSTANT ADDR_X_Data   : std_logic_vector (7 downto 0) := x"08";
  CONSTANT ADDR_Y_Data   : std_logic_vector (7 downto 0) := x"09";
  CONSTANT ADDR_Z_Data   : std_logic_vector (7 downto 0) := x"0A";
begin


-- You may need more states to this FSM    
FSM_transition: PROCESS(CLK)
   BEGIN
     IF Reset = '1' THEN -- Upon reset, set state to S0
        State <= S0;
     ELSIF (CLK'EVENT AND CLK = '1') THEN
        CASE State IS
        
           -- If the current state is S0 and Reset is set to 0, then the
           -- next state is S1
           WHEN S0 =>
           State <= S1;
                
            WHEN S1 =>
              IF START = '0' THEN State <= S1;
              ELSE State <= S2; END IF;
              
           WHEN S2 =>
              State <= S3;
              
           WHEN S3 =>
              IF Z = '1' THEN State <= S4;
              ELSE State <= S3; END IF;
           
           WHEN S4 => 
              State <= S5;
           
           WHEN S5 =>
                IF START = '1' THEN State <= S5;
                ELSE State <= S1; END IF;    
           
           WHEN others =>
                State <= S1;   
        END CASE;
     END IF;
   END PROCESS;
   
   
FSM_outPuts: PROCESS(State, clk)
   BEGIN
    Done <='0';STARTED <='0';LC<='0';LS<='0';ES<='0';SS<='1';LD_X<='0';LD_Y<='0';LD_Z<='0';SCLK <='0';
     CASE State IS
        WHEN S0 =>
        
        WHEN S1 =>
            LS <= '1';
            LC <= '1';
        
        WHEN S2 =>
            SS <= '0';
        
        WHEN S3 =>
            ES <= '1';
            SCLK <= '1';
            STARTED <= '1';
            
        WHEN S4 =>
            SS <= '1';
            ES <= '0';
            LD_X <= '1';
            LD_Y <= '1';
            LD_Z <= '1';
        
        WHEN S5 =>
            DONE <= '1';
          
     END CASE;
   END PROCESS;   
   
MISO_sample: PROCESS(SCLK)
   BEGIN
   IF SCLK'EVENT AND SCLK = '1' THEN
     MISO_int <= MISO;
    end if; 
  END PROCESS;  
   

   
   -- datapath circuit  
   
Counter_n: ele112_UpDownCounter PORT MAP (
                    count=>CLK,
                    UP_DOWN => Z,
                    clear => Reset,
                    Q => Count
                  );    
                                 
X_DATA_REG:ele112_regn GENERIC MAP(N => N)
                       PORT MAP (
                   R => S_register (7 downto 0),
                   Rin => LD_X,
                   Clock => CLK,
                   Q => X_register 
                  ); 
Y_DATA_REG:ele112_regn GENERIC MAP(N => N)
                       PORT MAP (
               R => S_register (7 downto 0),
               Rin => LD_Y,
               Clock => CLK,
               Q => Y_register  
              ); 
Z_DATA_REG:ele112_regn GENERIC MAP(N => N)
                       PORT MAP (
               R => S_register (7 downto 0),
               Rin => LD_Z,
               Clock => CLK,
               Q => Z_register 
              ); 
SPI_SHIFT_REG:ELE112_shiftlne GENERIC MAP(N => TS)
                        PORT MAP (
                R => TX_register,
                L => LS,
                E => ES,
                W => MISO_int,
                Clock => CLK,
                Q => S_register
           );  

-- You need to add the rest of the data path
                               

                              
end Behavioral;
