library ieee;
use ieee. std_logic_1164 .all;
use ieee. numeric_std .all;

entity ContBits is
	port(
		clk : in std_logic;
		reset_n : in std_logic;
		enable_cont : in std_logic;
		contador : out std_logic_vector(11 downto 0);
		contador_8 : out std_logic_vector(3 downto 0);
		medio_bit : out std_logic;
		un_bit : out std_logic);
		
end ContBits;

architecture behavioral of ContBits is

	signal contador_aux : unsigned(11 downto 0);
	signal contador_8_aux : unsigned(3 downto 0):="0000";
	signal medio_bit_aux : std_logic:='0';
	signal un_bit_aux : std_logic:='0';
	
begin
	process(clk,reset_n, enable_cont)
	begin
		if reset_n='0' then
			contador_aux <= (others => '0');
			contador_8_aux <= (others => '0');
		elsif rising_edge(clk) then
			if enable_cont='1' then
				contador_aux <= contador_aux+1;
				if contador_aux="101000101100" then
					contador_8_aux <= contador_8_aux+1;
					contador_aux <= (others => '0'); --Se pone a 0
				end if;
			end if;
		end if;
	end process;

	medio_bit <= '1' when contador_aux="010100010110" or contador_aux="101000101100" else '0';
	un_bit <= '1' when contador_aux="101000101100" else '0';
	
	contador <= std_logic_vector(contador_aux);
	contador_8 <= std_logic_vector(contador_8_aux);
	
end behavioral;