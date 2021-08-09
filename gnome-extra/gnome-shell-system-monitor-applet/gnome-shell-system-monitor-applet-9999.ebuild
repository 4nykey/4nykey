# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PLOCALES="
ar ca cs de es_ES es_MX fa fi fr it ja pl pt pt_BR ro ru sk uk zh_CN
"

inherit gnome2-utils plocale
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/paradoxxxzero/${PN}.git"
	SRC_URI=""
else
	MY_PV="35d3351"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/paradoxxxzero/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="An extension for displaying sensors information in GNOME Shell"
HOMEPAGE="https://github.com/paradoxxxzero/gnome-shell-system-monitor-applet"

LICENSE="GPL-3"
SLOT="0"
IUSE="nls"

DEPEND="
	app-eselect/eselect-gnome-shell-extensions
"
RDEPEND="
	${DEPEND}
	gnome-base/gnome-shell
	media-libs/clutter[introspection]
	gnome-base/libgtop[introspection]
	net-misc/networkmanager[introspection]
"
DEPEND="
	${DEPEND}
"
BDEPEND="
	nls? ( sys-devel/gettext )
"

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/gssma-makefile.diff
	)
	sed -e '/UUID)\/README/d' -i Makefile
	default
	rm -rf system-monitor@paradoxxx.zero.gmail.com/locale
	if use nls; then
		my_loc() { rm -rf po/${1}; }
		plocale_for_each_disabled_locale my_loc
	else
		sed \
			-e '/build:/s,translate,,' \
			-e '/usr\/share\/locale/d' \
			-i Makefile
	fi
	MAKEOPTS="${MAKEOPTS} BUILD_FOR_RPM=1"
}

src_compile() {
	local myemakeargs=( V=1 )
	[[ -n ${PV%%*9999} ]] && myemakeargs+=( VERSION="${PV%_p*}" )
	emake "${myemakeargs[@]}" build
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
