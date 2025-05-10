# Play golf.vim, in Helix

A small utility that lets you play [golf.vim](https://github.com/vuciv/golf) levels, with the Helix editor.

## Features

- Fetches random and daily challenges from the golf.vim API.
- Compares the solution against the target text, and displays any differences.
- Measures the time took to solve a level.

## Missing features

- Doesn't track keystrokes, as it would require support of the terminal emulator, or helix plugins.
- Doesn't display a leaderbord. It wouldn't be that useful anyway as there is no keystroke tracking.

## Dependencies

- [Helix](https://github.com/helix-editor/helix).
- A POSIX-compliant shell.
- [jq](https://jqlang.org/): lightweight JSON processor.

## Usage

The `--help` flag outputs the command usage.

```sh
$ ./golf.sh --help
Usage: golf.sh [mode]

Modes:
    daily:      play daily challenge
    easy:       play easy difficulty challenge
    medium:     play medium difficulty challenge
    hard:       play hard difficulty challenge

If no mode is given, a random challenge is selected.
```

The script opens a helix instance with the instructions on the left, and the
working text on the right. The objective is to modify the working text to match
the expected one. Once you finish the level, quit Helix to see the results (`:wqa`).

All the generated files will be stored at the relative `.tmp` directory. Run `make clean` to remove all temporary files.

For example, to play the daily level, execute:
```sh
./golf.sh daily
```
