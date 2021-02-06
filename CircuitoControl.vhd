library ieee;
use ieee.std_logic_1164.all;

entity CircuitoControl is
	port(
		clk : in std_logic;
		reset_n : in std_logic;
		datos : in std_logic; --Bit de entrada
		medio_bit : out std_logic; --Pulso cada 1/2 bit
		un_bit : out std_logic; --Pulso cada un bit
		paridad : out std_logic;
		error_paridad : out std_logic;
		error_trama : out std_logic;
		salida : out std_logic_vector(7 downto 0)); --Del registro ser-par

end CircuitoControl;

architecture behavioral of CircuitoControl is
	type t_estados is (reposo, start, registro_ser, reg_parpar, error_tra, stop, error_par);
	signal estado_act, estado_sig : t_estados;
	signal medio_bit_aux, un_bit_aux : std_logic:='0';
	signal error_p, error_t : std_logic:='0';
	signal enable_reg, enable_reg_par, enable_par, enable_cont, paridad_aux : std_logic;
	signal contador : std_logic_vector(11 downto 0);
	signal contador_8 : std_logic_vector(3 downto 0);
	signal salida_aux, salida_aux_final : std_logic_vector(7 downto 0);

	component RegSerPar
		port(
			clk : in std_logic;
			reset_n : in std_logic;
			enable : in std_logic;
			entrada : in std_logic;
			salida : out std_logic_vector(7 downto 0));
		
	end component;
	
	component RegParPar
		port(
			clk : in std_logic;
			reset_n : in std_logic;
			enable : in std_logic;
			entrada : in std_logic_vector(7 downto 0);
			salida : out std_logic_vector(7 downto 0));
			
	end component;
	
	component DetParidad
		port(
			clk : in std_logic;
			reset_n : in std_logic;
			enable_par : in std_logic;
			entrada : in std_logic;
			paridad : out std_logic);
		
	end component;
	
	component ContBits
		port(
		clk : in std_logic;
		reset_n : in std_logic;
		enable_cont : in std_logic;
		contador : out std_logic_vector(11 downto 0);
		contador_8 : out std_logic_vector(3 downto 0);
		medio_bit : out std_logic;
		un_bit : out std_logic);
		
	end component;

begin
	
	i_RegSerPar : RegSerPar
		port map(
			clk => clk,
			reset_n => reset_n,
			enable => enable_reg,
			entrada => datos, --Bits de 1 en 1
			salida => salida_aux); --Vector de 8 bits
			
	i_RegParPar : RegParPar
		port map(
			clk => clk,
			reset_n => reset_n,
			enable => enable_reg_par,
			entrada => salida_aux, --Vector de 8 bits
			salida => salida_aux_final); --Vector de 8 bits
			
	i_DetParidad : DetParidad
		port map(
			clk => clk,
			reset_n => reset_n,
			enable_par => enable_par,
			entrada => datos, --Bits de 1 en 1
			paridad => paridad_aux);
			
	i_ContBits : ContBits
		port map(
		clk => clk,
		reset_n => reset_n,
		enable_cont => enable_cont,
		contador => contador,
		contador_8 => contador_8,
		medio_bit => medio_bit_aux,
		un_bit => un_bit_aux);
			
	VarEstado: process(clk, reset_n)
	begin
		if reset_n='0' then 
			estado_act <= reposo;
		elsif clk'event and clk='1' then 
			estado_act <= estado_sig;
		end if;
	end process;

	CambioEstados: process(estado_act, datos)
	begin
	estado_sig <= estado_act;
	case estado_act is 
			when reposo =>
				if datos='0' then 
					estado_sig <= start;
					enable_cont <= '1';
				end if;
			when start =>
				--Comprobamos que start sigue a 0
				if medio_bit_aux='1' and datos='0' then estado_sig <= registro_ser;
				elsif medio_bit_aux='1' and datos='1' then estado_sig <= error_tra;
				end if;
			when registro_ser =>
				--Leemos los 8 bits
				enable_reg <= '1';
				enable_par <= '1';
				if contador_8="1001" then
					enable_par <= '0';
					--Si es par (0) el bit 9 debe ser 1 
					--Si es impar (1) el bit 9 debe ser 0
					if  paridad_aux='1' and datos='0'  then
						estado_sig <= reg_parpar; --Es impar
					elsif paridad_aux='0' and datos='1' then
						estado_sig <= reg_parpar; --Es par
					else 
						estado_sig <= error_par;
					end if;
				end if;
			when reg_parpar =>
				enable_reg_par <= '1';
				if contador_8="1010" then estado_sig <= stop;
				end if;
			when stop =>
				--Verificamos que vale 1
				if datos='1' then estado_sig <= reposo;
				elsif datos='0' then estado_sig <= error_tra;
				end if;
			when error_par => --Hay que encender un LED en caso de error
				error_p <= '1';
			when error_tra =>
				error_t <= '1';
	end case;
	end process;
	
	salida <= salida_aux_final;
	paridad <= paridad_aux;
	medio_bit <= medio_bit_aux;
	un_bit <= un_bit_aux;
	error_paridad <= error_p;
	error_trama <= error_t;
	
end behavioral;