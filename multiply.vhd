library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiply is
    port(
        clk : in std_logic;
        reset : in std_logic;
        done : in std_logic;
        column_counter : in unsigned(2 downto 0);
        row1_reg : in std_logic_vector(63 downto 0);
        row2_reg : in std_logic_vector(63 downto 0);
        row3_reg : in std_logic_vector(63 downto 0);
        row4_reg : in std_logic_vector(63 downto 0);
        dataROM : in std_logic_vector(13 downto 0);
        romAddress : out std_logic_vector(3 downto 0);
        p1 : out std_logic_vector(15 downto 0);
        p2 : out std_logic_vector(15 downto 0);
        p3 : out std_logic_vector(15 downto 0);
        p4 : out std_logic_vector(15 downto 0);
        ready_save : out std_logic
    );
end multiply;

architecture behavioral of multiply is

type state_type is (s_init, s_coeff1, s_coeff2);
signal current_state, next_state : state_type;

component MU is
    port(
        reset : in std_logic;
        clk : in std_logic;
        current_sum : in unsigned(15 downto 0);
        input : in unsigned(7 downto 0);
        coeff : in unsigned(6 downto 0);
        output : out unsigned(15 downto 0) 
    );
end component;

signal sum1, output1, sum2, output2, sum3, output3, sum4, output4 : unsigned(15 downto 0);
signal input1, input2, input3, input4 : unsigned(7 downto 0);
signal coeff, coeff2: unsigned(6 downto 0);
signal counter, counter_next: unsigned(2 downto 0);
signal address_counter, address_counter_next : unsigned(3 downto 0);

signal next_sum_reg1, current_sum_reg1, next_sum_reg2, current_sum_reg2, next_sum_reg3, current_sum_reg3, next_sum_reg4, current_sum_reg4 : unsigned(15 downto 0);
signal next_row_reg1, current_row_reg1, next_row_reg2, current_row_reg2, next_row_reg3, current_row_reg3, next_row_reg4, current_row_reg4 : unsigned(63 downto 0);

begin

MU1 : MU
    port map(
        reset => reset,
        clk => clk,
        current_sum => sum1,
        input => input1,
        coeff => coeff,
        output => output1
    );
MU2 : MU
    port map(
        reset => reset,
        clk => clk,
        current_sum => sum2,
        input => input2,
        coeff => coeff,
        output => output2
    );
MU3 : MU
    port map(
        reset => reset,
        clk => clk,
        current_sum => sum3,
        input => input3,
        coeff => coeff,
        output => output3
    );
MU4 : MU
    port map(
        reset => reset,
        clk => clk,
        current_sum => sum4,
        input => input4,
        coeff => coeff,
        output => output4
    );
    
registers : process(clk)
begin
    if reset = '1' then
        counter <= (others => '0');
        address_counter <= (others => '0');
        current_state <= s_init;
        current_sum_reg1 <= (others => '0');
        current_sum_reg2 <= (others => '0');
        current_sum_reg3 <= (others => '0');
        current_sum_reg4 <= (others => '0');
        
        current_row_reg1 <= (others => '0');
        current_row_reg2 <= (others => '0');
        current_row_reg3 <= (others => '0');
        current_row_reg4 <= (others => '0');
    elsif rising_edge(clk) then
        current_sum_reg1 <= next_sum_reg1;
        current_sum_reg2 <= next_sum_reg2;
        current_sum_reg3 <= next_sum_reg3;
        current_sum_reg4 <= next_sum_reg4;
        
        current_row_reg1 <= next_row_reg1;
        current_row_reg2 <= next_row_reg2;
        current_row_reg3 <= next_row_reg3;
        current_row_reg4 <= next_row_reg4;
        
        current_state <= next_state;
        
        counter <= counter_next;
        address_counter <= address_counter_next;
    end if;
end process;
    
