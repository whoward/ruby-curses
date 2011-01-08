require 'rubygems'
require 'ncurses'

WIDTH = 30
HEIGHT = 10

CHOICES = ['Choice 1', 'Choice 2', 'Choice 3', 'Choice 4', 'Exit']

def print_menu(menu_win, highlight)
  x = 2
  y = 2
  Ncurses.box(menu_win, 0, 0)
  CHOICES.each_with_index do |choice, i|
    if highlight == i + 1
      Ncurses.wattron(menu_win, Ncurses::A_REVERSE)
      Ncurses.mvwprintw(menu_win, y, x, CHOICES[i])
      Ncurses.wattroff(menu_win, Ncurses::A_REVERSE)
    else
      Ncurses.mvwprintw(menu_win, y, x, CHOICES[i])
    end
    y += 1
  end
  Ncurses.wrefresh(menu_win)
end

begin
  highlight = 1
  choice = 0
  
  Ncurses.initscr
  
  Ncurses.clear
  Ncurses.noecho
  Ncurses.cbreak
  
  startx = (80 - WIDTH) / 2
  starty = (24 - HEIGHT) / 2
    
  menu_win = Ncurses.newwin(HEIGHT, WIDTH, starty, startx)
  
  Ncurses.keypad(menu_win, true)
  
  Ncurses.mvprintw(0, 0, "Use arrow keys to go up and down, Press enter to select a choice")
  
  Ncurses.refresh
  
  print_menu(menu_win, highlight)
  
  loop do
    ch = Ncurses.wgetch(menu_win)
    
    case ch
    when Ncurses::KEY_UP 
      highlight = (highlight == 1) ? CHOICES.length : highlight - 1
      
    when Ncurses::KEY_DOWN
      highlight = (highlight == CHOICES.length) ? 1 : highlight + 1
      
    when "\n"[0]
      choice = highlight
      
    else
      Ncurses.mvprintw(24, 0, "Charcter pressed is = %3d Hopefully it can be pr", ch)
      Ncurses.refresh();
      
    end
    
    print_menu(menu_win, highlight)
    
    break if choice != 0
  end
  
  Ncurses.mvprintw(23, 0, "You chose choice %d with choice string %s\n", choice, CHOICES[choice - 1])
  Ncurses.clrtoeol
  Ncurses.refresh
  Ncurses.getch
  
rescue Exception => e
  Ncurses.printw e.inspect + "\n"
  Ncurses.printw e.backtrace.join("\n")
  Ncurses.getch
  
ensure
  Ncurses.endwin
end
