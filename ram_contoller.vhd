library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_controller is
    port(
        clk : in std_logic;
        reset : in std_logic;
        ready_save : in std_logic;
        p1 : in std_logic_vector(15 downto 0);
        p2 : in std_logic_vector(15 downto 0);
        p3 : in std_logic_vector(15 downto 0);
        p4 : in std_logic_vector(15 downto 0);
        ram_address : out std_logic_vector(7 downto 0);
        web : out std_logic;
        dataRAM : out std_logic_vector(31 downto 0)
    ); 
end ram_controller;

architecture behavioral of ram_controller is
type state_type is (s_init, s_save1, s_save2);
signal current_state, next_state : state_type;
signal current_p1, next_p1, current_p2, next_p2, current_p3, next_p3, current_p4, next_p4 : std_logic_vector(15 downto 0);
signal address_counter, address_counter_next : unsigned(7 downto 0);

begin

registers : process(clk)
begin
    if reset = '1' then
        address_counter <= (others => '0');
        current_state <= s_init;
    elsif rising_edge(clk) then
        current_p1 <= next_p1;
        current_p2 <= next_p2;
        current_p3 <= next_p3;
        current_p4 <= next_p4;
        current_state <= next_state;
        address_counter <= address_counter_next;
    end if;
end process;

statemachine : process(ready_save, p1, p2, p3, p4, current_p1, current_p2, current_p3, current_p4, address_counter)
begin
ram_address <= std_logic_vector(address_counter);
address_counter_next <= address_counter; 
case current_state is
    when s_init =>
        web <= '0';    
        if ready_save = '1' then
            next_p1 <= p1;
            next_p2 <= p2;
            next_p3 <= p3;
            next_p4 <= p4;
            next_state <= s_save1;
         else
            next_p1 <= current_p1;
            next_p2 <= current_p2;
            next_p3 <= current_p3;
            next_p4 <= current_p4;
            next_state <= s_init;
         end if; 
    when s_save1 =>
            dataRAM <= current_p1 & current_p2;
            web <= '1';
            ram_address <= std_logic_vector(address_counter);
            address_counter_next <= address_counter + 1;
            next_state <= s_save2;
    when s_save2 =>
            dataRAM <= current_p3 & current_p4;
            web <= '1';
            ram_address <= std_logic_vector(address_counter);
            address_counter_next <= address_counter + 1;
            next_state <= s_init;
end case;    
end process;
    
end behavioral;