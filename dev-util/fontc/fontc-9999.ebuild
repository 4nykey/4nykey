# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line@0.24.1
	adler2@2.0.0
	aho-corasick@1.1.3
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anes@0.1.6
	ansi_term@0.12.1
	anstream@0.6.15
	anstyle@1.0.8
	anstyle-parse@0.2.5
	anstyle-query@1.1.1
	anstyle-wincon@3.0.4
	anyhow@1.0.89
	arrayref@0.3.9
	arrayvec@0.7.6
	async-trait@0.1.82
	auto_impl@0.5.0
	autocfg@1.3.0
	backtrace@0.3.74
	base64@0.21.7
	base64@0.22.1
	bincode@1.3.3
	bitflags@1.3.2
	bitflags@2.6.0
	blake3@1.5.4
	bumpalo@3.16.0
	bytes@1.7.2
	camino@1.1.9
	cargo-platform@0.1.8
	cargo_metadata@0.18.1
	cast@0.3.0
	cc@1.1.21
	cfg-if@1.0.0
	chrono@0.4.38
	ciborium@0.2.2
	ciborium-io@0.2.2
	ciborium-ll@0.2.2
	clap@4.5.18
	clap_builder@4.5.18
	clap_derive@4.5.18
	clap_lex@0.7.2
	colorchoice@1.0.2
	constant_time_eq@0.3.1
	core-foundation-sys@0.8.7
	criterion@0.5.1
	criterion-plot@0.5.0
	crossbeam-channel@0.5.13
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.20
	crunchy@0.2.2
	dashmap@4.0.2
	deranged@0.3.11
	diff@0.1.13
	displaydoc@0.2.5
	dot2@1.0.0
	either@1.13.0
	env_logger@0.10.2
	equivalent@1.0.1
	errno@0.3.9
	fastrand@2.1.1
	filetime@0.2.25
	font-types@0.4.3
	form_urlencoded@1.2.1
	futures@0.3.30
	futures-channel@0.3.30
	futures-core@0.3.30
	futures-executor@0.3.30
	futures-io@0.3.30
	futures-macro@0.3.30
	futures-sink@0.3.30
	futures-task@0.3.30
	futures-timer@3.0.3
	futures-util@0.3.30
	getrandom@0.2.15
	gimli@0.31.0
	glob@0.3.1
	half@2.4.1
	hashbrown@0.14.5
	heck@0.3.3
	heck@0.5.0
	hermit-abi@0.3.9
	hermit-abi@0.4.0
	httparse@1.9.4
	humantime@2.1.0
	iana-time-zone@0.1.61
	iana-time-zone-haiku@0.1.2
	icu_collections@1.5.0
	icu_locid@1.5.0
	icu_locid_transform@1.5.0
	icu_locid_transform_data@1.5.0
	icu_properties@1.5.1
	icu_properties_data@1.5.0
	icu_provider@1.5.0
	icu_provider_macros@1.5.0
	idna@0.5.0
	indexmap@2.5.0
	is-terminal@0.4.13
	is_terminal_polyfill@1.70.1
	itertools@0.10.5
	itoa@1.0.11
	js-sys@0.3.70
	kurbo@0.11.1
	libc@0.2.158
	libredox@0.1.3
	linux-raw-sys@0.4.14
	litemap@0.7.3
	lock_api@0.4.12
	log@0.4.22
	lsp-types@0.91.1
	lspower@1.5.0
	lspower-macros@0.2.1
	memchr@2.7.4
	miniz_oxide@0.8.0
	mio@1.0.2
	more-asserts@0.3.1
	norad@0.12.1
	num-conv@0.1.0
	num-traits@0.2.19
	num_cpus@1.16.0
	num_threads@0.1.7
	object@0.36.4
	once_cell@1.19.0
	oorandom@11.1.4
	ordered-float@4.2.2
	parking_lot@0.12.3
	parking_lot_core@0.9.10
	percent-encoding@2.3.1
	pin-project-lite@0.2.14
	pin-utils@0.1.0
	plist@1.7.0
	plotters@0.3.7
	plotters-backend@0.3.7
	plotters-svg@0.3.7
	powerfmt@0.2.0
	pretty_assertions@1.4.1
	proc-macro-error@1.0.4
	proc-macro-error-attr@1.0.4
	proc-macro2@1.0.86
	quick-xml@0.30.0
	quick-xml@0.31.0
	quick-xml@0.32.0
	quote@1.0.37
	rand@0.8.5
	rand_core@0.6.4
	rayon@1.10.0
	rayon-core@1.12.1
	read-fonts@0.17.0
	redox_syscall@0.5.4
	regex@1.10.6
	regex-automata@0.4.7
	regex-syntax@0.8.4
	relative-path@1.9.3
	rstest@0.18.2
	rstest_macros@0.18.2
	rustc-demangle@0.1.24
	rustc_version@0.4.1
	rustix@0.38.37
	rustversion@1.0.17
	ryu@1.0.18
	same-file@1.0.6
	scopeguard@1.2.0
	semver@1.0.23
	serde@1.0.210
	serde_derive@1.0.210
	serde_json@1.0.128
	serde_repr@0.1.19
	serde_yaml@0.9.34+deprecated
	shlex@1.3.0
	skrifa@0.17.0
	slab@0.4.9
	smallvec@1.13.2
	smol_str@0.2.2
	socket2@0.5.7
	stable_deref_trait@1.2.0
	strsim@0.11.1
	syn@1.0.109
	syn@2.0.77
	synstructure@0.13.1
	temp-env@0.3.6
	tempfile@3.12.0
	termcolor@1.4.1
	thiserror@1.0.63
	thiserror-impl@1.0.63
	time@0.3.36
	time-core@0.1.2
	time-macros@0.2.18
	tinystr@0.7.6
	tinytemplate@1.2.1
	tinyvec@1.8.0
	tinyvec_macros@0.1.1
	tokio@1.40.0
	tokio-macros@2.4.0
	tokio-util@0.6.10
	tower-service@0.3.3
	twoway@0.2.2
	unchecked-index@0.2.2
	unicode-bidi@0.3.15
	unicode-ident@1.0.13
	unicode-normalization@0.1.24
	unicode-segmentation@1.12.0
	unsafe-libyaml@0.2.11
	url@2.5.2
	utf8parse@0.2.2
	uuid@1.10.0
	vergen@8.3.2
	version_check@0.9.5
	walkdir@2.5.0
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen@0.2.93
	wasm-bindgen-backend@0.2.93
	wasm-bindgen-macro@0.2.93
	wasm-bindgen-macro-support@0.2.93
	wasm-bindgen-shared@0.2.93
	web-sys@0.3.70
	winapi@0.3.9
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.9
	winapi-x86_64-pc-windows-gnu@0.4.0
	windows-core@0.52.0
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
	write-fonts@0.25.0
	writeable@0.5.5
	yansi@1.0.1
	yoke@0.7.4
	yoke-derive@0.7.4
	zerofrom@0.1.4
	zerofrom-derive@0.1.4
	zerovec@0.10.4
	zerovec-derive@0.10.3
"
inherit cargo
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${PN}.git"
else
	MY_PV="e0b1cb4"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PN}-v${PV}"
	SRC_URI="
		mirror://githubcl/googlefonts/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		${CARGO_CRATE_URIS}
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="Where in we pursue oxidizing fontmake"
HOMEPAGE="https://github.com/googlefonts/fontc"

LICENSE="Apache-2.0"
SLOT="0"

src_install() {
	cargo_src_install --path ${PN}
	einstalldocs
}