process(column_counter, address_counter, row1_reg, row2_reg, row3_reg, row4_reg, counter, dataROM, coeff2, output1, output2, output3, output4, current_state)
begin

romAddress <= std_logic_vector(address_counter);

input1 <= unsigned(current_row_reg1(63 downto 56));
input2 <= unsigned(current_row_reg2(63 downto 56));
input3 <= unsigned(current_row_reg3(63 downto 56));
input4 <= unsigned(current_row_reg4(63 downto 56));


p1 <= (others => '0');
p2 <= (others => '0');
p3 <= (others => '0');
p4 <= (others => '0');

ready_save <= '0';
address_counter_next <= address_counter;
counter_next <= counter;
case current_state is
    when s_init =>
            next_sum_reg1 <= (others => '0');
            next_sum_reg2 <= (others => '0');
            next_sum_reg3 <= (others => '0');
            next_sum_reg4 <= (others => '0');
        if done = '1' then
            next_state <= s_coeff1;
            next_row_reg1 <= unsigned(row1_reg);
            next_row_reg2 <= unsigned(row2_reg);
            next_row_reg3 <= unsigned(row3_reg);
            next_row_reg4 <= unsigned(row4_reg);    
        else
            if column_counter = "001" or column_counter = "010" or column_counter = "011" then
                next_state <= s_coeff1;
                next_row_reg1 <= unsigned(row1_reg);
                next_row_reg2 <= unsigned(row2_reg);
                next_row_reg3 <= unsigned(row3_reg);
                next_row_reg4 <= unsigned(row4_reg);
            else
                next_state <= s_init;     
            end if;
        end if;
        
    when s_coeff1 =>
            sum1 <= current_sum_reg1;
            sum2 <= current_sum_reg2;
            sum3 <= current_sum_reg3;
            sum4 <= current_sum_reg4;
            
            next_row_reg1 <= current_row_reg1(55 downto 0) & current_row_reg1(63 downto 56);
            next_row_reg2 <= current_row_reg2(55 downto 0) & current_row_reg2(63 downto 56);
            next_row_reg3 <= current_row_reg3(55 downto 0) & current_row_reg3(63 downto 56);
            next_row_reg4 <= current_row_reg4(55 downto 0) & current_row_reg4(63 downto 56);
            
            next_sum_reg1 <= output1;
            next_sum_reg2 <= output2;
            next_sum_reg3 <= output3;
            next_sum_reg4 <= output4;
            
            coeff2 <= unsigned(dataROM(6 downto 0));
            coeff <= unsigned(dataROM(13 downto 7));
            next_state <= s_coeff2;
            counter_next <= counter + 1;
            address_counter_next <= address_counter + 1; 
            
    when s_coeff2 =>
            sum1 <= current_sum_reg1;
            sum2 <= current_sum_reg2;
            sum3 <= current_sum_reg3;
            sum4 <= current_sum_reg4;
            
            next_row_reg1 <= current_row_reg1(55 downto 0) & current_row_reg1(63 downto 56);
            next_row_reg2 <= current_row_reg2(55 downto 0) & current_row_reg2(63 downto 56);
            next_row_reg3 <= current_row_reg3(55 downto 0) & current_row_reg3(63 downto 56);
            next_row_reg4 <= current_row_reg4(55 downto 0) & current_row_reg4(63 downto 56);
            
            next_sum_reg1 <= output1;
            next_sum_reg2 <= output2;
            next_sum_reg3 <= output3;
            next_sum_reg4 <= output4;
            
            coeff <= coeff2;
            counter_next <= counter + 1;
            if counter = "111" then
                next_state <= s_init;
                p1 <= std_logic_vector(output1);
                p2 <= std_logic_vector(output2);
                p3 <= std_logic_vector(output3);
                p4 <= std_logic_vector(output4);
                ready_save <= '1';
            else
                next_state <= s_coeff1;
            end if;
end case;

end process;

end behavioral;
