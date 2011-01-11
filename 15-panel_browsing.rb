require 'rubygems'
require 'ncurses'

NLINES = 10
NCOLS = 40

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
  # initialize curses
  Ncurses.initscr
  Ncurses.start_color
  Ncurses.cbreak
  Ncurses.noecho
  Ncurses.keypad(Ncurses.stdscr, true)
  
  # determine rows and lines for the screen
  cols = Ncurses.getmaxx(Ncurses.stdscr)
  lines = Ncurses.getmaxy(Ncurses.stdscr)
  
  # initialize all the colors
  Ncurses.init_pair(1, Ncurses::COLOR_RED,   Ncurses::COLOR_BLACK)
  Ncurses.init_pair(2, Ncurses::COLOR_GREEN, Ncurses::COLOR_BLACK)
  Ncurses.init_pair(3, Ncurses::COLOR_BLUE,  Ncurses::COLOR_BLACK)
  Ncurses.init_pair(4, Ncurses::COLOR_CYAN,  Ncurses::COLOR_BLACK)
  
  windows = []
  
  (0..2).each do |i|
    x = 10 + 3*i
    y = 2 + 7*i
    
    windows.push Ncurses.newwin(NLINES, NCOLS, y, x)
    
    win_show(windows.last, "Window Number #{i+1}", i+1)
  end
  
  # attach a panel to each window
  panels = windows.map {|win| Ncurses::Panel::PANEL.new(win) }
  
  # set up user pointers to the next panel
  Ncurses::Panel.set_panel_userptr(panels[0], panels[1])
  Ncurses::Panel.set_panel_userptr(panels[1], panels[2])
  Ncurses::Panel.set_panel_userptr(panels[2], panels[0])
  
  # Update the stacking order.  2nd panel will be on top.
  Ncurses::Panel.update_panels
  
  # Show it on the screen
  Ncurses.attron(Ncurses.COLOR_PAIR(4))
  Ncurses.mvprintw(lines - 2, 0, "Use tab to browse through the windows (F1 to Exit)")
  Ncurses.attroff(Ncurses.COLOR_PAIR(4))
  Ncurses.doupdate
  
  top = panels.last
  loop do
    case Ncurses.getch
      when Ncurses::KEY_F1
        break
      when "\t"[0]
        top = Ncurses::Panel.panel_userptr(top)
        Ncurses::Panel.top_panel(top)
        Ncurses::Panel.update_panels
        Ncurses.doupdate
    end
  end
  
rescue Exception => e
  Ncurses.printw e.inspect + "\n"
  Ncurses.printw e.backtrace.join("\n")
  Ncurses.getch
  
ensure
  Ncurses.endwin
  
end
