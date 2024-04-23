library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller is
    port(
        clk : in std_logic;
        reset : in std_logic;
        ready_save : in std_logic; -- will be one when one column is done
        done : in std_logic;
        ready : out std_logic;
        finish : out std_logic;  
        column_counter : out unsigned(2 downto 0)     
    );
end controller;

-- 2 states idle and counteing col from ready_save signal then count_col is4 change to idle send out ready

architecture behavioral of controller is
type state_type is (s_idle, s_running);
signal current_state, next_state : state_type;
signal column_counter_current, column_counter_next : unsigned(2 downto 0);

begin
    registers : process(clk)
    begin
        if reset = '1' then
            current_state <= s_idle;
            column_counter_current <= (others => '0');
        elsif rising_edge(clk) then
            current_state <= next_state;
            column_counter_current <= column_counter_next;
        end if;
    end process;
    
    process(ready_save, column_counter_current, done)
    begin
        finish <= '0';
        column_counter_next <= column_counter_current;

        case current_state is
            when s_idle =>
                ready <= '1';
                if done = '1' then
                    next_state <= s_running;
                else    
                    next_state <= s_idle;
                end if;
            when s_running =>   
                ready <= '0';
                if column_counter_current = "100" then
                    next_state <= s_idle;
                    column_counter_next <= "000";
                    finish <= '1';
                else
                    if ready_save = '1' then
                        column_counter_next <= column_counter_current + 1;
                    end if;
                    next_state <= s_running;
                end if;
        end case;
    end process;
    column_counter <= column_counter_current;
end behavioral;