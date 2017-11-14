boost: LIBS += -lboost_serialization
shiboken {
	PKGCONFIG -= shiboken
	PKGCONFIG += shiboken-python2.7
}
pyside {
	PKGCONFIG -= pyside
	PKGCONFIG += pyside-python2.7
	INCLUDEPATH += $$system(@PKGCONFIG@ --variable=includedir pyside-python2.7)/QtCore
	INCLUDEPATH += $$system(@PKGCONFIG@ --variable=includedir pyside-python2.7)/QtGui
}
CONFIG(notests) {
	SUBDIRS -= Tests
}
