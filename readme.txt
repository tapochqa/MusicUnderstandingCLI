This script spits the Music Understanding Framework JSON data to standard output.

I need to use the Music Understanding stuff with some other languages cause I don't know Swift.
So I'll build this binary and run it from other programming languages.

Mac OS 27+ of course.


BUILDING

Go see Makefile.


USAGE

Full analysis:
mu-cli file

Only loudness:
Full map: mu-cli --loudness file
Untrue peak as float (dB): mu-cli --loudness --peak file
Integrated as float (LUFS): mu-cli --loudness --integrated file
Max short-term as float (LUFS): mu-cli --loudness --short-term file
Max momentary as float (LUFS): mu-cli --loudness --momentary file


Only rhythm:
Full map: mu-cli --rhythm file
BPM as int: mu-cli --rhythm --bpm file
