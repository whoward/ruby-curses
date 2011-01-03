require 'rubygems'
require 'ncurses'

Ncurses.initscr

cols = Ncurses.getmaxx(Ncurses.stdscr)
rows = Ncurses.getmaxy(Ncurses.stdscr)

# print a string at the center of the screen
mesg = "Enter a string: "
Ncurses.mvprintw(rows / 2, (cols - mesg.length) / 2, mesg)

string = ""
Ncurses.stdscr.getstr(string)

Ncurses.mvprintw(rows - 2, 0, "You Entered: #{string}")

Ncurses.getch

Ncurses.endwin
