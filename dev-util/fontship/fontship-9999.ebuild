# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	Inflector@0.11.4
	adler2@2.0.0
	ahash@0.8.11
	aho-corasick@1.1.3
	allocator-api2@0.2.21
	anstream@0.6.18
	anstyle-parse@0.2.6
	anstyle-query@1.1.2
	anstyle-wincon@3.0.7
	anstyle@1.0.10
	anyhow@1.0.95
	arc-swap@1.7.1
	arraydeque@0.5.1
	async-trait@0.1.85
	autocfg@1.4.0
	bitflags@2.8.0
	block-buffer@0.10.4
	bstr@1.11.3
	bumpalo@3.16.0
	camino@1.1.9
	cargo-platform@0.1.9
	cargo_metadata@0.18.1
	cargo_metadata@0.19.1
	cc@1.2.10
	cfg-if@1.0.0
	chunky-vec@0.1.0
	clap@4.5.27
	clap_builder@4.5.27
	clap_complete@4.5.42
	clap_derive@4.5.24
	clap_lex@0.7.4
	clap_mangen@0.2.26
	clru@0.6.2
	colorchoice@1.0.3
	config@0.14.1
	console@0.15.10
	cpufeatures@0.2.17
	crc32fast@1.4.2
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	crypto-common@0.1.6
	darling@0.20.10
	darling_core@0.20.10
	darling_macro@0.20.10
	deranged@0.3.11
	derive_builder@0.20.2
	derive_builder_core@0.20.2
	derive_builder_macro@0.20.2
	digest@0.10.7
	displaydoc@0.2.5
	dunce@1.0.5
	either@1.13.0
	encode_unicode@1.0.0
	encoding_rs@0.8.35
	errno@0.3.10
	faster-hex@0.9.0
	fastrand@2.3.0
	filetime@0.2.25
	flate2@1.0.35
	fluent-bundle@0.15.3
	fluent-fallback@0.7.1
	fluent-langneg@0.13.0
	fluent-syntax@0.11.1
	fluent@0.16.1
	fnv@1.0.7
	form_urlencoded@1.2.1
	futures-channel@0.3.31
	futures-core@0.3.31
	futures-executor@0.3.31
	futures-io@0.3.31
	futures-macro@0.3.31
	futures-sink@0.3.31
	futures-task@0.3.31
	futures-util@0.3.31
	futures@0.3.31
	generic-array@0.14.7
	getrandom@0.2.15
	git-warp-time@0.8.5
	git2@0.20.0
	gix-actor@0.31.5
	gix-actor@0.33.2
	gix-bitmap@0.2.14
	gix-chunk@0.4.11
	gix-command@0.4.1
	gix-commitgraph@0.24.3
	gix-commitgraph@0.25.1
	gix-config-value@0.14.11
	gix-config@0.37.0
	gix-config@0.42.0
	gix-date@0.8.7
	gix-date@0.9.3
	gix-diff@0.44.1
	gix-diff@0.49.0
	gix-discover@0.32.0
	gix-discover@0.37.0
	gix-features@0.38.2
	gix-features@0.39.1
	gix-fs@0.11.3
	gix-fs@0.12.1
	gix-glob@0.16.5
	gix-glob@0.17.1
	gix-hash@0.14.2
	gix-hash@0.15.1
	gix-hashtable@0.5.2
	gix-hashtable@0.6.0
	gix-index@0.33.1
	gix-index@0.37.0
	gix-lock@14.0.0
	gix-lock@15.0.1
	gix-macros@0.1.5
	gix-object@0.42.3
	gix-object@0.46.1
	gix-odb@0.61.1
	gix-odb@0.66.0
	gix-pack@0.51.1
	gix-pack@0.56.0
	gix-packetline@0.18.3
	gix-path@0.10.14
	gix-protocol@0.47.0
	gix-quote@0.4.15
	gix-ref@0.44.1
	gix-ref@0.49.1
	gix-refspec@0.23.1
	gix-refspec@0.27.0
	gix-revision@0.27.2
	gix-revision@0.31.1
	gix-revwalk@0.13.2
	gix-revwalk@0.17.0
	gix-sec@0.10.11
	gix-shallow@0.1.0
	gix-tempfile@14.0.2
	gix-tempfile@15.0.0
	gix-trace@0.1.12
	gix-transport@0.44.0
	gix-traverse@0.39.2
	gix-traverse@0.43.1
	gix-url@0.27.5
	gix-url@0.28.2
	gix-utils@0.1.14
	gix-validate@0.8.5
	gix-validate@0.9.3
	gix@0.63.0
	gix@0.69.1
	hashbrown@0.14.5
	hashlink@0.8.4
	heck@0.5.0
	hermit-abi@0.3.9
	home@0.5.11
	icu_collections@1.5.0
	icu_locid@1.5.0
	icu_locid_transform@1.5.0
	icu_locid_transform_data@1.5.0
	icu_normalizer@1.5.0
	icu_normalizer_data@1.5.0
	icu_properties@1.5.1
	icu_properties_data@1.5.0
	icu_provider@1.5.0
	icu_provider_macros@1.5.0
	ident_case@1.0.1
	idna@1.0.3
	idna_adapter@1.2.0
	indicatif@0.17.9
	intl-memoizer@0.5.2
	intl_pluralrules@7.0.2
	is_terminal_polyfill@1.70.1
	itertools@0.13.0
	itoa@1.0.14
	jiff-tzdb-platform@0.1.2
	jiff-tzdb@0.1.2
	jiff@0.1.26
	jobserver@0.1.32
	js-sys@0.3.77
	lazy_static@1.5.0
	libc@0.2.169
	libgit2-sys@0.18.0+1.9.0
	libredox@0.1.3
	libz-sys@1.1.21
	linux-raw-sys@0.4.15
	litemap@0.7.4
	lock_api@0.4.12
	log@0.4.25
	maybe-async@0.2.10
	memchr@2.7.4
	memmap2@0.9.5
	minimal-lexical@0.2.1
	miniz_oxide@0.8.3
	nom@7.1.3
	num-conv@0.1.0
	num_cpus@1.16.0
	num_threads@0.1.7
	number_prefix@0.4.0
	once_cell@1.20.2
	parking_lot@0.12.3
	parking_lot_core@0.9.10
	pathdiff@0.2.3
	percent-encoding@2.3.1
	pin-cell@0.2.0
	pin-project-lite@0.2.16
	pin-utils@0.1.0
	pkg-config@0.3.31
	portable-atomic-util@0.2.4
	portable-atomic@1.10.0
	powerfmt@0.2.0
	proc-macro2@1.0.93
	prodash@28.0.0
	prodash@29.0.0
	quote@1.0.38
	rayon-core@1.12.1
	rayon@1.10.0
	redox_syscall@0.5.8
	regex-automata@0.4.9
	regex-syntax@0.8.5
	regex@1.11.1
	roff@0.2.2
	rust-embed-impl@8.5.0
	rust-embed-utils@8.5.0
	rust-embed@8.5.0
	rustc-hash@1.1.0
	rustc_version@0.4.1
	rustix@0.38.44
	rustversion@1.0.19
	ryu@1.0.18
	same-file@1.0.6
	scopeguard@1.2.0
	self_cell@0.10.3
	self_cell@1.1.0
	semver@1.0.25
	serde@1.0.217
	serde_derive@1.0.217
	serde_json@1.0.137
	sha1_smol@1.0.1
	sha2@0.10.8
	shell-words@1.1.0
	shlex@1.3.0
	signal-hook-registry@1.4.2
	signal-hook@0.3.17
	slab@0.4.9
	smallvec@1.13.2
	snafu-derive@0.8.5
	snafu@0.8.5
	stable_deref_trait@1.2.0
	strsim@0.11.1
	subprocess@0.2.9
	syn@2.0.96
	synstructure@0.13.1
	tempfile@3.15.0
	terminal_size@0.4.1
	thiserror-impl@1.0.69
	thiserror-impl@2.0.11
	thiserror@1.0.69
	thiserror@2.0.11
	time-core@0.1.2
	time-macros@0.2.19
	time@0.3.37
	tinystr@0.7.6
	tinyvec@1.8.1
	tinyvec_macros@0.1.1
	type-map@0.5.0
	typenum@1.17.0
	unic-langid-impl@0.9.5
	unic-langid@0.9.5
	unicode-bom@2.0.3
	unicode-ident@1.0.15
	unicode-normalization@0.1.24
	unicode-segmentation@1.12.0
	unicode-width@0.2.0
	url@2.5.4
	utf16_iter@1.0.5
	utf8_iter@1.0.4
	utf8parse@0.2.2
	vcpkg@0.2.15
	vergen-gix@1.0.6
	vergen-lib@0.1.6
	vergen@8.3.2
	vergen@9.0.4
	version_check@0.9.5
	walkdir@2.5.0
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.100
	wasm-bindgen-macro-support@0.2.100
	wasm-bindgen-macro@0.2.100
	wasm-bindgen-shared@0.2.100
	wasm-bindgen@0.2.100
	web-time@1.1.0
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.9
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
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
	winnow@0.6.24
	write16@1.0.0
	writeable@0.5.5
	yaml-rust2@0.8.1
	yoke-derive@0.7.5
	yoke@0.7.5
	zerocopy-derive@0.7.35
	zerocopy@0.7.35
	zerofrom-derive@0.1.5
	zerofrom@0.1.5
	zerovec-derive@0.10.3
	zerovec@0.10.4
