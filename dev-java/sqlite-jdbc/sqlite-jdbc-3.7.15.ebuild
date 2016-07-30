# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils toolchain-funcs versionator java-pkg-2
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/xerial/${PN}.git"
	# defined in VERSION
	SLOT="3.13.0"
	MY_SQL="2016/sqlite-amalgamation-"
else
	inherit vcs-snapshot
	SRC_URI="
		mirror://githubcl/xerial/${PN}/tar.gz/02cae28 -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
	SLOT="$(get_version_component_range -3)"
	MY_SQL="sqlite-amalgamation-"
fi
MY_SQL="${MY_SQL}$(printf '%d%02d%02d' ${SLOT//./ })00"
SRC_URI="
	${SRC_URI}
	http://www.sqlite.org/${MY_SQL}.zip
"
RESTRICT="primaryuri"

DESCRIPTION="A library for accessing and creating SQLite database files in Java"
HOMEPAGE="https://github.com/xerial/${PN}"
LICENSE="Apache-2.0"
IUSE=""

DEPEND="
	>=virtual/jdk-1.6
	dev-java/maven-bin
"
RDEPEND="
	>=virtual/jre-1.6
	dev-db/sqlite:3
"

my_mvn() {
	mvn -Dmaven.repo.local="${S}/homedir/.m2" ${@} || die
}

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		git-r3_src_unpack
		default
	else
		vcs-snapshot_src_unpack
	fi
}

src_prepare() {
	default
	java-pkg-2_src_prepare

	mkdir -p "${S}"/target
	ln -s "${DISTDIR}"/${MY_SQL#*/}.zip "${S}"/target/sqlite-${SLOT}-amal.zip
	mv "${WORKDIR}"/${MY_SQL#*/} "${S}"/target/
	touch "${S}"/target/sqlite-unpack.log
}

src_compile() {
	my_mvn -Dmaven.test.skip=true package
	emake CC="$(tc-getCC)" STRIP="/bin/true" native
}

src_test() {
	my_mvn test
}

src_install() {
	local _d="sqlite-${SLOT}-Linux-$(usex amd64 amd64 i386)"
	java-pkg_doso "${S}"/target/${_d}/libsqlitejdbc.so

	_d=$(egrep -m1 -o "${SLOT}[^<]+" "${S}"/pom.xml)
	java-pkg_newjar "${S}"/target/${PN}-${_d}.jar

	einstalldocs
}
