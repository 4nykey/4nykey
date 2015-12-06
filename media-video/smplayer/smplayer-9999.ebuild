# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PLOCALES="
ar_SY ar bg ca cs da de el_GR en_GB en_US es et eu fi fr gl he_IL hr hu id
it ja ka ko ku lt mk ms_MY nl nn_NO pl pt_BR pt ro_RO ru_RU sk sl_SI sq_AL
sr sv th tr uk_UA uz vi_VN zh_CN zh_TW
"
PLOCALE_BACKUP="en_US"

inherit l10n qmake-utils

if [[ -z ${PV%%*9999} ]]; then
	inherit subversion
	ESVN_REPO_URI="https://subversion.assembla.com/svn/${PN}/${PN}/trunk"
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Great Qt GUI front-end for mplayer/mpv"
HOMEPAGE="http://smplayer.info/"
LICENSE="GPL-2 BSD"
SLOT="0"
IUSE="autoshutdown bidi debug mpris qt4 qt5 skins streaming themes"
REQUIRED_USE="^^ ( qt4 qt5 )"

DEPEND="
	qt4? (
		dev-qt/qtgui:4
		dev-qt/qtsingleapplication[X,qt4]
		autoshutdown? ( dev-qt/qtdbus:4 )
		mpris? ( dev-qt/qtdbus:4 )
		streaming? ( dev-qt/qtcore:4[ssl] )
	)
	qt5? (
		>=dev-qt/qtsingleapplication-2.6.1_p20150629[X,qt5]
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
		mpris? ( dev-qt/qtdbus:5 )
		streaming? (
			dev-qt/qtnetwork:5[ssl]
			dev-qt/qtscript:5
		)
	)
"
RDEPEND="
	${DEPEND}
	|| (
		media-video/mplayer[bidi?,libass,png,X]
		(
			>=media-video/mpv-0.6.2[libass,X]
			streaming? ( >=net-misc/youtube-dl-2014.11.26 )
		)
	)
	skins? ( x11-themes/smplayer-skins )
	themes? ( x11-themes/smplayer-themes )
"

src_prepare() {
	# Upstream Makefile sucks
	sed \
		-e "/^PREFIX=/s:/usr/local:${EPREFIX}/usr:" \
		-e "/^DOC_PATH=/s:packages/smplayer:${PF}:" \
		-e '/tar -C docs/d' \
		-e '/\.\/get_svn_revision\.sh/,+2c\\tcd src && $(DEFS) $(MAKE)' \
		-i "${S}"/Makefile || die "sed failed"

	# Toggle autoshutdown option which pulls in dbus, bug #524392
	if ! use autoshutdown ; then
		sed -e 's:DEFINES += AUTO_SHUTDOWN_PC:#&:' \
			-i "${S}"/src/smplayer.pro || die "sed failed"
	fi

	# Turn debug message flooding off
	if ! use debug ; then
		sed -e '/NO_DEBUG_ON_CONSOLE/s:#::' \
			-i "${S}"/src/smplayer.pro || die "sed failed"
	fi

	# MPRIS2 pulls in dbus, bug #553710
	if ! use mpris ; then
		sed -e 's:DEFINES += MPRIS2:#&:' \
			-i "${S}"/src/smplayer.pro || die "sed failed"
	fi

	# Turn off online update checker, bug #479902
	sed \
		-e 's:DEFINES += UPDATE_CHECKER:#&:' \
		-e 's:DEFINES += CHECK_UPGRADED:#&:' \
		-i "${S}"/src/smplayer.pro || die "sed failed"

	# Turn off nasty share widget
	sed -e 's:DEFINES += SHAREWIDGET:#&:' \
		-i "${S}"/src/smplayer.pro || die "sed failed"

	# Turn off youtube support (which pulls in extra dependencies) if unwanted
	if ! use streaming ; then
		sed -e 's:DEFINES += YOUTUBE_SUPPORT:#&:' \
		-i "${S}"/src/smplayer.pro || die "sed failed"
	fi

	#l10n_find_plocales_changes "${S}/src/translations" "${PN}_" '.ts'

	# remove unneeded copies of licenses
	rm -rf Copying* docs
}

src_configure() {
	cd "${S}"/src
	echo "#define SVN_REVISION \"${ESVN_WC_REVISION:-${PV}} (Gentoo)\"" > \
		svn_revision.h
	use qt4 && eqmake4 || eqmake5
}

src_compile() {
	local _qt="$(usex qt4 $(qt4_get_bindir) $(qt5_get_bindir))"
	gen_translation() {
		ebegin "Generating $1 translation"
		${_qt}/lrelease "${S}"/src/translations/${PN}_${1}.ts
		eend $? || die "failed to generate $1 translation"
	}
	emake
	l10n_for_each_locale_do gen_translation
}
