# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
PYTHON_REQ_USE="sqlite"
DISTUTILS_USE_PEP517=setuptools
PLOCALES="cs de el en es fr it ko nl pt_BR ru ta tr uk"

MY_PN="PFS"
inherit distutils-r1 optfeature plocale xdg
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/PhotoFilmStrip/${MY_PN}.git"
else
	MY_PV="4275414"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/PhotoFilmStrip/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${MY_PV#v}"
fi

DESCRIPTION="Movie slideshow creator using Ken Burns effect"
HOMEPAGE="https://github.com/PhotoFilmStrip/${MY_PN}"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc nls"

RDEPEND="
	x11-libs/gtk+:3[introspection]
	dev-python/gst-python[${PYTHON_USEDEP}]
	media-libs/gstreamer-editing-services[introspection,${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	>=dev-python/wxpython-4.2.2:4.0[${PYTHON_USEDEP}]
	media-libs/gst-plugins-bad
	media-libs/gst-plugins-good
	media-libs/gst-plugins-ugly
	media-plugins/gst-plugins-libav
"
BDEPEND="
	dev-python/python-gettext[${PYTHON_USEDEP}]
"
distutils_enable_tests pytest
distutils_enable_sphinx docs/help --no-autodoc

src_prepare() {
	default

	# fix 'unexpected path' QA warning on einstalldocs
	sed -i 's|"share", "doc", "photofilmstrip"|"share", "doc", "'${PF}'"|g' setup.py ||
	die "Fixing unexpected path failed."

	# fix a QA issue with .desktop file
	sed -i '/Version=/d' data/photofilmstrip.desktop || die "Failed to update .desktop file."

	sed -e 's:True if Sphinx else ::' -i setup.py
}

python_install_all() {
	distutils-r1_python_install_all
	doman docs/manpage/*.1
	use nls || return
	local _p=PhotoFilmStrip
	_domo() {
		cp "${S}"/build/mo/${1}/LC_MESSAGES/${_p}.mo ${1}.mo
		MOPREFIX=${_p} domo ${1}.mo
	}
	plocale_for_each_locale _domo
}

pkg_postinst() {
	xdg_icon_cache_update

	optfeature "additional rendering formats" media-plugins/gst-plugins-bad
	optfeature "additional rendering formats" media-plugins/gst-plugins-good
	optfeature "additional rendering formats" media-plugins/gst-plugins-ugly
	optfeature "ogg/theora support" media-libs/gst-plugins-base[theora]
	optfeature "h264 (MKV/MP4) support" media-plugins/gst-plugins-x264
	optfeature "h265 (MKV) support" media-plugins/gst-plugins-x265
	optfeature "MPEG 1/2 (DVD) support" media-plugins/gst-plugins-mpeg2enc
}
