# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FONT_SRCDIR=src
# https://github.com/notofonts/notofonts.github.io/raw/main/fontrepos.json
SRC_URI="
mirror://githubcl/notofonts/adlam/tar.gz/dc2e980 -> noto-adlam-dc2e980.tar.gz
mirror://githubcl/notofonts/ahom/tar.gz/fb3e25e -> noto-ahom-fb3e25e.tar.gz
mirror://githubcl/notofonts/anatolian-hieroglyphs/tar.gz/d82f0bc -> noto-anatolian-hieroglyphs-d82f0bc.tar.gz
mirror://githubcl/notofonts/arabic/tar.gz/9e68bce7 -> noto-arabic-9e68bce7.tar.gz
mirror://githubcl/notofonts/armenian/tar.gz/36e1e68 -> noto-armenian-36e1e68.tar.gz
mirror://githubcl/notofonts/avestan/tar.gz/c19976e -> noto-avestan-c19976e.tar.gz
mirror://githubcl/notofonts/balinese/tar.gz/b0f7466 -> noto-balinese-b0f7466.tar.gz
mirror://githubcl/notofonts/bamum/tar.gz/92bf232 -> noto-bamum-92bf232.tar.gz
mirror://githubcl/notofonts/bassa-vah/tar.gz/bed459c -> noto-bassa-vah-bed459c.tar.gz
mirror://githubcl/notofonts/batak/tar.gz/9e4d85f -> noto-batak-9e4d85f.tar.gz
mirror://githubcl/notofonts/bengali/tar.gz/a43cbb8 -> noto-bengali-a43cbb8.tar.gz
mirror://githubcl/notofonts/bhaiksuki/tar.gz/570db5a -> noto-bhaiksuki-570db5a.tar.gz
mirror://githubcl/notofonts/brahmi/tar.gz/7803437 -> noto-brahmi-7803437.tar.gz
mirror://githubcl/notofonts/buginese/tar.gz/8d73947 -> noto-buginese-8d73947.tar.gz
mirror://githubcl/notofonts/buhid/tar.gz/f678808 -> noto-buhid-f678808.tar.gz
mirror://githubcl/notofonts/canadian-aboriginal/tar.gz/1766b85d -> noto-canadian-aboriginal-1766b85d.tar.gz
mirror://githubcl/notofonts/carian/tar.gz/90653aa -> noto-carian-90653aa.tar.gz
mirror://githubcl/notofonts/caucasian-albanian/tar.gz/fe112d9 -> noto-caucasian-albanian-fe112d9.tar.gz
mirror://githubcl/notofonts/chakma/tar.gz/239fe3a -> noto-chakma-239fe3a.tar.gz
mirror://githubcl/notofonts/cham/tar.gz/ab48c58 -> noto-cham-ab48c58.tar.gz
mirror://githubcl/notofonts/cherokee/tar.gz/a8a61f7 -> noto-cherokee-a8a61f7.tar.gz
mirror://githubcl/notofonts/chorasmian/tar.gz/0ce3cfe -> noto-chorasmian-0ce3cfe.tar.gz
mirror://githubcl/notofonts/coptic/tar.gz/ed35224 -> noto-coptic-ed35224.tar.gz
mirror://githubcl/notofonts/cuneiform/tar.gz/24c590e -> noto-cuneiform-24c590e.tar.gz
mirror://githubcl/notofonts/cypriot/tar.gz/4f81293 -> noto-cypriot-4f81293.tar.gz
mirror://githubcl/notofonts/cypro-minoan/tar.gz/12b0fed -> noto-cypro-minoan-12b0fed.tar.gz
mirror://githubcl/notofonts/deseret/tar.gz/fab3d4d -> noto-deseret-fab3d4d.tar.gz
mirror://githubcl/notofonts/devanagari/tar.gz/88d8a1d0 -> noto-devanagari-88d8a1d0.tar.gz
mirror://githubcl/notofonts/dives-akuru/tar.gz/f9b566a -> noto-dives-akuru-f9b566a.tar.gz
mirror://githubcl/notofonts/dogra/tar.gz/ca3e78b -> noto-dogra-ca3e78b.tar.gz
mirror://githubcl/notofonts/duployan/tar.gz/9626869 -> noto-duployan-9626869.tar.gz
mirror://githubcl/notofonts/egyptian-hieroglyphs/tar.gz/773da39 -> noto-egyptian-hieroglyphs-773da39.tar.gz
mirror://githubcl/notofonts/elbasan/tar.gz/42c5913 -> noto-elbasan-42c5913.tar.gz
mirror://githubcl/notofonts/elymaic/tar.gz/4a230cd -> noto-elymaic-4a230cd.tar.gz
mirror://githubcl/notofonts/ethiopic/tar.gz/3176529 -> noto-ethiopic-3176529.tar.gz
mirror://githubcl/notofonts/georgian/tar.gz/b9e1ca7 -> noto-georgian-b9e1ca7.tar.gz
mirror://githubcl/notofonts/glagolitic/tar.gz/142196c -> noto-glagolitic-142196c.tar.gz
mirror://githubcl/notofonts/gothic/tar.gz/1fdfe7f -> noto-gothic-1fdfe7f.tar.gz
mirror://githubcl/notofonts/grantha/tar.gz/e341f72 -> noto-grantha-e341f72.tar.gz
mirror://githubcl/notofonts/gujarati/tar.gz/d4f75b9 -> noto-gujarati-d4f75b9.tar.gz
mirror://githubcl/notofonts/gunjala-gondi/tar.gz/ab82937 -> noto-gunjala-gondi-ab82937.tar.gz
mirror://githubcl/notofonts/gurmukhi/tar.gz/ced2833 -> noto-gurmukhi-ced2833.tar.gz
mirror://githubcl/notofonts/hanifi-rohingya/tar.gz/48ba61f -> noto-hanifi-rohingya-48ba61f.tar.gz
mirror://githubcl/notofonts/hanunoo/tar.gz/5799d61 -> noto-hanunoo-5799d61.tar.gz
mirror://githubcl/notofonts/hatran/tar.gz/de47205 -> noto-hatran-de47205.tar.gz
mirror://githubcl/notofonts/hebrew/tar.gz/b86e609 -> noto-hebrew-b86e609.tar.gz
mirror://githubcl/notofonts/imperial-aramaic/tar.gz/059b859 -> noto-imperial-aramaic-059b859.tar.gz
mirror://githubcl/notofonts/indic-siyaq-numbers/tar.gz/5c2be06 -> noto-indic-siyaq-numbers-5c2be06.tar.gz
mirror://githubcl/notofonts/inscriptional-pahlavi/tar.gz/ae11e43 -> noto-inscriptional-pahlavi-ae11e43.tar.gz
mirror://githubcl/notofonts/inscriptional-parthian/tar.gz/3ad1b22 -> noto-inscriptional-parthian-3ad1b22.tar.gz
mirror://githubcl/notofonts/javanese/tar.gz/da4d013 -> noto-javanese-da4d013.tar.gz
mirror://githubcl/notofonts/kaithi/tar.gz/897d285 -> noto-kaithi-897d285.tar.gz
mirror://githubcl/notofonts/kawi/tar.gz/7b11823 -> noto-kawi-7b11823.tar.gz
mirror://githubcl/notofonts/kannada/tar.gz/5808394 -> noto-kannada-5808394.tar.gz
mirror://githubcl/notofonts/kayah-li/tar.gz/d804f25 -> noto-kayah-li-d804f25.tar.gz
mirror://githubcl/notofonts/kharoshthi/tar.gz/aacffd4 -> noto-kharoshthi-aacffd4.tar.gz
mirror://githubcl/notofonts/khitan-small-script/tar.gz/0b9bd72b -> noto-khitan-small-script-0b9bd72b.tar.gz
mirror://githubcl/notofonts/khmer/tar.gz/fddb0ac -> noto-khmer-fddb0ac.tar.gz
mirror://githubcl/notofonts/khojki/tar.gz/12a29ae -> noto-khojki-12a29ae.tar.gz
mirror://githubcl/notofonts/khudawadi/tar.gz/842e04f -> noto-khudawadi-842e04f.tar.gz
mirror://githubcl/notofonts/lao/tar.gz/3b78b9c -> noto-lao-3b78b9c.tar.gz
mirror://githubcl/notofonts/latin-greek-cyrillic/tar.gz/c4a321e12 -> noto-latin-greek-cyrillic-c4a321e12.tar.gz
mirror://githubcl/notofonts/lepcha/tar.gz/22993db -> noto-lepcha-22993db.tar.gz
mirror://githubcl/notofonts/limbu/tar.gz/191ac5f -> noto-limbu-191ac5f.tar.gz
mirror://githubcl/notofonts/linear-a/tar.gz/e139e1c -> noto-linear-a-e139e1c.tar.gz
mirror://githubcl/notofonts/linear-b/tar.gz/410f88c -> noto-linear-b-410f88c.tar.gz
mirror://githubcl/notofonts/lisu/tar.gz/d7e3457 -> noto-lisu-d7e3457.tar.gz
mirror://githubcl/notofonts/lycian/tar.gz/1e9e778 -> noto-lycian-1e9e778.tar.gz
mirror://githubcl/notofonts/lydian/tar.gz/fb2444a -> noto-lydian-fb2444a.tar.gz
mirror://githubcl/notofonts/mahajani/tar.gz/6af195b -> noto-mahajani-6af195b.tar.gz
mirror://githubcl/notofonts/makasar/tar.gz/e7902cc -> noto-makasar-e7902cc.tar.gz
mirror://githubcl/notofonts/malayalam/tar.gz/66cd7c0 -> noto-malayalam-66cd7c0.tar.gz
mirror://githubcl/notofonts/mandaic/tar.gz/36a3804 -> noto-mandaic-36a3804.tar.gz
mirror://githubcl/notofonts/manichaean/tar.gz/d3d108a -> noto-manichaean-d3d108a.tar.gz
mirror://githubcl/notofonts/marchen/tar.gz/8b7d0d7 -> noto-marchen-8b7d0d7.tar.gz
mirror://githubcl/notofonts/masaram-gondi/tar.gz/aa68815 -> noto-masaram-gondi-aa68815.tar.gz
mirror://githubcl/notofonts/math/tar.gz/fa7e876d -> noto-math-fa7e876d.tar.gz
mirror://githubcl/notofonts/mayan-numerals/tar.gz/2361f67 -> noto-mayan-numerals-2361f67.tar.gz
mirror://githubcl/notofonts/medefaidrin/tar.gz/db67ede -> noto-medefaidrin-db67ede.tar.gz
mirror://githubcl/notofonts/meetei-mayek/tar.gz/0df2732 -> noto-meetei-mayek-0df2732.tar.gz
mirror://githubcl/notofonts/mende-kikakui/tar.gz/70eb55c -> noto-mende-kikakui-70eb55c.tar.gz
mirror://githubcl/notofonts/meroitic/tar.gz/d682685 -> noto-meroitic-d682685.tar.gz
mirror://githubcl/notofonts/miao/tar.gz/60e05da -> noto-miao-60e05da.tar.gz
mirror://githubcl/notofonts/modi/tar.gz/8e9d484 -> noto-modi-8e9d484.tar.gz
mirror://githubcl/notofonts/mongolian/tar.gz/a61ef47 -> noto-mongolian-a61ef47.tar.gz
mirror://githubcl/notofonts/mro/tar.gz/3d7debf -> noto-mro-3d7debf.tar.gz
mirror://githubcl/notofonts/multani/tar.gz/1ef5899 -> noto-multani-1ef5899.tar.gz
mirror://githubcl/notofonts/music/tar.gz/2c97b9e -> noto-music-2c97b9e.tar.gz
mirror://githubcl/notofonts/myanmar/tar.gz/e63df08 -> noto-myanmar-e63df08.tar.gz
mirror://githubcl/notofonts/nabataean/tar.gz/d16bdaa -> noto-nabataean-d16bdaa.tar.gz
mirror://githubcl/notofonts/nag-mundari/tar.gz/64846ef -> noto-nag-mundari-64846ef.tar.gz
mirror://githubcl/notofonts/nandinagari/tar.gz/6fd9a06 -> noto-nandinagari-6fd9a06.tar.gz
mirror://githubcl/notofonts/nastaliq/tar.gz/3508acd -> noto-nastaliq-3508acd.tar.gz
mirror://githubcl/notofonts/new-tai-lue/tar.gz/f591483 -> noto-new-tai-lue-f591483.tar.gz
mirror://githubcl/notofonts/newa/tar.gz/5a902c1 -> noto-newa-5a902c1.tar.gz
mirror://githubcl/notofonts/nko/tar.gz/aee63be -> noto-nko-aee63be.tar.gz
mirror://githubcl/notofonts/nushu/tar.gz/759580e -> noto-nushu-759580e.tar.gz
mirror://githubcl/notofonts/nyiakeng-puachue-hmong/tar.gz/eb4fe4b -> noto-nyiakeng-puachue-hmong-eb4fe4b.tar.gz
mirror://githubcl/notofonts/ogham/tar.gz/f9ef276 -> noto-ogham-f9ef276.tar.gz
mirror://githubcl/notofonts/ol-chiki/tar.gz/61f81d5 -> noto-ol-chiki-61f81d5.tar.gz
mirror://githubcl/notofonts/old-hungarian/tar.gz/1e40814 -> noto-old-hungarian-1e40814.tar.gz
mirror://githubcl/notofonts/old-hungarian-ui/tar.gz/fdbc41f -> noto-old-hungarian-ui-fdbc41f.tar.gz
mirror://githubcl/notofonts/old-italic/tar.gz/486912f -> noto-old-italic-486912f.tar.gz
mirror://githubcl/notofonts/old-north-arabian/tar.gz/da9dd37 -> noto-old-north-arabian-da9dd37.tar.gz
mirror://githubcl/notofonts/old-permic/tar.gz/080df88 -> noto-old-permic-080df88.tar.gz
mirror://githubcl/notofonts/old-persian/tar.gz/27b5583 -> noto-old-persian-27b5583.tar.gz
mirror://githubcl/notofonts/old-sogdian/tar.gz/aa13b98 -> noto-old-sogdian-aa13b98.tar.gz
mirror://githubcl/notofonts/old-south-arabian/tar.gz/e77ff1f -> noto-old-south-arabian-e77ff1f.tar.gz
mirror://githubcl/notofonts/old-turkic/tar.gz/598d6ec -> noto-old-turkic-598d6ec.tar.gz
mirror://githubcl/notofonts/old-uyghur/tar.gz/44b6cbf -> noto-old-uyghur-44b6cbf.tar.gz
mirror://githubcl/notofonts/oriya/tar.gz/757b8f1 -> noto-oriya-757b8f1.tar.gz
mirror://githubcl/notofonts/osage/tar.gz/7778dc0 -> noto-osage-7778dc0.tar.gz
mirror://githubcl/notofonts/osmanya/tar.gz/6b87e2c -> noto-osmanya-6b87e2c.tar.gz
mirror://githubcl/notofonts/ottoman-siyaq-numbers/tar.gz/b6cca8f -> noto-ottoman-siyaq-numbers-b6cca8f.tar.gz
mirror://githubcl/notofonts/pahawh-hmong/tar.gz/793abf1 -> noto-pahawh-hmong-793abf1.tar.gz
mirror://githubcl/notofonts/palmyrene/tar.gz/bbb69ea -> noto-palmyrene-bbb69ea.tar.gz
mirror://githubcl/notofonts/pau-cin-hau/tar.gz/31ef11c -> noto-pau-cin-hau-31ef11c.tar.gz
mirror://githubcl/notofonts/phags-pa/tar.gz/a2cd1a7 -> noto-phags-pa-a2cd1a7.tar.gz
mirror://githubcl/notofonts/phoenician/tar.gz/42000fa -> noto-phoenician-42000fa.tar.gz
mirror://githubcl/notofonts/psalter-pahlavi/tar.gz/2f531fd -> noto-psalter-pahlavi-2f531fd.tar.gz
mirror://githubcl/notofonts/rejang/tar.gz/260e890 -> noto-rejang-260e890.tar.gz
mirror://githubcl/notofonts/runic/tar.gz/0badcd9 -> noto-runic-0badcd9.tar.gz
mirror://githubcl/notofonts/samaritan/tar.gz/86c2e96 -> noto-samaritan-86c2e96.tar.gz
mirror://githubcl/notofonts/saurashtra/tar.gz/922f6bd -> noto-saurashtra-922f6bd.tar.gz
mirror://githubcl/notofonts/sharada/tar.gz/cafc138 -> noto-sharada-cafc138.tar.gz
mirror://githubcl/notofonts/shavian/tar.gz/15edbc9 -> noto-shavian-15edbc9.tar.gz
mirror://githubcl/notofonts/siddham/tar.gz/6ff212c -> noto-siddham-6ff212c.tar.gz
mirror://githubcl/notofonts/sign-writing/tar.gz/a0a0e9a8 -> noto-sign-writing-a0a0e9a8.tar.gz
mirror://githubcl/notofonts/sinhala/tar.gz/ed40d91 -> noto-sinhala-ed40d91.tar.gz
mirror://githubcl/notofonts/sogdian/tar.gz/9f27761 -> noto-sogdian-9f27761.tar.gz
mirror://githubcl/notofonts/sora-sompeng/tar.gz/d6dc3ea -> noto-sora-sompeng-d6dc3ea.tar.gz
mirror://githubcl/notofonts/soyombo/tar.gz/c2488cb -> noto-soyombo-c2488cb.tar.gz
mirror://githubcl/notofonts/sundanese/tar.gz/8069fb6 -> noto-sundanese-8069fb6.tar.gz
mirror://githubcl/notofonts/syloti-nagri/tar.gz/24ab3ac -> noto-syloti-nagri-24ab3ac.tar.gz
mirror://githubcl/notofonts/symbols/tar.gz/635cef9e -> noto-symbols-635cef9e.tar.gz
mirror://githubcl/notofonts/syriac/tar.gz/0be4b71 -> noto-syriac-0be4b71.tar.gz
mirror://githubcl/notofonts/tagalog/tar.gz/3546fa0 -> noto-tagalog-3546fa0.tar.gz
mirror://githubcl/notofonts/tagbanwa/tar.gz/ec39a09 -> noto-tagbanwa-ec39a09.tar.gz
mirror://githubcl/notofonts/tai-le/tar.gz/297f30f -> noto-tai-le-297f30f.tar.gz
mirror://githubcl/notofonts/tai-tham/tar.gz/e336c51 -> noto-tai-tham-e336c51.tar.gz
mirror://githubcl/notofonts/tai-viet/tar.gz/8e1e111 -> noto-tai-viet-8e1e111.tar.gz
mirror://githubcl/notofonts/takri/tar.gz/bf175ad -> noto-takri-bf175ad.tar.gz
mirror://githubcl/notofonts/tamil/tar.gz/2a450f1 -> noto-tamil-2a450f1.tar.gz
mirror://githubcl/notofonts/tangsa/tar.gz/8d40c34 -> noto-tangsa-8d40c34.tar.gz
mirror://githubcl/notofonts/tangut/tar.gz/fd05a0c4 -> noto-tangut-fd05a0c4.tar.gz
mirror://githubcl/notofonts/telugu/tar.gz/2729e30 -> noto-telugu-2729e30.tar.gz
mirror://githubcl/notofonts/thaana/tar.gz/18a413d -> noto-thaana-18a413d.tar.gz
mirror://githubcl/notofonts/thai/tar.gz/b257d43 -> noto-thai-b257d43.tar.gz
mirror://githubcl/notofonts/tibetan/tar.gz/28f1693 -> noto-tibetan-28f1693.tar.gz
mirror://githubcl/notofonts/tifinagh/tar.gz/6c19a68 -> noto-tifinagh-6c19a68.tar.gz
mirror://githubcl/notofonts/tirhuta/tar.gz/3c941a6 -> noto-tirhuta-3c941a6.tar.gz
mirror://githubcl/notofonts/toto/tar.gz/654cc6c -> noto-toto-654cc6c.tar.gz
mirror://githubcl/notofonts/ugaritic/tar.gz/9ddf5ed -> noto-ugaritic-9ddf5ed.tar.gz
mirror://githubcl/notofonts/vai/tar.gz/f30c633 -> noto-vai-f30c633.tar.gz
mirror://githubcl/notofonts/vithkuqi/tar.gz/124a12d -> noto-vithkuqi-124a12d.tar.gz
mirror://githubcl/notofonts/wancho/tar.gz/91ab06e -> noto-wancho-91ab06e.tar.gz
mirror://githubcl/notofonts/warang-citi/tar.gz/4e23805 -> noto-warang-citi-4e23805.tar.gz
mirror://githubcl/notofonts/yezidi/tar.gz/905a5f0 -> noto-yezidi-905a5f0.tar.gz
mirror://githubcl/notofonts/yi/tar.gz/bdf568a -> noto-yi-bdf568a.tar.gz
mirror://githubcl/notofonts/zanabazar-square/tar.gz/41b2554 -> noto-zanabazar-square-41b2554.tar.gz
mirror://githubcl/notofonts/znamenny/tar.gz/342a803 -> noto-znamenny-342a803.tar.gz
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
