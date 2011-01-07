require 'rubygems'
require 'ncurses'

def print_centered(string, options={})
  window = options.fetch(:window, Ncurses.stdscr)
  startx = options.fetch(:startx, Ncurses.getcurx(window))
  starty = options.fetch(:starty, Ncurses.getcury(window))
  width  = options.fetch(:width, Ncurses.getmaxx(window))
  
  startx = startx + (width - string.length) / 2
  
  Ncurses.mvwprintw(window, starty, startx, string)
  Ncurses.refresh
end

begin
  Ncurses.initscr

  unless Ncurses.has_colors?
    Ncurses.endwin
    puts "Your terminal does not support color"
    exit 1
  end
  
  Ncurses.start_color
  
  Ncurses.init_pair(1, Ncurses::COLOR_RED, Ncurses::COLOR_BLACK)
  
  Ncurses.attron(Ncurses.COLOR_PAIR(1))
  print_centered "Viola!!! In color ...", :starty => Ncurses.getmaxy(Ncurses.stdscr)/2
  Ncurses.attroff(Ncurses.COLOR_PAIR(1))
  
  Ncurses.getch
  
rescue Exception => e
  Ncurses.printw e.inspect + "\n"
  Ncurses.printw e.backtrace.join("\n")
  Ncurses.getch
  
ensure
  Ncurses.endwin
end
