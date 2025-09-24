library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity combinatory_circuit is
    Port (A_1: in std_logic; 
          A_2: in std_logic;
          B_1: in std_logic;
          B_2: in std_logic;
          D_1: in std_logic;
          E: out std_logic_vector(2 downto 0));
end combinatory_circuit;

architecture Behavioral of combinatory_circuit is
signal A_out: std_logic;
signal B_out: std_logic;
signal C_out: std_logic;
signal D_not: std_logic;

begin
    D_not <= not D_1;
    A_out <= A_1 and A_2;
    B_out <= B_1 or B_2;
    C_out<= B_2 and D_not;
    E(0) <= A_out;
    E(1) <= B_out;
    E(2) <= C_out;
end Behavioral;