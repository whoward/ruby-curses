require 'rubygems'
require 'ncurses'

class Border < Struct.new(:ls, :rs, :ts, :bs, :tl, :tr, :bl, :br)
  def self.sql_style
    new('|', '|', '-', '-', '+', '+', '+', '+')
  end
  
  NAME_MAP = {'t' => 'top', 'r' => 'right', 'b' => 'bottom', 'l' => 'left', 's' => 'edge'}
  
  # make nice helper methods to access the character variables (as ASCII indexes)
  # based on the mapping given in NAME_MAP.  For example ts becomes top_side_char
  %w(ls rs ts bs tl tr bl br).each do |edge_character|
    method_name = ["char"]
    edge_character.reverse.each_char {|c| method_name.unshift(NAME_MAP[c]) }
    
    define_method(method_name.join "_") do
      send(edge_character)[0]
    end
  end

  def draw_on_window(window)
    x, y, w, h = window.startx, window.starty, window.width, window.height
    
    # draw the top left corner
    Ncurses.mvaddch y, x, top_left_char
    
    # draw the top right corner
    Ncurses.mvaddch y, x + w, top_right_char
    
    # draw the bottom left corner
    Ncurses.mvaddch y + h, x, bottom_left_char
    
    # draw the bottom right corner
    Ncurses.mvaddch y + h, x + w, bottom_right_char
    
    # draw a horizontal line for the top edge
    Ncurses.mvhline y, x + 1, top_edge_char, w - 1
    
    # draw a horizontal line for the bottom edge
    Ncurses.mvhline y + h, x + 1, bottom_edge_char, w - 1
    
    # draw a vertical line for the left edge
    Ncurses.mvvline y + 1, x, left_edge_char, h - 1
    
    # draw a vertical line for the bottom edge
    Ncurses.mvvline y + 1, x + w, right_edge_char, h - 1
  end
end

class Window < Struct.new(:startx, :starty, :height, :width, :border)
  
  def self.new_with_border(border)
    height = 3
    width = 10
    starty = (Ncurses.getmaxy(Ncurses.stdscr) - height) / 2
    startx = (Ncurses.getmaxx(Ncurses.stdscr) - width) / 2
    new(startx, starty, height, width, border)
  end
  
  def endx
    self.startx + width
  end
  
  def endy
    self.starty + height
  end
  
  # return a list of 2-tuples which are the coordinates of each border
  def border_coordinates
    yvals = (self.starty..endy).to_a
    xvals = (self.startx..endx).to_a
    yvals.product(xvals)
  end
  
  def draw_border
    border.draw_on_window(self)
  end
  
  def erase_border
    border_coordinates.each do |row, col|
      Ncurses.mvaddch(row, col, ' '[0])
    end
  end
  
  def shift(dx,dy)
    erase_border
    self.startx += dx
    self.starty += dy
    draw_border
  end
  
end

begin
  Ncurses.initscr
  Ncurses.start_color
  Ncurses.cbreak
  Ncurses.keypad(Ncurses.stdscr, true)
  Ncurses.noecho
  Ncurses.init_pair(1, Ncurses::COLOR_CYAN, Ncurses::COLOR_BLACK)
  
  window = Window.new_with_border(Border.sql_style)
  
  Ncurses.attron(Ncurses.COLOR_PAIR(1))
  Ncurses.printw("Press F1 to exit")
  Ncurses.refresh
  Ncurses.attroff(Ncurses.COLOR_PAIR(1))
  
  window.draw_border
  
  loop do
    case Ncurses.getch
      when Ncurses::KEY_LEFT  then window.shift(-1,  0)
      when Ncurses::KEY_RIGHT then window.shift(+1,  0)
      when Ncurses::KEY_UP    then window.shift( 0, -1)
      when Ncurses::KEY_DOWN  then window.shift( 0, +1)
      when Ncurses::KEY_F1    then break
    end
  end
  
rescue Exception => e
  Ncurses.printw e.inspect + "\n"
  Ncurses.printw e.backtrace.join("\n")
  Ncurses.getch
  
ensure
  Ncurses.endwin
end
