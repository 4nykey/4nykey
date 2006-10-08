# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/flac/flac-1.1.2-r5.ebuild,v 1.2 2006/05/28 02:16:10 flameeyes Exp $

inherit libtool cvs autotools toolchain-funcs

DESCRIPTION="free lossless audio encoder which includes an XMMS plugin"
HOMEPAGE="http://flac.sourceforge.net/"
ECVS_SERVER="flac.cvs.sourceforge.net:/cvsroot/flac"
ECVS_MODULE="flac"
S="${WORKDIR}/${ECVS_MODULE}"
RESTRICT="test" # see #59482

LICENSE="GPL-2 LGPL-2"
SLOT="1.1.3"
KEYWORDS="-*"
IUSE="3dnow debug doc ogg sse xmms pic"

RDEPEND="ogg? ( >=media-libs/libogg-1.0_rc2 )
	xmms? ( media-sound/xmms )"
DEPEND="${RDEPEND}
	x86? ( dev-lang/nasm )
	sys-apps/gawk
	doc? ( app-doc/doxygen )
	dev-util/pkgconfig"

src_unpack() {
	cvs_src_unpack
	cd "${S}"

if false; then
	# Enable only for GCC 4.1 and later
	[[ $(gcc-major-version)$(gcc-minor-version) -ge 41 ]] || \
		export EPATCH_EXCLUDE="130_all_visibility.patch"

	sed -i 's:-O. ::' configure.in # 080_all_noextraflags.patch
	EPATCH_SUFFIX="patch" epatch "${FILESDIR}"
	AT_M4DIR="m4" eautoreconf
	elibtoolize
else
	sed -i "s:-O3.*-finline-functions:${CFLAGS}:" build/{lib,exe}.mk
fi
}

src_compile() {
if false; then
	econf \
		$(use_enable ogg) \
		$(use_enable sse) \
		$(use_enable 3dnow) \
		$(use_enable debug) \
		$(use_enable doc) $(use_enable doc doxygen-docs) \
		$(use_with pic) \
		--disable-thorough-tests \
		--disable-dependency-tracking || die

	# the man page ebuild requires docbook2man... yick!
	sed -i -e 's:include man:include:g' Makefile

	# FIXME parallel make seems to mess up the building of the xmms input plugin
	local makeopts
	use xmms && makeopts="-j1"

	emake ${makeopts} || die "make failed"
else
	CFG="$(use debug && echo debug || echo release)"
	make CONFIG=${CFG} -f Makefile.lite flac metaflac
fi
}

src_install() {
if false; then
	make DESTDIR="${D}" docdir="/usr/share/doc/${PF}" \
		install || die "make install failed"
else
	dobin obj/${CFG}/bin/{,meta}flac
fi
	dodoc AUTHORS README

	doman man/{flac,metaflac}.1
}

pkg_postinst() {
if false; then
	ewarn "If you've upgraded from a previous version of flac, you may need to re-emerge"
	ewarn "packages that linked against flac by running:"
	ewarn "revdep-rebuild"
else
	elog "To prevent massive breakage we're installing binaries only for now"
fi
}
