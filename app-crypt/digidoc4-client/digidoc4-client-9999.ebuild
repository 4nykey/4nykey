# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="DigiDoc4-Client"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${MY_PN}.git"
else
	MY_PV="${PV^^}"
	MY_PV="v${MY_PV/_/-}"
	[[ -z ${PV%%*_p*} ]] && MY_PV="a4da0d3"
	MY_QC="qt-common-6a1b281"
	SRC_URI="${SRC_URI}
		mirror://githubcl/open-eid/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/open-eid/${MY_QC%-*}/tar.gz/${MY_QC##*-} -> ${MY_QC}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${MY_PV#v}"
fi
inherit toolchain-funcs cmake xdg

DESCRIPTION="An application for digitally signing and encrypting documents"
HOMEPAGE="https://open-eid.github.io"

LICENSE="LGPL-2.1 Nokia-Qt-LGPL-Exception-1.1"
SLOT="0"
IUSE="nautilus"

DEPEND="
	>=dev-libs/libdigidocpp-4.2
	sys-apps/pcsc-lite
	net-nds/openldap
	dev-libs/openssl:=
	dev-libs/flatbuffers:=
	dev-qt/qtbase:6=[gui,network,widgets]
	dev-qt/qt5compat:6=
	dev-qt/qtsvg:6=
"
RDEPEND="
	${DEPEND}
	dev-libs/opensc[pcsc-lite]
	nautilus? ( gnome-base/nautilus )
"
BDEPEND="
	dev-qt/qttools:6[linguist]
"
DOCS=( {README,RELEASE-NOTES}.md )

src_prepare() {
	if [[ -n ${PV%%*9999} ]]; then
		mv ../${MY_QC}/* ./common/
	fi
	sed \
		-e "s:doc/${PN}:doc/${PF}:" \
		-i CMakeLists.txt
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_KDE=no
		-DENABLE_NAUTILUS_EXTENSION=$(usex nautilus)
		-DCMAKE_CXX_COMPILER_AR=$(type -P $(tc-getBUILD_AR))
		-DCMAKE_CXX_COMPILER_RANLIB=$(type -P $(tc-getBUILD_RANLIB))
	)
	cmake_src_configure
}
