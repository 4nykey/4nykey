# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.codesynthesis.com/${PN}/${PN}.git"
else
	MY_PV="2056629"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV/_beta/-b.}"
	SRC_URI="
		https://git.codesynthesis.com/cgit/${PN}/${PN}/snapshot/${MY_PV}.tar.gz
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PV}"
fi
inherit toolchain-funcs multiprocessing

DESCRIPTION="A collection of C++ libraries (successor of libcult)"
HOMEPAGE="https://www.codesynthesis.com/projects/libcutl/"

LICENSE="MIT"
SLOT="0/1.11.0-b.8.z"
IUSE="static-libs"

RDEPEND="
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/build2-0.13.0
"

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

	MAKE=b \
	MAKEOPTS="--jobs $(makeopts_jobs) --verbose 3" \
	emake \
		"${myconfigargs[@]}" \
		configure
}

src_compile() {
	tc-is-gcc && export CCACHE_DISABLE=1
	set -- b --jobs $(makeopts_jobs) --verbose 3
	echo "${@}"
	"${@}" || die "b failed"
}

src_test() {
	MAKE=b \
	MAKEOPTS="--jobs $(makeopts_jobs)" \
	emake test
}

src_install() {
	MAKE=b \
	MAKEOPTS="--jobs $(makeopts_jobs) --verbose 3" \
	emake install
	einstalldocs
}
