# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/xvid/xvid-1.0.1.ebuild,v 1.6 2004/07/29 03:34:28 tgall Exp $

EAPI=4

inherit subversion autotools-utils

DESCRIPTION="high performance/quality MPEG-4 video de-/encoding solution"
HOMEPAGE="http://www.xvid.org/"
ESVN_REPO_URI="http://svn.xvid.org/trunk/xvidcore"
ESVN_USER="anonymous"
ESVN_PASSWORD=""
ESVN_OPTIONS="--non-interactive"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc examples +threads"

AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"
ECONF_SOURCE="${S}/build/generic"

DEPEND="
	|| ( dev-lang/yasm dev-lang/nasm )
"

src_prepare() {
	cd "${S}"/build/generic
	autotools-utils_src_prepare
	automake --add-missing --copy > /dev/null 2>&1
}

src_configure() {
	local myeconfargs=(
		$(use_enable threads pthread)
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	use examples && emake -C "${S}"/examples || die
}

src_install() {
	autotools-utils_src_install

	use examples && dobin examples/xvid_{encraw,decraw,bench}

	if use doc; then
		dodoc CodingStyle doc/README
		insinto /usr/share/doc/${PF}/examples
		doins -r examples
	fi
}
