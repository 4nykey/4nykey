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

	use verbose-build && epatch ${FILESDIR}/${PN}-verbose-build.diff

	cd makefiles

	sed -i config.mk \
		-e "s:-O3:${CXXFLAGS}:" \
		-e "s: -s: ${LDFLAGS}:" \

	sed -i arch/desktop.mk \
		-e "s:moc-qt3:${QTDIR}/bin/moc:" \
		-e "s:-I.*qt3:-I${QTDIR}/include:" \
		-e "s:moc-qt4:/usr/bin/moc:" \
		-e "s:-lqt-mt:-L${QTDIR}/lib &:" \
		-e "s:-lQtGui:-L/usr/lib/qt4 &:" \

	echo 'include $(ROOTDIR)/makefiles/target.mk' > platforms.mk

cat << EOF > target.mk
TARGET_STATUS = $(usev debug || echo release)
TARGET_ARCH = desktop
INSTALLDIR=${ROOT}usr
LIBDIR=${ROOT}usr/$(get_libdir)
DESTDIR=${D}
EOF
}

src_compile() {
	local d u

	for d in $(awk -F= '/DIRS[ ]*=/ {printf $2}' Makefile); do
		if [[ ${d#*/} = ui ]]; then
			_ui_dir=$d
		else
			_dirs+=" $d"
			emake -C $d || die "emake $d failed"
		fi
	done

	for u in $(usev gtk; usev qt3; usev qt4); do
		_uis+=" $u"
		emake \
			UI_TYPE=${u%3} \
			-C $_ui_dir \
			|| die
	done
}

src_install() {
	local d u

	for d in $_dirs; do
		emake -C $d do_install || die "emake install $d failed"
	done

	for u in $_uis; do
		emake UI_TYPE=${u%3} -C $_ui_dir do_install || \
			die "emake install $_ui_dir/$u failed"
		make_wrapper ${PN}-$u "FBReader -zlui ${u%3}"
	done

}
