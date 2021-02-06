LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY RegSerPar_vhd_tst IS
END RegSerPar_vhd_tst;
ARCHITECTURE RegSerPar_arch OF RegSerPar_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC:='0'; --Inicializar a 0
SIGNAL reset_n : STD_LOGIC;
SIGNAL enable : STD_LOGIC;
SIGNAL entrada : STD_LOGIC;
SIGNAL salida : STD_LOGIC_VECTOR(7 DOWNTO 0);
COMPONENT RegSerPar
	PORT (
	clk : IN STD_LOGIC;
	enable : IN STD_LOGIC;
	entrada : IN STD_LOGIC;
	reset_n : IN STD_LOGIC;
	salida : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;
BEGIN
	i1 : RegSerPar
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	enable => enable,
	entrada => entrada,
	reset_n => reset_n,
	salida => salida
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
        -- code that executes only once                      
WAIT;                                                       
END PROCESS init;

clk <= not clk after 50 ns; --Reloj
                                         
always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         
        -- code executes for every event on sensitivity list
	reset_n <= '0';
	enable <= '0';
	entrada <= '0';
	wait for 100 ns;
	reset_n <= '1';
	wait for 20 ns;
	
	enable <= '1';
	wait for 10 ns;
	entrada <= '1';
	wait for 80 ns;
	entrada <= '0';
	wait for 160 ns;
	entrada <= '1';
	wait for 50 ns;
	assert salida <= "10010000"
		report "Error 1 en el registro"
		severity failure; --Comprobacion intermedia
	wait for 160 ns;
	entrada <= '0';
	wait for 80 ns;
	entrada <= '1';
	wait for 200 ns;
	assert salida <= "11011001"
		report "Error 2 en el registro"
		severity failure; --Comprobacion final
		
	assert false report "Fin de la simulacion." severity failure;

WAIT;                                                        
END PROCESS always;                                          
END RegSerPar_arch;
