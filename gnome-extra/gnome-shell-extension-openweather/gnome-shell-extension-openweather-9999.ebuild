# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils gnome2
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jenslody/${PN}.git"
	SRC_URI=""
else
	inherit vcs-snapshot
	KEYWORDS="~amd64 ~x86"
	SRC_URI="
		mirror://githubcl/jenslody/${PN}/tar.gz/v${PV} -> ${P}.tar.gz
	"
fi

DESCRIPTION="An extension for displaying weather informations in GNOME Shell"
HOMEPAGE="https://github.com/jenslody/gnome-shell-extension-openweather"

LICENSE="GPL-3+ BSD"
SLOT="0"
IUSE=""

HDEPEND="
	app-eselect/eselect-gnome-shell-extensions
"
BDEPEND="
	${RDEPEND}
"
AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

src_prepare() {
	autotools-utils_src_prepare
	gnome2_src_prepare
}

src_configure() {
	if [[ -z ${PV%%*9999} ]]; then
		local _v=$(
		sed -e '/^\(Version\|Release\):/!d; s:[^0-9.]::g' \
			"${S}"/gnome-shell-extension-openweather.spec |tr '\n' '.'
		)
		_v=${_v%.*}$(git log -1 --pretty=format:"%h")
	fi
	local myeconfargs=(
		GIT_VERSION=${_v:-${PV}}
	)
	autotools-utils_src_configure
}

pkg_postinst() {
	gnome2_pkg_postinst

	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}

pkg_postrm() {
	gnome2_pkg_postrm
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}
