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
CONFIG(system-libs) {
	SUBDIRS -= ceres gflags glog hoedown
	PKGCONFIG += libglog gflags eigen3
	INCLUDEPATH += /usr/include/ceres /usr/include/ceres/internal /usr/include/hoedown
	LIBS += -lceres -lhoedown
}
