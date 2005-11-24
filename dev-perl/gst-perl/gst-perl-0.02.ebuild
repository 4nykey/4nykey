# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-module

DESCRIPTION="GStreamer Perl bindings"
SRC_URI_BASE="mirror://cpan/authors/id/F/FO/FOOF"
SRC_URI="mirror://sourceforge/gtk2-perl/GStreamer-${PV}.tar.gz"
HOMEPAGE="http://gtk2-perl.sourceforge.net/"
S="${WORKDIR}/GStreamer-${PV}"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE=""

DEPEND="${DEPEND}
	media-libs/gstreamer"
