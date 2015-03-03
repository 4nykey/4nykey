# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/lastpass/lastpass-3.1.61.ebuild,v 1.4 2014/10/19 06:41:17 robbat2 Exp $

EAPI=5
inherit unpacker nsplugins

DESCRIPTION="Online password manager and form filler that makes web browsing easier and more secure"
HOMEPAGE="https://lastpass.com/misc_download2.php"

LICENSE="LastPass"
SLOT="0"
KEYWORDS= #"-* ~x86 ~amd64"
IUSE="+chromium +firefox"
RESTRICT="strip mirror" # We can't mirror it, but we can fetch it

DEPEND="
	net-misc/wget
"
RDEPEND="
	chromium? ( || (
		>=www-client/chromium-32.0.1700.102
		www-client/google-chrome
		www-client/google-chrome-beta
		www-client/google-chrome-unstable
	) )
	firefox? ( www-client/firefox )
"
REQUIRED_USE="|| ( firefox chromium )"

LASTPASS_EXEDIR="/opt/lastpass/"

QA_PREBUILT="
	${LASTPASS_EXEDIR}*nplastpass*
	/usr/lib*/firefox/browser/extensions/support@lastpass.com/platform/Linux_x86*-gcc3/components/lpxpcom*.so
"

S="${WORKDIR}"

src_unpack() {
	# upstream has no versioned distfiles, so it's a live ebuild of sorts
	MAINDISTFILE=lplinux.tar.bz2
	_xpi='lp_linux.xpi'
	_crx='lpchrome_linux.crx'
	wget --no-verbose --directory-prefix=${S} \
		https://lastpass.com/${MAINDISTFILE} \
		https://lastpass.com/${_crx} \
		$(usex firefox "https://lastpass.com/${_xpi}" '') || die
	unpacker ${MAINDISTFILE}
	unpack_zip "${S}"/${_crx} 2>/dev/null
	use firefox && xpi_unpack "${S}"/${_xpi}
}

src_install() {
	# This is based on the upstream installer script that's in the tarball
	local _bin="nplastpass$(usex amd64 '64' '')"
	exeinto ${LASTPASS_EXEDIR}
	doexe "${S}"/*${_bin}*

	# despite the name, this piece seems used by both firefox+chrome
	inst_plugin ${LASTPASS_EXEDIR}lib${_bin}.so

	cat >"${T}"/lastpass_policy.json <<-EOF
	{
		"ExtensionInstallSources": [
			"https://lastpass.com/*",
			"https://*.lastpass.com/*",
			"https://*.cloudfront.net/lastpass/*"
		]
	}
	EOF
	cat >"${T}"/com.lastpass.nplastpass.json <<-EOF
	{
		"name": "com.lastpass.nplastpass",
		"description": "LastPass",
		"path": "${LASTPASS_EXEDIR}${_bin}",
		"type": "stdio",
		"allowed_origins": [
			"chrome-extension://hdokiejnpimakedhajhdlcegeplioahd/",
			"chrome-extension://debgaelkhoipmbjnhpoblmbacnmmgbeg/",
			"chrome-extension://hnjalnkldgigidggphhmacmimbdlafdo/",
			"chrome-extension://hgnkdfamjgnljokmokheijphenjjhkjc/"
		]
	}
	EOF
	local d EXTID="hdokiejnpimakedhajhdlcegeplioahd" \
		EXTV="$(sed '/"version":/!d; s:[^0-9.]::g' manifest.json)"
	cat >"${T}"/${EXTID}.json <<-EOF
	{
		"external_crx": "${LASTPASS_EXEDIR}${_crx}",
		"external_version": "${EXTV}"
	}
	EOF

	if use chromium; then
		insinto ${LASTPASS_EXEDIR}
		doins "${S}"/${_crx}
		for d in 'chromium' 'opt/chrome'; do
			insinto /etc/${d}/policies/managed
			doins "${T}"/lastpass_policy.json
			insinto /etc/${d}/native-messaging-hosts
			doins "${T}"/com.lastpass.nplastpass.json
		done
		for d in "$(get_libdir)/chromium-browser" 'share/google-chrome'; do
			insinto /usr/${d}/extensions
			doins "${T}"/${EXTID}.json
		done
	fi

	if use firefox; then
		insinto "/usr/$(get_libdir)/firefox/browser/extensions/support@lastpass.com"
		doins -r "${WORKDIR}"/${_xpi%.*}/*
	fi

}

pkg_postinst() {
	einfo "Visit https://lastpass.com/dl/inline/?full=1 to finish installing ${PN}"
}
