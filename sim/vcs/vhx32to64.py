#!/usr/bin/env python3

import sys

def combine_32bit_to_64bit(input_file, output_file):
    # Open the input file for reading and output file for writing
    with open(input_file, "r") as infile, open(output_file, "w") as outfile:
        # Read all lines and strip whitespace
        lines = [line.strip() for line in infile if line.strip()]

        # Ensure there are an even number of 32-bit hex numbers
        if len(lines) % 2 != 0:
            # raise ValueError("Input file must contain an even number of 32-bit hex numbers")
            lines.append("00000000")

        # Process each pair of 32-bit numbers
        for i in range(0, len(lines), 2):
            lsw_hex = lines[i]       # Least Significant Word (first in the pair)
            msw_hex = lines[i + 1]   # Most Significant Word (second in the pair)

            try:
                # Convert hex strings to integers
                lsw = int(lsw_hex, 16)
                msw = int(msw_hex, 16)

                # Combine MSW and LSW into a single 64-bit integer
                combined_64bit = (msw << 32) | lsw

                # Format the 64-bit integer as a hex string
                hex_64bit = f"{combined_64bit:016x}"

                # Write the result to the output file
                outfile.write(hex_64bit + "\n")
            except ValueError:
                print(f"Invalid hex number in input: {lsw_hex} or {msw_hex}")

if __name__ == "__main__":
    # Check if the user provided the correct number of arguments
    if len(sys.argv) != 3:
        print("Usage: python combine_hex.py <input_file> <output_file>")
        sys.exit(1)

    # Get input and output file names from the command line arguments
    input_file = sys.argv[1]
    output_file = sys.argv[2]

    try:
        combine_32bit_to_64bit(input_file, output_file)
        print(f"Successfully processed. Output written to {output_file}")
    except Exception as e:
        print(f"Error: {e}")

