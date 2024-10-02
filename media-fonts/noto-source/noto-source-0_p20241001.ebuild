# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FONT_SRCDIR=src
# https://github.com/notofonts/notofonts.github.io/raw/main/fontrepos.json
SRC_URI="
mirror://githubcl/notofonts/adlam/tar.gz/66c3f01 -> noto-adlam-66c3f01.tar.gz
mirror://githubcl/notofonts/ahom/tar.gz/831b7b7 -> noto-ahom-831b7b7.tar.gz
mirror://githubcl/notofonts/anatolian-hieroglyphs/tar.gz/5805307 -> noto-anatolian-hieroglyphs-5805307.tar.gz
mirror://githubcl/notofonts/arabic/tar.gz/b38c6b30 -> noto-arabic-b38c6b30.tar.gz
mirror://githubcl/notofonts/armenian/tar.gz/2d2274f -> noto-armenian-2d2274f.tar.gz
mirror://githubcl/notofonts/avestan/tar.gz/fd2b353 -> noto-avestan-fd2b353.tar.gz
mirror://githubcl/notofonts/balinese/tar.gz/3677ecc -> noto-balinese-3677ecc.tar.gz
mirror://githubcl/notofonts/bamum/tar.gz/af2c50c -> noto-bamum-af2c50c.tar.gz
mirror://githubcl/notofonts/bassa-vah/tar.gz/db05ffb -> noto-bassa-vah-db05ffb.tar.gz
mirror://githubcl/notofonts/batak/tar.gz/8666cec -> noto-batak-8666cec.tar.gz
mirror://githubcl/notofonts/bengali/tar.gz/a43cbb8 -> noto-bengali-a43cbb8.tar.gz
mirror://githubcl/notofonts/bhaiksuki/tar.gz/01af78e -> noto-bhaiksuki-01af78e.tar.gz
mirror://githubcl/notofonts/brahmi/tar.gz/c49f83e -> noto-brahmi-c49f83e.tar.gz
mirror://githubcl/notofonts/buginese/tar.gz/9a2ea75 -> noto-buginese-9a2ea75.tar.gz
mirror://githubcl/notofonts/buhid/tar.gz/94e63cc -> noto-buhid-94e63cc.tar.gz
mirror://githubcl/notofonts/canadian-aboriginal/tar.gz/268bebb4 -> noto-canadian-aboriginal-268bebb4.tar.gz
mirror://githubcl/notofonts/carian/tar.gz/d8cb85b -> noto-carian-d8cb85b.tar.gz
mirror://githubcl/notofonts/caucasian-albanian/tar.gz/25fe773 -> noto-caucasian-albanian-25fe773.tar.gz
mirror://githubcl/notofonts/chakma/tar.gz/e1a7139 -> noto-chakma-e1a7139.tar.gz
mirror://githubcl/notofonts/cham/tar.gz/1688bf8 -> noto-cham-1688bf8.tar.gz
mirror://githubcl/notofonts/cherokee/tar.gz/e8c5af2 -> noto-cherokee-e8c5af2.tar.gz
mirror://githubcl/notofonts/chorasmian/tar.gz/64c4a72 -> noto-chorasmian-64c4a72.tar.gz
mirror://githubcl/notofonts/coptic/tar.gz/abe1bdd -> noto-coptic-abe1bdd.tar.gz
mirror://githubcl/notofonts/cuneiform/tar.gz/5de2510 -> noto-cuneiform-5de2510.tar.gz
mirror://githubcl/notofonts/cypriot/tar.gz/bc65101 -> noto-cypriot-bc65101.tar.gz
mirror://githubcl/notofonts/cypro-minoan/tar.gz/6cc10b0 -> noto-cypro-minoan-6cc10b0.tar.gz
mirror://githubcl/notofonts/deseret/tar.gz/1336558 -> noto-deseret-1336558.tar.gz
mirror://githubcl/notofonts/devanagari/tar.gz/b9504c02 -> noto-devanagari-b9504c02.tar.gz
mirror://githubcl/notofonts/dives-akuru/tar.gz/ff399f7 -> noto-dives-akuru-ff399f7.tar.gz
mirror://githubcl/notofonts/dogra/tar.gz/7ab5646 -> noto-dogra-7ab5646.tar.gz
mirror://githubcl/notofonts/duployan/tar.gz/dcec488 -> noto-duployan-dcec488.tar.gz
mirror://githubcl/notofonts/egyptian-hieroglyphs/tar.gz/08dec90 -> noto-egyptian-hieroglyphs-08dec90.tar.gz
mirror://githubcl/notofonts/elbasan/tar.gz/f439f3e -> noto-elbasan-f439f3e.tar.gz
mirror://githubcl/notofonts/elymaic/tar.gz/f9b4109 -> noto-elymaic-f9b4109.tar.gz
mirror://githubcl/notofonts/ethiopic/tar.gz/e5ffb56 -> noto-ethiopic-e5ffb56.tar.gz
mirror://githubcl/notofonts/georgian/tar.gz/a22bf6c -> noto-georgian-a22bf6c.tar.gz
mirror://githubcl/notofonts/glagolitic/tar.gz/7eec7b1 -> noto-glagolitic-7eec7b1.tar.gz
mirror://githubcl/notofonts/gothic/tar.gz/ba27db8 -> noto-gothic-ba27db8.tar.gz
mirror://githubcl/notofonts/grantha/tar.gz/6bb911f -> noto-grantha-6bb911f.tar.gz
mirror://githubcl/notofonts/gujarati/tar.gz/76198ff -> noto-gujarati-76198ff.tar.gz
mirror://githubcl/notofonts/gunjala-gondi/tar.gz/17bad64 -> noto-gunjala-gondi-17bad64.tar.gz
mirror://githubcl/notofonts/gurmukhi/tar.gz/2925c42 -> noto-gurmukhi-2925c42.tar.gz
mirror://githubcl/notofonts/hanifi-rohingya/tar.gz/d3cf7bd -> noto-hanifi-rohingya-d3cf7bd.tar.gz
mirror://githubcl/notofonts/hanunoo/tar.gz/81bdc6b -> noto-hanunoo-81bdc6b.tar.gz
mirror://githubcl/notofonts/hatran/tar.gz/4c71b07 -> noto-hatran-4c71b07.tar.gz
mirror://githubcl/notofonts/hebrew/tar.gz/c14a1e0 -> noto-hebrew-c14a1e0.tar.gz
mirror://githubcl/notofonts/imperial-aramaic/tar.gz/f32017c -> noto-imperial-aramaic-f32017c.tar.gz
mirror://githubcl/notofonts/indic-siyaq-numbers/tar.gz/8edc2ee -> noto-indic-siyaq-numbers-8edc2ee.tar.gz
mirror://githubcl/notofonts/inscriptional-pahlavi/tar.gz/ccf6d04 -> noto-inscriptional-pahlavi-ccf6d04.tar.gz
mirror://githubcl/notofonts/inscriptional-parthian/tar.gz/8930035 -> noto-inscriptional-parthian-8930035.tar.gz
mirror://githubcl/notofonts/javanese/tar.gz/47fac81 -> noto-javanese-47fac81.tar.gz
mirror://githubcl/notofonts/kaithi/tar.gz/a439d16 -> noto-kaithi-a439d16.tar.gz
mirror://githubcl/notofonts/kawi/tar.gz/c52ddbe -> noto-kawi-c52ddbe.tar.gz
mirror://githubcl/notofonts/kannada/tar.gz/7eeac89 -> noto-kannada-7eeac89.tar.gz
mirror://githubcl/notofonts/kayah-li/tar.gz/0ede9a6 -> noto-kayah-li-0ede9a6.tar.gz
mirror://githubcl/notofonts/kharoshthi/tar.gz/922cbed -> noto-kharoshthi-922cbed.tar.gz
mirror://githubcl/notofonts/khitan-small-script/tar.gz/20bf39d6 -> noto-khitan-small-script-20bf39d6.tar.gz
mirror://githubcl/notofonts/khmer/tar.gz/46ad2c6 -> noto-khmer-46ad2c6.tar.gz
mirror://githubcl/notofonts/khojki/tar.gz/1f04a37 -> noto-khojki-1f04a37.tar.gz
mirror://githubcl/notofonts/khudawadi/tar.gz/77a425b -> noto-khudawadi-77a425b.tar.gz
mirror://githubcl/notofonts/lao/tar.gz/3b4d031 -> noto-lao-3b4d031.tar.gz
mirror://githubcl/notofonts/latin-greek-cyrillic/tar.gz/4e0e245f1 -> noto-latin-greek-cyrillic-4e0e245f1.tar.gz
mirror://githubcl/notofonts/lepcha/tar.gz/9e90cf9 -> noto-lepcha-9e90cf9.tar.gz
mirror://githubcl/notofonts/limbu/tar.gz/d82787e -> noto-limbu-d82787e.tar.gz
mirror://githubcl/notofonts/linear-a/tar.gz/4803de7 -> noto-linear-a-4803de7.tar.gz
mirror://githubcl/notofonts/linear-b/tar.gz/99f8ab7 -> noto-linear-b-99f8ab7.tar.gz
mirror://githubcl/notofonts/lisu/tar.gz/0e0d8fa -> noto-lisu-0e0d8fa.tar.gz
mirror://githubcl/notofonts/lycian/tar.gz/02cef55 -> noto-lycian-02cef55.tar.gz
mirror://githubcl/notofonts/lydian/tar.gz/396e00e -> noto-lydian-396e00e.tar.gz
mirror://githubcl/notofonts/mahajani/tar.gz/7142323 -> noto-mahajani-7142323.tar.gz
mirror://githubcl/notofonts/makasar/tar.gz/a44a4ff -> noto-makasar-a44a4ff.tar.gz
mirror://githubcl/notofonts/malayalam/tar.gz/ec0ef52 -> noto-malayalam-ec0ef52.tar.gz
mirror://githubcl/notofonts/mandaic/tar.gz/ef8c8ef -> noto-mandaic-ef8c8ef.tar.gz
mirror://githubcl/notofonts/manichaean/tar.gz/45f925c -> noto-manichaean-45f925c.tar.gz
mirror://githubcl/notofonts/marchen/tar.gz/0efb263 -> noto-marchen-0efb263.tar.gz
mirror://githubcl/notofonts/masaram-gondi/tar.gz/ce1d619 -> noto-masaram-gondi-ce1d619.tar.gz
mirror://githubcl/notofonts/math/tar.gz/b1f8b818 -> noto-math-b1f8b818.tar.gz
mirror://githubcl/notofonts/mayan-numerals/tar.gz/4ab74b5 -> noto-mayan-numerals-4ab74b5.tar.gz
mirror://githubcl/notofonts/medefaidrin/tar.gz/6875062 -> noto-medefaidrin-6875062.tar.gz
mirror://githubcl/notofonts/meetei-mayek/tar.gz/8c41d41 -> noto-meetei-mayek-8c41d41.tar.gz
mirror://githubcl/notofonts/mende-kikakui/tar.gz/f9cbb61 -> noto-mende-kikakui-f9cbb61.tar.gz
mirror://githubcl/notofonts/meroitic/tar.gz/d7e3c21 -> noto-meroitic-d7e3c21.tar.gz
mirror://githubcl/notofonts/miao/tar.gz/dcbd5ac -> noto-miao-dcbd5ac.tar.gz
mirror://githubcl/notofonts/modi/tar.gz/7b6303e -> noto-modi-7b6303e.tar.gz
mirror://githubcl/notofonts/mongolian/tar.gz/8089c2a -> noto-mongolian-8089c2a.tar.gz
mirror://githubcl/notofonts/mro/tar.gz/24b2532 -> noto-mro-24b2532.tar.gz
mirror://githubcl/notofonts/multani/tar.gz/c18ac4c -> noto-multani-c18ac4c.tar.gz
mirror://githubcl/notofonts/music/tar.gz/65aff20 -> noto-music-65aff20.tar.gz
mirror://githubcl/notofonts/myanmar/tar.gz/2901d18 -> noto-myanmar-2901d18.tar.gz
mirror://githubcl/notofonts/nabataean/tar.gz/4eae9b5 -> noto-nabataean-4eae9b5.tar.gz
mirror://githubcl/notofonts/nag-mundari/tar.gz/aa14d2d -> noto-nag-mundari-aa14d2d.tar.gz
mirror://githubcl/notofonts/nandinagari/tar.gz/86264e9 -> noto-nandinagari-86264e9.tar.gz
mirror://githubcl/notofonts/nastaliq/tar.gz/f8432ae -> noto-nastaliq-f8432ae.tar.gz
mirror://githubcl/notofonts/new-tai-lue/tar.gz/3049a13 -> noto-new-tai-lue-3049a13.tar.gz
mirror://githubcl/notofonts/newa/tar.gz/ccc0e5c -> noto-newa-ccc0e5c.tar.gz
mirror://githubcl/notofonts/nko/tar.gz/dada5d4 -> noto-nko-dada5d4.tar.gz
mirror://githubcl/notofonts/nushu/tar.gz/ca5dfa0 -> noto-nushu-ca5dfa0.tar.gz
mirror://githubcl/notofonts/nyiakeng-puachue-hmong/tar.gz/5b94dc5 -> noto-nyiakeng-puachue-hmong-5b94dc5.tar.gz
mirror://githubcl/notofonts/ogham/tar.gz/a4eb11b -> noto-ogham-a4eb11b.tar.gz
mirror://githubcl/notofonts/ol-chiki/tar.gz/df57d98 -> noto-ol-chiki-df57d98.tar.gz
mirror://githubcl/notofonts/old-hungarian/tar.gz/2249d78 -> noto-old-hungarian-2249d78.tar.gz
mirror://githubcl/notofonts/old-hungarian-ui/tar.gz/de5917b -> noto-old-hungarian-ui-de5917b.tar.gz
mirror://githubcl/notofonts/old-italic/tar.gz/5142063 -> noto-old-italic-5142063.tar.gz
mirror://githubcl/notofonts/old-north-arabian/tar.gz/50b78ad -> noto-old-north-arabian-50b78ad.tar.gz
mirror://githubcl/notofonts/old-permic/tar.gz/89d15c3 -> noto-old-permic-89d15c3.tar.gz
mirror://githubcl/notofonts/old-persian/tar.gz/24ac053 -> noto-old-persian-24ac053.tar.gz
mirror://githubcl/notofonts/old-sogdian/tar.gz/63f9407 -> noto-old-sogdian-63f9407.tar.gz
mirror://githubcl/notofonts/old-south-arabian/tar.gz/1683548 -> noto-old-south-arabian-1683548.tar.gz
mirror://githubcl/notofonts/old-turkic/tar.gz/b9616ab -> noto-old-turkic-b9616ab.tar.gz
mirror://githubcl/notofonts/old-uyghur/tar.gz/da8ad06 -> noto-old-uyghur-da8ad06.tar.gz
mirror://githubcl/notofonts/oriya/tar.gz/be18c96 -> noto-oriya-be18c96.tar.gz
mirror://githubcl/notofonts/osage/tar.gz/f466eb6 -> noto-osage-f466eb6.tar.gz
mirror://githubcl/notofonts/osmanya/tar.gz/6d665ae -> noto-osmanya-6d665ae.tar.gz
mirror://githubcl/notofonts/ottoman-siyaq-numbers/tar.gz/aa42405 -> noto-ottoman-siyaq-numbers-aa42405.tar.gz
mirror://githubcl/notofonts/pahawh-hmong/tar.gz/b09196e -> noto-pahawh-hmong-b09196e.tar.gz
mirror://githubcl/notofonts/palmyrene/tar.gz/203c23c -> noto-palmyrene-203c23c.tar.gz
mirror://githubcl/notofonts/pau-cin-hau/tar.gz/e4ee24d -> noto-pau-cin-hau-e4ee24d.tar.gz
mirror://githubcl/notofonts/phags-pa/tar.gz/e1ca953 -> noto-phags-pa-e1ca953.tar.gz
mirror://githubcl/notofonts/phoenician/tar.gz/780c098 -> noto-phoenician-780c098.tar.gz
mirror://githubcl/notofonts/psalter-pahlavi/tar.gz/c7f8c2c -> noto-psalter-pahlavi-c7f8c2c.tar.gz
mirror://githubcl/notofonts/rejang/tar.gz/23ebbfd -> noto-rejang-23ebbfd.tar.gz
mirror://githubcl/notofonts/runic/tar.gz/1f0a034 -> noto-runic-1f0a034.tar.gz
mirror://githubcl/notofonts/samaritan/tar.gz/e7b3ddd -> noto-samaritan-e7b3ddd.tar.gz
mirror://githubcl/notofonts/saurashtra/tar.gz/1c68739 -> noto-saurashtra-1c68739.tar.gz
mirror://githubcl/notofonts/sharada/tar.gz/a66024f -> noto-sharada-a66024f.tar.gz
mirror://githubcl/notofonts/shavian/tar.gz/9575fea -> noto-shavian-9575fea.tar.gz
mirror://githubcl/notofonts/siddham/tar.gz/fbb964b -> noto-siddham-fbb964b.tar.gz
mirror://githubcl/notofonts/sign-writing/tar.gz/9e07f61e -> noto-sign-writing-9e07f61e.tar.gz
mirror://githubcl/notofonts/sinhala/tar.gz/6cc7c8c -> noto-sinhala-6cc7c8c.tar.gz
mirror://githubcl/notofonts/sogdian/tar.gz/ff05273 -> noto-sogdian-ff05273.tar.gz
mirror://githubcl/notofonts/sora-sompeng/tar.gz/499ef10 -> noto-sora-sompeng-499ef10.tar.gz
mirror://githubcl/notofonts/soyombo/tar.gz/93bb72b -> noto-soyombo-93bb72b.tar.gz
mirror://githubcl/notofonts/sundanese/tar.gz/de739c0 -> noto-sundanese-de739c0.tar.gz
mirror://githubcl/notofonts/syloti-nagri/tar.gz/1aaa56e -> noto-syloti-nagri-1aaa56e.tar.gz
mirror://githubcl/notofonts/symbols/tar.gz/a388e636 -> noto-symbols-a388e636.tar.gz
mirror://githubcl/notofonts/syriac/tar.gz/47ef681 -> noto-syriac-47ef681.tar.gz
mirror://githubcl/notofonts/tagalog/tar.gz/6ddc11f -> noto-tagalog-6ddc11f.tar.gz
mirror://githubcl/notofonts/tagbanwa/tar.gz/7f663a0 -> noto-tagbanwa-7f663a0.tar.gz
mirror://githubcl/notofonts/tai-le/tar.gz/ff2e2d3 -> noto-tai-le-ff2e2d3.tar.gz
mirror://githubcl/notofonts/tai-tham/tar.gz/18e1240 -> noto-tai-tham-18e1240.tar.gz
mirror://githubcl/notofonts/tai-viet/tar.gz/224809f -> noto-tai-viet-224809f.tar.gz
mirror://githubcl/notofonts/takri/tar.gz/cf0ca6f -> noto-takri-cf0ca6f.tar.gz
mirror://githubcl/notofonts/tamil/tar.gz/a712e46 -> noto-tamil-a712e46.tar.gz
mirror://githubcl/notofonts/tangsa/tar.gz/39077e3 -> noto-tangsa-39077e3.tar.gz
mirror://githubcl/notofonts/tangut/tar.gz/fe94969c -> noto-tangut-fe94969c.tar.gz
mirror://githubcl/notofonts/telugu/tar.gz/41de4bf -> noto-telugu-41de4bf.tar.gz
mirror://githubcl/notofonts/thaana/tar.gz/0502740 -> noto-thaana-0502740.tar.gz
mirror://githubcl/notofonts/thai/tar.gz/dbb3e9d -> noto-thai-dbb3e9d.tar.gz
mirror://githubcl/notofonts/tibetan/tar.gz/ebda038 -> noto-tibetan-ebda038.tar.gz
mirror://githubcl/notofonts/tifinagh/tar.gz/5a8c5fa -> noto-tifinagh-5a8c5fa.tar.gz
mirror://githubcl/notofonts/tirhuta/tar.gz/2ca94d6 -> noto-tirhuta-2ca94d6.tar.gz
mirror://githubcl/notofonts/toto/tar.gz/3ea8167 -> noto-toto-3ea8167.tar.gz
mirror://githubcl/notofonts/ugaritic/tar.gz/78bb779 -> noto-ugaritic-78bb779.tar.gz
mirror://githubcl/notofonts/vai/tar.gz/0a0da41 -> noto-vai-0a0da41.tar.gz
mirror://githubcl/notofonts/vithkuqi/tar.gz/653cab3 -> noto-vithkuqi-653cab3.tar.gz
mirror://githubcl/notofonts/wancho/tar.gz/a5fddfb -> noto-wancho-a5fddfb.tar.gz
mirror://githubcl/notofonts/warang-citi/tar.gz/4bee456 -> noto-warang-citi-4bee456.tar.gz
mirror://githubcl/notofonts/yezidi/tar.gz/1b337d3 -> noto-yezidi-1b337d3.tar.gz
mirror://githubcl/notofonts/yi/tar.gz/8207c5d -> noto-yi-8207c5d.tar.gz
mirror://githubcl/notofonts/zanabazar-square/tar.gz/1f76d9c -> noto-zanabazar-square-1f76d9c.tar.gz
mirror://githubcl/notofonts/znamenny/tar.gz/4c3fa5d -> noto-znamenny-4c3fa5d.tar.gz
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
	rm -f "src/NotoSansMultani-Regular (Autosaved).glyphs"
	fontmake_src_prepare
}
