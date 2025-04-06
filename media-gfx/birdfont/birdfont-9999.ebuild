# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
PLOCALES="
cs de el es fi fr he id it nb nl oc pl pt pt_BR ru sk sr sv tr uk
"
inherit python-any-r1 vala plocale toolchain-funcs xdg
if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/johanmattssonm/${PN}.git"
	inherit git-r3
else
	MY_PV="3d8d358"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/johanmattssonm/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="A font editor which can generate fonts in TTF, EOT, SVG and BF format"
HOMEPAGE="https://birdfont.org"

LICENSE="GPL-3"
SLOT="0"
IUSE="nls"

RDEPEND="
	dev-libs/xmlbird
	dev-libs/libgee:0.8=
	dev-libs/glib:2
	dev-db/sqlite:3
	media-libs/fontconfig
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	net-libs/webkit-gtk:4.1
	net-libs/libsoup:3.0
	x11-libs/libnotify
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
	$(vala_depend)
	nls? ( sys-devel/gettext )
"

pkg_setup() {
	vala_setup
	python-any-r1_pkg_setup
}

src_prepare() {
	rmloc() {
		rm -f "${S}"/po/${1}.po
	}
	default
	plocale_for_each_disabled_locale rmloc
	sed \
		-e 's:freetype-config --libs:{pkg-config} --libs freetype2:' \
		-e '/webkit2gtk-/s:4\.0:4.1:' \
		-e '/libsoup-/s:2\.4:3.0:' \
		-i configure dodo.py
	sed \
		-e '/action="quit"/s:key="" ctrl="false:key="q" ctrl="true:' \
		-i resources/key_bindings.xml
}

src_configure() {
	"${PYTHON}" ./configure \
		--prefix="${EPREFIX}/usr" \
		--cc="$(tc-getCC)" \
		--pkg-config="$(tc-getPKG_CONFIG)" \
		--gee=gee-0.8 \
		--valac="${VALAC}" \
		--cflags="${CFLAGS} ${CPPFLAGS}" \
		--ldflags="${LDFLAGS}" \
		|| die
}

src_compile() {
	use nls || declare -x LINGUAS=''
	"${PYTHON}" ./build.py || die
}

src_install() {
	"${PYTHON}" ./install.py \
		--dest="${ED}" \
		--nogzip=1 \
		--libdir="/$(get_libdir)" \
		--manpages-directory="/share/man/man1" \
		|| die
	einstalldocs
}
