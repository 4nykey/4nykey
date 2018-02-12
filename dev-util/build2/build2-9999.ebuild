# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs
MY_PN="${PN}-toolchain"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.${PN}.org/${MY_PN}.git"
else
	inherit vcs-snapshot
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
IUSE=""

RDEPEND="
	dev-db/sqlite:3
"
DEPEND="${RDEPEND}"

src_prepare() {
	local _pc="$(tc-getPKG_CONFIG)"
	printf 'cxx.libs += %s\ncxx.poptions += %s\n' \
		"$(${_pc} sqlite3 --libs)" "$(${_pc} sqlite3 --cflags)" >> \
		libodb-sqlite/buildfile
	sed \
		-e 's:libsqlite3[/]\?::' \
		-i buildfile build/bootstrap.build

	sed \
		-e '/-o build2\/b-boot/ s:"\$cxx" :&${CXXFLAGS} ${LDFLAGS} :' \
		-i ${PN}/bootstrap.sh

	default
}

src_compile() {
	local myconfigargs=(
		--verbose 3
		config.cxx="$(tc-getCXX)"
		config.cc.coptions="${CFLAGS}"
		config.cc.loptions="${LDFLAGS}"
		config.cxx.coptions="${CXXFLAGS}"
		config.cxx.loptions="${LDFLAGS}"
		config.bin.ar="$(tc-getAR)"
		config.bin.ranlib="$(tc-getRANLIB)"
		config.install.root="${ED}/usr/"
		config.install.lib="exec_root/$(get_libdir)"
		config.install.doc="data_root/share/doc/${PF}"
	)

	cd ${PN}
	./bootstrap.sh $(tc-getCXX) || die

	./build2/b-boot \
		"${myconfigargs[@]}" \
		config.bin.lib=static \
		|| die

	cd "${S}"
	./build2/build2/b \
		"${myconfigargs[@]}" \
		config.bin.lib=shared \
		configure || die

	./build2/build2/b --verbose 3 || die
}

src_install() {
	./build2/build2/b --verbose 3 install || die
	einstalldocs
}
