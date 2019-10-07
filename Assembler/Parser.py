class Parser:
	def __init__(self):
		self.parsed = []
	def parse(self, code):
		lines = code.split("\n")
		for line in lines:
			line = line.replace("("," ") #for LW SW
			line = line.replace(")", "") 
			parts = line.split(" ")
			self.parsed.append(parts)
		return self.parsed