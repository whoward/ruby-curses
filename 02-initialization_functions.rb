require 'rubygems'
require 'ncurses'

# start in ncurses mode
Ncurses.initscr

# disable line buffering and handle Ctrl+Z and Ctrl+C manually - don't generate
# signals when these are pressed
Ncurses.raw

# enable input from F1-F10 keys and cursor keys
Ncurses.keypad(Ncurses.stdscr, true)

# disable echoing of inputted characters
Ncurses.noecho

# print some text
Ncurses.printw "Type any character to see it in bold\n"

# based on input print some output
input = Ncurses.getch
if input == Ncurses::KEY_F1
  Ncurses.printw "F1 Key pressed"
else
  Ncurses.printw "The pressed key is "
  Ncurses.attron(Ncurses::A_BOLD) 
  Ncurses.printw "%c", input
  Ncurses.attron(Ncurses::A_BOLD)
end

# draw on the screen
Ncurses.refresh

# wait for a key press
Ncurses.getch

# return to regular terminal mode
Ncurses.endwin