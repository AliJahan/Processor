# Processor
A 5-stage pipelined processor implementation in verilog for [this ISA](https://github.com/AliJahan/Processor/blob/master/Docs/ISA.pdf).

TODO: the processor does not support forwarding, add dummy instruction in your code if there is a dependancy.

## 1 Processor architecture
![Processor_architecture](https://github.com/AliJahan/Processor/blob/master/Docs/Architecture.jpg)

Notes:
* Data forwarding is not supported in this implemetation YET.
* In order to make sure that each stage takes 1 clock cycle, all memories (*RF*, *ICache*, and *DCache*) work with ```negedge``` clock. 
* ```Cond ALU``` performs conditional operations, ```Comp ALU``` performs arithmetic and bitwise operations. 
* Taken ```branch``` instructions have two cycle penalty, in order to reduce the penalty cycles, we can use branch predictor or additional hardware to check if a branch is taken in *Decode* stage, which makes it one cycle penalty (still there is a penalty for branch). For more performance improvement, we can also use *Branch Predictors* which is not implemented in this processor.
* It is assumed that all the instructions and data are already in *ICache* and *DCache*, respectively.(The instructions and the data are loaded into the caches at the begining of the **simulation**)

## 2 Project structure
 The project constists of four components:
### Processor implementation 
Located in ```src/```, which is implemented in *Verilog* and is explained in [*Processor Architecture*](#1-processor-architecture) section. Contains:
* *Memory.v* : Memory used for *instruction and data cache*. One port for read and one port for write. (write port is not used in *instruction cache*. On FPGA, BRAMs can be used instead.
* *RF.v* : Memory used for *Register File*. Supports two reads and one write at the same time.
* *FETCH.v* : Fetch stage (combinational)
* *DEC.v* : Decode stage (combinational)
* *EXE.v* : Execution stage (combinational)
* *MEM.v* : Memory stage (contains *data cache*) 
* *WB.v* : Write-back stage (combinational)
* *PCGen.v* : Generates next PC based on branch target address (contains one register for EXE stage flush)
* *Processor.v* : All stages' mouldes are instantiated here. Inter-stage registers are put between each stage here (Contains all inter-stage registers)

### Assembler
located in ```Assembler/```, which is an assembler developed in *python3* to convert assembly to machine code. 
In order to use the assembler, run following command in the project's root:

```python3 Assembler/main.py path_to_assembly_code_file```

The results will be written in the directory of *path_to_assembly_code_file* with the same name as the input file with ```.asm``` extension added to the file name.

### Examples
located in ```examples/```, which is a testbench that runs a code on the implemented processor using *iverilog* tool. Following testbench is in the ```examples/``` directory for now:
 * **fibonacci_tb.v**: first, loads the provided machine code file (```examples/fibonacci_code.init```) into *instruction cache* of the processor. Then, loads the data file (```/examples/fibonacci_data```) into *data cache*. And finallly, excutes the code on the processor. ```examples/fibonacci_code``` is the assemlby code of a programm that calculates N*th* first elements of Fibonacci series and save it to the *data cache*. At the end of each execution, the *data cache* is dumped to the ```examples/fibonacci_dcache```. (Important note: since the pipelined processor stil does not support data forwarding, dummy instructions are placed between depeneant instructions ```ADD r10 r10 r10```)
 

In order to execute another program on the processor, change the following paramteres in ```fibonacci_tb.v```:
  * **ICACHE_INIT_FILE**: The address of the machine code to be loaded in *instruction cache*
  * **DCACHE_INIT_FILE**: The address of the data needed by your programm to be executed. If your program does not need data to be in the memory, provide an empty file.
  * **DCACHE_DUMP_FILE**: The address of the file to which the *data chache* is going to be dumped after execution
  
### Scripts
Located in ```scripts/```, which cantains following scripts:
 * **install_iverilog.sh**: *iverilog* installation script (tested on Ubuntu 16.04) **needs root access to run**
 * **run.sh**: uses the implemeted assembler to convert the ```/examples/fibonacci_code``` assembly code to machine code. Then compiles the testbench located in ```/examples/fibonacci_tb.v``` with *iverilog*, and runs the simulation in verbose mode (-v flag enabled) or non-verbose mode. Verbose mode prints the writes to *Register file* and *data cache* at any time.

## 3 How to run simulation
Examplained in [*Scripts*](#scripts) section.
