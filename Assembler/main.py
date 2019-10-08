import sys
from Assembler import *

def main():
	file_name = sys.argv[1]
	assem = Assembler(file_name)
	machine_code = assem.get_machine_code()
	f = open(file_name+".asm", 'w')
	f.write(machine_code)
	f.close()

if __name__ == "__main__":
	main()