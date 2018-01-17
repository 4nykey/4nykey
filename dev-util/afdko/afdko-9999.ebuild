# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
MULTILIB_COMPAT=( abi_x86_32 )
inherit vcs-snapshot distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-type-tools/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="c2d0a36"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/adobe-type-tools/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
SRC_URI+="https://github.com/adobe-type-tools/afdko/commit/49527cd.patch"
RESTRICT="primaryuri"
inherit multilib-build

DESCRIPTION="Adobe Font Development Kit for OpenType"
HOMEPAGE="http://www.adobe.com/devnet/opentype/afdko.html"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-python/fonttools-3.19.1[${PYTHON_USEDEP}]
	dev-python/booleanOperations[${PYTHON_USEDEP}]
	dev-python/fontMath[${PYTHON_USEDEP}]
	dev-python/robofab[${PYTHON_USEDEP}]
	dev-python/defcon[${PYTHON_USEDEP}]
	dev-python/MutatorMath[${PYTHON_USEDEP}]
	dev-python/ufoLib[${PYTHON_USEDEP}]
	dev-python/ufoNormalizer[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
DOCS=(
{README,NEWS}.rst
html
FDK/FDKReleaseNotes.txt
)

python_prepare_all() {
	mv -f afdko FDK
	eapply -R "${DISTDIR}"/49527cd.patch
	local PATCHES=(
		"${FILESDIR}"/${PN}-makeotf.diff
		"${FILESDIR}"/${PN}-inc.diff
		"${FILESDIR}"/${PN}-ar.diff
		"${FILESDIR}"/${PN}-ufo3.diff
		"${FILESDIR}"/${PN}-gsub.diff #ae4a57f
		"${FILESDIR}"/${PN}-setup.diff
	)
	distutils-r1_python_prepare_all
	mkdir -p afdko/Tools html
	mv -f FDK/__init__.py afdko/
	mv -f FDK/Tools/{linux,SharedData,__init__.py} afdko/Tools/
	mv -f FDK/*.html html/
}

src_compile() {
	tc-export CC CPP AR
	local _d _i
	tc-is-gcc && _i=" -D__NO_STRING_INLINES"
	find -path '*/linux/gcc/release/Makefile' | while read _d; do
		emake -C "${_d%/Makefile}" \
			XFLAGS="${CFLAGS_x86} ${CFLAGS}${_i}" || return
	done
	find -path '*exe/linux/release/*' -execdir mv -f -t "${S}"/afdko/Tools/linux {} +
	distutils-r1_src_compile
}
