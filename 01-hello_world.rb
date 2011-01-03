require 'curses'

Curses.init_screen
Curses.addstr "Hello World !!!"
Curses.refresh
Curses.getch
Curses.close_screen
