# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools gnome2-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/jenslody/${PN}.git"
	SRC_URI=""
else
	inherit vcs-snapshot
	KEYWORDS="~amd64 ~x86"
	MY_PV="7ea4ce7"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		https://gitlab.com/jenslody/${PN}/-/archive/${MY_PV}/${PN}-${MY_PV}.tar.bz2
		-> ${P}.tar.bz2
	"
	RESTRICT="primaryuri"
fi

DESCRIPTION="An extension for displaying weather informations in GNOME Shell"
HOMEPAGE="https://github.com/jenslody/${PN}"

LICENSE="GPL-3+"
SLOT="0"
IUSE="nls"

DEPEND="
	app-eselect/eselect-gnome-shell-extensions
"
RDEPEND="
	${DEPEND}
	gnome-base/gnome-shell
"
BDEPEND="
	nls? ( sys-devel/gettext )
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local _v=$(sed -e '/^\(Version\|Release\):/!d; s:[^0-9.]::g' \
		"${S}"/${PN}.spec |tr '\n' '.')
	_v=${_v%..}
	if [[ -z ${PV%%*9999} ]]; then
		_v=${_v}.$(git rev-parse --short HEAD)
	elif [[ -z ${PV%%*_p*} ]]; then
		_v=${_v}.${MY_PV}
	fi
	econf \
		$(use_enable nls) \
		GIT_VERSION=${_v:-${PV}}
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}

pkg_postrm() {
	gnome2_schemas_update
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}
