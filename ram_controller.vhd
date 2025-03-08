-- ram_controller.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.ALL;

entity ram_controller is
    port (
        clock        : in  std_logic;            
        reset        : in  std_logic;             
        ai_command   : in  std_logic_vector(2 downto 0); 
        sensor_data  : in  std_logic_vector(7 downto 0); -- sensor data; 8 bits to expand on any direction
        ram_address  : out std_logic_vector(3 downto 0); 
        ram_data_in  : out std_logic_vector(7 downto 0);
        ram_data_out : out  std_logic_vector(7 downto 0); 
        write_enable : out std_logic               
    );
end entity ram_controller;

architecture RTL of ram_controller is
    type ram_type is array (0 to 15) of std_logic_vector(7 downto 0);  -- RAM type definition
    signal ram : ram_type := (others => (others => '0')); -- initialize RAM with zeros
    signal current_address : std_logic_vector(3 downto 0); 

begin
   
    process(clock, reset)
    begin
        if reset = '1' then
            current_address <= "0000";
            ram_address <= "0000";
            ram_data_in <= (others => '0');
            write_enable <= '0';
        elsif rising_edge(clock) then
            ram(to_integer(unsigned(current_address))) <= sensor_data; -- write sensor data to RAM
            write_enable <= '1';
            ram_address <= current_address;  
        end if;
    end process;

    -- RAM is being read continuously and be reported back to the AI brain.
    ram_data_out <= ram(to_integer(unsigned(current_address)));
end architecture RTL;


