import fontforge
from sys import argv

for i in range(1, len(argv)):
	f = fontforge.open(argv[i])
	otfile = f.familyname + '-' + f.weight + '.otf'
	print 'Generating', otfile
	f.encoding = 'UnicodeFull'
	f.selection.all()
	f.autoHint()
	f.generate(otfile, flags=('opentype','old-kern','round'))
	f.close()