"
PYTHON_COMPAT=( python3_{10..13} )
inherit bash-completion-r1 autotools python-single-r1 cargo
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/theleagueof/${PN}.git"
else
	MY_PV="0e12ede"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
		SRC_URI="
			mirror://githubcl/theleagueof/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
			${CARGO_CRATE_URIS}
		"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="A font development toolkit"
HOMEPAGE="https://github.com/theleagueof/${PN}"

LICENSE="GPL-3"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/babelfont[${PYTHON_USEDEP}]
		dev-python/font-v[${PYTHON_USEDEP}]
		dev-python/fonttools[ufo(-),unicode,woff,${PYTHON_USEDEP}]
		dev-python/pcpp[${PYTHON_USEDEP}]
		dev-python/sfdLib[${PYTHON_USEDEP}]
		dev-python/ufo2ft[cffsubr(+),${PYTHON_USEDEP}]
		dev-python/ufoLib2[cffsubr(+),${PYTHON_USEDEP}]
		dev-python/vttLib[${PYTHON_USEDEP}]
	')
	>=dev-util/gftools-0.6.2
	>=dev-python/font-v-1.0.5
	>=dev-util/fontmake-2.2.1
	>=dev-python/fonttools-4.16.1
	dev-util/afdko
	dev-util/fontmake
	dev-util/gftools
	>=dev-util/sfdnormalize-0.3.0
	>=dev-python/ufoNormalizer-0.5.3
	media-gfx/ttfautohint
	media-libs/woff2
	app-shells/zsh
	dev-libs/libgit2:=[ssh]
	dev-vcs/git
"
RDEPEND="
	${DEPEND}
"
PATCHES=(
	"${FILESDIR}"/jq.diff
	"${FILESDIR}"/psautohint.diff
)

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		default
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_prepare() {
	if [[ -n ${PV%%*9999} ]]; then
		echo "${PV%_p*}" > .tarball-version
	fi
	touch aminclude.am
	sh ./build-aux/git-version-gen .tarball-version > .version
	default
	sed \
		-e '/sfnt2woff-zopfli/d' \
		-i configure.ac
	sed \
		-e '/dist_license_DATA = /d' \
		-e '/docdir = /d' \
		-e 's:\<cp\> -bf:cp -f:' \
		-i Makefile.am
	eautoreconf
	# a ./configure run is needed to generate aminclude.am
	econf
	eautomake
	sh ./config.status Makefile
}

src_configure() {
	econf \
		--with-bash-completion-dir="$(get_bashcompdir)" \
		--with-zsh-completion-dir="${EPREFIX}/usr/share/zsh/site-functions"
}

src_compile() {
	default
}

src_install() {
	default
}
