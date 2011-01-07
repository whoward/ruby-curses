require 'rubygems'
require 'ncurses'

def create_window(height, width, starty, startx)
  window = Ncurses.newwin(height, width, starty, startx)
  
  Ncurses.box(window, 0, 0) # 0, 0 gives default characters for the vertical
                            # and horizontal lines
                            
  Ncurses.wrefresh(window)  # show that box
  
  window
end

def destroy_window(window)
  # Draws over the border with the space character (ASCII #32).
  # The parameters are:
  #   wnd - window object
  #   ls - left edge character index
  #   rs - right edge character index
  #   ts - top edge character index
  #   bs - bottom edge character index
  #   tl - top left character index
  #   tr - top right character index
  #   bl - bottom left character index
  #   br - bottom right character index
  Ncurses.wborder(window, 32, 32, 32, 32, 32, 32, 32, 32)
  
  Ncurses.wrefresh(window)
  
  Ncurses.delwin(window)
end

begin
  Ncurses.initscr

  Ncurses.cbreak
  
  Ncurses.keypad(Ncurses.stdscr, true)
  
  cols = Ncurses.getmaxx(Ncurses.stdscr)
  rows = Ncurses.getmaxy(Ncurses.stdscr)
  
  height = 3
  width  = 10
  
  starty = (rows - height) / 2
  startx = (cols - width) / 2
  
  Ncurses.printw("Press F1 to exit")
  
  Ncurses.refresh
  
  window = create_window(height, width, starty, startx)
  
  while (ch = Ncurses.getch) != Ncurses::KEY_F1
    if ch == Ncurses::KEY_LEFT
      startx -= 1
      destroy_window(window)
      window = create_window(height, width, starty, startx)
      
    elsif ch == Ncurses::KEY_RIGHT
      startx += 1
      destroy_window(window)
      window = create_window(height, width, starty, startx)
      
    elsif ch == Ncurses::KEY_UP
      starty -= 1
      destroy_window(window)
      window = create_window(height, width, starty, startx)
      
    elsif ch == Ncurses::KEY_DOWN
      starty += 1
      destroy_window(window)
      window = create_window(height, width, starty, startx)
      
    end
  end

rescue Exception => e
  Ncurses.printw e.inspect + "\n"
  Ncurses.printw e.backtrace.join("\n")
  Ncurses.getch
  
ensure
  Ncurses.endwin
end
