This script spits all of the Music Understanding Framework JSON data to standard output.

I need to use the Music Understanding stuff with some other languages cause I don't know Swift.
So I'll build this binary and run it from other programming languages.

Mac OS 27+ of course.


BUILDING

Go see Makefile.


USAGE

Full analysis:
mu-cli /path/to/audio

Only loudness (cause it's the only part that's fast):
mu-cli -l /path/to/audio