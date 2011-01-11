require 'rubygems'
require 'ncurses'

NLINES = 10
NCOLS = 40
NWINDOWS = 3

class CustomPanel
  attr_accessor :x, :y, :w, :h, :panel, :label, :label_color, :next
  
  def initialize(window, i)
    self.panel = Ncurses::Panel::PANEL.new(window)
    
    self.x = Ncurses.getbegx(window)
    self.y = Ncurses.getbegy(window)
    self.w = Ncurses.getmaxx(window)
    self.h = Ncurses.getmaxy(window)

    self.label = "Window Number #{i}"
    self.label_color = i
  end
    
  def coords
    [self.x, self.y, self.w, self.h]
  end
  
  def method_missing(method, *args, &block)
    self.panel.send(method, *args, &block)
  end
  
end

def win_show(win, label, label_color)
  startx = Ncurses.getbegx(win)
  starty = Ncurses.getbegy(win)
  width  = Ncurses.getmaxx(win)
  height = Ncurses.getmaxy(win)
  
  Ncurses.box(win, 0, 0)
  Ncurses.mvwaddch(win, 2, 0, '+'[0])
  Ncurses.mvwhline(win, 2, 1, '-'[0], width - 2)
  Ncurses.mvwaddch(win, 2, width - 1, '+'[0])
  
  print_in_middle(win, 1, 0, width, label, Ncurses.COLOR_PAIR(label_color))
end

def print_in_middle(win, starty, startx, width, string, color)
  win = win ? win : Ncurses.stdscr
  
  y, x = [Ncurses.getcury(win), Ncurses.getcurx(win)]
  
  x = (startx != 0) ? startx : x
  y = (starty != 0) ? starty : y
  
  width = (width == 0) ? 80 : width
  
  x = startx + (width - string.length) / 2
  Ncurses.wattron(win, color)
  Ncurses.mvwprintw(win, y, x, string)
  Ncurses.wattroff(win, color)
  Ncurses.refresh
end

begin
  windows = []
  panels = []
  
  # initialize ncurses
  Ncurses.initscr
  Ncurses.start_color
  Ncurses.cbreak
  Ncurses.noecho
  Ncurses.keypad(Ncurses.stdscr, true)
  
  # determine rows and lines for the screen
  cols = Ncurses.getmaxx(Ncurses.stdscr)
  lines = Ncurses.getmaxy(Ncurses.stdscr)
  
  # initialize all the colors
  Ncurses.init_pair(1, Ncurses::COLOR_RED, Ncurses::COLOR_BLACK)
  Ncurses.init_pair(2, Ncurses::COLOR_GREEN, Ncurses::COLOR_BLACK)
  Ncurses.init_pair(3, Ncurses::COLOR_BLUE, Ncurses::COLOR_BLACK)
  Ncurses.init_pair(4, Ncurses::COLOR_CYAN, Ncurses::COLOR_BLACK)
  
  (0..(NWINDOWS - 1)).each do |i|
    x = 10 + 3*i
    y = 2 + 7*i
    
    windows.push Ncurses.newwin(NLINES, NCOLS, y, x)
    
    win_show(windows.last, "Window Number #{i+1}", i+1)
  end
  
  # Attach a panel to each window
  windows.each_with_index do |win, i|
    panels.push CustomPanel.new(win, i)
  end
  
  panels.each_with_index do |panel, i|
    panel.next = (i == panels.length - 1) ? panels.first : panels[i+1]
  end
  
  # Update the stacking order.  2nd panel will be on top.
  Ncurses::Panel.update_panels
  
  # Show it on the screen
  Ncurses.attron(Ncurses.COLOR_PAIR(4))
  Ncurses.mvprintw(lines - 3, 0, "Use 'm' for moving, 'r' for resizing")
  Ncurses.mvprintw(lines - 2, 0, "Use tab to browse through the windows (F1 to Exit)")
  Ncurses.attroff(Ncurses.COLOR_PAIR(4))
  Ncurses.doupdate
  
  top = panels.last
  size, move = [false, false]
  newx, newy, neww, newh = top.coords
  
  loop do
    case Ncurses.getch
      when Ncurses::KEY_F1
        break
        
      when "\t"[0]
        Ncurses::Panel.top_panel(top.next.panel)
        top = top.next
        newx, newy, neww, newh = top.coords
        
      when "r"[0]
        size = true
        Ncurses.attron(Ncurses.COLOR_PAIR(4))
        Ncurses.mvprintw(lines - 4, 0, "Entered Resizing: Use Arrow Keys to resize")
        Ncurses.refresh
        Ncurses.attroff(Ncurses.COLOR_PAIR(4))
        
      when "m"[0]
        Ncurses.attron(Ncurses.COLOR_PAIR(4))
        Ncurses.mvprintw(lines - 4, 0, "Entered Moving: Use Arrow Keys to Move and ????")
        Ncurses.refresh
        Ncurses.attroff(Ncurses.COLOR_PAIR(4))
        move = true
        
      when Ncurses::KEY_LEFT
        if size
          newx -= 1
          neww += 1
        elsif move
          newx -= 1
        end
        
      when Ncurses::KEY_RIGHT
        if size
          newx += 1
          neww -= 1
        elsif move
          newx += 1
        end
        
      when Ncurses::KEY_UP
        if size
          newy -= 1
          newh += 1
        elsif move
          newy -= 1
        end
        
      when Ncurses::KEY_DOWN
        if size
          newy += 1
          newh -= 1
        elsif move
          newy += 1
        end
        
      when "\n"[0]
        Ncurses.move(lines - 4, 0)
        Ncurses.clrtoeol
        Ncurses.refresh
        
        if size
          old = Ncurses::Panel.panel_window(top.panel)
          temp = Ncurses.newwin(newh, neww, newy, newx)
          Ncurses::Panel.replace_panel(top.panel, temp)
          win_show(temp, top.label, top.label_color)
          Ncurses.delwin(old)
          size = false
          
        elsif move
          Ncurses::Panel.move_panel(top.panel, newy, newx)
          move = false
        end
    end
    
    Ncurses.attron(Ncurses.COLOR_PAIR(4))
    Ncurses.mvprintw(lines - 3, 0, "Use 'm' for moving, 'r' for resizing")
    Ncurses.mvprintw(lines - 2, 0, "Use tab to browse through the windows (F1 to exit)")
    Ncurses.attroff(Ncurses.COLOR_PAIR(4))
    Ncurses.refresh
    Ncurses::Panel.update_panels
    Ncurses.doupdate
  end
  
rescue Exception => e
  Ncurses.printw e.inspect + "\n"
  Ncurses.printw e.backtrace.join("\n")
  Ncurses.getch
  
ensure
  Ncurses.endwin
  
end
