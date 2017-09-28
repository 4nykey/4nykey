# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="
cs fr ru sk uk zh_CN zh_TW
"
inherit l10n cmake-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dushistov/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="82a06b8"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/dushistov/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~x86 ~amd64"
	RESTRICT="primaryuri"
fi

DESCRIPTION="A console version of StarDict"
HOMEPAGE="https://dushistov.github.io/${PN}"

LICENSE="GPL-2"
SLOT="0"
IUSE="readline nls"

RDEPEND="
	sys-libs/zlib
	>=dev-libs/glib-2.6.1
	readline? ( sys-libs/readline:0 )
"
DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
"

CMAKE_IN_SOURCE_BUILD=1
DOCS=( AUTHORS NEWS README.org doc/DICTFILE_FORMAT )

rmloc() {
	rm -f "${S}"/po/${1}.po
}

src_prepare() {
	cmake-utils_src_prepare
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
