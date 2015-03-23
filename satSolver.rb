# SAT Solver Implementation for CSC 320
# Braydon Justice, Cortland Thibodeau, and Sebastian Craig
# Converts given Sudoku puzzles into Conjunctive Normal Form (CNF)

# THE RULES
# 1) Every cell contains at least one number
# 2) Each number appears at most once in every row
# 3) Each number appears at most once in every column
# 4) Each number appears at most once in every 3x3 subgrid

$board = [9]

# Parses the input string into a 9x9 grid
def parsePuzzle str
    count = -1
	str.gsub!(/[.?*]/, '0')
	str.gsub!("\n", "")
	str.gsub!("\r", "")

    (0 .. 8).each do |row|
	$board[row] = Array.new(9)
	(0 .. 8).each do |col|
            current = str[count+=1]
            if current == '\r' || current == '\n'
                next
            elsif current == '.' || current == '*' || current == '?'
                $board[row][col] = 0
            else
                $board[row][col] = current.to_i
            end
        end
    end
end

# Calculates the variable value
# Base 9 was all weird...
def GetVar(row, col, value)
   # value = (81 * (i - 1)) + (9 * (j - 1)) + ((k - 1) + 1) 
   (row * 100) + (col * 10) + value 
end

# Ensures there are no duplicates in a row
# If there are, raise an error
# Else returns the values in the specific column
def RowCheck row
    cnf = []
    seen = []
    (0..8).each do |col|
        if $board[row][col] !=0
            seen.push($board [row][col])
        end
    end
    
    if seen.count != seen.uniq.count
    	    p seen
        raise "Duplicate value in row #{row}"
    else
        seen
    end
end

# Ensure there are no duplicates in a column
def ColCheck col
    cnf = []
    seen = []
    (0 .. 8).each do |row|
        val = $board[row][col]
        if val != 0
            seen.push(val)
        end
    end  

    if seen.count != seen.uniq.count
    	    p seen
        raise "Duplicate value in column #{j}"
    else        
        seen
    end
end 

# Ensure there are no duplicates in a box
def GridCheck(rowIndex, colIndex)
    row = ((rowIndex - 1) / 3).floor
    col = ((colIndex - 1) / 3).floor
    seen = []
    (0 .. 2).each do|innerRow|
        (0 .. 2).each do |innerCol|
            $boardVal = $board[3*row + innerRow][3*col + innerCol]
            if $boardVal != 0
                seen.push($boardVal)
            end
        end
    end
    
    if seen.count != seen.uniq.count
    	    p seen
        raise "Duplicate value in grid #{rowIndex} #{colIndex}"
    else        
        seen
    end
end

def uniqueValues(arr)
    arr.count == arr.uniq.count
end

def GetCellCNF (row, col)
    cnfVals= []
    rowVals = RowCheck(row)    
    colVals = ColCheck(col)   
    gridVals = GridCheck(row, col)
    
    #[rowVals, colVals, gridVals].each do |x|
     #   raise "Duplicate Value Somewhere!" unless uniqueValues(x)
    #end
     
    notVals = rowVals|colVals|gridVals
    vals = []   
    
    (1..9).each do |checkVal|
        if !notVals.include? checkVal
            vals.unshift(checkVal)
        end
    end

    vals.each do |k|
        cnfVals.unshift(GetVar(row+1, col+1, k))
    end
    
    cnfVals
end

# Converts the parsed puzzle (the variable values) into CNF
# Adheres to the 4 given rules
def convertToCNF theParsedPuzzle
    cnfMat = []
    cnfCounter = -1 

    (0..8).each do |row|
        (0..8).each do |col|
            if $board[row][col] == 0
                cnfMat[cnfCounter+=1] = GetCellCNF(row, col)
            end
        end
    end
    #FOR DEBUGGING
    cnfMat.each do |set|
  	p set
    end
    #FOR DEBUGGING
end

def run
    if ARGV.count == 0
       theParsedPuzzle = parsePuzzle "4.....8.5.3..........7......2.....6.....8.4......1.......6.3.7.5..2.....1.4......"
    else
       if ARGV[0].length != 81   # Checks the validaty of rule 1
          puts "Puzzle doesn't contain 81 elements, invalid puzzle"
        else
          parsePuzzle ARGV[0].dup
      end
   end
   convertToCNF theParsedPuzzle
end



# Run with input
run
