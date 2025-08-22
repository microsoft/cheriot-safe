#!/usr/bin/env python3

import sys

def main():
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <filename>")
        sys.exit(1)

    filename = sys.argv[1]
    cnt = 0
    num64 = 0

    try:
        with open(filename, "rb") as f:
            while True:
                buf = f.read(1)
                if not buf:
                    break

                w1 = buf[0]  # same as ord($buf) in Perl
                shamt = 8 * (cnt % 8)
                num64 += (w1 << shamt)

                cnt += 1
                if cnt % 8 == 0:
                    print(f"{num64:016x}")
                    num64 = 0
    except OSError as e:
        print(f"Cannot open file: {e}", file=sys.stderr)
        sys.exit(1)

    # Handle leftover bytes (partial 64-bit word)
    if cnt % 8 != 0:
        print(f"{num64:016x}")

if __name__ == "__main__":
    main()

