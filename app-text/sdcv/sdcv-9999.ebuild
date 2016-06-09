# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PLOCALES="
cs fr ru sk uk zh_CN zh_TW
"
inherit l10n cmake-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Dushistov/${PN}.git"
else
	inherit vcs-snapshot
	SRC_URI="
		mirror://sourceforge/${PN}/${P/_beta/-beta}-Source.tar.bz2
		-> ${P}.tar.bz2
	"
	KEYWORDS="~x86 ~amd64"
fi

DESCRIPTION="sdcv - console version of StarDict program"
HOMEPAGE="http://sdcv.sourceforge.net"

LICENSE="GPL-2"
SLOT="0"
IUSE="readline nls"

RDEPEND="
	sys-libs/zlib
	>=dev-libs/glib-2.6.1
	readline? ( sys-libs/readline )
"
DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
"

CMAKE_IN_SOURCE_BUILD=1
DOCS="AUTHORS NEWS README* doc/DICTFILE_FORMAT"

rmloc() {
	rm -f "${S}"/po/${1}.po
}

src_prepare() {
	default
	use nls && l10n_for_each_disabled_locale_do rmloc
}

src_configure() {
	local mycmakeargs=(
		-DWITH_READLINE=$(usex readline)
		-DENABLE_NLS=$(usex nls)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile all $(usex nls 'lang' '')
}
