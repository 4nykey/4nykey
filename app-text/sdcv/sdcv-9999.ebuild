# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PLOCALES="
cs fr ru sk uk zh_CN zh_TW
"
inherit subversion l10n cmake-utils

DESCRIPTION="sdcv - console version of StarDict program"
HOMEPAGE="http://sdcv.sourceforge.net"
ESVN_REPO_URI="https://sdcv.svn.sourceforge.net/svnroot/sdcv/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
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
	rm -rf "${D}"/usr/share/locale/${1}
}

src_configure() {
	local mycmakeargs="
		$(cmake-utils_use_with readline)
		$(cmake-utils_use_enable nls)
	"
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile all $(use nls && echo lang)
}

src_install() {
	cmake-utils_src_install
	use nls && l10n_for_each_disabled_locale_do rmloc
}
