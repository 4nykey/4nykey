# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/smplayer/smplayer-14.9.0.ebuild,v 1.1 2014/09/24 07:33:47 yngwin Exp $

EAPI=5
PLOCALES="ar_SY bg ca cs da de el_GR en_US es et eu fi fr gl he_IL hr hu it ja
ka ko ku lt mk ms_MY nl pl pt pt_BR ro_RO ru_RU sk sl_SI sr sv th tr uk_UA vi_VN
zh_CN zh_TW"
PLOCALE_BACKUP="en_US"

inherit l10n qmake-utils subversion

ESVN_REPO_URI="https://subversion.assembla.com/svn/smplayer/smplayer/trunk"

DESCRIPTION="Great Qt4 GUI front-end for mplayer"
HOMEPAGE="http://smplayer.sourceforge.net/"
LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug qt4 qt5 skins themes"
REQUIRED_USE="^^ ( qt4 qt5 )"

DEPEND="
	qt4? (
		dev-qt/qtgui:4
	)
	qt5? (
		dev-qt/qtxml:5
		dev-qt/qtwidgets:5
	)
"
COMMON_USE="libass,png,X"
RDEPEND="
	${DEPEND}
	|| (
		media-video/mplayer[bidi,${COMMON_USE}]
		media-video/mplayer2[${COMMON_USE}]
	)
	skins? ( x11-themes/smplayer-skins )
	themes? ( x11-themes/smplayer-themes )
"

gen_translation() {
	ebegin "Generating $1 translation"
	lrelease ${PN}_${1}.ts
	eend $? || die "failed to generate $1 translation"
}

src_prepare() {
	# Upstream Makefile sucks
	sed -i \
		-e "/^PREFIX=/s:/usr/local:${EPREFIX}/usr:" \
		-e "/^DOC_PATH=/s:packages/smplayer:${PF}:" \
		-e '/tar -C docs/d' \
		-e '/\.\/get_svn_revision\.sh/,+2c\\tcd src && $(DEFS) $(MAKE)' \
		"${S}"/Makefile || die "sed failed"

	# Turn debug message flooding off
	if ! use debug ; then
		sed -i '/NO_DEBUG_ON_CONSOLE/s:#::' \
			"${S}"/src/smplayer.pro || die "sed failed"
	fi

	# Turn off online update checker, bug #479902
	sed \
		-e 's:DEFINES += UPDATE_CHECKER:#&:' \
		-e 's:DEFINES += CHECK_UPGRADED:#&:' \
		-i "${S}"/src/smplayer.pro || die "sed failed"

	# l10n_find_plocales_changes "${S}/src/translations" "${PN}_" '.ts'

	echo "#define SVN_REVISION \"SVN-${ESVN_WC_REVISION} (Gentoo)\"" > src/svn_revision.h

	# remove unneeded copies of licenses
	rm -rf Copying*
}

src_configure() {
	cd "${S}"/src
	use qt4 && eqmake4 || eqmake5
}

src_compile() {
	emake

	cd "${S}"/src/translations
	l10n_for_each_locale_do gen_translation
}
