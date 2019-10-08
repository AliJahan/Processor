#!/bin/bash
set -e
VERBOSE="t"
# Check for arguments (verbose flag)
(($#)) && VERBOSE=$1

# Parse assembly code and generate binary
cd ../Assembler
python3 main.py ../examples/fibonacci_code 

cd ../examples

# Run simulation
if [ "$VERBOSE" == "-v" ]; then
    echo "Running in verbose mode"
    ./a.out     
else
    echo "Running in non-verbose mode"
    echo "To run in verbose mode run with -v flag"
    ./a.out >/dev/null
fi

echo "Data cache dumped in examples/fibonacci_dcache"i
cd ../scripts
