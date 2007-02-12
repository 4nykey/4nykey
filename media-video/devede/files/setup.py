#!/usr/bin/env python

import os
from glob import glob
from distutils.core import setup

name='DeVeDe'
data_files=[
    ('share/devede', ['devede.glade','devedesans.ttf']+glob('pixmaps/*.png')),
    ('share/applications',  ['devede.desktop']),
    ('share/pixmaps',       ['devede.png']),
    ('share/doc/@PF@/html', glob('docs/*'))
    ]

for mo_file in glob('po/*.mo'):
    lang = os.path.basename(mo_file[:-3])
    mo_dir = 'share/locale/%s/LC_MESSAGES' % lang
    data_files.append((mo_dir, [mo_file]))

setup(name=name,
    version='@PV@',
    description='A program to create video DVD suitable for home DVD players',
    url='http://www.rastersoft.com/programas/devede.html',
    packages=[name],
    scripts = ['devede'],
    data_files = data_files
    )
