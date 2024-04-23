library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MU is
    port(
        reset : in std_logic;
        clk : in std_logic;
        current_sum : in unsigned(15 downto 0);
        input : in unsigned(7 downto 0);
        coeff : in unsigned(6 downto 0);
        output : out unsigned(15 downto 0) 
    );
end MU;

architecture behavioral of MU is
begin

--registers : process(clk)
--begin
--    if reset = '1' then
--        output <= (others => '0');
--    elsif rising_edge(clk) then
--        output<= (input*coeff) +  current_sum;
--    end if;
--end process;
output<= (input*coeff) +  current_sum;
end behavioral;