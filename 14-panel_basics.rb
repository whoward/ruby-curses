require 'rubygems'
require 'ncurses'

begin
  lines, cols, y, x = [10, 40, 2, 4]
  
  Ncurses.initscr
  Ncurses.cbreak
  Ncurses.noecho
  
  windows = []
  windows.push Ncurses.newwin(lines, cols, y, x)
  windows.push Ncurses.newwin(lines, cols, y + 1, x + 5)
  windows.push Ncurses.newwin(lines, cols, y + 2, x + 10)
  
  windows.each {|win| Ncurses.box(win, 0, 0) }
  
  
  panels = windows.map {|win| Ncurses::Panel::PANEL.new(win) }
  
  Ncurses::Panel.update_panels
  
  Ncurses.doupdate
  
  Ncurses.getch
  
rescue Exception => e
  Ncurses.printw e.inspect + "\n"
  Ncurses.printw e.backtrace.join("\n")
  Ncurses.getch
  
ensure
  Ncurses.endwin
  
end
