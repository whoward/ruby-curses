require 'rubygems'
require 'ncurses'

begin
  Ncurses.initscr
  Ncurses.printw "Hello World!!!\n"
  Ncurses.refresh
  Ncurses.getch
  
  Ncurses.def_prog_mode
  Ncurses.endwin
  system "/bin/sh"
  Ncurses.reset_prog_mode
  Ncurses.refresh
  
  Ncurses.printw "Another String\n"
  Ncurses.refresh()
  Ncurses.getch
  
rescue Exception => e
  Ncurses.printw e.inspect + "\n"
  Ncurses.printw e.backtrace.join("\n")
  Ncurses.getch
  
ensure
  Ncurses.endwin
  
end
