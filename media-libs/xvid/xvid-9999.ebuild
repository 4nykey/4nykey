# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/xvid/xvid-1.0.1.ebuild,v 1.6 2004/07/29 03:34:28 tgall Exp $

EAPI=4

inherit autotools subversion

DESCRIPTION="high performance/quality MPEG-4 video de-/encoding solution"
HOMEPAGE="http://www.xvid.org/"
ESVN_REPO_URI="http://svn.xvid.org/trunk/xvidcore"
ESVN_USER="anonymous"
ESVN_PATCHES="${PN}-*.patch"
#S="${WORKDIR}/build/generic"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc examples +threads"

DEPEND="
	|| ( dev-lang/yasm dev-lang/nasm )
"

src_prepare() {
	subversion_bootstrap
	cd "${S}"/build/generic
	eautoreconf
	automake --add-missing --copy > /dev/null 2>&1
}

src_configure() {
	cd "${S}"/build/generic
	econf $(use_enable threads pthread)
}

src_compile() {
	emake -C "${S}"/build/generic || die
	use examples && emake -C "${S}"/examples || die
}

src_install() {
	emake DESTDIR="${D}" -C "${S}"/build/generic install || die
	dodoc AUTHORS ChangeLog* CodingStyle README TODO

	use examples && dobin examples/xvid_{encraw,decraw,bench}

	if use doc; then
		dodoc CodingStyle doc/README
		insinto /usr/share/doc/${PF}/examples
		doins -r examples
	fi
}
