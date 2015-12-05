# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PLOCALES="
cs fr ru sk uk zh_CN zh_TW
"
inherit l10n cmake-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit subversion
	ESVN_REPO_URI="svn://svn.code.sf.net/p/sdcv/code/trunk"
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
	use nls && l10n_for_each_disabled_locale_do rmloc
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with readline)
		$(cmake-utils_use_enable nls)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile all $(usex nls 'lang' '')
}
