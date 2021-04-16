# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
inherit autotools python-single-r1 cargo
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/theleagueof/${PN}.git"
else
	CRATES="
	Inflector-0.11.4
	aho-corasick-0.7.15
	arrayvec-0.5.2
	atty-0.2.14
	autocfg-1.0.1
	bitflags-1.2.1
	cc-1.0.66
	cfg-if-0.1.10
	cfg-if-1.0.0
	chrono-0.4.19
	clap-3.0.0-beta.2
	clap_derive-3.0.0-beta.2
	clap_generate-3.0.0-beta.2
	colored-2.0.0
	config-0.10.1
	const_fn-0.4.5
	crossbeam-channel-0.5.0
	crossbeam-deque-0.8.0
	crossbeam-epoch-0.9.1
	crossbeam-utils-0.8.1
	either-1.6.1
	elsa-1.3.2
	fluent-0.12.0
	fluent-bundle-0.12.0
	fluent-fallback-0.0.4
	fluent-langneg-0.13.0
	fluent-syntax-0.9.3
	form_urlencoded-1.0.0
	git2-0.13.17
	hashbrown-0.9.1
	heck-0.3.2
	hermit-abi-0.1.18
	idna-0.2.0
	indexmap-1.6.1
	intl-memoizer-0.5.1
	intl_pluralrules-7.0.1
	itertools-0.9.0
	itoa-0.4.7
	jobserver-0.1.21
	lazy_static-1.4.0
	lexical-core-0.7.4
	libc-0.2.84
	libgit2-sys-0.12.18+1.1.0
	libssh2-sys-0.2.20
	libz-sys-1.1.2
	linked-hash-map-0.3.0
	linked-hash-map-0.5.4
	log-0.4.14
	matches-0.1.8
	memchr-2.3.4
	memoffset-0.6.1
	nom-5.1.2
	num-integer-0.1.44
	num-traits-0.1.43
	num-traits-0.2.14
	num_cpus-1.13.0
	once_cell-1.5.2
	openssl-probe-0.1.2
	openssl-sys-0.9.60
	os_str_bytes-2.4.0
	percent-encoding-2.1.0
	pkg-config-0.3.19
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.24
	quote-1.0.8
	rayon-1.5.0
	rayon-core-1.9.0
	regex-1.4.3
	regex-syntax-0.6.22
	reiterate-0.1.3
	rental-0.5.5
	rental-impl-0.5.5
	rust-embed-5.9.0
	rust-embed-impl-5.9.0
	rust-embed-utils-5.1.0
	rust-ini-0.13.0
	rustc-hash-1.1.0
	ryu-1.0.5
	same-file-1.0.6
	scopeguard-1.1.0
	serde-0.8.23
	serde-1.0.123
	serde-hjson-0.9.1
	serde_json-1.0.61
	serde_test-0.8.23
	smallvec-1.6.1
	stable_deref_trait-1.2.0
	static_assertions-1.1.0
	strsim-0.10.0
	subprocess-0.2.6
	syn-1.0.60
	termcolor-1.1.2
	terminal_size-0.1.16
	textwrap-0.12.1
	thread_local-1.1.2
	time-0.1.44
	tinystr-0.3.4
	tinyvec-1.1.1
	tinyvec_macros-0.1.0
	toml-0.5.8
	type-map-0.4.0
	unic-langid-0.9.0
	unic-langid-impl-0.9.0
	unicode-bidi-0.3.4
	unicode-normalization-0.1.16
	unicode-segmentation-1.7.1
	unicode-width-0.1.8
	unicode-xid-0.2.1
	url-2.2.0
	vcpkg-0.2.11
	vec_map-0.8.2
	vergen-3.1.0
	version_check-0.9.2
	walkdir-2.3.1
	wasi-0.10.0+wasi-snapshot-preview1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	yaml-rust-0.4.5
	"
	MY_PV="64509b2"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/theleagueof/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		$(cargo_crate_uris ${CRATES})
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="A font development toolkit"
HOMEPAGE="https://github.com/theleagueof/${PN}"

LICENSE="AGPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/babelfont-0.0.2[${PYTHON_USEDEP}]
		>=dev-python/click-7.1.2[${PYTHON_USEDEP}]
		>=dev-python/pcpp-1.22[${PYTHON_USEDEP}]
		>=dev-python/pygit2-1.2.1[${PYTHON_USEDEP}]
		>=dev-python/sfdLib-1.0.7[${PYTHON_USEDEP}]
		>=dev-python/ufo2ft-2.19.1[cffsubr(+),${PYTHON_USEDEP}]
		dev-python/vttLib[${PYTHON_USEDEP}]
	')
	>=dev-util/gftools-0.6.2
	>=dev-python/font-v-1.0.5
	>=dev-util/fontmake-2.2.1
	>=dev-python/fonttools-4.16.1
	>=dev-util/psautohint-2.2
	>=dev-util/sfdnormalize-0.3.0
	>=dev-python/ufoNormalizer-0.5.3
	media-gfx/ttfautohint
	media-libs/woff2
	app-shells/zsh
	dev-libs/libgit2[ssh]
	dev-vcs/git
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	[[ -n ${PV%%*9999} ]] && echo "${PV%_p*}" > .tarball-version
	./build-aux/git-version-gen .tarball-version > .version
	default
	sed -e '/sfnt2woff-zopfli/d' -i configure.ac
	sed -e '/dist_license_DATA = /d' -i Makefile.am
	eautoreconf
}

src_compile() { default; }
src_configure() { default; }
src_install() { default; }
