library ieee;
use ieee.std_logic_1164.all;

entity DetectorFlanco is
	port(
		e: in std_logic;
		s: out std_logic;
		clk: in std_logic;
		res: in std_logic);
end DetectorFlanco;

architecture behavioral of DetectorFlanco is
	type t_estado is (esp0,esp1,pulso);
	signal estado_act, estado_sig : t_estado;
	
	begin
	varestado: process (clk,res)
	begin 
	if res='0' then 
		estado_act <= esp1;
	elsif clk'event and clk='1' then 
		estado_act<=estado_sig;
	end if;
	end process varestado;
	
	transiciones: process(estado_act, e)
	begin
	estado_sig <= estado_act;
	case estado_act is 
		when esp1 => 
			if e='1' then 
				estado_sig<=pulso;
			end if;
		when pulso => 
			if e='1' then 
				estado_sig<=esp0;
			else 
				estado_sig<= esp1;
			end if; 
		when esp0 =>
			if e='0' then 
				estado_sig<=esp1;
			end if;
		when others =>
			estado_sig<=esp1;
	end case;
	end process transiciones;
	
	salidas: process(estado_act)
	begin
	s<='0';
	case estado_act is 
		when esp1 => 
			null;
		when pulso => 
			s<='1';
		when esp0 => 
			null;
		when others =>
			null;
	end case;
	end process salidas;
end behavioral;
	