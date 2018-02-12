# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.codesynthesis.com/${PN}/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="dd5dbdd"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		https://git.codesynthesis.com/cgit/${PN}/${PN}/snapshot/${MY_PV}.tar.gz
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit toolchain-funcs

DESCRIPTION="A collection of C++ libraries (successor of libcult)"
HOMEPAGE="http://www.codesynthesis.com/projects/libcutl/"

LICENSE="MIT"
SLOT="0"
IUSE="static-libs"

RDEPEND="
"
DEPEND="
	${RDEPEND}
	dev-util/build2
	|| (
		>=sys-devel/gcc-4.7
		>=sys-devel/clang-3.5
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.10.0-fix-c++14.patch
)

src_prepare() {
	default

	# remove bundled libs
	rm -r cutl/details/{boost,expat} || die

	# ensure <regex> works on GCC 5 and below
	# bug 630016
	sed -e '/cxx.std =/s:=.*:= 14:' -i build/root.build
}

src_configure() {
	local myconfigargs=(
		config.cxx="$(tc-getCXX)"
		config.cxx.coptions="${CXXFLAGS}"
		config.cxx.loptions="${LDFLAGS}"
		config.bin.ar="$(tc-getAR)"
		config.bin.ranlib="$(tc-getRANLIB)"
		config.bin.lib="$(usex static-libs both shared)"
		config.install.root="${ED}/usr/"
		config.install.lib="exec_root/$(get_libdir)"
		config.install.doc="data_root/share/doc/${PF}"
	)

	b --verbose 3 \
		"${myconfigargs[@]}" \
		configure || die
}

src_compile() {
	b --verbose 3 || die
}

src_install() {
	b --verbose 3 install || die
	einstalldocs
}
