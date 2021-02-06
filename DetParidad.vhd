library ieee;
use ieee.std_logic_1164.all;
use ieee. numeric_std .all;

entity DetParidad is
	port(
		clk : in std_logic;
		reset_n : in std_logic;
		enable_par : in std_logic;
		entrada : in std_logic;
		paridad : out std_logic); --Par es 0, impar es 1
		
end DetParidad;

architecture behavioral of DetParidad is
	signal paridad_aux : unsigned(3 downto 0);
	
begin
	process(reset_n, clk)
	begin
	if reset_n='0' then
			paridad_aux <= (others => '0');
		elsif rising_edge(clk) then
			if enable_par='1' then
				if entrada='1' then
					paridad_aux <= paridad_aux+1;
				end if;
			end if;
		end if;
	end process;
	--Si es par es 0
	--Si es impar es 1
	paridad <= std_logic(paridad_aux(0));
	
end behavioral;