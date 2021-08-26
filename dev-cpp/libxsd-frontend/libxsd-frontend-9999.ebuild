# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.codesynthesis.com/${PN}/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="04fbe05"
	[[ -n ${PV%%*_*} ]] && MY_PV="${PV}"
	SRC_URI="
		https://git.codesynthesis.com/cgit/${PN}/${PN}/snapshot/${MY_PV}.tar.gz
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit toolchain-funcs multiprocessing

DESCRIPTION="A compiler frontend for the W3C XML Schema definition language"
HOMEPAGE="https://www.codesynthesis.com/projects/libxsd-frontend/"
LICENSE="GPL-2"
SLOT="0/2.1.0-b.1.z"
IUSE="static-libs"
RDEPEND="
	>=dev-libs/xerces-c-3.0.0
	dev-libs/boost:=[threads]
	>=dev-cpp/libcutl-1.11.0_pre20210722:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-util/build2
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
