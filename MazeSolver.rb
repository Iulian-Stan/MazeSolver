module Maze
 
  DIRECTIONS = [ [0, -1], [0, 1], [1, 0], [-1, 0] ]
    
  def self.read inFile
    if inFile && File.file?(inFile)
      File.open(inFile, "r") { |f|
        f.each_line.map { |line| line.chomp.split(//) }
      }
    end
  end
    
  def self.write outFile, mazeSolver
    begin
      File.open(outFile, "w") { |f|
        f << mazeSolver.to_s
      }
    rescue
    end    
  end

  class LinkedListNode < Struct.new(:x, :y, :parent)
  end
 
  class MazeSolver
      
    def initialize maze
      @maze = maze
      @queue = []
    end
    
    def self.maze=maze
      @maze = maze
    end
      
    def to_s
      @maze.map { |row| row.join('') }.join("\n")
    end
      
    def solve
      solved = false
 
      (0...@maze.length).each { |row|
          @queue << LinkedListNode.new(row, 0, nil) if @maze[row][0] == ' '
      }  
            
      while !@queue.empty? && !solved
        node = @queue.shift # queue.pop
        x = node.x
        y = node.y
        if (y == @maze.length-1)
          solved = true
        else
          @maze[x][y] = '*' # Mark path as visited
          neighbours(node).each { |neighbour| @queue << neighbour}
        end
      end

      @maze.each_index { |idx|
        @maze[idx] = @maze[idx].join.gsub(/[^#|\s]/i,' ').split(//) 
      }
        
      if solved
        @maze[node.x][node.y] = '@'
        while node.parent
          node = node.parent
          @maze[node.x][node.y] = '@'
        end
      end
      solved
    end
 
    private
      
    def neighbours node
      DIRECTIONS.map{|step| LinkedListNode.new(node.x+step[0], node.y+step[1], node)}.
            select{|neighbour| @maze[neighbour.x][neighbour.y] == ' ' }
    end
  
  end

end