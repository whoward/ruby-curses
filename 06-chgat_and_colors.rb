require 'rubygems'
require 'ncurses'

Ncurses.initscr

Ncurses.start_color

Ncurses.init_pair(1, Ncurses::COLOR_CYAN, Ncurses::COLOR_BLACK)

Ncurses.printw "A big string which I didn't care to type fully"

# style the string so part of it is bold
#   First two parameters specify the position at which to start
#   Third parameter number of characters to update. -1 means till end of line.
#   Fourth parameter is the normal attribute you wanted to give to the character
#   Fifth is the color index.  It is the index given during init_pair()
#   use 0 if you didn't want color
#   Sixth one is always nil
Ncurses.mvchgat(0, 20, -1, Ncurses::A_BOLD, 1, nil)

Ncurses.refresh

Ncurses.getch

Ncurses.endwin
