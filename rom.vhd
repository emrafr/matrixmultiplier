library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std;
entity rom is
    port(
        clk : in std_logic;
        romAddress : in std_logic_vector(3 downto 0);
        dataROM : out std_logic_vector(13 downto 0)        
    );
end rom;

architecture behavioral of rom is
signal data : std_logic_vector(13 downto 0);
type mem is array (0 to 15) of std_logic_vector(13 downto 0);
constant my_rom : mem := (
    0 => "00000110010110",
    1 => "00010110000001",
    2 => "00010000000011",
    3 => "00000010000010",
    4 => "00010000001111",
    5 => "00000100000100",
    6 => "00011000000110",
    7 => "00000010000010",
    8 => "00100100101000",
    9 => "00000110000010",
    10 => "00100000001001",
    11 => "00000010000010",
    12 => "00000010001010",
    13 => "00001000000000",
    14 => "00000100001100",
    15 => "00000010000010"
);
begin

clock : process(clk)
begin
    if rising_edge(clk) then
        dataROM <= data;
    end if;
end process;

process (romAddress)
begin
    case romAddress is
        when "0000" => data <= my_rom(0);
        when "0001" => data <= my_rom(1);
        when "0010" => data <= my_rom(2);
        when "0011" => data <= my_rom(3);
        when "0100" => data <= my_rom(4);
        when "0101" => data <= my_rom(5);
        when "0110" => data <= my_rom(6);
        when "0111" => data <= my_rom(7);
        when "1000" => data <= my_rom(8);
        when "1001" => data <= my_rom(9);
        when "1010" => data <= my_rom(10);
        when "1011" => data <= my_rom(11);
        when "1100" => data <= my_rom(12);
        when "1101" => data <= my_rom(13);
        when "1110" => data <= my_rom(14);
        when "1111" => data <= my_rom(15);
        when others => data <= "00000000000000";
     end case;
end process;
end behavioral;