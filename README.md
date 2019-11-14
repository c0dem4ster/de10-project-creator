# DE10 Project Creator
## Setup
Clone this repository and add it to your path.
## Usage
Enter the parent directory of your project and run `configure`.  
Then specify your project information and all of the files will be added automatically to a git repository located in a subdirectory called the same as your project.  

![screenshot](https://raw.githubusercontent.com/c0dem4ster/de10-project-creator/master/screenshot.png)

## Simulation
Once a project is created, the design is ready to be simulated using GHDL. For simulating it you need ghdl, gtkwave and make installed. When all of these are installed, executing `make` in the project directory runs the simulation and displays its results graphically.

## Synthesizing
When opening a newly generated project in Quartus Prime, it should be synthesizable out of the box and all of the pins should already be assigned.