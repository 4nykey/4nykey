# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="An audioripper with the ultimate goal of providing perfect rips"
HOMEPAGE="http://rubyforge.org/projects/rubyripper/"
SRC_URI="http://rubyforge.halostatue.info/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="gtk"

RDEPEND="gtk? ( dev-ruby/ruby-libglade2 )
	dev-ruby/ruby-freedb
	media-sound/cdparanoia
	app-cdr/cdrtools"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i "s:\./\(rr_lib\.rb\):\1:" rubyripper_*.rb
	sed -i "s:\(rubyripper.glade\):/usr/share/${PN}/glade/\1:" \
		${S}/rubyripper_gtk2.rb
}

src_install() {
	local sitelibdir
	sitelibdir=$(${RUBY} -r rbconfig -e 'print Config::CONFIG["sitelibdir"]')
	insinto ${sitelibdir}
	doins rr_lib.rb rubyripper_cli.rb
	echo -e "#!/bin/sh\n${RUBY} ${sitelibdir}/rubyripper_cli.rb" > ${T}/blah
	newbin ${T}/blah rubyripper
	if use gtk; then
		doins rubyripper_gtk2.rb
		echo -e "#!/bin/sh\n${RUBY} ${sitelibdir}/rubyripper_gtk2.rb" > ${T}/blah
		newbin ${T}/blah rubyripper-gui
		insinto /usr/share/${PN}/glade
		doins ${S}/rubyripper.glade
	fi
	dodoc README
}
