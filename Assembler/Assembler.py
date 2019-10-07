import sys
from Parser import *
from ISA import *

class Assembler:
	parser = Parser()
	def __init__(self, code_file):
		self.code_file = code_file
		f = open(self.code_file)
		self.code = f.read()

	def to_binary(self, n, bits):
	    s = bin(n & int("1"*bits, 2))[2:]
	    return ("{0:0>%s}" % (bits)).format(s)

	def print_reg_name_guide(self, reg_name):
		print("Error: "+str(reg_name)+" is invalid, register names must follow r# format, exp: r1")

	def verify(self, reg_name):
		reg_data = reg_name.split("r")
		if not len(reg_data) == 2:
			try:
				f = int(reg_name)
				return True,f
			except ValueError:
				self.print_reg_name_guide(reg_name)
				sys.exit()
		return False, int(reg_data[1])

	def get_machine_code(self):
		parsed_code_lines = self.parser.parse(self.code)
		self.machine_code = ""
		for i in parsed_code_lines:
			op = i[0].upper()
			rd = rs1 = rs2 = ""
			machine_code_map = ISA_table[op]
			line_machine_code = machine_code_map[2]
			for j in range(machine_code_map[0]):
				pos = machine_code_map[1][j]
				is_imm, reg_num = self.verify(i[j+1]) 
				if is_imm:
					line_machine_code[pos] = self.to_binary(reg_num,16)
				else:
					line_machine_code[pos] = self.to_binary(reg_num,4)
			self.machine_code += ''.join(map(str, line_machine_code)) + "\n"
		return self.machine_code