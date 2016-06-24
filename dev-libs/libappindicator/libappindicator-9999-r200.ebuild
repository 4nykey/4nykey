# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libappindicator/libappindicator-12.10.0.ebuild,v 1.3 2013/05/12 14:40:30 pacho Exp $

EAPI=6
VALA_MIN_API_VERSION="0.16"
VALA_USE_DEPEND="vapigen"
PYTHON_COMPAT=( python2_7 )
DBUSMENU="libdbusmenu-12.10.2"

inherit autotools python-single-r1 vala
if [[ -z ${PV%%*9999} ]]; then
	inherit bzr
	EBZR_REPO_URI="lp:${PN}"
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="
		http://launchpad.net/${PN}/${PV%.*}/${PV}/+download/${P}.tar.gz
		http://launchpad.net/dbusmenu/${PV%.*}/${DBUSMENU#*-}/+download/${DBUSMENU}.tar.gz
	"
	RESTRICT="primaryuri"
fi

DESCRIPTION="A library to allow applications to export a menu into the Unity Menu bar"
HOMEPAGE="http://launchpad.net/libappindicator"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="2"
IUSE="doc +introspection python static-libs"

RDEPEND="
	>=dev-libs/dbus-glib-0.98
	>=dev-libs/glib-2.26
	>=dev-libs/libindicator-12.10.0:0
	x11-libs/gtk+:2
	introspection? ( >=dev-libs/gobject-introspection-1 )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	introspection? ( $(vala_depend) )
	doc? ( dev-util/gtk-doc )
"

src_unpack() {
	DBUSMENU="${WORKDIR}/${DBUSMENU}"
	if [[ -z ${PV%%*9999} ]]; then
		bzr_fetch
		EBZR_REPO_URI="lp:libdbusmenu" EBZR_PROJECT="libdbusmenu" \
		EBZR_UNPACK_DIR="${DBUSMENU}" bzr_fetch
	else
		default
	fi
}

src_prepare() {
	default
	# build and link against static libdbusmenu
	echo "AC_CONFIG_SUBDIRS(${DBUSMENU#${S}/})" >> "${S}"/configure.ac
	sed \
		-e "s:\$(LIBRARY_LIBS):& \
			${DBUSMENU}/libdbusmenu-glib/libdbusmenu-glib.la\
			${DBUSMENU}/libdbusmenu-gtk/libdbusmenu-gtk.la:"\
		-i src/Makefile.am || die
	sed \
		-e 's:dbusmenu-gtk-0.4 >= [\\]*\$DBUSMENUGTK_REQUIRED_VERSION::' \
		-i configure.ac || die
	sed -e 's:dbusmenu-glib-0.4 ::' -i src/appindicator-0.1.pc.in || die

	# Disable MONO for now because of http://bugs.gentoo.org/382491
	sed \
		-e '/^MONO_REQUIRED_VERSION/s:=.*:=9999:' \
		-i configure.ac || die

	sed -e 's:-Werror::' -i src/Makefile.am || die

	if use !python; then
		sed -e '/python/d' -i bindings/Makefile.am || die
	fi

	sed \
		-e '/indicator_desktop_shortcuts_nick_exec_with_context/d' \
		-i src/app-indicator.c
	
	if use !doc; then
		_d=( $(grep -rl 'gtk\-doc\.make' "${WORKDIR}") )
		[[ -n ${_d} ]] && sed \
			-e '/gtk-doc\.make/d' \
			-e '/EXTRA_DIST/ s:+=:=:' \
			-i ${_d[@]}
	fi

	use introspection && vala_src_prepare

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-silent-rules
		--disable-tests
		--with-gtk=${SLOT}
		$(use_enable doc gtk-doc)
		$(use_enable doc gtk-doc-html)
	)

	CPPFLAGS="-I${DBUSMENU}" econf \
		"${myeconfargs[@]}" \
		$(use_enable static-libs static)

	cd ${DBUSMENU}
	HAVE_VALGRIND_FALSE='true' econf \
		"${myeconfargs[@]}" \
		--enable-static \
		--disable-shared \
		--with-pic
}

src_compile() {
	emake -C ${DBUSMENU}/libdbusmenu-glib
	emake -C ${DBUSMENU}/libdbusmenu-gtk
	default
}

src_install() {
	default
	prune_libtool_files --modules
	use doc || rm -rf "${ED}"/usr/share/gtk-doc
}
