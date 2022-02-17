# Tunesmith for the KIM-1

![Bach mit KIM](https://github.com/netzherpes/tunesmith-for-kim-1/raw/main/tunesmith_old.png)

(c)  1979 Anthony T. Scarpelli<br>
found in micro 6/79

news 13.2.21<br>
An initial test makes it look like this program is actually working :)

 # *Instructions*
Load both papertape file and start the progam at location $0200

Type in the notes with the corresponding letters A - F on the keypad; 9 stands for note G.<br>
After the note you can set the upper octave with '7' and halfnotes ('sharp notes') with '5' <br>
The length can be set with 1,2,4,8 as a full, half, quater or eighth note.<br>
To save a note press '3'<br>
The song will continue to play from the first note on.<br>

If you have listened to your song, you can write it down by pressing '+'on the keypad and shuffle through the notes with '3' on the keypad. The song will be shown on the lc display note by note. on the LCD:  

![anzeige](https://github.com/netzherpes/tunesmith-for-kim-1/raw/main/image/digit.jpg)

digit | meaning
---|---
1 | octave
2 | note
3 | sharp or not
4 | length

If you want to go on composing the coldstart is at location $021C<br>
To just listen to the tune start at $0300<br>
To do:<br>
 1. Right now the program uses an unexpanded KIM and can only store 72 notes. Maybe I can set the resticrions to the upper mem and have unlimited space.
 2. The notes are only shown after you think you are done. I could think of a permanent display while composing.
 
