#!/usr/bin/env python

import os, glob
from distutils.core import setup

data_files=[
	('lib/devede',			glob.glob('devede_*.py')),
    ('share/devede',        ['devede.glade']),
	('share/devede',		glob.glob('pixmaps/*.png')),
    ('share/applications',  ['devede.desktop']),
    ('share/pixmaps',       ['devede.png']),
    ('share/doc/@PF@/html', glob.glob('docs/*'))
	]

for po_file in glob.glob('po/*.po'):
	lang = os.path.basename(po_file[:-3])
	mo_dir = 'share/locale/%s/LC_MESSAGES' % lang
	mo_file = mo_dir + '/devede.mo'
	if not os.path.isdir(mo_dir):
		os.makedirs(mo_dir)
		os.system('msgfmt %s -o %s' % (po_file, mo_file))
	data_files.append((mo_dir, [mo_file]))

setup(name='DeVeDe',
    version='@PV@',
    description='A program to create video DVD suitable for home DVD players',
    url='http://www.rastersoft.com/programas/devede.html',
    scripts = ['devede'],
	data_files = data_files
    )
