# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FONT_SRCDIR=src
FONTMAKE_EXTRA_ARGS=( "--fea-include-dir ./${FONT_SRCDIR}" )
# https://github.com/notofonts/notofonts.github.io/raw/main/fontrepos.json
SRC_URI="
mirror://githubcl/notofonts/adlam/tar.gz/525273b -> noto-adlam-525273b.tar.gz
mirror://githubcl/notofonts/ahom/tar.gz/f08a1b5 -> noto-ahom-f08a1b5.tar.gz
mirror://githubcl/notofonts/anatolian-hieroglyphs/tar.gz/bbeda41 -> noto-anatolian-hieroglyphs-bbeda41.tar.gz
mirror://githubcl/notofonts/arabic/tar.gz/f1ba474b -> noto-arabic-f1ba474b.tar.gz
mirror://githubcl/notofonts/armenian/tar.gz/901f22b -> noto-armenian-901f22b.tar.gz
mirror://githubcl/notofonts/avestan/tar.gz/2df4b79 -> noto-avestan-2df4b79.tar.gz
mirror://githubcl/notofonts/balinese/tar.gz/5213c93 -> noto-balinese-5213c93.tar.gz
mirror://githubcl/notofonts/bamum/tar.gz/bc0b15f -> noto-bamum-bc0b15f.tar.gz
mirror://githubcl/notofonts/bassa-vah/tar.gz/1b478db -> noto-bassa-vah-1b478db.tar.gz
mirror://githubcl/notofonts/batak/tar.gz/3670d09 -> noto-batak-3670d09.tar.gz
mirror://githubcl/notofonts/bengali/tar.gz/4c0546e2 -> noto-bengali-4c0546e2.tar.gz
mirror://githubcl/notofonts/bhaiksuki/tar.gz/e419aa5 -> noto-bhaiksuki-e419aa5.tar.gz
mirror://githubcl/notofonts/brahmi/tar.gz/14253b9 -> noto-brahmi-14253b9.tar.gz
mirror://githubcl/notofonts/buginese/tar.gz/b87a45b -> noto-buginese-b87a45b.tar.gz
mirror://githubcl/notofonts/buhid/tar.gz/5cb8532 -> noto-buhid-5cb8532.tar.gz
mirror://githubcl/notofonts/canadian-aboriginal/tar.gz/1d47c5bf -> noto-canadian-aboriginal-1d47c5bf.tar.gz
mirror://githubcl/notofonts/carian/tar.gz/f2765bf -> noto-carian-f2765bf.tar.gz
mirror://githubcl/notofonts/caucasian-albanian/tar.gz/a07d983 -> noto-caucasian-albanian-a07d983.tar.gz
mirror://githubcl/notofonts/chakma/tar.gz/e351533 -> noto-chakma-e351533.tar.gz
mirror://githubcl/notofonts/cham/tar.gz/513c6da -> noto-cham-513c6da.tar.gz
mirror://githubcl/notofonts/cherokee/tar.gz/c29a3b5 -> noto-cherokee-c29a3b5.tar.gz
mirror://githubcl/notofonts/chorasmian/tar.gz/dc59828 -> noto-chorasmian-dc59828.tar.gz
mirror://githubcl/notofonts/coptic/tar.gz/4dd7b11 -> noto-coptic-4dd7b11.tar.gz
mirror://githubcl/notofonts/cuneiform/tar.gz/1ce983e -> noto-cuneiform-1ce983e.tar.gz
mirror://githubcl/notofonts/cypriot/tar.gz/18bc01b -> noto-cypriot-18bc01b.tar.gz
mirror://githubcl/notofonts/cypro-minoan/tar.gz/d4ab691 -> noto-cypro-minoan-d4ab691.tar.gz
mirror://githubcl/notofonts/deseret/tar.gz/b87f7ae -> noto-deseret-b87f7ae.tar.gz
mirror://githubcl/notofonts/devanagari/tar.gz/d9a55ac6 -> noto-devanagari-d9a55ac6.tar.gz
mirror://githubcl/notofonts/dives-akuru/tar.gz/b9970834 -> noto-dives-akuru-b9970834.tar.gz
mirror://githubcl/notofonts/dogra/tar.gz/0b38052 -> noto-dogra-0b38052.tar.gz
mirror://githubcl/notofonts/duployan/tar.gz/1a1c8d7 -> noto-duployan-1a1c8d7.tar.gz
mirror://githubcl/notofonts/egyptian-hieroglyphs/tar.gz/7d1e8b5 -> noto-egyptian-hieroglyphs-7d1e8b5.tar.gz
mirror://githubcl/notofonts/elbasan/tar.gz/5fb7e7b -> noto-elbasan-5fb7e7b.tar.gz
mirror://githubcl/notofonts/elymaic/tar.gz/9af6a08 -> noto-elymaic-9af6a08.tar.gz
mirror://githubcl/notofonts/ethiopic/tar.gz/eda2436 -> noto-ethiopic-eda2436.tar.gz
mirror://githubcl/notofonts/georgian/tar.gz/ac0c343 -> noto-georgian-ac0c343.tar.gz
mirror://githubcl/notofonts/glagolitic/tar.gz/5bbffba -> noto-glagolitic-5bbffba.tar.gz
mirror://githubcl/notofonts/gothic/tar.gz/a99b6f1 -> noto-gothic-a99b6f1.tar.gz
mirror://githubcl/notofonts/grantha/tar.gz/506b9c0 -> noto-grantha-506b9c0.tar.gz
mirror://githubcl/notofonts/gujarati/tar.gz/dc1aa99 -> noto-gujarati-dc1aa99.tar.gz
mirror://githubcl/notofonts/gunjala-gondi/tar.gz/50e846c -> noto-gunjala-gondi-50e846c.tar.gz
mirror://githubcl/notofonts/gurmukhi/tar.gz/71ff667 -> noto-gurmukhi-71ff667.tar.gz
mirror://githubcl/notofonts/hanifi-rohingya/tar.gz/6e5fb99 -> noto-hanifi-rohingya-6e5fb99.tar.gz
mirror://githubcl/notofonts/hanunoo/tar.gz/c62ad8c -> noto-hanunoo-c62ad8c.tar.gz
mirror://githubcl/notofonts/hatran/tar.gz/6d506cb -> noto-hatran-6d506cb.tar.gz
mirror://githubcl/notofonts/hebrew/tar.gz/3d63973 -> noto-hebrew-3d63973.tar.gz
mirror://githubcl/notofonts/hentaigana/tar.gz/3aa4d30 -> noto-hentaigana-3aa4d30.tar.gz
mirror://githubcl/notofonts/imperial-aramaic/tar.gz/84e4b80 -> noto-imperial-aramaic-84e4b80.tar.gz
mirror://githubcl/notofonts/indic-siyaq-numbers/tar.gz/edab641 -> noto-indic-siyaq-numbers-edab641.tar.gz
mirror://githubcl/notofonts/inscriptional-pahlavi/tar.gz/9229865 -> noto-inscriptional-pahlavi-9229865.tar.gz
mirror://githubcl/notofonts/inscriptional-parthian/tar.gz/718e75b -> noto-inscriptional-parthian-718e75b.tar.gz
mirror://githubcl/notofonts/javanese/tar.gz/ee9e707 -> noto-javanese-ee9e707.tar.gz
mirror://githubcl/notofonts/kaithi/tar.gz/30a3645 -> noto-kaithi-30a3645.tar.gz
mirror://githubcl/notofonts/kawi/tar.gz/d608375 -> noto-kawi-d608375.tar.gz
mirror://githubcl/notofonts/kannada/tar.gz/c529be7 -> noto-kannada-c529be7.tar.gz
mirror://githubcl/notofonts/kayah-li/tar.gz/a4ea3b4 -> noto-kayah-li-a4ea3b4.tar.gz
mirror://githubcl/notofonts/kharoshthi/tar.gz/e9090e2 -> noto-kharoshthi-e9090e2.tar.gz
mirror://githubcl/notofonts/khitan-small-script/tar.gz/0afd119d -> noto-khitan-small-script-0afd119d.tar.gz
mirror://githubcl/notofonts/khmer/tar.gz/a44f559 -> noto-khmer-a44f559.tar.gz
mirror://githubcl/notofonts/khojki/tar.gz/14a035a -> noto-khojki-14a035a.tar.gz
mirror://githubcl/notofonts/khudawadi/tar.gz/1707c19 -> noto-khudawadi-1707c19.tar.gz
mirror://githubcl/notofonts/lao/tar.gz/452bd56 -> noto-lao-452bd56.tar.gz
mirror://githubcl/notofonts/latin-greek-cyrillic/tar.gz/71cf6f3ca -> noto-latin-greek-cyrillic-71cf6f3ca.tar.gz
mirror://githubcl/notofonts/lepcha/tar.gz/cb2706c -> noto-lepcha-cb2706c.tar.gz
mirror://githubcl/notofonts/limbu/tar.gz/bcd2fc7 -> noto-limbu-bcd2fc7.tar.gz
mirror://githubcl/notofonts/linear-a/tar.gz/dcb3abb -> noto-linear-a-dcb3abb.tar.gz
mirror://githubcl/notofonts/linear-b/tar.gz/5eed8a3 -> noto-linear-b-5eed8a3.tar.gz
mirror://githubcl/notofonts/lisu/tar.gz/db1313c -> noto-lisu-db1313c.tar.gz
mirror://githubcl/notofonts/lycian/tar.gz/c5100e9 -> noto-lycian-c5100e9.tar.gz
mirror://githubcl/notofonts/lydian/tar.gz/84aafd0 -> noto-lydian-84aafd0.tar.gz
mirror://githubcl/notofonts/mahajani/tar.gz/88e15f8 -> noto-mahajani-88e15f8.tar.gz
mirror://githubcl/notofonts/makasar/tar.gz/32b40f9 -> noto-makasar-32b40f9.tar.gz
mirror://githubcl/notofonts/malayalam/tar.gz/cd430d8 -> noto-malayalam-cd430d8.tar.gz
mirror://githubcl/notofonts/mandaic/tar.gz/69cc180 -> noto-mandaic-69cc180.tar.gz
mirror://githubcl/notofonts/manichaean/tar.gz/ce5f932 -> noto-manichaean-ce5f932.tar.gz
mirror://githubcl/notofonts/marchen/tar.gz/093d665 -> noto-marchen-093d665.tar.gz
mirror://githubcl/notofonts/masaram-gondi/tar.gz/2ce7791 -> noto-masaram-gondi-2ce7791.tar.gz
mirror://githubcl/notofonts/math/tar.gz/6764bbdf -> noto-math-6764bbdf.tar.gz
mirror://githubcl/notofonts/mayan-numerals/tar.gz/51411fc -> noto-mayan-numerals-51411fc.tar.gz
mirror://githubcl/notofonts/medefaidrin/tar.gz/be58eba -> noto-medefaidrin-be58eba.tar.gz
mirror://githubcl/notofonts/meetei-mayek/tar.gz/e9bec62 -> noto-meetei-mayek-e9bec62.tar.gz
mirror://githubcl/notofonts/mende-kikakui/tar.gz/1caad60 -> noto-mende-kikakui-1caad60.tar.gz
mirror://githubcl/notofonts/meroitic/tar.gz/6285894 -> noto-meroitic-6285894.tar.gz
mirror://githubcl/notofonts/miao/tar.gz/ee32414 -> noto-miao-ee32414.tar.gz
mirror://githubcl/notofonts/modi/tar.gz/0e7ee4b -> noto-modi-0e7ee4b.tar.gz
mirror://githubcl/notofonts/mongolian/tar.gz/b7d9154 -> noto-mongolian-b7d9154.tar.gz
mirror://githubcl/notofonts/mro/tar.gz/3bd2c6a -> noto-mro-3bd2c6a.tar.gz
mirror://githubcl/notofonts/multani/tar.gz/c92e378 -> noto-multani-c92e378.tar.gz
mirror://githubcl/notofonts/music/tar.gz/205a96f -> noto-music-205a96f.tar.gz
mirror://githubcl/notofonts/myanmar/tar.gz/0f1e904 -> noto-myanmar-0f1e904.tar.gz
mirror://githubcl/notofonts/nabataean/tar.gz/d0e1fa7 -> noto-nabataean-d0e1fa7.tar.gz
mirror://githubcl/notofonts/nag-mundari/tar.gz/4cec3ee -> noto-nag-mundari-4cec3ee.tar.gz
mirror://githubcl/notofonts/nandinagari/tar.gz/297eb4f -> noto-nandinagari-297eb4f.tar.gz
mirror://githubcl/notofonts/nastaliq/tar.gz/ac904fb -> noto-nastaliq-ac904fb.tar.gz
mirror://githubcl/notofonts/new-tai-lue/tar.gz/fcf219c -> noto-new-tai-lue-fcf219c.tar.gz
mirror://githubcl/notofonts/newa/tar.gz/176f0e4 -> noto-newa-176f0e4.tar.gz
mirror://githubcl/notofonts/nko/tar.gz/88065e2 -> noto-nko-88065e2.tar.gz
mirror://githubcl/notofonts/nushu/tar.gz/59137b5 -> noto-nushu-59137b5.tar.gz
mirror://githubcl/notofonts/nyiakeng-puachue-hmong/tar.gz/a046870 -> noto-nyiakeng-puachue-hmong-a046870.tar.gz
mirror://githubcl/notofonts/ogham/tar.gz/a021c4b -> noto-ogham-a021c4b.tar.gz
mirror://githubcl/notofonts/ol-chiki/tar.gz/4128bf9 -> noto-ol-chiki-4128bf9.tar.gz
mirror://githubcl/notofonts/old-hungarian/tar.gz/f6cd63d -> noto-old-hungarian-f6cd63d.tar.gz
mirror://githubcl/notofonts/old-hungarian-ui/tar.gz/d1603b3 -> noto-old-hungarian-ui-d1603b3.tar.gz
mirror://githubcl/notofonts/old-italic/tar.gz/03c0ccd -> noto-old-italic-03c0ccd.tar.gz
mirror://githubcl/notofonts/old-north-arabian/tar.gz/ed9c650 -> noto-old-north-arabian-ed9c650.tar.gz
mirror://githubcl/notofonts/old-permic/tar.gz/00c2754 -> noto-old-permic-00c2754.tar.gz
mirror://githubcl/notofonts/old-persian/tar.gz/d4479fa -> noto-old-persian-d4479fa.tar.gz
mirror://githubcl/notofonts/old-sogdian/tar.gz/190b4b2 -> noto-old-sogdian-190b4b2.tar.gz
mirror://githubcl/notofonts/old-south-arabian/tar.gz/ebb3b78 -> noto-old-south-arabian-ebb3b78.tar.gz
mirror://githubcl/notofonts/old-turkic/tar.gz/be54e1e -> noto-old-turkic-be54e1e.tar.gz
mirror://githubcl/notofonts/old-uyghur/tar.gz/1379b92 -> noto-old-uyghur-1379b92.tar.gz
mirror://githubcl/notofonts/oriya/tar.gz/8383f20 -> noto-oriya-8383f20.tar.gz
mirror://githubcl/notofonts/osage/tar.gz/a8bb193 -> noto-osage-a8bb193.tar.gz
mirror://githubcl/notofonts/osmanya/tar.gz/85d416c -> noto-osmanya-85d416c.tar.gz
mirror://githubcl/notofonts/ottoman-siyaq-numbers/tar.gz/7ed7d02 -> noto-ottoman-siyaq-numbers-7ed7d02.tar.gz
mirror://githubcl/notofonts/pahawh-hmong/tar.gz/433211d -> noto-pahawh-hmong-433211d.tar.gz
mirror://githubcl/notofonts/palmyrene/tar.gz/5feef79 -> noto-palmyrene-5feef79.tar.gz
mirror://githubcl/notofonts/pau-cin-hau/tar.gz/be0e817 -> noto-pau-cin-hau-be0e817.tar.gz
mirror://githubcl/notofonts/phags-pa/tar.gz/a17cead -> noto-phags-pa-a17cead.tar.gz
mirror://githubcl/notofonts/phoenician/tar.gz/ea097dd -> noto-phoenician-ea097dd.tar.gz
mirror://githubcl/notofonts/psalter-pahlavi/tar.gz/915d10e -> noto-psalter-pahlavi-915d10e.tar.gz
mirror://githubcl/notofonts/rejang/tar.gz/4731c11 -> noto-rejang-4731c11.tar.gz
mirror://githubcl/notofonts/runic/tar.gz/3da6445 -> noto-runic-3da6445.tar.gz
mirror://githubcl/notofonts/samaritan/tar.gz/b57b178 -> noto-samaritan-b57b178.tar.gz
mirror://githubcl/notofonts/saurashtra/tar.gz/6f848c7 -> noto-saurashtra-6f848c7.tar.gz
mirror://githubcl/notofonts/sharada/tar.gz/5860efa -> noto-sharada-5860efa.tar.gz
mirror://githubcl/notofonts/shavian/tar.gz/f49e15f -> noto-shavian-f49e15f.tar.gz
mirror://githubcl/notofonts/siddham/tar.gz/16aa450 -> noto-siddham-16aa450.tar.gz
mirror://githubcl/notofonts/sign-writing/tar.gz/57a81919 -> noto-sign-writing-57a81919.tar.gz
mirror://githubcl/notofonts/sinhala/tar.gz/cdecf7b -> noto-sinhala-cdecf7b.tar.gz
mirror://githubcl/notofonts/sogdian/tar.gz/985ec6f -> noto-sogdian-985ec6f.tar.gz
mirror://githubcl/notofonts/sora-sompeng/tar.gz/3a4329c -> noto-sora-sompeng-3a4329c.tar.gz
mirror://githubcl/notofonts/soyombo/tar.gz/654ae46 -> noto-soyombo-654ae46.tar.gz
mirror://githubcl/notofonts/sundanese/tar.gz/a4b75be -> noto-sundanese-a4b75be.tar.gz
mirror://githubcl/notofonts/sunuwar/tar.gz/2d685e7 -> noto-sunuwar-2d685e7.tar.gz
mirror://githubcl/notofonts/syloti-nagri/tar.gz/8c9d1f4 -> noto-syloti-nagri-8c9d1f4.tar.gz
mirror://githubcl/notofonts/symbols/tar.gz/91ef396f -> noto-symbols-91ef396f.tar.gz
mirror://githubcl/notofonts/syriac/tar.gz/2e6607f -> noto-syriac-2e6607f.tar.gz
mirror://githubcl/notofonts/tagalog/tar.gz/3a157f4 -> noto-tagalog-3a157f4.tar.gz
mirror://githubcl/notofonts/tagbanwa/tar.gz/a63bf75 -> noto-tagbanwa-a63bf75.tar.gz
mirror://githubcl/notofonts/tai-le/tar.gz/1d81562 -> noto-tai-le-1d81562.tar.gz
mirror://githubcl/notofonts/tai-tham/tar.gz/e7f3462 -> noto-tai-tham-e7f3462.tar.gz
mirror://githubcl/notofonts/tai-viet/tar.gz/35b4d77 -> noto-tai-viet-35b4d77.tar.gz
mirror://githubcl/notofonts/takri/tar.gz/da41dbc -> noto-takri-da41dbc.tar.gz
mirror://githubcl/notofonts/tamil/tar.gz/d2a9200 -> noto-tamil-d2a9200.tar.gz
mirror://githubcl/notofonts/tangsa/tar.gz/dd0cbc4 -> noto-tangsa-dd0cbc4.tar.gz
mirror://githubcl/notofonts/tangut/tar.gz/50cf91d -> noto-tangut-50cf91d.tar.gz
mirror://githubcl/notofonts/telugu/tar.gz/e5a5b2a -> noto-telugu-e5a5b2a.tar.gz
mirror://githubcl/notofonts/thaana/tar.gz/20f7f18 -> noto-thaana-20f7f18.tar.gz
mirror://githubcl/notofonts/thai/tar.gz/5fcaac2 -> noto-thai-5fcaac2.tar.gz
mirror://githubcl/notofonts/tibetan/tar.gz/76fd5cb -> noto-tibetan-76fd5cb.tar.gz
mirror://githubcl/notofonts/tifinagh/tar.gz/aeb343e -> noto-tifinagh-aeb343e.tar.gz
mirror://githubcl/notofonts/tirhuta/tar.gz/bb725d0 -> noto-tirhuta-bb725d0.tar.gz
mirror://githubcl/notofonts/todhri/tar.gz/203e8ff -> noto-todhri-203e8ff.tar.gz
mirror://githubcl/notofonts/toto/tar.gz/1f53bed -> noto-toto-1f53bed.tar.gz
mirror://githubcl/notofonts/ugaritic/tar.gz/0c4e02c -> noto-ugaritic-0c4e02c.tar.gz
mirror://githubcl/notofonts/vai/tar.gz/7377da4 -> noto-vai-7377da4.tar.gz
mirror://githubcl/notofonts/vithkuqi/tar.gz/27aeb70 -> noto-vithkuqi-27aeb70.tar.gz
mirror://githubcl/notofonts/wancho/tar.gz/956b5a4 -> noto-wancho-956b5a4.tar.gz
mirror://githubcl/notofonts/warang-citi/tar.gz/78d1597 -> noto-warang-citi-78d1597.tar.gz
mirror://githubcl/notofonts/yezidi/tar.gz/9d8aad9 -> noto-yezidi-9d8aad9.tar.gz
mirror://githubcl/notofonts/yi/tar.gz/bf10763 -> noto-yi-bf10763.tar.gz
mirror://githubcl/notofonts/zanabazar-square/tar.gz/316101b -> noto-zanabazar-square-316101b.tar.gz
mirror://githubcl/notofonts/znamenny/tar.gz/f7b6c39 -> noto-znamenny-f7b6c39.tar.gz
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
	echo 'buildVariable: false' >> todhri-203e8ff/sources/config-serif-todhri.yaml || die
	rm todhri-203e8ff/sources/NotoSerifTodhri-Regular.designspace || die
	use variable && export SKIP_VF="$(grep -rl 'buildVariable.*false' \
		--include=config-*.yaml | xargs yq -r '.sources[]' | grep -v NotoSansThaiLoopedUI)"
	use clean-as-you-go && HELPER_ARGS=( clean )
	mkdir -p ${FONT_SRCDIR}
	cp -f -t ${FONT_SRCDIR} -rl */sources/*
	rm -f "${FONT_SRCDIR}/NotoSansMultani-Regular (Autosaved).glyphs"
	fontmake_src_prepare
}
