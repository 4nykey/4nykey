# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cargo xdg
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/daa84/${PN}.git"
else
	MY_PV="48f7181"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	CRATES="
	aho-corasick-0.6.6
	atk-sys-0.7.0
	atty-0.2.11
	bitflags-1.0.3
	byteorder-1.2.4
	cairo-rs-0.5.0
	cairo-sys-rs-0.7.0
	cc-1.0.18
	cfg-if-0.1.4
	dirs-1.0.3
	dtoa-0.4.3
	env_logger-0.5.12
	fragile-0.3.0
	fuchsia-zircon-0.3.3
	fuchsia-zircon-sys-0.3.3
	gdk-0.9.0
	gdk-pixbuf-0.5.0
	gdk-pixbuf-sys-0.7.0
	gdk-sys-0.7.0
	gio-0.5.0
	gio-sys-0.7.0
	glib-0.6.0
	glib-sys-0.7.0
	gobject-sys-0.7.0
	gtk-0.5.0
	gtk-sys-0.7.0
	htmlescape-0.3.1
	humantime-1.1.1
	itoa-0.4.2
	lazy_static-1.1.0
	libc-0.2.43
	log-0.4.3
	memchr-2.0.1
	neovim-lib-0.5.4
	num-traits-0.1.43
	num-traits-0.2.5
	pango-0.5.0
	pango-sys-0.7.0
	pangocairo-0.6.0
	pangocairo-sys-0.8.0
	percent-encoding-1.0.1
	phf-0.7.22
	phf_codegen-0.7.22
	phf_generator-0.7.22
	phf_shared-0.7.22
	pkg-config-0.3.13
	proc-macro2-0.4.9
	quick-error-1.2.2
	quote-0.6.5
	rand-0.4.2
	redox_syscall-0.1.40
	redox_termios-0.1.1
	regex-1.0.2
	regex-syntax-0.6.2
	rmp-0.8.7
	rmpv-0.4.0
	serde-1.0.71
	serde_bytes-0.10.4
	serde_derive-1.0.71
	serde_json-1.0.24
	siphasher-0.2.3
	syn-0.14.7
	termcolor-1.0.1
	termion-1.5.1
	thread_local-0.3.5
	toml-0.4.6
	ucd-util-0.1.1
	unicode-segmentation-1.2.1
	unicode-width-0.1.5
	unicode-xid-0.1.0
	unix-daemonize-0.1.2
	unix_socket-0.5.0
	unreachable-1.0.0
	utf8-ranges-1.0.0
	version_check-0.1.4
	void-1.0.2
	winapi-0.3.5
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
	wincolor-1.0.0
	"
	SRC_URI="
		mirror://githubcl/daa84/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		$(cargo_crate_uris ${CRATES})
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="GTK ui for neovim written in rust using gtk-rs bindings"
HOMEPAGE="https://github.com/daa84/${PN}"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	x11-libs/gtk+:3
"
RDEPEND="
	${DEPEND}
	>=app-editors/neovim-0.2.2
"

src_prepare() {
	default
	sed \
		-e '/\(fonts\|fc-cache\|\<sed\>\)/d' \
		-i Makefile
}

src_install() {
	cargo_src_install
	emake install-resources PREFIX="${ED}/usr"
	einstalldocs
}
