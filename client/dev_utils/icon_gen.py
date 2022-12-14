#!/usr/bin/env python3

import argparse
import re

# import os
# import shutil

# Converts a string to lowerCamelCase.
def to_lower_camel_case(string: str) -> str:
    out_string = ""
    string.replace("-", "_")

    for i, char in enumerate(string):
        # lowercase the first character
        if i == 0:
            out_string += char.lower()
        # uppercase the character after a dash or underscore and remove the dash or underscore
        elif char == "-" or char == "_":
            # remove the dash or underscore
            char = ""
            # uppercase the next character
            out_string += string[i + 1].upper()
            # remove the lowercase version
            # out_string = out_string[:2]

        # otherwise just add the character
        else:
            out_string += char

    return out_string


# Generates a Flutter class from the given dict of names and code points.
# Largely taken from
# https://github.com/ScerIO/icon_font_generator/blob/master/lib/generate_flutter_class.dart
def generate_flutter_class(icons: dict[str, str]) -> str:
    out = """library tabler_icons;

import 'package:flutter/widgets.dart';

class TablerIcons {
  TablerIcons._();

"""

    processed_icons = {}

    for icon in icons:
        # convert to lowerCamelCase
        name = to_lower_camel_case(icon)

        # if name starts with a numeric
        if name[0].isdigit():
            name = "i" + name

        processed_icons[name] = icons[icon]

        code_point = icons[icon]

        out += f"    static const IconData {name} = IconData(0x{code_point}, fontFamily: 'tabler-icons', fontPackage: 'tabler_icons');\n"

    out += "\n  static const all = <String, IconData> {\n"

    for icon in processed_icons:
        out += f"    '{icon}': {icon},\n"

    out += "  };\n}\n"

    return out


if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "-i",
        "--input",
        help="Tabler Fonts CSS input file",
        default="assets/tabler/tabler-icons.css",
    )

    parser.add_argument(
        "-o",
        "--output",
        help="Output file for the Dart class",
        default="lib/icons/icons.dart",
    )

    args = parser.parse_args()

    icon_buffer = {}

    # Parse the CSS to get the names and code points of all the icons.
    with open(args.input, "r") as input_file:
        css = input_file.read()
        rules = re.findall(".*:before {\s.*\s}", css)

        for rule in rules:
            icon_name = re.search("(?<=\.ti-).*(?=:)", rule).group()
            icon_hex_val = re.search("(?<=content: '\\\).*(?=';)", rule).group()
            # code_point = re.search('(?<=content: "\\\).*(?=";)', rule).group()
            # assert len(icon_hex_val) == 4
            icon_buffer[icon_name] = icon_hex_val

    icons_flutter_output_code = generate_flutter_class(icon_buffer)

    with open(args.output, "w") as output_file:
        output_file.write(icons_flutter_output_code)
