# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line@0.24.2
	adler2@2.0.0
	aho-corasick@1.1.3
	anstream@0.6.18
	anstyle-parse@0.2.6
	anstyle-query@1.1.2
	anstyle-wincon@3.0.7
	anstyle@1.0.10
	async-trait@0.1.87
	autocfg@1.4.0
	automod@1.0.15
	backtrace@0.3.74
	bitflags@2.9.0
	build-version@0.1.1
	byteorder@1.5.0
	bytes@0.4.12
	bytes@1.10.0
	cairo-rs@0.20.7
	cairo-sys-rs@0.20.7
	cfg-expr@0.17.2
	cfg-if@1.0.0
	clap@4.5.31
	clap_builder@4.5.31
	clap_derive@4.5.28
	clap_lex@0.7.4
	colorchoice@1.0.3
	content_inspector@0.2.4
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	dunce@1.0.5
	either@1.14.0
	env_filter@0.1.3
	env_logger@0.11.6
	equivalent@1.0.2
	errno@0.3.10
	fastrand@2.3.0
	field-offset@0.3.6
	filetime@0.2.25
	fnv@1.0.7
	fork@0.2.0
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
	gdk-pixbuf-sys@0.20.7
	gdk-pixbuf@0.20.9
	gdk4-sys@0.9.6
	gdk4@0.9.6
	getrandom@0.3.1
	gimli@0.31.1
	gio-sys@0.20.9
	gio@0.20.9
	glib-macros@0.20.7
	glib-sys@0.20.9
	glib@0.20.9
	glob@0.3.2
	gobject-sys@0.20.9
	graphene-rs@0.20.9
	graphene-sys@0.20.7
	gsk4-sys@0.9.6
	gsk4@0.9.6
	gtk4-macros@0.9.5
	gtk4-sys@0.9.6
	gtk4@0.9.6
	hashbrown@0.14.5
	hashbrown@0.15.2
	heck@0.5.0
	hermit-abi@0.3.9
	hermit-abi@0.4.0
	html-escape@0.2.13
	humantime-serde@1.1.1
	humantime@2.1.0
	indexmap@2.7.1
	iovec@0.1.4
	is-terminal@0.4.15
	is_terminal_polyfill@1.70.1
	itoa@1.0.15
	libc@0.2.170
	libredox@0.1.3
	linux-raw-sys@0.4.15
	lock_api@0.4.12
	log@0.4.26
	memchr@2.7.4
	memoffset@0.9.1
	miniz_oxide@0.8.5
	mio@1.0.3
	normalize-line-endings@0.3.0
	num-traits@0.2.19
	num_cpus@1.16.0
	nvim-rs@0.9.0
	object@0.36.7
	once_cell@1.20.3
	os_pipe@1.2.1
	pango-sys@0.20.9
	pango@0.20.9
	parking_lot@0.12.3
	parking_lot_core@0.9.10
	paste@1.0.15
	percent-encoding@2.3.1
	phf@0.11.3
	phf_codegen@0.11.3
	phf_generator@0.11.3
	phf_shared@0.11.3
	pin-project-lite@0.2.16
	pin-utils@0.1.0
	pkg-config@0.3.32
	proc-macro-crate@3.2.0
	proc-macro2@1.0.94
	quick-error@1.2.3
	quote@1.0.39
	rand@0.8.5
	rand_core@0.6.4
	rayon-core@1.12.1
	rayon@1.10.0
	redox_syscall@0.5.10
	regex-automata@0.4.9
	regex-syntax@0.8.5
	regex@1.11.1
	rmp@0.8.14
	rmpv@1.3.0
	rustc-demangle@0.1.24
	rustc_version@0.4.1
	rustix@0.38.44
	ryu@1.0.20
	same-file@1.0.6
	scopeguard@1.2.0
	semver@1.0.26
	serde@1.0.218
	serde_bytes@0.11.16
	serde_derive@1.0.218
	serde_json@1.0.140
	serde_spanned@0.6.8
	shlex@1.3.0
	signal-hook-registry@1.4.2
	similar@2.7.0
	siphasher@1.0.1
	slab@0.4.9
	smallvec@1.14.0
	snapbox-macros@0.3.10
	snapbox@0.6.21
	socket2@0.5.8
	strsim@0.11.1
	syn@2.0.99
	system-deps@7.0.3
	target-lexicon@0.12.16
	tempfile@3.17.1
	terminal_size@0.4.1
	tokio-io@0.1.13
	tokio-macros@2.5.0
	tokio-util@0.7.13
	tokio@1.43.0
	toml@0.5.11
	toml@0.8.20
	toml_datetime@0.6.8
	toml_edit@0.22.24
	trycmd@0.15.9
	unicode-ident@1.0.18
	unicode-segmentation@1.12.0
	unicode-width@0.2.0
	utf8-width@0.1.7
	utf8parse@0.2.2
	version-compare@0.2.0
	wait-timeout@0.2.1
	walkdir@2.5.0
	wasi@0.11.0+wasi-snapshot-preview1
	wasi@0.13.3+wasi-0.2.2
	winapi-util@0.1.9
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	winnow@0.7.3
	winres@0.1.12
	wit-bindgen-rt@0.33.0
"
inherit cargo xdg
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Lyude/${PN}.git"
else
	MY_PV="f36cfec"
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
