# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit python eutils

DESCRIPTION="A viewer for dictionaries in SDictionary format"
HOMEPAGE="http://dmych.wikispaces.com/SdiQt"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="qt3"

DEPEND=""
RDEPEND="
	>=virtual/python-2.4
	qt3? ( dev-python/PyQt )
"

DEST="/usr/lib/${PN}"

dolauncher() {
cat << EOF > ${T}/${PN}
#!/bin/sh
/usr/bin/python ${DEST}/${PN}.py
EOF
dobin ${T}/${PN}
}

pkg_setup() {
	use !qt3 && python_tkinter_exists
}

src_install() {
	dolauncher
	insinto ${DEST}
	doins *.p{y,ng}
	dodoc README THANKS
	doicon sdiqt.png
	make_desktop_entry ${PN} SdiQt
}

pkg_postinst() {
	python_mod_optimize ${ROOT}${DEST}
}

pkg_postrm() {
	python_mod_cleanup ${ROOT}${DEST}
}
