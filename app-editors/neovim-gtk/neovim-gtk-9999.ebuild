# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER=1.85
CRATES="
	aho-corasick@1.1.4
	anstream@0.6.21
	anstyle-parse@0.2.7
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.13
	async-trait@0.1.89
	autocfg@1.5.0
	automod@1.0.15
	bitflags@2.10.0
	build-version@0.1.1
	byteorder@1.5.0
	bytes@0.4.12
	bytes@1.11.0
	cairo-rs@0.21.5
	cairo-sys-rs@0.21.5
	cfg-expr@0.20.5
	cfg-if@1.0.4
	clap@4.5.53
	clap_builder@4.5.53
	clap_derive@4.5.49
	clap_lex@0.7.6
	colorchoice@1.0.4
	content_inspector@0.2.4
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	dunce@1.0.5
	either@1.15.0
	env_filter@0.1.4
	env_logger@0.11.8
	equivalent@1.0.2
	errno@0.3.14
	fastrand@2.3.0
	field-offset@0.3.6
	filetime@0.2.26
	fnv@1.0.7
	fork@0.6.0
	futures-channel@0.3.31
	futures-core@0.3.31
	futures-executor@0.3.31
	futures-io@0.3.31
	futures-macro@0.3.31
	futures-sink@0.3.31
	futures-task@0.3.31
	futures-util@0.3.31
	futures@0.1.31
	futures@0.3.31
	gdk-pixbuf-sys@0.21.5
	gdk-pixbuf@0.21.5
	gdk4-sys@0.10.3
	gdk4@0.10.3
	getrandom@0.3.4
	gio-sys@0.21.5
	gio@0.21.5
	glib-macros@0.21.5
	glib-sys@0.21.5
	glib@0.21.5
	glob@0.3.3
	gobject-sys@0.21.5
	graphene-rs@0.21.5
	graphene-sys@0.21.5
	gsk4-sys@0.10.3
	gsk4@0.10.3
	gtk4-macros@0.10.3
	gtk4-sys@0.10.3
	gtk4@0.10.3
	hashbrown@0.15.5
	hashbrown@0.16.1
	heck@0.5.0
	hermit-abi@0.5.2
	html-escape@0.2.13
	humantime-serde@1.1.1
	humantime@2.3.0
	indexmap@2.12.1
	iovec@0.1.4
	is-terminal@0.4.17
	is_terminal_polyfill@1.70.2
	itoa@1.0.15
	jiff-static@0.2.16
	jiff@0.2.16
	libc@0.2.178
	libredox@0.1.10
	linux-raw-sys@0.11.0
	lock_api@0.4.14
	log@0.4.29
	memchr@2.7.6
	memoffset@0.9.1
	mio@1.1.1
	normalize-line-endings@0.3.0
	num-traits@0.2.19
	num_cpus@1.17.0
	nvim-rs@0.9.2
	once_cell@1.21.3
	once_cell_polyfill@1.70.2
	os_pipe@1.2.3
	pango-sys@0.21.5
	pango@0.21.5
	parking_lot@0.12.5
	parking_lot_core@0.9.12
	paste@1.0.15
	percent-encoding@2.3.2
	phf@0.13.1
	phf_codegen@0.13.1
	phf_generator@0.13.1
	phf_shared@0.13.1
	pin-project-lite@0.2.16
	pin-utils@0.1.0
	pkg-config@0.3.32
	portable-atomic-util@0.2.4
	portable-atomic@1.11.1
	proc-macro-crate@3.4.0
	proc-macro2@1.0.103
	quick-error@1.2.3
	quote@1.0.42
	r-efi@5.3.0
	rayon-core@1.13.0
	rayon@1.11.0
	redox_syscall@0.5.18
	regex-automata@0.4.13
	regex-syntax@0.8.8
	regex@1.12.2
	rmp@0.8.14
	rmpv@1.3.0
	rustc_version@0.4.1
	rustix@1.1.2
	ryu@1.0.20
	same-file@1.0.6
	scopeguard@1.2.0
	semver@1.0.27
	serde@1.0.228
	serde_bytes@0.11.19
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.145
	serde_spanned@1.0.3
	shlex@1.3.0
	signal-hook-registry@1.4.7
	similar@2.7.0
	siphasher@1.0.1
	slab@0.4.11
	smallvec@1.15.1
	snapbox-macros@0.4.0
	snapbox@0.6.23
	socket2@0.6.1
	strsim@0.11.1
	syn@2.0.111
	system-deps@7.0.7
	target-lexicon@0.13.3
	tempfile@3.23.0
	terminal_size@0.4.3
	tokio-io@0.1.13
	tokio-macros@2.6.0
	tokio-util@0.7.17
	tokio@1.48.0
	toml@0.5.11
	toml@0.9.8
	toml_datetime@0.7.3
	toml_edit@0.23.9
	toml_parser@1.0.4
	toml_writer@1.0.4
	trycmd@0.15.11
	unicode-ident@1.0.22
	unicode-segmentation@1.12.0
	unicode-width@0.2.2
	utf8-width@0.1.8
	utf8parse@0.2.2
	version-compare@0.2.1
	wait-timeout@0.2.1
	walkdir@2.5.0
	wasi@0.11.1+wasi-snapshot-preview1
	wasip2@1.0.1+wasi-0.2.4
	winapi-util@0.1.11
	windows-link@0.2.1
	windows-sys@0.60.2
	windows-sys@0.61.2
	windows-targets@0.53.5
	windows_aarch64_gnullvm@0.53.1
	windows_aarch64_msvc@0.53.1
	windows_i686_gnu@0.53.1
	windows_i686_gnullvm@0.53.1
	windows_i686_msvc@0.53.1
	windows_x86_64_gnu@0.53.1
	windows_x86_64_gnullvm@0.53.1
	windows_x86_64_msvc@0.53.1
	winnow@0.7.14
	winres@0.1.12
	wit-bindgen@0.46.0
"
inherit cargo xdg
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Lyude/${PN}.git"
else
	MY_PV="e9882f5"
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
