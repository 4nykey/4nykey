# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit confutils

DESCRIPTION="FBReader is an e-book reader for various platforms"
HOMEPAGE="http://www.fbreader.org/"
SRC_URI="http://www.fbreader.org/${PN}-sources-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="gtk qt3 qt4 debug verbose-build"

RDEPEND="
	dev-libs/expat
	app-i18n/enca
	sys-libs/zlib
	app-arch/bzip2
	dev-libs/liblinebreak
	net-misc/curl
	dev-libs/fribidi
	gtk? ( >=x11-libs/gtk+-2.4 )
	qt3? ( x11-libs/qt:3 )
	qt4? ( x11-libs/qt-gui )
"
DEPEND="
	${RDEPEND}
	sys-apps/gawk
"

pkg_setup() {
	confutils_require_any gtk qt3 qt4
}

src_unpack() {
	unpack ${A}
	cd ${S}

	sed -i Makefile \
		-e "s:zlibrary/ui::" \

	cd makefiles

	use verbose-build && \
	sed -i *.mk \
		-e "/@echo/d" \
		-e 's:@\$:$:' \

	sed -i config.mk \
		-e "s:-O3:${CXXFLAGS}:" \
		-e "s: -s: ${LDFLAGS}:" \

	sed -i arch/desktop.mk \
		-e "s:moc-qt3:${QTDIR}/bin/moc:" \
		-e "s:-I.*qt3:-I${QTDIR}/include:" \
		-e "s:moc-qt4:/usr/bin/moc:" \
		-e "s:-lqt-mt:-L${QTDIR}/lib &:" \
		-e "s:-lQtGui:-L/usr/lib/qt4 &:" \

cat << EOF > platforms.mk
TARGET_STATUS = $(usev debug || echo release)
TARGET_ARCH = desktop
INSTALLDIR=${ROOT}usr
LIBDIR=${ROOT}usr/$(get_libdir)
DESTDIR=${D}
EOF
}

src_compile() {
	emake || die "emake failed"

	local u
	_uis=" $(usev gtk; usev qt3; usev qt4)"
	for u in $_uis; do
		emake UI_TYPE=${u%3} -C zlibrary/ui || die
	done
}

src_install() {
	local u

	emake do_install || die

	for u in $_uis; do
		emake UI_TYPE=${u%3} -C zlibrary/ui do_install || die
		make_wrapper ${PN}-${u} "FBReader -zlui ${u%3}"
	done

}
