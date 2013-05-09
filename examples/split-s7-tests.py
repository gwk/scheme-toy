#!/usr/bin/env py3

import sys
import re

source = sys.stdin.read()

r = re.compile(';;;; (.+?)\n')

parts = r.split(source)

names = set()

for n, s in zip(parts[1::2], parts[2::2]):
  name = 's7-test_' + n.strip().replace('/', 'slash').replace('*', '_star').replace('!', '_bang') + '.scm'
  if name in names:
    print('DUPLICATE:', name)
    sys.exit(1)
  names.add(name)
  print(name)
  print(s.strip()[:64], '...\n')

  with open(name, 'w') as f:
    f.write(s.strip())
    f.write('\n')

