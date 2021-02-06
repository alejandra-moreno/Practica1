LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY DetParidad_vhd_tst IS
END DetParidad_vhd_tst;
ARCHITECTURE DetParidad_arch OF DetParidad_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC:='0';
SIGNAL reset_n : STD_LOGIC;
SIGNAL enable_par : STD_LOGIC;
SIGNAL entrada : STD_LOGIC;
SIGNAL paridad : STD_LOGIC;

COMPONENT DetParidad
	PORT (
	clk : IN STD_LOGIC;
	enable_par : IN STD_LOGIC;
	entrada : IN STD_LOGIC;
	paridad : OUT STD_LOGIC;
	reset_n : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : DetParidad
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	enable_par => enable_par,
	entrada => entrada,
	paridad => paridad,
	reset_n => reset_n
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
        -- code that executes only once                      
WAIT;                                                       
END PROCESS init; 

clk <= not clk after 50 ns;
                                          
always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         
        -- code executes for every event on sensitivity list
	reset_n <= '0';
	enable_par <= '0';
	entrada <= '0';
	wait for 20 ns;
	reset_n <= '1';
	enable_par <= '1';
	wait for 10 ns;
	--Damos valores a la entrada
	entrada <= '1';	--1
	wait for 100 ns;
	entrada <= '0';	--0
	wait for 100 ns;
	entrada <= '1';	--1
	wait for 100 ns;
	entrada <= '0';	--0
	wait for 100 ns;	
	entrada <= '1';	--1
	wait for 100 ns;
	entrada <= '0';	--0
	wait for 100 ns;	
	entrada <= '1';	--1
	wait for 100 ns;
	entrada <= '0';	--0
	
	wait for 25 ns;
	enable_par <= '0';
	assert paridad = '0'
		report "Error en el calculo 1 de la paridad"
		severity failure;
		
	wait for 20 ns;
	reset_n <= '0'; --Reseteamos
	wait for 50 ns;
	reset_n <= '1';
	enable_par <= '1';
	
	wait for 60 ns;
	--Damos valores a la entrada 2
	entrada <= '1';	--1
	wait for 100 ns;
	entrada <= '0';	--0
	wait for 100 ns;
	entrada <= '1';	--1
	wait for 100 ns;
	entrada <= '0';	--0
	wait for 100 ns;	
	entrada <= '1';	--1
	wait for 100 ns;
	entrada <= '0';	--0
	wait for 100 ns;	
	entrada <= '1';	--1
	wait for 100 ns;
	entrada <= '1';	--1
	
	wait for 80 ns;
	enable_par <= '0';
	assert paridad = '1'
		report "Error en el calculo 2 de la paridad"
		severity failure;
	
	
	assert false report "Fin de simulacion" severity failure;
	
WAIT;                                                        
END PROCESS always;                                          
END DetParidad_arch;
