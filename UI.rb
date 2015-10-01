module GUI

  def self.mazeDisplay root, maze
    if maze  
      solved = false
      mazeWindow = TkToplevel.new(root)
      mazeWindow['resizable'] = false, false
      mazeFrame = TkFrame.new(mazeWindow)
      (0...maze.length).each do |row|
        (0...maze[row].length).each do |column|
            TkButton.new(mazeFrame, 'background'=> 
                "#%06x" % (#(maze[row][column] == ' ' ? 1 : (maze[row][column] == ' ' ? 2 : 0)) * 0xffffff)
                case maze[row][column]
                  when ' '
                    0xffffff
                  when '#'
                    0x000000
                  else
                    solved = true
                    0x32CD32	
                  end
                 ), 'width'=>2, 'height'=>1).grid :row=>row,   :column=>column
        end
      end
      mazeFrame.grid :row=>0, :sticky=>'ew'
      TkButton.new(mazeWindow, :text=> solved ? 'Reset' : 'Solve', :command=>proc{Maze::MazeSolver.new(maze).solve; mazeWindow.destroy; mazeDisplay root, maze}).grid :row=>1, :sticky=>'ew'
      if solved
        TkButton.new(mazeWindow, :text=> 'Save', :command=>proc{Maze.write Tk::getSaveFile, Maze::MazeSolver.new(maze).to_s}).grid :row=>2, :sticky=>'ew'
      end
    end
  end

  def self.mainWindow
    root = TkRoot.new :title=> "Touch the kitty"
    root['resizable'] = false, false
    limg = GifAnimatedLabel.new(root).grid :row=>0
    limg.image(TkPhotoImage.new :format=>'GIF', :file=>"zara.gif")
    limg.bind("Enter") { limg.start(100) } 
    limg.bind("Leave") { limg.stop }
    TkButton.new(root, :text=> "Open File", :command=>proc{maze = Maze.read Tk::getOpenFile; mazeDisplay root, maze}).grid :row=>1, :sticky=>'ew'
    Tk.mainloop
  end

end