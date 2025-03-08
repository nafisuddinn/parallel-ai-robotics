-- robot_motion.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity robot_motion is
    Port (
        clk             : in  STD_LOGIC;          
        reset           : in  STD_LOGIC;          
        sensor_data     : in  STD_LOGIC_VECTOR(7 downto 0);  -- sensor data (8 bits allow us to choose a wide range of distances)
 	motor_action   : out STD_LOGIC_VECTOR(3 downto 0);  -- motor control signals
        ram_address     : out STD_LOGIC_VECTOR(3 downto 0);  -- RAM address
        ram_data_in     : out STD_LOGIC_VECTOR(7 downto 0);  -- data to write to RAM
        ram_data_out    : out  STD_LOGIC_VECTOR(7 downto 0); -- data read from RAM
        write_enable    : out STD_LOGIC         	     -- write enable for RAM
    );
end robot_motion;

architecture Behavioral of robot_motion is
    -- Parallel AI Command outputs
    signal ai_command1, ai_command2, ai_command3, ai_command4 : STD_LOGIC_VECTOR(2 downto 0);  -- 3 bits is sufficient for forward, backwards, right, and left movements 

   -- Integrating the AI decision units (4 parallel units)
    component ai_decision_unit
        Port (
            sensor_data : in  STD_LOGIC_VECTOR(7 downto 0);  -- input sensor data
            ai_command  : out STD_LOGIC_VECTOR(2 downto 0);    -- default AI command
 ai_command6  : out STD_LOGIC_VECTOR(2 downto 0);    -- coordinates to forward movement
 ai_command7  : out STD_LOGIC_VECTOR(2 downto 0);    -- coordinates to backward movement
 ai_command8  : out STD_LOGIC_VECTOR(2 downto 0);   -- coordinates to left movement
 ai_command9  : out STD_LOGIC_VECTOR(2 downto 0)    -- coordinates to right movement
        );
    end component;


    
begin
    
    ai_unit1: ai_decision_unit port map (sensor_data => sensor_data, ai_command6 => ai_command1);  -- Here, we map our outputs from
    ai_unit2: ai_decision_unit port map (sensor_data => sensor_data, ai_command7 => ai_command2);  -- the AI units to ports we created
    ai_unit3: ai_decision_unit port map (sensor_data => sensor_data, ai_command8 => ai_command3);  -- in this file.
    ai_unit4: ai_decision_unit port map (sensor_data => sensor_data, ai_command9 => ai_command4);  

   
    process(sensor_data, reset, ai_command1, ai_command2, ai_command3, ai_command4) -- process where the robot generates movemment
    begin
        
        if ai_command1 = "000" then
        motor_action <= "0001";  -- move Forward
 	ram_address <= "0001"; -- address that coordinates with forward movement
        ram_data_in <= sensor_data;
        write_enable <= '1'; 

        elsif ai_command2 = "001" then
        motor_action <= "0010";  -- move Backward
	ram_address <= "0010";  -- address that coordinates with backward movement
        ram_data_in <= sensor_data;
        write_enable <= '1';      

        elsif ai_command3 = "010" then
        motor_action <= "0100";  -- turn Left
	ram_address <= "0100";  -- address that coordinates with left movement
        ram_data_in <= sensor_data;
        write_enable <= '1'; 

        elsif ai_command4 = "011" then
        motor_action <= "1000";  -- turn Right
	ram_address <= "1000"; -- address that coordinates with forward movement
        ram_data_in <= sensor_data;
        write_enable <= '1'; 

        else 
        motor_action <= "0000";  -- our default action (no movement)
	ram_address <= "0000";  -- address that coordinates with no movement
        ram_data_in <= sensor_data;
        write_enable <= '1';  
        end if;

 
    end process;
end Behavioral;

