# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/vorbis-tools/vorbis-tools-1.0.1.ebuild,v 1.22 2005/05/15 02:16:11 flameeyes Exp $

IUSE="nls flac speex"

inherit toolchain-funcs flag-o-matic subversion

DESCRIPTION="tools for using the Ogg Vorbis sound file format"
HOMEPAGE="http://www.xiph.org/ogg/vorbis/index.html"
#SRC_URI="http://www.vorbis.com/files/${PV}/unix/${P}.tar.gz"
ESVN_REPO_URI="http://svn.xiph.org/trunk/vorbis-tools"
ESVN_PATCHES="*.diff"
ESVN_BOOTSTRAP="WANT_AUTOMAKE=1.7 ./autogen.sh"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"

RDEPEND=">=media-libs/libvorbis-1.0
	>=media-libs/libao-0.8.2
	>=net-misc/curl-7.9
	!mips? ( speex? ( media-libs/speex ) )
	flac? ( media-libs/flac )"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_compile() {
	use hppa && [ "`gcc-fullversion`" == "3.3.2" ] && replace-flags -march=2.0 -march=1.0
	use ppc-macos && use speex && append-flags -I/usr/include/speex
	local myconf

	# --with-{flac,speex} is not supported.  See bug #49763
	use flac || myconf="${myconf} --without-flac"
	if ! use mips; then
		use speex || myconf="${myconf} --without-speex"
	fi

	econf \
		`use_enable nls` \
		${myconf} || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die

	rm -rf ${D}/usr/share/doc
	dodoc AUTHORS README
	docinto ogg123
	dodoc ogg123/ogg123rc-example
}
