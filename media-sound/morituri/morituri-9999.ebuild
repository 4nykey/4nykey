# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT="python2_7"
WANT_AUTOMAKE="1.8"
EGIT_HAS_SUBMODULES="y"
AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"

inherit bash-completion-r1 python-single-r1 git-2 autotools-utils

DESCRIPTION="morituri is a CD ripper aiming for accuracy over speed"
HOMEPAGE="http://thomas.apestaart.org/morituri/trac"
EGIT_REPO_URI="git://github.com/thomasvs/morituri.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alac doc flac mp3 test vorbis wavpack"

RDEPEND="
	dev-python/pygobject
	dev-python/gst-python
	media-sound/cdparanoia
	app-cdr/cdrdao
	media-libs/gst-plugins-good
	dev-python/python-musicbrainz
	>=dev-python/pycdio-0.19
	dev-python/pyxdg
	dev-python/cddb-py
	alac? ( media-plugins/gst-plugins-ffmpeg )
	flac? ( media-plugins/gst-plugins-flac )
	mp3? ( media-plugins/gst-plugins-lame )
	vorbis? ( media-plugins/gst-plugins-vorbis )
	wavpack? ( media-plugins/gst-plugins-wavpack )
"
DEPEND="
	dev-python/setuptools
	doc? ( dev-python/epydoc )
	test? ( dev-python/pychecker )
"

src_configure() {
	ac_cv_prog_EPYDOC="" \
	ac_cv_path_PYTHON="${PYTHON}" \
		autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	use doc && GST_REGISTRY="${T}/registry.xml" epydoc -o doc/reference morituri
}

src_install() {
	use doc && local HTML_DOCS=(doc/reference/)
	autotools-utils_src_install

	rm -r "${D}"/etc
	dobashcomp etc/bash_completion.d/rip
}
