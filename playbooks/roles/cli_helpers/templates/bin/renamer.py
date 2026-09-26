#!/usr/bin/env python3

import argparse
import os
import re

import eyed3

us = re.compile(r" ")
sq = re.compile(r"'")
dq = re.compile(r'""')
ex = re.compile(r"!")
colon = re.compile(r":")
semicolon = re.compile(r";")
question = re.compile(r"\?")

parser = argparse.ArgumentParser()
parser.add_argument("filename")

args = parser.parse_args()

# load tags
audiofile = eyed3.load(args.filename)
# prefer f-strings over percent-format
track_num = f"{audiofile.tag.track_num[0]:02d}"
disc_num = f"{audiofile.tag.disc_num[0]:02d}"
# print(disc_num)
title = us.sub("_", audiofile.tag.title)
title = sq.sub("", title)
title = dq.sub("", title)
title = ex.sub("", title)
title = colon.sub("", title)
title = semicolon.sub("", title)
title = question.sub("", title)
print(f"{track_num}-{title}.mp3")
new_filename = f"{track_num}-{title}.mp3"
os.rename(args.filename, new_filename)
