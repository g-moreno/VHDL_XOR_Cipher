# VHDL_XOR_Cipher
This project aims to implement a simple XOR cipher on the Zybo Z7 FPGA development board. The XOR cipher is a basic cryptographic technique where each byte of the plaintext is XOR with a corresponding byte of the key to produce the ciphertext. This method is symmetric, meaning the same process is used for both encryption and decryption. 


**Overview:**
This project implements a simple XOR cipher in VHDL for the Zybo Z7 board. Users can input a 4-bit key and data value, and the system performs XOR encryption/decryption. The result is displayed on a 7-segment display. This served as a final project for Embedded System Design.

**Components:**
Zybo Z7 Board
PMODSSD Seven Segment Display
Input Switches
Output LEDs
Micro USB Cable
Windows PC with Vivado Installed

**Functionality:**
Key Input: Users input a 4-bit key using the input switches.
Data Input: Users input a 4-bit data value using the input switches.
XOR Operation: Pressing a button initiates the XOR operation between the key and data.
Display: The result is displayed on the 7-segment display.
Reset: A reset button clears all stored values and resets the system.

**Implementation Details:**
Binary-to-Decimal Conversion: A function converts binary values to decimal for display.
Multiplexing: The 7-segment display is multiplexed to display both tens and units digits.
XOR Logic: The core encryption/decryption logic is implemented using XOR gates.
User Interface: Input switches, output LEDs, and a reset button provide a user-friendly interface.

**Troubleshooting:**
Initial Challenges: Difficulties were encountered in implementing the binary-to-decimal conversion and multiplexing logic.
Solutions: Through iterative testing and debugging, these issues were resolved by refining the code and understanding the underlying concepts.

**Recommendations:**
Debouncing: Implementing debouncing for the input buttons can prevent accidental multiple presses.
Data Size: Increasing the data size to 8 bits can enhance security and allow for larger values.
Advanced Encryption: Incorporating additional XOR operations or other cryptographic techniques can improve the strength of the cipher.
Display Refresh Rate: Adjusting the refresh rate can optimize power consumption and display performance.

**Conclusion:**
This project demonstrates a practical application of VHDL in implementing a cryptographic system. By understanding the XOR algorithm, designing a user-friendly interface, and overcoming technical challenges, a functional XOR cipher was successfully developed for the Zybo Z7 board.

**To Set Up and Run the Code:**
_Prerequisites:_
- Zybo Z7 Board
- Vivado Design Suite
- USB Cable

_Steps:_

1. Clone Repository:
Download or clone the GitHub repository.

2. Use the following command:
Bash
git clone <repository_url>
Use code with caution.

3. Open Project in Vivado:
Launch Vivado.
Create a new project.
Select the VHDL files.

4. Create Block Design:
Add IP cores to the block design.
Connect the IP cores.

5. Generate HDL Wrapper:
Right-click on the block design and select "Generate HDL Wrapper."

6. Run Synthesis and Implementation:
Go to "Run Synthesis" and "Run Implementation."

7. Generate Bitstream:
Generate a bitstream file.

8. Program Board:
Connect the Zybo Z7 board.
Program the bitstream and hardware.

