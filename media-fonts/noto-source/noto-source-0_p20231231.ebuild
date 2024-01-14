# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FONT_SRCDIR=src
# https://github.com/notofonts/notofonts.github.io/raw/main/fontrepos.json
SRC_URI="
mirror://githubcl/notofonts/adlam/tar.gz/410e8d6 -> noto-adlam-410e8d6.tar.gz
mirror://githubcl/notofonts/ahom/tar.gz/831b7b7 -> noto-ahom-831b7b7.tar.gz
mirror://githubcl/notofonts/anatolian-hieroglyphs/tar.gz/5805307 -> noto-anatolian-hieroglyphs-5805307.tar.gz
mirror://githubcl/notofonts/arabic/tar.gz/628b5c5f -> noto-arabic-628b5c5f.tar.gz
mirror://githubcl/notofonts/armenian/tar.gz/bf17506 -> noto-armenian-bf17506.tar.gz
mirror://githubcl/notofonts/avestan/tar.gz/fd2b353 -> noto-avestan-fd2b353.tar.gz
mirror://githubcl/notofonts/balinese/tar.gz/2bd9ec1 -> noto-balinese-2bd9ec1.tar.gz
mirror://githubcl/notofonts/bamum/tar.gz/af2c50c -> noto-bamum-af2c50c.tar.gz
mirror://githubcl/notofonts/bassa-vah/tar.gz/db05ffb -> noto-bassa-vah-db05ffb.tar.gz
mirror://githubcl/notofonts/batak/tar.gz/8666cec -> noto-batak-8666cec.tar.gz
mirror://githubcl/notofonts/bengali/tar.gz/a43cbb8 -> noto-bengali-a43cbb8.tar.gz
mirror://githubcl/notofonts/bhaiksuki/tar.gz/01af78e -> noto-bhaiksuki-01af78e.tar.gz
mirror://githubcl/notofonts/brahmi/tar.gz/a878c16 -> noto-brahmi-a878c16.tar.gz
mirror://githubcl/notofonts/buginese/tar.gz/9a2ea75 -> noto-buginese-9a2ea75.tar.gz
mirror://githubcl/notofonts/buhid/tar.gz/94e63cc -> noto-buhid-94e63cc.tar.gz
mirror://githubcl/notofonts/canadian-aboriginal/tar.gz/2a6f29a5 -> noto-canadian-aboriginal-2a6f29a5.tar.gz
mirror://githubcl/notofonts/carian/tar.gz/d8cb85b -> noto-carian-d8cb85b.tar.gz
mirror://githubcl/notofonts/caucasian-albanian/tar.gz/25fe773 -> noto-caucasian-albanian-25fe773.tar.gz
mirror://githubcl/notofonts/chakma/tar.gz/e1a7139 -> noto-chakma-e1a7139.tar.gz
mirror://githubcl/notofonts/cham/tar.gz/6898dee -> noto-cham-6898dee.tar.gz
mirror://githubcl/notofonts/cherokee/tar.gz/e8c5af2 -> noto-cherokee-e8c5af2.tar.gz
mirror://githubcl/notofonts/chorasmian/tar.gz/64c4a72 -> noto-chorasmian-64c4a72.tar.gz
mirror://githubcl/notofonts/coptic/tar.gz/abe1bdd -> noto-coptic-abe1bdd.tar.gz
mirror://githubcl/notofonts/cuneiform/tar.gz/5de2510 -> noto-cuneiform-5de2510.tar.gz
mirror://githubcl/notofonts/cypriot/tar.gz/bc65101 -> noto-cypriot-bc65101.tar.gz
mirror://githubcl/notofonts/cypro-minoan/tar.gz/6cc10b0 -> noto-cypro-minoan-6cc10b0.tar.gz
mirror://githubcl/notofonts/deseret/tar.gz/cec2c24 -> noto-deseret-cec2c24.tar.gz
mirror://githubcl/notofonts/devanagari/tar.gz/a60545b -> noto-devanagari-a60545b.tar.gz
mirror://githubcl/notofonts/dives-akuru/tar.gz/ff399f7 -> noto-dives-akuru-ff399f7.tar.gz
mirror://githubcl/notofonts/dogra/tar.gz/7ab5646 -> noto-dogra-7ab5646.tar.gz
mirror://githubcl/notofonts/duployan/tar.gz/43b95ae -> noto-duployan-43b95ae.tar.gz
mirror://githubcl/notofonts/egyptian-hieroglyphs/tar.gz/103c1b4 -> noto-egyptian-hieroglyphs-103c1b4.tar.gz
mirror://githubcl/notofonts/elbasan/tar.gz/f439f3e -> noto-elbasan-f439f3e.tar.gz
mirror://githubcl/notofonts/elymaic/tar.gz/f9b4109 -> noto-elymaic-f9b4109.tar.gz
mirror://githubcl/notofonts/ethiopic/tar.gz/d475202 -> noto-ethiopic-d475202.tar.gz
mirror://githubcl/notofonts/georgian/tar.gz/6256769 -> noto-georgian-6256769.tar.gz
mirror://githubcl/notofonts/glagolitic/tar.gz/2bf7ef2 -> noto-glagolitic-2bf7ef2.tar.gz
mirror://githubcl/notofonts/gothic/tar.gz/ba27db8 -> noto-gothic-ba27db8.tar.gz
mirror://githubcl/notofonts/grantha/tar.gz/3bc76d2 -> noto-grantha-3bc76d2.tar.gz
mirror://githubcl/notofonts/gujarati/tar.gz/3e84104 -> noto-gujarati-3e84104.tar.gz
mirror://githubcl/notofonts/gunjala-gondi/tar.gz/2ad5735 -> noto-gunjala-gondi-2ad5735.tar.gz
mirror://githubcl/notofonts/gurmukhi/tar.gz/2925c42 -> noto-gurmukhi-2925c42.tar.gz
mirror://githubcl/notofonts/hanifi-rohingya/tar.gz/d3cf7bd -> noto-hanifi-rohingya-d3cf7bd.tar.gz
mirror://githubcl/notofonts/hanunoo/tar.gz/4cd8172 -> noto-hanunoo-4cd8172.tar.gz
mirror://githubcl/notofonts/hatran/tar.gz/4c71b07 -> noto-hatran-4c71b07.tar.gz
mirror://githubcl/notofonts/hebrew/tar.gz/cd88bca -> noto-hebrew-cd88bca.tar.gz
mirror://githubcl/notofonts/imperial-aramaic/tar.gz/0a4bdd9 -> noto-imperial-aramaic-0a4bdd9.tar.gz
mirror://githubcl/notofonts/indic-siyaq-numbers/tar.gz/8edc2ee -> noto-indic-siyaq-numbers-8edc2ee.tar.gz
mirror://githubcl/notofonts/inscriptional-pahlavi/tar.gz/72fdb60 -> noto-inscriptional-pahlavi-72fdb60.tar.gz
mirror://githubcl/notofonts/inscriptional-parthian/tar.gz/872bd83 -> noto-inscriptional-parthian-872bd83.tar.gz
mirror://githubcl/notofonts/javanese/tar.gz/47fac81 -> noto-javanese-47fac81.tar.gz
mirror://githubcl/notofonts/kaithi/tar.gz/dd1af82 -> noto-kaithi-dd1af82.tar.gz
mirror://githubcl/notofonts/kawi/tar.gz/c52ddbe -> noto-kawi-c52ddbe.tar.gz
mirror://githubcl/notofonts/kannada/tar.gz/32aed1c -> noto-kannada-32aed1c.tar.gz
mirror://githubcl/notofonts/kayah-li/tar.gz/0ede9a6 -> noto-kayah-li-0ede9a6.tar.gz
mirror://githubcl/notofonts/kharoshthi/tar.gz/922cbed -> noto-kharoshthi-922cbed.tar.gz
mirror://githubcl/notofonts/khitan-small-script/tar.gz/20bf39d6 -> noto-khitan-small-script-20bf39d6.tar.gz
mirror://githubcl/notofonts/khmer/tar.gz/46ad2c6 -> noto-khmer-46ad2c6.tar.gz
mirror://githubcl/notofonts/khojki/tar.gz/78448bb -> noto-khojki-78448bb.tar.gz
mirror://githubcl/notofonts/khudawadi/tar.gz/eee2fd8 -> noto-khudawadi-eee2fd8.tar.gz
mirror://githubcl/notofonts/lao/tar.gz/8e82e06 -> noto-lao-8e82e06.tar.gz
mirror://githubcl/notofonts/latin-greek-cyrillic/tar.gz/18e6e9153 -> noto-latin-greek-cyrillic-18e6e9153.tar.gz
mirror://githubcl/notofonts/lepcha/tar.gz/9e90cf9 -> noto-lepcha-9e90cf9.tar.gz
mirror://githubcl/notofonts/limbu/tar.gz/5e74854 -> noto-limbu-5e74854.tar.gz
mirror://githubcl/notofonts/linear-a/tar.gz/4803de7 -> noto-linear-a-4803de7.tar.gz
mirror://githubcl/notofonts/linear-b/tar.gz/99f8ab7 -> noto-linear-b-99f8ab7.tar.gz
mirror://githubcl/notofonts/lisu/tar.gz/0e0d8fa -> noto-lisu-0e0d8fa.tar.gz
mirror://githubcl/notofonts/lycian/tar.gz/02cef55 -> noto-lycian-02cef55.tar.gz
mirror://githubcl/notofonts/lydian/tar.gz/01982d6 -> noto-lydian-01982d6.tar.gz
mirror://githubcl/notofonts/mahajani/tar.gz/7142323 -> noto-mahajani-7142323.tar.gz
mirror://githubcl/notofonts/makasar/tar.gz/a44a4ff -> noto-makasar-a44a4ff.tar.gz
mirror://githubcl/notofonts/malayalam/tar.gz/6131738 -> noto-malayalam-6131738.tar.gz
mirror://githubcl/notofonts/mandaic/tar.gz/7d2b224 -> noto-mandaic-7d2b224.tar.gz
mirror://githubcl/notofonts/manichaean/tar.gz/8a41809 -> noto-manichaean-8a41809.tar.gz
mirror://githubcl/notofonts/marchen/tar.gz/2127d91 -> noto-marchen-2127d91.tar.gz
mirror://githubcl/notofonts/masaram-gondi/tar.gz/6e7cb99 -> noto-masaram-gondi-6e7cb99.tar.gz
mirror://githubcl/notofonts/math/tar.gz/2b3f0b6 -> noto-math-2b3f0b6.tar.gz
mirror://githubcl/notofonts/mayan-numerals/tar.gz/4ab74b5 -> noto-mayan-numerals-4ab74b5.tar.gz
mirror://githubcl/notofonts/medefaidrin/tar.gz/6875062 -> noto-medefaidrin-6875062.tar.gz
mirror://githubcl/notofonts/meetei-mayek/tar.gz/8c41d41 -> noto-meetei-mayek-8c41d41.tar.gz
mirror://githubcl/notofonts/mende-kikakui/tar.gz/f9cbb61 -> noto-mende-kikakui-f9cbb61.tar.gz
mirror://githubcl/notofonts/meroitic/tar.gz/d7e3c21 -> noto-meroitic-d7e3c21.tar.gz
mirror://githubcl/notofonts/miao/tar.gz/19488bf -> noto-miao-19488bf.tar.gz
mirror://githubcl/notofonts/modi/tar.gz/7b6303e -> noto-modi-7b6303e.tar.gz
mirror://githubcl/notofonts/mongolian/tar.gz/9e9a901 -> noto-mongolian-9e9a901.tar.gz
mirror://githubcl/notofonts/mro/tar.gz/24b2532 -> noto-mro-24b2532.tar.gz
mirror://githubcl/notofonts/multani/tar.gz/1abb0cb -> noto-multani-1abb0cb.tar.gz
mirror://githubcl/notofonts/music/tar.gz/65aff20 -> noto-music-65aff20.tar.gz
mirror://githubcl/notofonts/myanmar/tar.gz/2901d18 -> noto-myanmar-2901d18.tar.gz
mirror://githubcl/notofonts/nabataean/tar.gz/4eae9b5 -> noto-nabataean-4eae9b5.tar.gz
mirror://githubcl/notofonts/nag-mundari/tar.gz/933e006 -> noto-nag-mundari-933e006.tar.gz
mirror://githubcl/notofonts/nandinagari/tar.gz/86264e9 -> noto-nandinagari-86264e9.tar.gz
mirror://githubcl/notofonts/nastaliq/tar.gz/f52e0ad -> noto-nastaliq-f52e0ad.tar.gz
mirror://githubcl/notofonts/new-tai-lue/tar.gz/fc90a04 -> noto-new-tai-lue-fc90a04.tar.gz
mirror://githubcl/notofonts/newa/tar.gz/ccc0e5c -> noto-newa-ccc0e5c.tar.gz
mirror://githubcl/notofonts/nko/tar.gz/dada5d4 -> noto-nko-dada5d4.tar.gz
mirror://githubcl/notofonts/nushu/tar.gz/ca5dfa0 -> noto-nushu-ca5dfa0.tar.gz
mirror://githubcl/notofonts/nyiakeng-puachue-hmong/tar.gz/5b94dc5 -> noto-nyiakeng-puachue-hmong-5b94dc5.tar.gz
mirror://githubcl/notofonts/ogham/tar.gz/a4eb11b -> noto-ogham-a4eb11b.tar.gz
mirror://githubcl/notofonts/ol-chiki/tar.gz/df57d98 -> noto-ol-chiki-df57d98.tar.gz
mirror://githubcl/notofonts/old-hungarian/tar.gz/2249d78 -> noto-old-hungarian-2249d78.tar.gz
mirror://githubcl/notofonts/old-hungarian-ui/tar.gz/de5917b -> noto-old-hungarian-ui-de5917b.tar.gz
mirror://githubcl/notofonts/old-italic/tar.gz/515340e -> noto-old-italic-515340e.tar.gz
mirror://githubcl/notofonts/old-north-arabian/tar.gz/50b78ad -> noto-old-north-arabian-50b78ad.tar.gz
mirror://githubcl/notofonts/old-permic/tar.gz/89d15c3 -> noto-old-permic-89d15c3.tar.gz
mirror://githubcl/notofonts/old-persian/tar.gz/24ac053 -> noto-old-persian-24ac053.tar.gz
mirror://githubcl/notofonts/old-sogdian/tar.gz/6d943ea -> noto-old-sogdian-6d943ea.tar.gz
mirror://githubcl/notofonts/old-south-arabian/tar.gz/1683548 -> noto-old-south-arabian-1683548.tar.gz
mirror://githubcl/notofonts/old-turkic/tar.gz/047f68c -> noto-old-turkic-047f68c.tar.gz
mirror://githubcl/notofonts/old-uyghur/tar.gz/c877fe4 -> noto-old-uyghur-c877fe4.tar.gz
mirror://githubcl/notofonts/oriya/tar.gz/ff6d507 -> noto-oriya-ff6d507.tar.gz
mirror://githubcl/notofonts/osage/tar.gz/f466eb6 -> noto-osage-f466eb6.tar.gz
mirror://githubcl/notofonts/osmanya/tar.gz/6d665ae -> noto-osmanya-6d665ae.tar.gz
mirror://githubcl/notofonts/ottoman-siyaq-numbers/tar.gz/aa42405 -> noto-ottoman-siyaq-numbers-aa42405.tar.gz
mirror://githubcl/notofonts/pahawh-hmong/tar.gz/042cb27 -> noto-pahawh-hmong-042cb27.tar.gz
mirror://githubcl/notofonts/palmyrene/tar.gz/203c23c -> noto-palmyrene-203c23c.tar.gz
mirror://githubcl/notofonts/pau-cin-hau/tar.gz/e4ee24d -> noto-pau-cin-hau-e4ee24d.tar.gz
mirror://githubcl/notofonts/phags-pa/tar.gz/e1ca953 -> noto-phags-pa-e1ca953.tar.gz
mirror://githubcl/notofonts/phoenician/tar.gz/780c098 -> noto-phoenician-780c098.tar.gz
mirror://githubcl/notofonts/psalter-pahlavi/tar.gz/0deedbd -> noto-psalter-pahlavi-0deedbd.tar.gz
mirror://githubcl/notofonts/rejang/tar.gz/23ebbfd -> noto-rejang-23ebbfd.tar.gz
mirror://githubcl/notofonts/runic/tar.gz/1f0a034 -> noto-runic-1f0a034.tar.gz
mirror://githubcl/notofonts/samaritan/tar.gz/e7b3ddd -> noto-samaritan-e7b3ddd.tar.gz
mirror://githubcl/notofonts/saurashtra/tar.gz/1c68739 -> noto-saurashtra-1c68739.tar.gz
mirror://githubcl/notofonts/sharada/tar.gz/a66024f -> noto-sharada-a66024f.tar.gz
mirror://githubcl/notofonts/shavian/tar.gz/9575fea -> noto-shavian-9575fea.tar.gz
mirror://githubcl/notofonts/siddham/tar.gz/d901df3 -> noto-siddham-d901df3.tar.gz
mirror://githubcl/notofonts/sign-writing/tar.gz/9e07f61e -> noto-sign-writing-9e07f61e.tar.gz
mirror://githubcl/notofonts/sinhala/tar.gz/6cc7c8c -> noto-sinhala-6cc7c8c.tar.gz
mirror://githubcl/notofonts/sogdian/tar.gz/ff05273 -> noto-sogdian-ff05273.tar.gz
mirror://githubcl/notofonts/sora-sompeng/tar.gz/499ef10 -> noto-sora-sompeng-499ef10.tar.gz
mirror://githubcl/notofonts/soyombo/tar.gz/93bb72b -> noto-soyombo-93bb72b.tar.gz
mirror://githubcl/notofonts/sundanese/tar.gz/de739c0 -> noto-sundanese-de739c0.tar.gz
mirror://githubcl/notofonts/syloti-nagri/tar.gz/7acac55 -> noto-syloti-nagri-7acac55.tar.gz
mirror://githubcl/notofonts/symbols/tar.gz/d3d8b439 -> noto-symbols-d3d8b439.tar.gz
mirror://githubcl/notofonts/syriac/tar.gz/1b28f79 -> noto-syriac-1b28f79.tar.gz
mirror://githubcl/notofonts/tagalog/tar.gz/6ddc11f -> noto-tagalog-6ddc11f.tar.gz
mirror://githubcl/notofonts/tagbanwa/tar.gz/7f663a0 -> noto-tagbanwa-7f663a0.tar.gz
mirror://githubcl/notofonts/tai-le/tar.gz/fee38d1 -> noto-tai-le-fee38d1.tar.gz
mirror://githubcl/notofonts/tai-tham/tar.gz/18e1240 -> noto-tai-tham-18e1240.tar.gz
mirror://githubcl/notofonts/tai-viet/tar.gz/224809f -> noto-tai-viet-224809f.tar.gz
mirror://githubcl/notofonts/takri/tar.gz/cf0ca6f -> noto-takri-cf0ca6f.tar.gz
mirror://githubcl/notofonts/tamil/tar.gz/a712e46 -> noto-tamil-a712e46.tar.gz
mirror://githubcl/notofonts/tangsa/tar.gz/f06acc5 -> noto-tangsa-f06acc5.tar.gz
mirror://githubcl/notofonts/tangut/tar.gz/2d77c08 -> noto-tangut-2d77c08.tar.gz
mirror://githubcl/notofonts/telugu/tar.gz/c6c0a18 -> noto-telugu-c6c0a18.tar.gz
mirror://githubcl/notofonts/thaana/tar.gz/0502740 -> noto-thaana-0502740.tar.gz
mirror://githubcl/notofonts/thai/tar.gz/dbb3e9d -> noto-thai-dbb3e9d.tar.gz
mirror://githubcl/notofonts/tibetan/tar.gz/ebda038 -> noto-tibetan-ebda038.tar.gz
mirror://githubcl/notofonts/tifinagh/tar.gz/5a8c5fa -> noto-tifinagh-5a8c5fa.tar.gz
mirror://githubcl/notofonts/tirhuta/tar.gz/2ca94d6 -> noto-tirhuta-2ca94d6.tar.gz
mirror://githubcl/notofonts/toto/tar.gz/27d8ec4 -> noto-toto-27d8ec4.tar.gz
mirror://githubcl/notofonts/ugaritic/tar.gz/78bb779 -> noto-ugaritic-78bb779.tar.gz
mirror://githubcl/notofonts/vai/tar.gz/0a0da41 -> noto-vai-0a0da41.tar.gz
mirror://githubcl/notofonts/vithkuqi/tar.gz/653cab3 -> noto-vithkuqi-653cab3.tar.gz
mirror://githubcl/notofonts/wancho/tar.gz/a5fddfb -> noto-wancho-a5fddfb.tar.gz
mirror://githubcl/notofonts/warang-citi/tar.gz/4bee456 -> noto-warang-citi-4bee456.tar.gz
mirror://githubcl/notofonts/yezidi/tar.gz/1b337d3 -> noto-yezidi-1b337d3.tar.gz
mirror://githubcl/notofonts/yi/tar.gz/8207c5d -> noto-yi-8207c5d.tar.gz
mirror://githubcl/notofonts/zanabazar-square/tar.gz/1f76d9c -> noto-zanabazar-square-1f76d9c.tar.gz
"
RESTRICT="primaryuri"
KEYWORDS="~amd64"
S="${WORKDIR}"
inherit fontmake

DESCRIPTION="A WIP versions of the noto fonts"
HOMEPAGE="https://notofonts.github.io"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="clean-as-you-go"
BDEPEND="
	variable? ( app-misc/yq )
"

src_prepare() {
	use variable && export SKIP_VF="$(grep -rl 'buildVariable.*false' \
		--include=config-*.yaml | xargs yq -r '.sources[]' | grep -v NotoSansThaiLoopedUI)"
	use clean-as-you-go && HELPER_ARGS=( clean )
	mkdir -p src
	mv -t src */sources/*
	fontmake_src_prepare
}
