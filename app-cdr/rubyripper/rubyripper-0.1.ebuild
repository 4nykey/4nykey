# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit ruby

DESCRIPTION="An audioripper with the ultimate goal of providing perfect rips"
HOMEPAGE="http://rubyforge.org/projects/rubyripper/"
SRC_URI="http://rubyforge.org/frs/download.php/8289/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="dev-ruby/ruby-libglade2
	dev-ruby/ruby-freedb
	media-sound/cdparanoia
	app-cdr/cdrtools"

src_unpack() {
	unpack ${A}
	sed -i \
		"s:\./\(ripr\.rb\):\1:; s:\(rubyripper.glade\):/usr/share/${PN}/glade/\1:" \
		${S}/rubyripper.rb
}

src_install() {
	ruby_einstall
	SITEDIR=$(${RUBY} -r rbconfig -e 'print Config::CONFIG["sitedir"]')
	insinto /usr/share/${PN}/glade
	doins ${S}/rubyripper.glade
	touch ${T}/blah
	echo -e "#\x21/bin/sh\n${RUBY} ${SITEDIR}/${PN}.rb" > ${T}/blah
	newbin ${T}/blah ${PN}
}
