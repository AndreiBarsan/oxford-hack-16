# Muse Mouse

A mouse control via the [Muse headband](http://www.choosemuse.com/).

## Set up

The hack only runs on OS X. You also need Ruby and [ruby-osc](https://github.com/maca/ruby-osc).

Compile the C part using
```
gcc mouse_movement.c -o move_mouse -framework ApplicationServices
```

## Usage

Move your mouse by gentle movement of your head vertically and sideways.

Clicking? ** CLENCH YER JAW ** (sic) (you heard it right)