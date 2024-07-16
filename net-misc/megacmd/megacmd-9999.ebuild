# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AT_M4DIR="${EROOT}/usr/share/mega/m4"
inherit autotools
MY_PN="MEGAcmd"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/meganz/${MY_PN}.git"
	EGIT_SUBMODULES=( )
else
	MY_PV="48f96ed"
	SRC_URI="
		mirror://githubcl/meganz/${MY_PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
fi

DESCRIPTION="Command Line Interactive and Scriptable Application to access MEGA"
HOMEPAGE="https://mega.nz/cmd"

LICENSE="BSD-2"
SLOT="0"
IUSE="pcre"

DEPEND="
	>=net-misc/meganz-sdk-7.1.2:=
	pcre? ( dev-libs/libpcre:3[cxx] )
	sys-libs/readline:0
"
RDEPEND="
	${DEPEND}
"
PATCHES=(
	"${FILESDIR}"/sdk7.diff
)

src_prepare() {
	sed \
		-e '/SUBDIRS.*sdk/d' \
		-e '/sdk\/m4/d' \
		-e 's:LMEGAINC=.*:PKG_CHECK_MODULES([MEGA],[sdklib])\nLMEGAINC=${MEGA_CFLAGS}:' \
		-e '/AX_CXX_COMPILE_STDCXX/d' \
		-i Makefile.am configure.ac
	sed \
		-e 's:\$(top_builddir)/sdk/src/libmega\.la:$(MEGA_LIBS):' \
		-e 's:mega_\(cmd\|exec\)_LDADD = .*:& $(MEGA_LIBS):' \
		-e 's:sdk/include/mega/[^ ]\+\.h::g' \
		-e '/sdk\/src\/[^ ]\+\.cpp/d' \
		-i src/include.am
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-readline="/usr/$(get_libdir)"
		$(use_with pcre pcre "/usr")
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	dodoc UserGuide.md contrib/docs/*.md
}
