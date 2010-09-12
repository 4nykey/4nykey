# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/mutagen/mutagen-1.19.ebuild,v 1.1 2010/03/13 18:16:15 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils eutils

DESCRIPTION="Mutagen is an audio metadata tag reader and writer implemented in pure Python."
HOMEPAGE="http://code.google.com/p/mutagen http://pypi.python.org/pypi/mutagen"
SRC_URI="
http://mutagen.googlecode.com/files/${P}.tar.gz
http://mutagen.googlecode.com/issues/attachment?aid=3511520795503940074&name=mpc-sv8-v2.patch&token=0df4ed95fe9aff794f5b2e115016786b -> ${PN}-sv8.patch
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="
	test? (
		dev-python/eyeD3
		dev-python/pyvorbis
		media-libs/flac[ogg]
		media-sound/vorbis-tools
	)
"
RESTRICT_PYTHON_ABIS="3.*"

DOCS="API-NOTES NEWS README TODO TUTORIAL"

src_prepare() {
	epatch "${DISTDIR}"/${PN}-sv8.patch
	distutils_src_prepare
}
