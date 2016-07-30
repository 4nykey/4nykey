# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit versionator java-pkg-2 java-pkg-simple

MY_PV="$(replace_all_version_separators _)"
DESCRIPTION="SimMetrics is a Similarity Metric Library"
HOMEPAGE="https://sourceforge.net/projects/simmetrics"
SRC_URI="mirror://sourceforge/${PN}/simmetrics_source/${PN}_v${MY_PV}/${PN}_src_v${MY_PV}_d07_02_07.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND="
	>=virtual/jre-1.5
"
DEPEND="
	>=virtual/jdk-1.5
	app-arch/unzip
	dev-java/junit:4
"
JAVA_SRC_DIR="src/uk/ac/shef/wit/${PN}"

src_prepare() {
	default
	java-pkg-2_src_prepare
	JAVA_GENTOO_CLASSPATH_EXTRA="$(java-pkg_getjars --build-only junit-4)"
}
