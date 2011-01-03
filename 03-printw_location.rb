require 'rubygems'
require 'ncurses'

Ncurses.initscr

cols = Ncurses.getmaxx(Ncurses.stdscr)
rows = Ncurses.getmaxy(Ncurses.stdscr)

# print a string at the center of the screen
mesg = "Just a string"
Ncurses.mvprintw(rows / 2, (cols - mesg.length) / 2, mesg)

# print another near the bottom
Ncurses.mvprintw(rows - 2, 0, "This screen has %d rows and %d columns\n", rows, cols)

Ncurses.printw "Try resizing your window (if possible) and then run this program again"

Ncurses.refresh

Ncurses.getch

Ncurses.endwin
