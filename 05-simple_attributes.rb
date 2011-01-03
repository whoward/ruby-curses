# pager functionality by Joseph Spainhour <spainhou@bellsouth.net>
require 'rubygems'
require 'ncurses'
require 'open-uri' # try loading an http url for fun :)

# make sure there's one arguments
if ARGV.length != 1
  puts "Usage: #{__FILE__} <a c file name>"
  exit(1)
end

# attempt to open the file given by the first arg
begin
  file = open(ARGV.first, "r");
rescue
  STDERR.puts "Cannot open input file #{ARGV.first}"
  exit(1)
end

begin
  Ncurses.initscr
  
  cols = Ncurses.getmaxx(Ncurses.stdscr)
  rows = Ncurses.getmaxy(Ncurses.stdscr)
  
  prev = ""
  
  while not file.eof?
    ch = file.getc.chr
    
    xpos = Ncurses.getcurx(Ncurses.stdscr)
    ypos = Ncurses.getcury(Ncurses.stdscr)
    
    if ypos == rows - 1
      Ncurses.printw "<-Press Any Key->"
      Ncurses.getch
      Ncurses.clear
      Ncurses.move(0, 0)
    end
    
    if prev == '/' and ch == '*'
      Ncurses.attron(Ncurses::A_BOLD)
      xpos = Ncurses.getcurx(Ncurses.stdscr)
      ypos = Ncurses.getcury(Ncurses.stdscr)
      Ncurses.move(ypos, xpos - 1)
      Ncurses.printw("/#{ch}")
    else
      Ncurses.printw(ch)
    end
    
    Ncurses.refresh
    
    if prev == '*' and ch == '/'
      Ncurses.attroff(Ncurses::A_BOLD)
    end
    
    prev = ch
  end

rescue Exception => e
  Ncurses.printw e.inspect + "\n"
  Ncurses.printw e.backtrace.join("\n")
  Ncurses.getch
  
ensure
  Ncurses.endwin
  file.close
  
end