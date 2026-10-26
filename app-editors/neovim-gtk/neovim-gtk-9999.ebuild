# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER=1.92
CRATES="
	aho-corasick@1.1.5
	anstream@1.0.0
	anstyle-parse@1.0.0
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.14
	async-trait@0.1.92
	autocfg@1.5.1
	bitflags@1.3.2
	bitflags@2.13.2
	bstr@1.13.1
	build-version@0.1.1
	byteorder@1.5.0
	bytes@0.4.12
	bytes@1.12.1
	cairo-rs@0.22.9
	cairo-sys-rs@0.22.9
	cfg-expr@0.20.9
	cfg-if@1.0.5
	clap@4.6.7
	clap_builder@4.6.7
	clap_derive@4.6.7
	clap_lex@1.1.1
	colorchoice@1.0.5
	content_inspector@0.2.4
	crossbeam-deque@0.8.8
	crossbeam-epoch@0.9.21
	crossbeam-utils@0.8.23
	defmt-macros@1.1.1
	defmt-parser@1.0.0
	defmt@1.1.1
	dunce@1.0.5
	either@1.18.0
	env_filter@2.0.0
	env_logger@0.11.11
	equivalent@1.0.2
	errno@0.3.14
	fastrand@2.5.0
	field-offset@0.3.6
	filetime@0.2.29
	fnv@1.0.7
	fork@0.8.0
	futures-channel@0.3.34
	futures-core@0.3.34
	futures-executor@0.3.34
	futures-io@0.3.34
	futures-macro@0.3.34
	futures-sink@0.3.34
	futures-task@0.3.34
	futures-util@0.3.34
	futures@0.1.31
	futures@0.3.34
	gdk-pixbuf-sys@0.22.9
	gdk-pixbuf@0.22.0
	gdk4-sys@0.11.5
	gdk4@0.11.5
	gio-sys@0.22.9
	gio@0.22.10
	glib-macros@0.22.9
	glib-sys@0.22.9
	glib@0.22.10
	glob@0.3.4
	gobject-sys@0.22.9
	graphene-rs@0.22.8
	graphene-sys@0.22.9
	gsk4-sys@0.11.5
	gsk4@0.11.5
	gtk4-macros@0.11.5
	gtk4-sys@0.11.5
	gtk4@0.11.5
	hashbrown@0.15.5
	hashbrown@0.17.1
	heck@0.5.0
	hermit-abi@0.5.3
	html-escape@0.2.15
	humantime-serde@1.1.1
	humantime@2.4.0
	indexmap@2.14.2
	iovec@0.1.4
	is-terminal@0.4.17
	is_terminal_polyfill@1.70.2
	itoa@1.0.18
	jiff-core@0.1.1
	jiff-static@0.2.37
	jiff@0.2.37
	libc@0.2.189
	linux-raw-sys@0.12.1
	lock_api@0.4.14
	log@0.4.34
	memchr@2.8.3
	memoffset@0.9.1
	mio@1.2.3
	normalize-line-endings@0.3.0
	num-traits@0.2.19
	nvim-rs@0.9.2
	once_cell@1.21.4
	once_cell_polyfill@1.70.2
	os_pipe@1.2.3
	pango-sys@0.22.9
	pango@0.22.9
	parking_lot@0.12.5
	parking_lot_core@0.9.12
	percent-encoding@2.3.2
	phf@0.14.0
	phf_codegen@0.14.0
	phf_generator@0.14.0
	phf_shared@0.14.0
	pin-project-lite@0.2.17
	pkg-config@0.3.34
	portable-atomic-util@0.2.8
	portable-atomic@1.15.0
	proc-macro-crate@3.5.0
	proc-macro2@1.0.107
	quick-error@1.2.3
	quote@1.0.47
	rayon-core@1.13.0
	rayon@1.12.0
	redox_syscall@0.5.18
	regex-automata@0.4.18
	regex-syntax@0.8.11
	regex@1.13.1
	rmp@0.8.15
	rmpv@1.3.1
	rustc_version@0.4.1
	rustix@1.1.5
	same-file@1.0.6
	scopeguard@1.2.0
	semver@1.0.28
	serde@1.0.229
	serde_bytes@0.11.19
	serde_core@1.0.229
	serde_derive@1.0.229
	serde_json@1.0.151
	serde_spanned@1.1.1
	shlex@1.3.0
	signal-hook-registry@1.4.8
	similar@3.2.0
	siphasher@1.0.3
	slab@0.4.12
	smallvec@1.16.2
	snapbox-macros@1.1.0
	snapbox@1.2.2
	socket2@0.6.5
	strsim@0.11.1
	syn@2.0.119
	syn@3.0.6
	system-deps@9.0.0
	target-lexicon@0.13.5
	tempfile@3.27.0
	terminal_size@0.4.4
	thiserror-impl@2.0.21
	thiserror@2.0.21
	tokio-io@0.1.13
	tokio-macros@2.7.2
	tokio-util@0.7.19
	tokio@1.53.1
	toml@0.5.11
	toml@1.1.6+spec-1.1.0
	toml_datetime@1.1.1+spec-1.1.0
	toml_edit@0.25.15+spec-1.1.0
	toml_parser@1.1.3+spec-1.1.0
	toml_writer@1.1.2+spec-1.1.0
	trycmd@1.2.1
	unicode-ident@1.0.26
	unicode-segmentation@1.13.3
	unicode-width@0.2.2
	utf8parse@0.2.2
	version-compare@0.2.1
	wait-timeout@0.2.1
	walkdir@2.5.0
	wasi@0.11.1+wasi-snapshot-preview1
	winapi-util@0.1.11
	windows-link@0.2.1
	windows-sys@0.61.2
	winnow@1.0.4
	winres@0.1.12
	zmij@1.0.23
"
inherit cargo xdg
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Lyude/${PN}.git"
else
	MY_PV="a394e44"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/Lyude/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		${CARGO_CRATE_URIS}
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="GTK UI for neovim written in rust using gtk-rs bindings"
HOMEPAGE="https://github.com/Lyude/${PN}"

LICENSE="GPL-3"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD LGPL-3 LGPL-3+ MIT
	Unicode-3.0
"
SLOT="0"

DEPEND="
	gui-libs/gtk:4
"
RDEPEND="
	${DEPEND}
	app-editors/neovim
"

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_prepare() {
	default
	sed -e '/license = /s:GPLv3:GPL-3.0:' -i Cargo.toml
}

src_install() {
	dobin $(cargo_target_dir)/nvim-gtk
	emake install-resources DESTDIR="${D}" PREFIX="${EPREFIX}/usr"
	einstalldocs
}
