# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools subversion

DESCRIPTION="WavPack hybrid audio compression"
HOMEPAGE="http://www.wavpack.com/"
ESVN_REPO_URI="http://svn.slomosnail.de/wavpack/trunk"
ESVN_BOOTSTRAP="eautoreconf"
ESVN_PATCHES="${P}*.diff"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="mmx doc"

RDEPEND="
	virtual/libiconv
"
DEPEND="
	${RDEPEND}
	doc? ( dev-libs/libxslt app-text/docbook-xml-dtd:4.1.2 )
"

src_configure() {
	econf \
		$(use_enable mmx) \
		$(use_enable doc man)
}

src_install() {
	einstall || die
	if use doc; then
		dodoc doc/*.txt
		dohtml -r doc/
	fi
}
