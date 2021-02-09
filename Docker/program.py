import argparse
import random as r
import sys




parser = argparse.ArgumentParser(description='Generate random number.')
parser.add_argument('-g', default=5)
parser.add_argument('-f', action='store_true')
args = parser.parse_args()
r_list = r.sample(range(0, 1000), int(args.g))


if args.f is True:
    sys.exit(1)
else:
    print(*r_list, sep='\n')
