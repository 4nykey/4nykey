# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-module eutils

DESCRIPTION="Client-side interface to the X11 Protocol"
HOMEPAGE="http://www.cpan.org/modules/by-module/X11/${P}.readme"
SRC_URI="http://www.cpan.org/modules/by-module/X11/${P}.tar.gz"

LICENSE="Artistic X11"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="virtual/x11"
