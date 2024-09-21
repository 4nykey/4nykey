# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	Inflector@0.11.4
	adler2@2.0.0
	ahash@0.8.11
	aho-corasick@1.1.3
	allocator-api2@0.2.18
	anstream@0.6.15
	anstyle@1.0.8
	anstyle-parse@0.2.5
	anstyle-query@1.1.1
	anstyle-wincon@3.0.4
	anyhow@1.0.89
	arc-swap@1.7.1
	async-trait@0.1.82
	autocfg@1.3.0
	bitflags@2.6.0
	block-buffer@0.10.4
	bstr@1.10.0
	camino@1.1.9
	cargo-platform@0.1.8
	cargo_metadata@0.18.1
	cc@1.1.19
	cfg-if@1.0.0
	chunky-vec@0.1.0
	clap@4.5.17
	clap_builder@4.5.17
	clap_complete@4.5.26
	clap_derive@4.5.13
	clap_lex@0.7.2
	clap_mangen@0.2.23
	clru@0.6.2
	colorchoice@1.0.2
	config@0.14.0
	console@0.15.8
	cpufeatures@0.2.14
	crc32fast@1.4.2
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.20
	crypto-common@0.1.6
	darling@0.20.10
	darling_core@0.20.10
	darling_macro@0.20.10
	deranged@0.3.11
	derive_builder@0.20.1
	derive_builder_core@0.20.1
	derive_builder_macro@0.20.1
	digest@0.10.7
	displaydoc@0.2.5
	dunce@1.0.5
	either@1.13.0
	encode_unicode@0.3.6
	errno@0.3.9
	faster-hex@0.9.0
	fastrand@2.1.1
	filetime@0.2.25
	flate2@1.0.33
	fluent@0.16.1
	fluent-bundle@0.15.3
	fluent-fallback@0.7.1
	fluent-langneg@0.13.0
	fluent-syntax@0.11.1
	fnv@1.0.7
	form_urlencoded@1.2.1
	futures@0.3.30
	futures-channel@0.3.30
	futures-core@0.3.30
	futures-executor@0.3.30
	futures-io@0.3.30
	futures-macro@0.3.30
	futures-sink@0.3.30
	futures-task@0.3.30
	futures-util@0.3.30
	generic-array@0.14.7
	getset@0.1.3
	git-warp-time@0.8.3
	git2@0.19.0
	gix@0.63.0
	gix-actor@0.31.5
	gix-bitmap@0.2.11
	gix-chunk@0.4.8
	gix-commitgraph@0.24.3
	gix-config@0.37.0
	gix-config-value@0.14.8
	gix-date@0.8.7
	gix-diff@0.44.1
	gix-discover@0.32.0
	gix-features@0.38.2
	gix-fs@0.11.3
	gix-glob@0.16.5
	gix-hash@0.14.2
	gix-hashtable@0.5.2
	gix-index@0.33.1
	gix-lock@14.0.0
	gix-macros@0.1.5
	gix-object@0.42.3
	gix-odb@0.61.1
	gix-pack@0.51.1
	gix-path@0.10.11
	gix-quote@0.4.12
	gix-ref@0.44.1
	gix-refspec@0.23.1
	gix-revision@0.27.2
	gix-revwalk@0.13.2
	gix-sec@0.10.8
	gix-tempfile@14.0.2
	gix-trace@0.1.10
	gix-traverse@0.39.2
	gix-url@0.27.5
	gix-utils@0.1.12
	gix-validate@0.8.5
	hashbrown@0.14.5
	heck@0.5.0
	hermit-abi@0.3.9
	home@0.5.9
	ident_case@1.0.1
	idna@0.5.0
	indicatif@0.17.8
	instant@0.1.13
	intl-memoizer@0.5.2
	intl_pluralrules@7.0.2
	is_terminal_polyfill@1.70.1
	itertools@0.13.0
	itoa@1.0.11
	jobserver@0.1.32
	lazy_static@1.5.0
	libc@0.2.158
	libgit2-sys@0.17.0+1.8.1
	libredox@0.1.3
	libz-sys@1.1.20
	linked-hash-map@0.5.6
	linux-raw-sys@0.4.14
	lock_api@0.4.12
	log@0.4.22
	memchr@2.7.4
	memmap2@0.9.5
	minimal-lexical@0.2.1
	miniz_oxide@0.8.0
	nom@7.1.3
	num-conv@0.1.0
	num_cpus@1.16.0
	num_threads@0.1.7
	number_prefix@0.4.0
	once_cell@1.19.0
	parking_lot@0.12.3
	parking_lot_core@0.9.10
	pathdiff@0.2.1
	percent-encoding@2.3.1
	pin-cell@0.2.0
	pin-project-lite@0.2.14
	pin-utils@0.1.0
	pkg-config@0.3.30
	portable-atomic@1.7.0
	powerfmt@0.2.0
	proc-macro-error-attr2@2.0.0
	proc-macro-error2@2.0.1
	proc-macro2@1.0.86
	prodash@28.0.0
	quote@1.0.37
	rayon@1.10.0
	rayon-core@1.12.1
	redox_syscall@0.5.3
	regex@1.10.6
	regex-automata@0.4.7
	regex-syntax@0.8.4
	roff@0.2.2
	rust-embed@8.5.0
	rust-embed-impl@8.5.0
	rust-embed-utils@8.5.0
	rustc-hash@1.1.0
	rustc_version@0.4.1
	rustix@0.38.37
	rustversion@1.0.17
	ryu@1.0.18
	same-file@1.0.6
	scopeguard@1.2.0
	self_cell@0.10.3
	self_cell@1.0.4
	semver@1.0.23
	serde@1.0.210
	serde_derive@1.0.210
	serde_json@1.0.128
	sha1_smol@1.0.1
	sha2@0.10.8
	shlex@1.3.0
	signal-hook@0.3.17
	signal-hook-registry@1.4.2
	slab@0.4.9
	smallvec@1.13.2
	snafu@0.8.4
	snafu-derive@0.8.4
	strsim@0.11.1
	subprocess@0.2.9
	syn@2.0.77
	tempfile@3.12.0
	terminal_size@0.3.0
	thiserror@1.0.63
	thiserror-impl@1.0.63
	time@0.3.36
	time-core@0.1.2
	time-macros@0.2.18
	tinystr@0.7.6
	tinyvec@1.8.0
	tinyvec_macros@0.1.1
	type-map@0.5.0
	typenum@1.17.0
	unic-langid@0.9.5
	unic-langid-impl@0.9.5
	unicode-bidi@0.3.15
	unicode-bom@2.0.3
	unicode-ident@1.0.13
	unicode-normalization@0.1.23
	unicode-segmentation@1.12.0
	unicode-width@0.1.13
	url@2.5.2
	utf8parse@0.2.2
	vcpkg@0.2.15
	vergen@8.3.2
	vergen@9.0.0
	vergen-gix@1.0.1
	vergen-lib@0.1.3
	version_check@0.9.5
	walkdir@2.5.0
	winapi@0.3.9
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.9
	winapi-x86_64-pc-windows-gnu@0.4.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-targets@0.48.5
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.6
	winnow@0.6.18
	yaml-rust@0.4.5
	zerocopy@0.7.35
	zerocopy-derive@0.7.35
"
PYTHON_COMPAT=( python3_{10..12} )
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

LICENSE="AGPL-3"
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
