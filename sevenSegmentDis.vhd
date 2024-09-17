----------------------------------------------------------------------------------
-- Engineer: Gabriel Moreno
-- 
-- Create Date: 07/20/2024 12:10:36 PM
-- Design Name: Simple XOR Cipher
-- Module Name: sevenSegmentDis - Behavioral
-- Target Devices: Zybo Z7
-- Description: The included program is a simply XOR cipher that prompts the user to input a 4-bit key, followed by 4-bit data, and then performing 
-- an XOR function on the data with the key in order to encrypt it. Inputting the encrypted data alongside the same key will then decrypt the data. 
-- Dependencies: 'IEEE.STD_LOGIC_1164.ALL' provides definitions for basic digital logic types such as 'STD_LOGIC' and 'STD_LOGIC_VECTOR'. 
-- 'IEEE.NUMERIC_STD.ALL' provides definitions for arithmetic operations on 'unisgned' and 'signed' types.
-- Revision: 1.5
-- 
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sevenSegmentDis is
  Port (
    SW : in STD_LOGIC_VECTOR (3 downto 0); -- Input: 4-bit switch input
    CLK : in STD_LOGIC; -- Input: Clock signal
    BTN0 : in STD_LOGIC; -- Input: Button 0 for storing key
    BTN1 : in STD_LOGIC; -- Input: Button 1 for storing data
    BTN2 : in STD_LOGIC; -- Input: Button 2 for XOR operation
    Reset : in std_logic; -- Input: Button 3 for reseting
    LED0 : out STD_LOGIC; -- Output: LED 0 to indicate key stored
    LED1 : out STD_LOGIC; -- Output: LED 1 to indicate data stored
    LED2 : out STD_LOGIC; -- Output: LED 2 to indicate encryption/decryption
    C : out STD_LOGIC; -- Output: Multiplexing control signal
    SevenSD : out STD_LOGIC_VECTOR (6 downto 0) -- Output: 7-segment display segments
  );
end sevenSegmentDis;

architecture Behavioral of sevenSegmentDis is
  signal count : integer := 0; -- Counter for multiplexing
  signal current_digit : STD_LOGIC_VECTOR(3 downto 0); -- Current digit to be displayed
  signal display : STD_LOGIC_VECTOR(6 downto 0); -- Output to the 7-segment display
  signal c_internal : STD_LOGIC := '0'; -- Internal signal for multiplexing control
  signal digits : STD_LOGIC_VECTOR(7 downto 0); -- Extracted tens and units digits
  signal key_value : STD_LOGIC_VECTOR(3 downto 0) := (others => '0'); -- Stored key value
  signal data_value : STD_LOGIC_VECTOR(3 downto 0) := (others => '0'); -- Stored data value
  signal xor_result : STD_LOGIC_VECTOR(3 downto 0) := (others => '0'); -- Result of XOR operation
  signal display_xor : STD_LOGIC := '0'; -- Signal to indicate if XOR result should be displayed

  -- Function to convert a 4-bit binary to 7-segment code
  function to_SevenSegment (binary : STD_LOGIC_VECTOR(3 downto 0)) return STD_LOGIC_VECTOR is
  begin
    case binary is
      when "0000" => return "0111111"; -- 0
      when "0001" => return "0000110"; -- 1
      when "0010" => return "1011011"; -- 2
      when "0011" => return "1001111"; -- 3
      when "0100" => return "1100110"; -- 4
      when "0101" => return "1101101"; -- 5
      when "0110" => return "1111101"; -- 6
      when "0111" => return "0000111"; -- 7
      when "1000" => return "1111111"; -- 8
      when "1001" => return "1101111"; -- 9
      when others => return "0000000"; -- Default case
    end case;
  end function;

  -- Function to extract tens and units digits from a 4-bit binary number
  function get_digits (binary : STD_LOGIC_VECTOR(3 downto 0)) return STD_LOGIC_VECTOR is
    variable result : STD_LOGIC_VECTOR(7 downto 0);
    variable num : unsigned(3 downto 0);
    variable tens : unsigned(3 downto 0);
    variable unit : unsigned(3 downto 0); --special note: I had to use the variable 'unit' instead of "units"
  begin
    num := unsigned(binary);
    unit := num mod 10;
    tens := num / 10;
    result(3 downto 0) := std_logic_vector(unit);
    result(7 downto 4) := std_logic_vector(tens);
    return result;
  end function;

begin

  process(CLK)
  begin
    if rising_edge(CLK) then
      -- Increment the counter for multiplexing
      count <= count + 1;

      -- Check if it's time to switch digits
      if count = 1000000 then -- Adjust this value for desired refresh rate
        count <= 0;
        c_internal <= not c_internal; -- Toggle multiplexing control signal
      end if;

      -- Extract tens and units digits from the switch input or XOR result
      if display_xor = '1' then
        digits <= get_digits(xor_result); -- Display XOR result
      else
        digits <= get_digits(SW); -- Display switch input
      end if;

      -- Select the current digit to display based on the multiplexing control
      if c_internal = '0' then
        current_digit <= digits(3 downto 0); -- Display units digit
      else
        current_digit <= digits(7 downto 4); -- Display tens digit
      end if;

      -- Convert the current digit to a 7-segment code
      display <= to_SevenSegment(current_digit);

      -- Drive the seven-segment display with the calculated pattern
      SevenSD <= display;

      -- Output the multiplexing control signal
      C <= c_internal;
    end if;
  end process;

  -- Process to handle button presses and store key/data values
  process(CLK)
  begin
    if rising_edge(CLK) then
        if Reset = '1' then
         key_value <= (others => '0'); -- Reset key value
         data_value <= (others => '0'); -- Reset data value
         xor_result <= (others => '0'); -- Reset XOR result
         LED0 <= '0'; -- Turn off all LEDs
         LED1 <= '0';
         LED2 <= '0';
         display_xor <= '0'; -- Ensure display shows switch input
      elsif BTN0 = '1' then
        key_value <= SW; -- Store key value
        LED0 <= '1'; -- Enables LED0 to indicate key stored
        LED1 <= '0';
        LED2 <= '0'; -- Enables LED2 to indicate key stored
        display_xor <= '0'; -- Ensure display shows switch input
      elsif BTN1 = '1' then
        data_value <= SW; -- Store data value
        LED0 <= '1'; -- Enables LED0 to indicate key stored
        LED1 <= '1';
        LED2 <= '0'; -- Enables LED2 to indicate key stored
        display_xor <= '0'; -- Ensure display shows switch input
      elsif BTN2 = '1' then
        xor_result <= key_value xor data_value; -- Perform XOR operation
        LED0 <= '1'; -- Enables LED0 to indicate key stored
        LED1 <= '1';
        LED2 <= '1'; -- Enables LED2 to indicate key stored
        display_xor <= '1'; -- Set flag to display XOR result
      end if;
    end if;
  end process;

end Behavioral;
