#!/usr/bin/env python3

import sys

BLOCK_SIZE = 4

def main():
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <filename>")
        sys.exit(1)

    fname = sys.argv[1]
    try:
        with open(fname, "rb") as f:
            ct = 0
            while True:
                buf = f.read(BLOCK_SIZE)
                if not buf:
                    break

                # Reverse the block (pad if needed to 4 bytes)
                for b in reversed(buf):
                    print(f"{b:02x}", end="")

                ct += 1
                print(" ", end="")

                if ct % 4 == 0:
                    print()
    except OSError as e:
        print(f"Unable to open file {fname}: {e}", file=sys.stderr)
        sys.exit(1)

    print()

if __name__ == "__main__":
    main()

