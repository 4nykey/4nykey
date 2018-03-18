# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cargo xdg-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/daa84/${PN}.git"
else
	CRATES="
	aho-corasick-0.6.3
	atk-sys-0.3.3
	bitflags-0.4.0
	bitflags-0.5.0
	byteorder-1.0.0
	cairo-rs-0.1.2
	cairo-sys-rs-0.3.3
	cfg-if-0.1.0
	c_vec-1.2.0
	env_logger-0.4.2
	gdk-0.5.2
	gdk-pixbuf-0.1.2
	gdk-pixbuf-sys-0.3.3
	gdk-sys-0.3.3
	gio-0.1.2
	gio-sys-0.3.3
	glib-0.1.2
	glib-sys-0.3.3
	gobject-sys-0.3.3
	gtk-0.1.2
	gtk-sys-0.3.3
	kernel32-sys-0.2.2
	libc-0.2.21
	log-0.3.7
	memchr-1.0.1
	neovim-lib-0.3.0
	num-traits-0.1.37
	pango-0.1.2
	pangocairo-0.1.0
	pangocairo-sys-0.1.0
	pango-sys-0.3.3
	phf-0.7.21
	phf_codegen-0.7.21
	phf_generator-0.7.21
	phf_shared-0.7.21
	pkg-config-0.3.9
	rand-0.3.15
	regex-0.2.1
	regex-syntax-0.4.0
	rmp-0.8.5
	rmpv-0.3.4
	siphasher-0.2.2
	thread-id-3.0.0
	thread_local-0.3.3
	unix_socket-0.5.0
	unreachable-0.1.1
	utf8-ranges-1.0.0
	void-1.0.2
	winapi-0.2.8
	winapi-build-0.1.1
	"
	SRC_URI="
		mirror://githubcl/daa84/${PN}/tar.gz/v${PV} -> ${P}.tar.gz
		$(cargo_crate_uris ${CRATES})
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="GTK ui for neovim written in rust using gtk-rs bindings"
HOMEPAGE="https://github.com/daa84/${PN}"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	x11-libs/gtk+:3
	app-editors/neovim
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -e '/\(fonts\|fc-cache\)/d' -i Makefile
}

src_install() {
	cargo_src_install
	emake install-resources PREFIX="${ED}/usr"
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
