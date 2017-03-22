# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml(+)"
DISTUTILS_SINGLE_IMPL=1
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
PATCHES=(
	"${FILESDIR}"/${PN}-modpath.diff
)
S="${WORKDIR}/${P}/${PN}-trunk"

RDEPEND="
	${PYTHON_DEPS}
	dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	media-libs/mlt[python,${PYTHON_USEDEP}]
	gnome-base/librsvg:2[introspection]
	x11-libs/gtk+:3[introspection]
	frei0r? ( media-plugins/frei0r-plugins )
	swh? ( media-plugins/swh-plugins )
	gmic? ( media-gfx/gmic )
"
DEPEND="
	${RDEPEND}
"
DOCS=( AUTHORS README docs/{FAQ,KNOWN_ISSUES,RELEASE_NOTES,ROADMAP}.md )

src_compile() {
	rmloc() { rm -rf "${S}"/Flowblade/locale/${1}; }
	l10n_for_each_disabled_locale_do rmloc
	distutils-r1_src_compile
}
