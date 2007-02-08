# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git distutils

DESCRIPTION="Chalyx Python music player service abstraction library"
HOMEPAGE="http://eleusis.f2o.org/projects/xmms2/chalyx"
EGIT_REPO_URI="git://git.xmms.se/xmms2/${PN}.git"

LICENSE=""
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND="media-sound/xmms2"

PYTHON_MODNAME="Chalyx"

pkg_setup() {
	if ! built_with_use 'media-sound/xmms2' 'python'; then
		eerror "No go, need xmms2 python bindings"
		die "remerge xmms2 with 'python' in USE"
	fi
}
