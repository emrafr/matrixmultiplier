library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_input is
    port(
        reset : in std_logic;
        clk : in std_logic;
        input : in std_logic_vector(7 downto 0);
        valid_input : in std_logic;
        row1_reg : out std_logic_vector(63 downto 0); 
        row2_reg : out std_logic_vector(63 downto 0); 
        row3_reg : out std_logic_vector(63 downto 0); 
        row4_reg : out std_logic_vector(63 downto 0);
        done : out std_logic 
    );
end shift_input;

architecture behavioral of shift_input is

signal shift_count, shift_count_next : unsigned(1 downto 0);
signal count, count_next : unsigned(5 downto 0);

signal current_reg1, next_reg1, current_reg2, next_reg2, current_reg3, next_reg3, current_reg4, next_reg4 : std_logic_vector(63 downto 0);

begin

registers : process (clk)
begin
    if reset = '1' then
        count <= (others => '0');
        current_reg1 <= (others => '0');
        current_reg2 <= (others => '0');
        current_reg3 <= (others => '0');
        current_reg4 <= (others => '0');
        shift_count <= (others => '0');
    elsif rising_edge(clk) then
        current_reg1 <= next_reg1;
        current_reg2 <= next_reg2;
        current_reg3 <= next_reg3;
        current_reg4 <= next_reg4;
        shift_count <= shift_count_next;
        count <= count_next;
     end if;
end process;

shift : process (input, valid_input, count, shift_count, current_reg1, current_reg2, current_reg3, current_reg4)
begin

if (valid_input = '1') then
    next_reg1 <= current_reg1;
    next_reg2 <= current_reg2;
    next_reg3 <= current_reg3;
    next_reg4 <= current_reg4;
    case shift_count is
        when "00" =>
            next_reg1 <= current_reg1(55 downto 0) & input;
        when "01" =>
            next_reg2 <= current_reg2(55 downto 0) & input;
        when "10" =>
            next_reg3 <= current_reg3(55 downto 0) & input;
        when "11" =>
            next_reg4 <= current_reg4(55 downto 0) & input;
        when others =>
            next_reg1 <= current_reg1;
            next_reg2 <= current_reg2;
            next_reg3 <= current_reg3;
            next_reg4 <= current_reg4;
     end case;
     shift_count_next <= shift_count + 1;
     count_next <= count + 1;
else 
    next_reg1 <= current_reg1;
    next_reg2 <= current_reg2;
    next_reg3 <= current_reg3;
    next_reg4 <= current_reg4;
end if; 

if count = "100000" then
    done <= '1';
    count_next <="000000";
    shift_count_next <= "00";
else
    done <= '0';
end if; 

end process;

row1_reg <= current_reg1;
row2_reg <= current_reg2;
row3_reg <= current_reg3;
row4_reg <= current_reg4;

end behavioral; 