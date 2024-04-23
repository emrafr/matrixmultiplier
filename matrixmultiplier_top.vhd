library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity matrixmultiplier_top is
    port(
        clk : in std_logic;
        reset : in std_logic;
        input : in std_logic_vector(7 downto 0);
        valid_input : in std_logic;
        finish : out std_logic      
    );
end matrixmultiplier_top;

architecture structural of matrixmultiplier_top is

component controller is
    port(
        clk : in std_logic;
        reset : in std_logic;
        ready_save : in std_logic; -- will be one when one column is done
        done : in std_logic;
        ready : out std_logic;   
        finish : out std_logic;
        column_counter : out unsigned(2 downto 0)  
    );
end component;

component shift_input is
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
end component;

component multiply is
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
end component;

component rom is
    port(
        clk : in std_logic;
        romAddress : in std_logic_vector(3 downto 0);
        dataROM : out std_logic_vector(13 downto 0)  
    );
end component;

component ram_controller is
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
end component;

component sram_wrapper is
    port(
        clk: in std_logic;
        cs_n: in std_logic;  -- Active Low
        we_n: in std_logic;  --Active Low
        address: in std_logic_vector(7 downto 0);
        ry: out std_logic;
        write_data: in std_logic_vector(31 downto 0);
        read_data: out std_logic_vector(31 downto 0)
    );
end component;

signal ready_save, done, ready, web, ry : std_logic;
signal row1_reg, row2_reg, row3_reg, row4_reg : std_logic_vector(63 downto 0);
signal dataROM: std_logic_vector(13 downto 0);
signal romAddress: std_logic_vector(3 downto 0);
signal p1, p2, p3, p4: std_logic_vector(15 downto 0);
signal ram_address: std_logic_vector(7 downto 0);
signal dataRAM, ram_out: std_logic_vector(31 downto 0);
signal column_counter : unsigned(2 downto 0);

begin

controller_inst : controller 
port map(
        clk => clk,
        reset => reset,
        ready_save => ready_save,
        done => done,
        ready => ready,
        finish => finish,
        column_counter => column_counter
);

shift_input_inst : shift_input
port map(
        reset => reset,
        clk => clk,
        input => input,
        valid_input  => valid_input,
        row1_reg => row1_reg,
        row2_reg => row2_reg,
        row3_reg => row3_reg,
        row4_reg => row4_reg,
        done => done   
);

multiply_inst : multiply
port map(
        clk => clk,
        reset => reset,
        done => done,
        column_counter => column_counter,
        row1_reg => row1_reg,
        row2_reg => row2_reg,
        row3_reg => row3_reg, 
        row4_reg => row4_reg,
        dataROM => dataROM,
        romAddress => romAddress,
        p1 => p1,
        p2 => p2,
        p3 => p3,
        p4 => p4,
        ready_save => ready_save
);

rom_inst : rom
port map(
        clk => clk,
        romAddress => romAddress,
        dataROM  => dataROM
);

ram_controller_inst : ram_controller
port map(
        clk => clk,
        reset => reset,
        ready_save  => ready_save,
        p1 => p1,
        p2 => p2,
        p3 => p3,
        p4 => p4,
        ram_address => ram_address,
        web => web,
        dataRAM => dataRAM
);

ram_inst : sram_wrapper
port map(
        clk => clk,
        cs_n => '1',
        we_n => not(web),
        address => ram_address,
        ry => ry,
        write_data => dataRAM,
        read_data => ram_out
);

end structural;
