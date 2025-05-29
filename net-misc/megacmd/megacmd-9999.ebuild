# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 flag-o-matic cmake
MY_PN="MEGAcmd"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/meganz/${MY_PN}.git"
	EGIT_SUBMODULES=( )
else
	MY_PV="7fe3e1e"
	MY_SDK="61013ee"
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
	>=net-misc/meganz-sdk-9.1:=
	pcre? ( dev-libs/libpcre:3[cxx] )
	sys-libs/readline:0
"
RDEPEND="
	${DEPEND}
"
PATCHES=(
	"${FILESDIR}"/cmake.diff
	"${FILESDIR}"/sdk92.diff
)

src_prepare() {
	append-cppflags -DNDEBUG
	cmake_src_prepare
	if [[ -n ${PV%%*9999} ]]; then
		sed \
			-e '/find_package(Git/d' \
			-e "s:\${GIT_EXECUTABLE}.*:echo ${MY_SDK}:" \
			-i CMakeLists.txt
	fi
}

src_configure() {
	local mycmakeargs=(
		-DUSE_PCRE=$(usex pcre)
		-DFULL_REQS=no
		-DBUILD_SHARED_LIBS=no
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	newbashcomp src/client/megacmd_completion.sh ${PN}
	insinto /etc/sysctl.d
	doins "${BUILD_DIR}"/99-megacmd-inotify-limit.conf
}
