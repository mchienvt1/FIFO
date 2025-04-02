# FIFO

FIFO Design and Implementation
Overview
This project focuses on the design and implementation of FIFO (First-In-First-Out) buffers, which are essential components in digital systems for managing data flow between processes or modules. The project includes two types of FIFO designs:
* Synchronous FIFO: Operates within a single clock domain.
* Asynchronous FIFO: Facilitates communication between different clock domains.
Both FIFO designs are implemented in Verilog and verified through simulation. The project utilizes Icarus Verilog for compilation and simulation, and GTKWave for waveform analysis to ensure correctness and functionality.
Project Structure

FIFO-Design/
├── synchronous_fifo/       # Synchronous FIFO design
│   ├── rtl/                # RTL implementation files
│   ├── verification/       # Testbenches and simulation scripts
├── asynchronous_fifo/      # Asynchronous FIFO design
│   ├── rtl/                # RTL implementation files
│   ├── verification/       # Testbenches and simulation scripts
├── README.md               # Project documentation
Synchronous FIFO
* Clock Domain: Write and read operations share the same clock.
* Key Features:
   * Simple pointer-based management.
   * Full and empty status flags.
* Usage: Ideal for systems operating within a single clock domain.
Asynchronous FIFO
* Clock Domain: Write and read operations occur in separate, asynchronous clock domains.
* Key Features:
   * Pointer synchronization using Gray code and 2-flop synchronizers.
   * Ensures reliable communication between different clock domains.
* Usage: Suitable for interfacing modules with independent clocking schemes.
Running Simulations
Prerequisites
Ensure the following tools are installed before running simulations:
* Icarus Verilog: For compiling and simulating Verilog designs.
* GTKWave: For waveform visualization and analysis.
Simulation Steps
Navigate to the appropriate FIFO verification directory:
For Synchronous FIFO:

cd synchronous_fifo/verification
For Asynchronous FIFO:

cd asynchronous_fifo/verification
Run the simulation:

make run
This will compile and execute the testbenches, producing waveform files for analysis in GTKWave.
