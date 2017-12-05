# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
PLOCALES="
cs de el es fi fr he id it nb nl oc pl pt pt_BR ru sk sr sv tr uk
"
inherit python-any-r1 vala l10n toolchain-funcs xdg-utils
if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/johanmattssonm/${PN}.git"
	inherit git-r3
else
	inherit vcs-snapshot
	SRC_URI="
		mirror://githubcl/johanmattssonm/${PN}/tar.gz/v${PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A font editor which can generate fonts in TTF, EOT, SVG and BF format"
HOMEPAGE="https://birdfont.org"

LICENSE="GPL-3"
SLOT="0"
IUSE="+gtk nls"

RDEPEND="
	dev-libs/xmlbird
	dev-libs/libgee:0.8=
	dev-libs/glib:2
	dev-db/sqlite:3
	media-libs/fontconfig
	gtk? (
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3
		net-libs/webkit-gtk:4
		net-libs/libsoup:2.4
		x11-libs/libnotify
	)
"
DEPEND="
	${RDEPEND}
	${PYTHON_DEPS}
	$(vala_depend)
	nls? ( sys-devel/gettext )
"
PATCHES=(
	"${FILESDIR}"/${PN}-build.diff
	"${FILESDIR}"/${PN}-dialqforquit.diff
)

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	default
	vala_src_prepare
}

src_configure() {
	"${PYTHON}" ./configure \
		--prefix="${EPREFIX}/usr" \
		--cc="$(tc-getCC)" \
		--pkg-config="$(tc-getPKG_CONFIG)" \
		--gtk=$(usex gtk True False) \
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
		--dest="${D}" \
		--nogzip=1 \
		--libdir="/$(get_libdir)" \
		--manpages-directory="/share/man/man1" \
		--skip-command-line-tools=$(usex gtk '0' '1') \
		|| die
	einstalldocs
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
