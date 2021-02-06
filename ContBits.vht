LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY ContBits_vhd_tst IS
END ContBits_vhd_tst;
ARCHITECTURE ContBits_arch OF ContBits_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC:='0';
SIGNAL reset_n : STD_LOGIC;
SIGNAL enable_cont : STD_LOGIC;
SIGNAL contador : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL contador_8 : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL medio_bit : STD_LOGIC;
SIGNAL un_bit : STD_LOGIC;
COMPONENT ContBits
	PORT (
	clk : IN STD_LOGIC;
	contador : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
	contador_8 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	enable_cont : IN STD_LOGIC;
	medio_bit : OUT STD_LOGIC;
	reset_n : IN STD_LOGIC;
	un_bit : OUT STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : ContBits
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	contador => contador,
	contador_8 => contador_8,
	enable_cont => enable_cont,
	medio_bit => medio_bit,
	reset_n => reset_n,
	un_bit => un_bit
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
        -- code that executes only once                      
WAIT;                                                       
END PROCESS init;  

clk <= not clk after 10 ns;
                                         
always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         
        -- code executes for every event on sensitivity list
	reset_n <= '0';
	enable_cont <= '0';
	wait for 100 ns;
	reset_n <= '1';
	wait for 20 ns;
	enable_cont <= '1';
	wait for 52100 ns;
	assert contador_8 = "0001"
		report "Error contador 1 ciclo"
		severity failure;
	wait for 52100 ns;
	assert contador_8 = "0010"
		report "Error contador 2 ciclos"
		severity failure;
	wait for 50 ns;
	assert false report "Fin simulacion" severity failure;
WAIT;                                                        
END PROCESS always;                                          
END ContBits_arch;
