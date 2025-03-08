--robot_motion_tb.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY robot_motion_tb IS
END ENTITY robot_motion_tb;

ARCHITECTURE behavior OF robot_motion_tb IS

    COMPONENT robot_motion -- our ports defined in robot_motion.vhd
    PORT(
         clk             : IN  STD_LOGIC;
         reset           : IN  STD_LOGIC;
         sensor_data     : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); 
	 motor_action   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  
         ram_address     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); 
         ram_data_in     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);  
         ram_data_out    : OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);  
         write_enable    : OUT STD_LOGIC  
         );
    END COMPONENT;

    COMPONENT ai_decision_unit -- our processors defined in ai_decision_unit.vhd
        PORT (
         sensor_data : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);  
         ai_command  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);   
 	 ai_command6  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);    
	 ai_command7  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);   
 	 ai_command8  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);    
 	 ai_command9  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)    
        );
    END COMPONENT;

    -- all signals for the testbench
    SIGNAL clk          : STD_LOGIC := '0';
    SIGNAL reset        : STD_LOGIC := '0';
    SIGNAL sensor_data  : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
    SIGNAL ai_command1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL ai_command2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL ai_command3 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL ai_command4 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL motor_action : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL ram_address   : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL ram_data_in   : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL ram_data_out  : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL write_enable  : STD_LOGIC;

    CONSTANT CLK_PERIOD : time := 10 ns;  -- clock period

BEGIN

    -- directing our robot_motion ports
    direction: robot_motion
        PORT MAP (
            clk => clk,
            reset => reset,
            sensor_data => sensor_data,
            motor_action => motor_action,
            ram_address => ram_address,
            ram_data_in => ram_data_in,
            ram_data_out => ram_data_out,
            write_enable => write_enable
        );

    -- ai_decision_unit for each AI command
    ai_unit1: ai_decision_unit
        PORT MAP (
            sensor_data => sensor_data,
            ai_command6  => ai_command1
        );

    ai_unit2: ai_decision_unit
        PORT MAP (
            sensor_data => sensor_data,
            ai_command7  => ai_command2
        );

    ai_unit3: ai_decision_unit
        PORT MAP (
            sensor_data => sensor_data,
            ai_command8  => ai_command3
        );

    ai_unit4: ai_decision_unit
        PORT MAP (
            sensor_data => sensor_data,
            ai_command9  => ai_command4
        );

    -- clock generation
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2; -- half our clk period
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- stimulus process
    stimulus_process: process
    begin
        -- reset the system
        reset <= '1';
        wait for CLK_PERIOD * 2;
        reset <= '0';
        wait for CLK_PERIOD * 2;

         -- Case 1: move forward (sensor_data = 00000000)
   	sensor_data <= "00000000";  
	--assert (ai_command1 = "000");  -- forcing data in case needed (forward)
   	--assert (ai_command2 = "100");  -- rest stay in default phase
   	--assert (ai_command3 = "100");
    	--assert (ai_command4 = "100");

    wait for CLK_PERIOD * 3; -- then move onto next case
   
  	  -- Case 2: move backward (sensor_data = 00000001)
    	sensor_data <= "00000001";  
	--assert (ai_command1 = "100");  
  	--assert (ai_command2 = "001");  -- backwards
   	--assert (ai_command3 = "100");
   	--assert (ai_command4 = "100");

    wait for CLK_PERIOD * 3;
   
    -- Case 3: turn left (sensor_data = 00000010)
    sensor_data <= "00000010";  
 	--assert (ai_command1 = "100");
   	--assert (ai_command2 = "100");
    	--assert (ai_command3 = "010"); -- left
    	--assert (ai_command4 = "100");
    wait for CLK_PERIOD * 3;
  

    -- Case 4: turn right (sensor_data = 00000011)
   	 sensor_data <= "00000011";  
 	-- assert (ai_command1 = "100");
  	-- assert (ai_command2 = "100");
  	-- assert (ai_command3 = "100");
   	-- assert (ai_command4 = "011");  -- right


    wait for CLK_PERIOD * 3;
   


    -- Test Case 5: No Move (sensor_data = 11111111)
   	sensor_data <= "11111111";  
	--assert (ai_command1 = "100");
   	--assert (ai_command2 = "100");
  	--assert (ai_command3 = "100");
    	--assert (ai_command4 = "100");  -- all commands are set to default no motion


    wait for CLK_PERIOD * 3;
   
 
        wait;
    end process;

END ARCHITECTURE behavior;

