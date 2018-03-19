----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.10.2015 15:11:13
-- Design Name: 
-- Module Name: Components - Behavioral
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

PACKAGE components IS   
COMPONENT ELE112_LAB_5_SPIS
    Port ( 
       MODE : in STD_LOGIC_VECTOR (3 downto 0);
       MOSI : in STD_LOGIC;
       MISO : out STD_LOGIC;
       SS : in STD_LOGIC;
       SCLK : in STD_LOGIC;
       Reset:in STD_LOGIC;
       CLK : in STD_LOGIC);
END COMPONENT;

COMPONENT ELE112_shiftlne is
GENERIC ( N : INTEGER := 4);
    Port ( R : in STD_LOGIC_VECTOR (N -1 downto 0);
           L : in STD_LOGIC;
           E : in STD_LOGIC;
           W : in STD_LOGIC;
           Clock : in STD_LOGIC;
           Q : inout STD_LOGIC_VECTOR (N -1 downto 0));
END COMPONENT;

COMPONENT ele112_PreScaler is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           preScalerNumber : in STD_LOGIC_VECTOR (3 downto 0);
           clkOut : out STD_LOGIC);
END COMPONENT;

  COMPONENT ele112_regn  --register
    GENERIC ( N : INTEGER := 8);
    PORT ( R           :IN STD_LOGIC_VECTOR ( N-1 DOWNTO 0);
           RIN, Clock  : IN  STD_LOGIC;
           Q           : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
  END COMPONENT; 
  
  COMPONENT ele112_UpDownCounter  --register
    GENERIC ( N : INTEGER := 8);
    Port ( count: in STD_LOGIC;
           UP_DOWN : in STD_LOGIC;
           clear: in STD_LOGIC;
           Q : inout STD_LOGIC_VECTOR (N-1 downto 0));
    END COMPONENT;       
           
  COMPONENT ele112_Address_decoder  --register
      Port ( Address : in STD_LOGIC_VECTOR (7 downto 0);
             RW : in STD_LOGIC;
             RW_Bus : out STD_LOGIC_VECTOR (7 downto 0));
  END COMPONENT;
   
  COMPONENT ele112_trin   --  tri-state Buffer
     GENERIC ( N : INTEGER := 8);
     PORT ( X : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
            E : IN  STD_LOGIC;
            F : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
     END COMPONENT;  
     
       COMPONENT ele112_ALU   --  ALU
        PORT ( s : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
               A : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
               B : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
               F : OUT  STD_LOGIC_VECTOR(7 DOWNTO 0));
        END COMPONENT; 
END components;                
