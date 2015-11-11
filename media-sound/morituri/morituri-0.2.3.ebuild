# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=(python2_7)
WANT_AUTOMAKE="1.8"
AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"

inherit bash-completion-r1 python-single-r1 autotools-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/thomasvs/morituri.git"
	RESTRICT="primaryuri"
else
	inherit vcs-snapshot
	SRC_URI="
		mirror://githubcl/thomasvs/${PN}/tar.gz/v${PV} -> ${P}.tar.gz
		mirror://githubcl/thomasvs/python-command/tar.gz/4c31072e9f5f68e22c92cdc8f0a02d911b7e5fc0
		-> python-command.tar.gz
		mirror://githubcl/thomasvs/python-deps/tar.gz/48b505ab5a10037d50d03311f15f8a3a8aab75ed
		-> python-deps.tar.gz
		mirror://githubcl/Flumotion/flog/tar.gz/f1cb3815e5e8c47385fe1ded2542b151a8cf8fc5
		-> flog.tar.gz
		mirror://githubcl/thomasvs/python-musicbrainz-ngs/tar.gz/4260ed51273babb909a27fe07d68923158d2e9ec
		-> python-musicbrainz-ngs.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="morituri is a CD ripper aiming for accuracy over speed"
HOMEPAGE="http://thomas.apestaart.org/morituri/trac"

LICENSE="GPL-3"
SLOT="0"
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

src_prepare() {
	if [[ -n ${PV%%*9999} ]]; then
		mv -f \
			"${WORKDIR}"/{flog,python-command,python-deps,python-musicbrainz-ngs} \
			"${S}"/${PN}/extern
	fi
	autotools-utils_src_prepare
}

src_configure() {
	ac_cv_prog_EPYDOC="" \
	ac_cv_path_PYTHON="${EPYTHON}" \
		autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	use doc && \
		GST_REGISTRY="${T}/registry.xml" epydoc -o doc/reference morituri
}

src_install() {
	use doc && local HTML_DOCS=(doc/reference/)
	autotools-utils_src_install

	rm -r "${D}"/etc
	dobashcomp etc/bash_completion.d/rip
}
