# SAT Solver Implementation for CSC 320
# Braydon Justice, Cortland Thibodeau, and Toasty
# Converts given Sudoku puzzles into Conjunctive Normal Form (CNF)
# Ruby < python

# THE RULES
# 1) Every cell contains at least one number
# 2) Each number appears at most once in every row
# 3) Each number appears at most once in every column
# 4) Each number appears at most once in every 3x3 subgrid

# Gets all the distinct varbiables for the CNF
# If there are duplicates in the conversions then the Sudoku puzzle is not valid
def parsePuzzle puzzle
   columns = (1..9).to_a
   rows = (1..9).to_a
   # Need to check that this is the correct starting index
   count = -1
   variables = []

   # Replaces wildcard characters with 0s
   puzzle.gsub!(/[.?*]/, '0')

   rows.each do |row|
      columns.each do |col|
	# puts "Calculate variable value of: #{row} #{col}"
         variables.push(getVariableNumber(row, col, puzzle[count+=1].to_i))
      end
   end
   
   # FOR DEBUGGING
   # puts variables.sort
   # puts "There are #{variables.count} values"
   # puts "There are #{variables.uniq.count} unique values"
   # puts variables.detect{ |e| variables.count(e) > 1 }

   # Checks for duplicates.. uniq are only unique values
   if variables.uniq.length == variables.length
      puts "Array does not contain duplicates"
   else
      puts "Array contains duplicates BAD SUDOKU"
   end
end

# Calculates the variable value
# Base 9 was all weird...
def getVariableNumber(row, col, value)
   # value = (81 * (i - 1)) + (9 * (j - 1)) + ((k - 1) + 1) 
   (row * 100) + (col * 10) + value 
end

# Converts the parsed puzzle (the variable values) into CNF
# Adheres to the 4 given rules
def convertToCNF theParsedPuzzle
end

def run
   if ARGV.count == 0
      puts 'Please provide a Sudoku puzzle as a string'
   else
      parsePuzzle ARGV[0].dup
   end
end

# Run with input
run
