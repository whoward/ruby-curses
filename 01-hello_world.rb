require 'rubygems'
require 'ncurses'

# tell the terminal to enter curses mode
Ncurses.initscr

# prints "Hello World !!!" at the current location (0,0)
Ncurses.printw "Hello World !!!"

# causes changes to be displayed on the screen - maybe this means that NCurses
# uses front and back buffers for drawing?
Ncurses.refresh

# blocks until the user presses a key
Ncurses.stdscr.getch

# returns back to regular console mode
Ncurses.endwin
