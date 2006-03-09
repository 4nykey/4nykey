# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/mail-notification/mail-notification-1.0.ebuild,v 1.4 2005/01/12 16:47:15 slarti Exp $

inherit gnome2 eutils

DESCRIPTION="A GNOME trayicon which checks for mail supporting mbox, MH,
Maildir, IMAP, Sylpheed, POP3, Gmail. Authenticates via apop, ssl, sasl."
HOMEPAGE="http://www.nongnu.org/mailnotify/"
SRC_URI="http://savannah.nongnu.org/download/mailnotify/${P}.tar.gz"

KEYWORDS="~x86 ~amd64 ~ppc"
SLOT="0"
LICENSE="GPL-2"

IUSE="imap ipv6 mbox mh maildir pop3 ssl sasl sylpheed gmail eds maildir"

DEPEND=">=x11-libs/gtk+-2.6
	>=dev-util/gob-2
	>=gnome-base/gnome-panel-2.6
	>=gnome-base/eel-2.6
	>=gnome-base/gconf-2.6
	>=gnome-base/libgnomeui-2.6
	>=gnome-base/libglade-2
	>=gnome-base/orbit-2
	>=dev-libs/gmime-2.1
	dev-perl/XML-Parser
	ssl? ( >=dev-libs/openssl-0.9.5b )
	sasl? ( >=dev-libs/cyrus-sasl-2 )
	gmail? ( >=net-libs/libsoup-2.2 )
	eds? ( >=mail-client/evolution-2.2 )"

G2CONF="	$(use_enable ssl) \
			$(use_enable sasl) \
			$(use_enable ipv6) \
			$(use_enable imap) \
			$(use_enable mbox) \
			$(use_enable mh) \
			$(use_enable pop3) \
			$(use_enable sylpheed) \
			$(use_enable maildir)"


# We need evo-sources for building evolution-support
# Disabled for now
#
#			$(use_enable eds evolution)
#			$(use_enable eds evolution-source-dir=$HOME/.evolution)"

src_unpack() {

	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/mail-notification-2.0-buildfix.diff 
	epatch ${FILESDIR}/mail-notification-2.0-gmail-properties-fix.diff

}

pkg_postinstall() {

	einfo "Due to a bug in bonobo-activation your session must be"
	einfo "restarted after installing Mail-Notification."

}
