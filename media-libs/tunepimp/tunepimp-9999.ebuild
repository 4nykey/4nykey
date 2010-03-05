# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/tunepimp/tunepimp-0.5.3-r2.ebuild,v 1.10 2010/01/22 00:26:27 abcd Exp $

EAPI=2
inherit autotools distutils subversion

DESCRIPTION="TunePimp is a library to create MusicBrainz enabled tagging applications."
HOMEPAGE="http://www.musicbrainz.org/products/tunepimp"
ESVN_REPO_URI="http://svn.musicbrainz.org/libtunepimp/trunk"
#ESVN_PATCHES="${PN}-*.patch"
ESVN_BOOTSTRAP="eautoreconf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python flac mad musepack mp4 vorbis taglib"

RDEPEND="
	sys-libs/zlib
	dev-libs/expat
	net-misc/curl
	media-libs/libofa
	media-libs/musicbrainz:1
	taglib? (
		media-libs/taglib
		musepack? ( media-libs/libmpcdec )
	)
	mp4? ( media-libs/libmp4v2 )
	mad? ( media-libs/libmad )
	vorbis? ( media-libs/libvorbis )
	flac? ( media-libs/flac )
"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-*.patch

	# Don't hardcode ".so", use get_modname instead
	sed -e "s|.so \$(top_srcdir)|$(get_modname) \$(top_srcdir)|g" \
		-i plugins/*/Makefile.*

	subversion_src_prepare
}

src_compile() {
	default
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README TODO

	if use python; then
		cd python
		distutils_src_install
		insinto /usr/share/doc/${PF}/examples
		doins examples/* || die "doins failed"
	fi
}
