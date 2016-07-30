# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A Java PNG Decoder"
HOMEPAGE="https://code.google.com/archive/p/javapng"
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/${PN}/${P}-src.jar"

LICENSE="GPL-2-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND="
	>=virtual/jre-1.5
"
DEPEND="
	>=virtual/jdk-1.5
	app-arch/unzip
	dev-java/ant-core:0
	dev-java/jarjar:1
	dev-java/junit:4
	dev-java/xml-writer:0
"

EANT_BUILD_TARGET=""
EANT_DOC_TARGET=""

src_prepare() {
	default
	java-pkg-2_src_prepare
	java-ant_rewrite-classpath
	#java-pkg_clean
	rm -f libdev/*.jar
	EANT_EXTRA_ARGS="-Dgentoo.classpath=$(java-pkg_getjars --build-only ant-core,junit-4,jarjar-1,xml-writer)"
}

src_install() {
	java-pkg_newjar dist/${P}.jar
	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc src
}
