-- ai_decision_unit.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ai_decision_unit is
    Port (
        sensor_data : in  STD_LOGIC_VECTOR(7 downto 0);  -- input sensor data
        ai_command  : out STD_LOGIC_VECTOR(2 downto 0);    -- default AI command
	ai_command6  : out STD_LOGIC_VECTOR(2 downto 0);    -- forward AI command
	ai_command7  : out STD_LOGIC_VECTOR(2 downto 0);    -- backward AI command
 	ai_command8  : out STD_LOGIC_VECTOR(2 downto 0);    -- left AI command
 	ai_command9  : out STD_LOGIC_VECTOR(2 downto 0)    -- right AI command
    );
end ai_decision_unit;

architecture Behavioral of ai_decision_unit is
begin
    process(sensor_data)
    begin

        -- default behavior: output is "100"
        ai_command <= "100";  

        CASE sensor_data IS
            WHEN "00000000" =>
        ai_command6 <= "000";  -- forward
	ai_command7 <= "100";
	ai_command8 <= "100";
	ai_command9 <= "100";
            WHEN "00000001" =>
        ai_command7 <= "001";  -- backward
	ai_command6 <= "100";
	ai_command8 <= "100";
	ai_command9 <= "100";
            WHEN "00000010" =>
                ai_command8 <= "010";  -- turn left
	ai_command6 <= "100";
	ai_command7 <= "100";
	ai_command9 <= "100";
            WHEN "00000011" =>
                ai_command9 <= "011";  -- turn right
	ai_command6 <= "100";
	ai_command7 <= "100";
	ai_command8 <= "100";
            WHEN OTHERS =>
        ai_command6 <= "100";  -- default no movement
	ai_command7 <= "100";
	ai_command8 <= "100";
	ai_command9 <= "100";
        END CASE;
    end process;
end Behavioral;

