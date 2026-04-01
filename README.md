 Multi-Channel PWM Controller with Scheduler

Description
This FPGA project implements a 4-channel PWM controller with an 8-bit duty cycle resolution and a scheduling FSM. Duty cycles are adjustable via VIO interface, and LEDs show the PWM output.

Features
- 4 PWM channels
- 8-bit resolution
- Sequential channel activation with dead time
- Duty cycle configurable via VIO
- Demonstrable via LEDs

Files
- `src/` : Verilog source code
- `constraints/` : FPGA pin mapping
- `jpeg/` : Project images
- `video/` : Project demo 

How to Run
1. Open the Vivado project and upload the design sources.
2. Then upload the .xci and constraint file.
3. Synthesize and implement the design.
4. Program the FPGA.
5. Adjust duty cycles using VIO and observe LED behavior.
