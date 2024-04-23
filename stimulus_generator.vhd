library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;


entity stimulus_generator is
    generic (
        FILE_NAME: string := "input_stimuli.txt";
        SAMPLE_WIDTH: positive
    );
    port (
        clk: in std_logic;
        reset: in std_logic;
        data_valid : out std_logic;
        stimulus_stream : out std_logic_vector(7 downto 0)
    );
end stimulus_generator;


architecture behavioral of stimulus_generator is

    signal sample_clk: std_logic := '0';
    signal sample_clk_counter: integer := 0;
    
    signal valid_next, valid_current : std_logic := '0';
    
    signal stimulus_sample: std_logic_vector(SAMPLE_WIDTH-1 downto 0) := (others => '0');

begin

    process (reset, clk)
        file test_vector_file: text open READ_MODE is FILE_NAME;
        variable file_row: line;
        variable stimulus_raw: std_logic_vector(7 downto 0);
    begin
        if (reset = '1') then
            stimulus_sample <= (others => '0');  
--            valid_current <= '0';
            data_valid <= '0';
        elsif rising_edge(clk) then
            stimulus_raw := "00000000";
            if not endfile(test_vector_file) then
                readline(test_vector_file, file_row);
                read(file_row, stimulus_raw);  
--                valid_next <= '1';   
                data_valid <= '1';
            else
                data_valid <= '0';          
            end if;
            stimulus_sample <= stimulus_raw;
            
--            valid_current <= valid_next;
        end if;
    end process;
    
--    data_valid <= valid_current;   
    stimulus_stream <= stimulus_sample;

end behavioral;