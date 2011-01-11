# NOTE: ncurses-ruby 0.9.1 is not functioning for mousemask()
require 'rubygems'
require 'ncurses'

WIDTH = 30
HEIGHT = 10

def startx
  (80 - WIDTH) / 2
end

def starty
  (24 - HEIGHT) / 2
end

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
  end
  
  y += 1
  
  Ncurses.wrefresh(menu_win)
end

def report_choice(mouse_x, mouse_y)
  i = startx + 2
  j = starty + 3
  
  CHOICES.each_with_index do |choice, k|
    if mouse_y == j + k && mouse_x >= i && mouse_x <= i + choice.length
      if k == CHOICES.length - 1
        return -1
      else
        return k + 1
      end
    end
  end
end

begin
  choice = 0
  event = Ncurses::MEVENT.new
  
  Ncurses.initscr
  Ncurses.clear
  Ncurses.noecho
  Ncurses.cbreak
  
  Ncurses.attron(Ncurses::A_REVERSE)
  Ncurses.mvprintw(23, 1, "Click on Exit to quit (Works best in a virtual console)")
  Ncurses.refresh
  Ncurses.attroff(Ncurses::A_REVERSE)
  
  menu_win = Ncurses.newwin(HEIGHT, WIDTH, starty, startx)
  print_menu(menu_win, 1)
  
  Ncurses.mousemask([Ncurses::ALL_MOUSE_EVENTS])
  
  loop do
    ch = Ncurses.wgetch(menu_win)
    case ch
    when Ncurses::KEY_MOUSE
      if Ncurses.getmouse(event) == Ncurses::OK
        if event.bstate & Ncurses::BUTTON1_PRESSED
          choice = report_choice(event.x + 1, event.y + 1)
          if(choice == -1)
            break
          end
          Ncurses.mvprintw(22, 1, "choice made is %s", CHOICES[choice])
          Ncurses.refresh
        end
      end
      print_menu(menu_win, choice)
    end
  end
  
rescue Exception => e
  Ncurses.printw e.inspect + "\n"
  Ncurses.printw e.backtrace.join("\n")
  Ncurses.getch
  
ensure
  Ncurses.endwin
  
end
