This is a fork of d1x's "Promotional Kirby Contest Card (Loser) Disassembly", found here:
https://github.com/d1x/ereader-card-disassemblies/tree/master/kirby-contest-card-loser


It is a recreation of the 1st Prize Kirby Contest e-Reader Card from e3 2002.
It is important to note that the hash for the recreation is not going to match that of the official card, as the compression is not going to be exactly the same.

CRC: D5984FD9

However, the purpose of this project is to fully recreate the experience.

![ ](screenshot.png)

The image displayed on the screen when this card is loaded onto the e-Reader is the official image of the 1st Prize Kirby card, and was obtained through editor of Tips 'N Tricks Magazine earlier this year.
He was sent the image for a piece on 'The rarest e-Reader Card', featuring the Kirby Prize cards, and the screens displayed for the places: 1st, 2nd and Loser.
To this day this image is the closest known thing to this card existing anywhere.

The song included in this repo has been guessed, and picked out to try and match what a 'winning' sound would sound like when compared to the other 2 prize cards.
All songs are loaded from the e-Reader itself.

This one is 0x0054.

    ; CONSTANTS

    input_register = 0x9f02
    system_sound_83 = 0x0054

Change the value of system_sound_83 to change the music

The repo will be updated should information on the song that was officially used is found.

## How to build

* Download [SDCC](http://sdcc.sourceforge.net/)
* Download [nedcmake](https://www.caitsith2.com/ereader/tools/nedcmake.rar) from [caitsith2.com E-Reader Development Tools](https://www.caitsith2.com/ereader/devtools.htm)

Compile:
```
sdasz80.exe -l -o -s -p main.o main.asm
```

Link:
```
sdldz80.exe -n -- -i main.ihx main.o
```

Make binary:
```
makebin.exe -p < main.ihx > main.z80
```

Remove first 256 bytes of `main.z80` in your editor of choice and save it as `main.bin`.

To run in an emulator: generate `RAW`:
```
nedcmake.exe -i main.bin -o us -type 1 -region 1 -raw
```

To run on real hardware: generate `BMP`:
```
nedcmake.exe -i main.bin -o us -type 1 -region 1 -bmp
```
