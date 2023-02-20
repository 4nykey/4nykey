# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..11} )
inherit autotools python-single-r1 cargo
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/theleagueof/${PN}.git"
else
	CRATES="
	Inflector-0.11.4
	anyhow-1.0.40
	arrayvec-0.5.2
	atty-0.2.14
	autocfg-1.0.1
	bitflags-1.2.1
	cc-1.0.67
	cfg-if-1.0.0
	chrono-0.4.19
	clap-3.0.0-beta.2
	clap_derive-3.0.0-beta.2
	clap_generate-3.0.0-beta.2
	colored-2.0.0
	config-0.11.0
	crossbeam-channel-0.5.1
	crossbeam-deque-0.8.0
	crossbeam-epoch-0.9.3
	crossbeam-utils-0.8.3
	either-1.6.1
	elsa-1.4.0
	enum-iterator-0.6.0
	enum-iterator-derive-0.6.0
	filetime-0.2.14
	fluent-0.12.0
	fluent-bundle-0.12.0
	fluent-fallback-0.0.4
	fluent-langneg-0.13.0
	fluent-syntax-0.9.3
	form_urlencoded-1.0.1
	getset-0.1.1
	git-warp-time-0.4.3
	git2-0.13.17
	hashbrown-0.9.1
	heck-0.3.2
	hermit-abi-0.1.18
	idna-0.2.3
	indexmap-1.6.2
	intl-memoizer-0.5.1
	intl_pluralrules-7.0.1
	itertools-0.10.0
	jobserver-0.1.21
	lazy_static-1.4.0
	lexical-core-0.7.5
	libc-0.2.94
	libgit2-sys-0.12.18+1.1.0
	libz-sys-1.1.2
	linked-hash-map-0.5.4
	log-0.4.14
	matches-0.1.8
	memchr-2.4.0
	memoffset-0.6.3
	nom-5.1.2
	num-integer-0.1.44
	num-traits-0.2.14
	num_cpus-1.13.0
	os_str_bytes-2.4.0
	percent-encoding-2.1.0
	pkg-config-0.3.19
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.26
	quote-1.0.9
	rayon-1.5.0
	rayon-core-1.9.0
	redox_syscall-0.2.7
	regex-1.5.4
	regex-syntax-0.6.25
	reiterate-0.1.3
	rental-0.5.5
	rental-impl-0.5.5
	rust-embed-5.9.0
	rust-embed-impl-5.9.0
	rust-embed-utils-5.1.0
	rustc-hash-1.1.0
	rustversion-1.0.5
	ryu-1.0.5
	same-file-1.0.6
	scopeguard-1.1.0
	serde-1.0.125
	smallvec-1.6.1
	stable_deref_trait-1.2.0
	static_assertions-1.1.0
	strsim-0.10.0
	subprocess-0.2.6
	syn-1.0.72
	termcolor-1.1.2
	terminal_size-0.1.16
	textwrap-0.12.1
	thiserror-1.0.24
	thiserror-impl-1.0.24
	time-0.1.44
	tinystr-0.3.4
	tinyvec-1.2.0
	tinyvec_macros-0.1.0
	type-map-0.4.0
	unic-langid-0.9.0
	unic-langid-impl-0.9.0
	unicode-bidi-0.3.5
	unicode-normalization-0.1.17
	unicode-segmentation-1.7.1
	unicode-width-0.1.8
	unicode-xid-0.2.2
	url-2.2.1
	vcpkg-0.2.12
	vec_map-0.8.2
	vergen-5.1.1
	version_check-0.9.3
	walkdir-2.3.2
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
	dev-libs/libgit2:=[ssh]
	dev-vcs/git
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	app-misc/jq
"

src_prepare() {
	if [[ -n ${PV%%*9999} ]]; then
		echo "${PV%_p*}" > .tarball-version
		eapply "${FILESDIR}"/rustversion.diff
	fi
	./build-aux/git-version-gen .tarball-version > .version
	default
	sed -e '/sfnt2woff-zopfli/d' -i configure.ac
	sed \
		-e '/dist_license_DATA = /d' \
		-e '/docdir = /d' \
		-e 's:\<cp\> -bf:cp -f:' \
		-i Makefile.am
	eautoreconf
}

src_compile() { default; }
src_configure() { default; }
src_install() { default; }
