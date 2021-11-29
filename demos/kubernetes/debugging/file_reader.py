#!/usr/bin/env python3
# -*- coding: utf-8 -*-

""" Reads a file and prints it, again and again. """

import sys
import time


__author__ = "Andreas Lindhé"


def main(filename):
    """ Main function description """
    with open(filename, 'r') as f:
        content = f.read()
    prints = 0
    while True:
        prints += 1
        print(content + ' (' + str(prints) + ')')
        time.sleep(1)


if __name__ == '__main__':
    try:
        main(sys.argv[1])
    except KeyboardInterrupt:
        sys.exit("\nInterrupted by ^C\n")
