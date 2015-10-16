# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"
inherit ruby-fakegem
if [[ "${PV%9999}" != "${PV}" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/defunkt/gist.git"
	EGIT_CHECKOUT_DIR="${WORKDIR}/all/${P}"
	SRC_URI=""
else
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Upload code to gist.github.com"
HOMEPAGE="http://defunkt.io/gist"

LICENSE="MIT"
SLOT="0"
IUSE=""

ruby_add_rdepend "dev-ruby/json dev-ruby/webmock"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

all_ruby_prepare() {
	if [[ "${PV%9999}" == "${PV}" ]]; then
		sed -e '/git ls-files/d' -i gist.gemspec
	fi
}

all_ruby_install() {
	all_fakegem_install
	doman build/${PN}.1
}
