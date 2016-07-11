# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
PLOCALES="cs de es fi fr it"
inherit l10n gnome2 distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jliljebl/${PN}.git"
	SRC_URI=
else
	inherit vcs-snapshot
	SRC_URI="
		mirror://githubcl/jliljebl/${PN}/tar.gz/v${PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A non-linear PyGTK/MLT video editor"
HOMEPAGE="http://jliljebl.github.io/flowblade"

LICENSE="GPL-3"
SLOT="0"
IUSE="frei0r gmic swh"
PATCHES=( "${FILESDIR}" )
S="${WORKDIR}/${P}/${PN}-trunk"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"
RDEPEND="
	${PYTHON_DEPS}
	dev-python/pygtk:2
	dev-python/dbus-python
	dev-python/pillow
	dev-python/numpy
	dev-python/pycairo
	media-libs/mlt[python]
	frei0r? ( media-plugins/frei0r-plugins )
	swh? ( media-plugins/swh-plugins )
	gmic? ( media-gfx/gmic )
"
DEPEND=""
DOCS=( AUTHORS README docs/{FAQ,KNOWN_ISSUES,RELEASE_NOTES,ROADMAP}.md )

src_compile() {
	rmloc() {
		rm -rf "${S}"/Flowblade/locale/${1}
	}
	l10n_for_each_disabled_locale_do rmloc
	distutils-r1_src_compile
}
