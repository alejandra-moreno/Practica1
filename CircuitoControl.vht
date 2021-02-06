 LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY CircuitoControl_vhd_tst IS
END CircuitoControl_vhd_tst;
ARCHITECTURE CircuitoControl_arch OF CircuitoControl_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC:='0';
SIGNAL datos : STD_LOGIC:='1';
SIGNAL reset_n : STD_LOGIC;
SIGNAL medio_bit : STD_LOGIC;
SIGNAL un_bit : STD_LOGIC;
SIGNAL paridad : STD_LOGIC;
SIGNAL error_paridad : STD_LOGIC;
SIGNAL error_trama : STD_LOGIC;
SIGNAL salida : STD_LOGIC_VECTOR(7 DOWNTO 0);
COMPONENT CircuitoControl
	PORT (
	clk : IN STD_LOGIC;
	datos : IN STD_LOGIC;
	medio_bit : out std_logic; --Pulso cada 1/2 bit
	un_bit : out std_logic; --Pulso cada un bit
	error_paridad : OUT STD_LOGIC;
	error_trama : OUT STD_LOGIC;
	paridad : OUT STD_LOGIC;
	reset_n : IN STD_LOGIC;
	salida : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;
BEGIN
	i1 : CircuitoControl
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	datos => datos,
	medio_bit => medio_bit,
	un_bit => un_bit,
	error_paridad => error_paridad,
	error_trama => error_trama,
	paridad => paridad,
	reset_n => reset_n,
	salida => salida
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
        -- code that executes only once                      
WAIT;                                                       
END PROCESS init;   

clk <= not clk after 10 ns; --Reloj
                                        
always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         
        -- code executes for every event on sensitivity list
	reset_n <= '0';
	wait for 30 ns;
	reset_n <= '1';
	wait for 10 ns;
	
	datos <= '0'; --Bit de start
	wait for 26040 ns;
	for n in 0 to 3 loop
		 datos <= '1';
		 wait for 52000 ns;
		 datos <= '0';
		 wait for 52000 ns;
	 end loop;
	
	wait for 20 ns;
	datos <= '1'; --Bit de paridad
	
	wait for 20 ns;
	datos <= '1'; --Bit de stop
	
	wait for 52100 ns;
	assert salida="10101010"
		report "Error salida"
		severity failure;
		
	assert false report "Fin de la simulacion." severity failure;
	
WAIT;                                                        
END PROCESS always;                                          
END CircuitoControl_arch;
