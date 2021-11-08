# Copyright 2018-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs multiprocessing
MY_PN="${PN}-toolchain"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.${PN}.org/${MY_PN}.git"
else
	SRC_URI="
		https://download.${PN}.org/${PV}/${MY_PN}-${PV}.tar.xz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

DESCRIPTION="An open source cross-platform toolchain for building and packaging C++ code"
HOMEPAGE="https://build2.org"

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-db/sqlite:3
	dev-util/pkgconf:=
"
DEPEND="
	${RDEPEND}
"
PATCHES=(
	"${FILESDIR}"/${PN}-nousrlocal.diff
)

myb() {
	local myconfigargs=(
		--jobs $(makeopts_jobs)
		--verbose 2
		config.c="$(tc-getCC)"
		config.cxx="$(tc-getCXX)"
		config.cc.coptions="${CFLAGS}"
		config.cc.loptions="${LDFLAGS}"
		config.cxx.coptions="${CXXFLAGS}"
		config.cxx.loptions="${LDFLAGS}"
		config.bin.ar="$(tc-getAR)"
		config.bin.ranlib="$(tc-getRANLIB)"
		config.bin.lib=shared
		config.install.root="${ED}/usr/"
		config.install.lib="exec_root/$(get_libdir)"
		config.install.doc="data_root/share/doc/${PF}"
	)

	tc-is-gcc && export CCACHE_DISABLE=1
	set -- "${@}" "${myconfigargs[@]}"
	echo "${@}"
	"${@}" || die "${@} failed"
}

src_prepare() {
	local _pc="$(tc-getPKG_CONFIG)"
	printf 'cxx.libs += %s\ncxx.poptions += %s\n' \
		"$(${_pc} sqlite3 --libs)" "$(${_pc} sqlite3 --cflags)" >> \
		libodb-sqlite/buildfile
	printf 'cxx.libs += %s\ncxx.poptions += %s\n' \
		"$(${_pc} libpkgconf --libs)" "$(${_pc} libpkgconf --cflags)" >> \
		build2/libbuild2/cc/buildfile
	sed -e 's:lib\(pkgconf\|sqlite3\)/ ::g' -i buildfile
	rm -rf libpkgconf libsqlite3
	default
}

src_compile() {
	emake -C build2 -f bootstrap.gmake CXX=$(tc-getCXX)
	myb "${S}"/build2/build2/b-boot configure
}

src_install() {
	myb "${S}"/build2/build2/b-boot install: build2/ bpkg/ bdep/
	mkdir -p "${ED}"/usr/share/doc/${PF}/html
	mv -f "${ED}"/usr/share/doc/${PF}/*.xhtml "${ED}"/usr/share/doc/${PF}/html
}
