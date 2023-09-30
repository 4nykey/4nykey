# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FONT_SRCDIR=src
# https://github.com/notofonts/notofonts.github.io/raw/main/fontrepos.json
SRC_URI="
mirror://githubcl/notofonts/adlam/tar.gz/5f0082a -> noto-adlam-5f0082a.tar.gz
mirror://githubcl/notofonts/ahom/tar.gz/ddc04c2 -> noto-ahom-ddc04c2.tar.gz
mirror://githubcl/notofonts/anatolian-hieroglyphs/tar.gz/480f1c1 -> noto-anatolian-hieroglyphs-480f1c1.tar.gz
mirror://githubcl/notofonts/arabic/tar.gz/2227806c -> noto-arabic-2227806c.tar.gz
mirror://githubcl/notofonts/armenian/tar.gz/967f85f -> noto-armenian-967f85f.tar.gz
mirror://githubcl/notofonts/avestan/tar.gz/d7b2e8c -> noto-avestan-d7b2e8c.tar.gz
mirror://githubcl/notofonts/balinese/tar.gz/e841f2e -> noto-balinese-e841f2e.tar.gz
mirror://githubcl/notofonts/bamum/tar.gz/d08b335 -> noto-bamum-d08b335.tar.gz
mirror://githubcl/notofonts/bassa-vah/tar.gz/b656777 -> noto-bassa-vah-b656777.tar.gz
mirror://githubcl/notofonts/batak/tar.gz/60f1ecc -> noto-batak-60f1ecc.tar.gz
mirror://githubcl/notofonts/bengali/tar.gz/9521115 -> noto-bengali-9521115.tar.gz
mirror://githubcl/notofonts/bhaiksuki/tar.gz/f6f9e77 -> noto-bhaiksuki-f6f9e77.tar.gz
mirror://githubcl/notofonts/brahmi/tar.gz/97c83e0 -> noto-brahmi-97c83e0.tar.gz
mirror://githubcl/notofonts/buginese/tar.gz/787deae -> noto-buginese-787deae.tar.gz
mirror://githubcl/notofonts/buhid/tar.gz/3336b4b -> noto-buhid-3336b4b.tar.gz
mirror://githubcl/notofonts/canadian-aboriginal/tar.gz/b98f8acf -> noto-canadian-aboriginal-b98f8acf.tar.gz
mirror://githubcl/notofonts/carian/tar.gz/fdc0e34 -> noto-carian-fdc0e34.tar.gz
mirror://githubcl/notofonts/caucasian-albanian/tar.gz/ad77f76 -> noto-caucasian-albanian-ad77f76.tar.gz
mirror://githubcl/notofonts/chakma/tar.gz/b8240d9 -> noto-chakma-b8240d9.tar.gz
mirror://githubcl/notofonts/cham/tar.gz/5300537 -> noto-cham-5300537.tar.gz
mirror://githubcl/notofonts/cherokee/tar.gz/081c39a -> noto-cherokee-081c39a.tar.gz
mirror://githubcl/notofonts/chorasmian/tar.gz/945a26c -> noto-chorasmian-945a26c.tar.gz
mirror://githubcl/notofonts/coptic/tar.gz/a5a6909 -> noto-coptic-a5a6909.tar.gz
mirror://githubcl/notofonts/cuneiform/tar.gz/20c2d39 -> noto-cuneiform-20c2d39.tar.gz
mirror://githubcl/notofonts/cypriot/tar.gz/6e28f5f -> noto-cypriot-6e28f5f.tar.gz
mirror://githubcl/notofonts/cypro-minoan/tar.gz/3ffc1fc -> noto-cypro-minoan-3ffc1fc.tar.gz
mirror://githubcl/notofonts/deseret/tar.gz/33d9e58 -> noto-deseret-33d9e58.tar.gz
mirror://githubcl/notofonts/devanagari/tar.gz/efaf162 -> noto-devanagari-efaf162.tar.gz
mirror://githubcl/notofonts/dives-akuru/tar.gz/d4bf13a -> noto-dives-akuru-d4bf13a.tar.gz
mirror://githubcl/notofonts/dogra/tar.gz/f42ba15 -> noto-dogra-f42ba15.tar.gz
mirror://githubcl/notofonts/duployan/tar.gz/af53a4a -> noto-duployan-af53a4a.tar.gz
mirror://githubcl/notofonts/egyptian-hieroglyphs/tar.gz/bdb9905 -> noto-egyptian-hieroglyphs-bdb9905.tar.gz
mirror://githubcl/notofonts/elbasan/tar.gz/7c26dcf -> noto-elbasan-7c26dcf.tar.gz
mirror://githubcl/notofonts/elymaic/tar.gz/4fd4164 -> noto-elymaic-4fd4164.tar.gz
mirror://githubcl/notofonts/ethiopic/tar.gz/da7f411 -> noto-ethiopic-da7f411.tar.gz
mirror://githubcl/notofonts/georgian/tar.gz/850c587 -> noto-georgian-850c587.tar.gz
mirror://githubcl/notofonts/glagolitic/tar.gz/aba2a97 -> noto-glagolitic-aba2a97.tar.gz
mirror://githubcl/notofonts/gothic/tar.gz/3682cf6 -> noto-gothic-3682cf6.tar.gz
mirror://githubcl/notofonts/grantha/tar.gz/26415d4 -> noto-grantha-26415d4.tar.gz
mirror://githubcl/notofonts/gujarati/tar.gz/64a5de8 -> noto-gujarati-64a5de8.tar.gz
mirror://githubcl/notofonts/gunjala-gondi/tar.gz/2e90f4d -> noto-gunjala-gondi-2e90f4d.tar.gz
mirror://githubcl/notofonts/gurmukhi/tar.gz/f6b7a6c -> noto-gurmukhi-f6b7a6c.tar.gz
mirror://githubcl/notofonts/hanifi-rohingya/tar.gz/079dcf6 -> noto-hanifi-rohingya-079dcf6.tar.gz
mirror://githubcl/notofonts/hanunoo/tar.gz/e40b008 -> noto-hanunoo-e40b008.tar.gz
mirror://githubcl/notofonts/hatran/tar.gz/b2ce17e -> noto-hatran-b2ce17e.tar.gz
mirror://githubcl/notofonts/hebrew/tar.gz/4d688c4 -> noto-hebrew-4d688c4.tar.gz
mirror://githubcl/notofonts/imperial-aramaic/tar.gz/d6cd227 -> noto-imperial-aramaic-d6cd227.tar.gz
mirror://githubcl/notofonts/indic-siyaq-numbers/tar.gz/3039776 -> noto-indic-siyaq-numbers-3039776.tar.gz
mirror://githubcl/notofonts/inscriptional-pahlavi/tar.gz/48a950c -> noto-inscriptional-pahlavi-48a950c.tar.gz
mirror://githubcl/notofonts/inscriptional-parthian/tar.gz/c53d050 -> noto-inscriptional-parthian-c53d050.tar.gz
mirror://githubcl/notofonts/javanese/tar.gz/4faccc7 -> noto-javanese-4faccc7.tar.gz
mirror://githubcl/notofonts/kaithi/tar.gz/ca0c332 -> noto-kaithi-ca0c332.tar.gz
mirror://githubcl/notofonts/kawi/tar.gz/a70c1b3 -> noto-kawi-a70c1b3.tar.gz
mirror://githubcl/notofonts/kannada/tar.gz/6387faa -> noto-kannada-6387faa.tar.gz
mirror://githubcl/notofonts/kayah-li/tar.gz/9be3045 -> noto-kayah-li-9be3045.tar.gz
mirror://githubcl/notofonts/kharoshthi/tar.gz/297e010 -> noto-kharoshthi-297e010.tar.gz
mirror://githubcl/notofonts/khitan-small-script/tar.gz/0eac7683 -> noto-khitan-small-script-0eac7683.tar.gz
mirror://githubcl/notofonts/khmer/tar.gz/5d2251a -> noto-khmer-5d2251a.tar.gz
mirror://githubcl/notofonts/khojki/tar.gz/336b343 -> noto-khojki-336b343.tar.gz
mirror://githubcl/notofonts/khudawadi/tar.gz/53586de -> noto-khudawadi-53586de.tar.gz
mirror://githubcl/notofonts/lao/tar.gz/8b9c1a6 -> noto-lao-8b9c1a6.tar.gz
mirror://githubcl/notofonts/latin-greek-cyrillic/tar.gz/9b7310b8f -> noto-latin-greek-cyrillic-9b7310b8f.tar.gz
mirror://githubcl/notofonts/lepcha/tar.gz/f8c0d33 -> noto-lepcha-f8c0d33.tar.gz
mirror://githubcl/notofonts/limbu/tar.gz/5dbe236 -> noto-limbu-5dbe236.tar.gz
mirror://githubcl/notofonts/linear-a/tar.gz/2586573 -> noto-linear-a-2586573.tar.gz
mirror://githubcl/notofonts/linear-b/tar.gz/eec155e -> noto-linear-b-eec155e.tar.gz
mirror://githubcl/notofonts/lisu/tar.gz/b3b1f40 -> noto-lisu-b3b1f40.tar.gz
mirror://githubcl/notofonts/lycian/tar.gz/5e8c626 -> noto-lycian-5e8c626.tar.gz
mirror://githubcl/notofonts/lydian/tar.gz/31d0e90 -> noto-lydian-31d0e90.tar.gz
mirror://githubcl/notofonts/mahajani/tar.gz/0d2e5be -> noto-mahajani-0d2e5be.tar.gz
mirror://githubcl/notofonts/makasar/tar.gz/94d6bfc -> noto-makasar-94d6bfc.tar.gz
mirror://githubcl/notofonts/malayalam/tar.gz/ea3898d -> noto-malayalam-ea3898d.tar.gz
mirror://githubcl/notofonts/mandaic/tar.gz/932cf08 -> noto-mandaic-932cf08.tar.gz
mirror://githubcl/notofonts/manichaean/tar.gz/83a45f5 -> noto-manichaean-83a45f5.tar.gz
mirror://githubcl/notofonts/marchen/tar.gz/9c5a492 -> noto-marchen-9c5a492.tar.gz
mirror://githubcl/notofonts/masaram-gondi/tar.gz/f207f80 -> noto-masaram-gondi-f207f80.tar.gz
mirror://githubcl/notofonts/math/tar.gz/7d5de23 -> noto-math-7d5de23.tar.gz
mirror://githubcl/notofonts/mayan-numerals/tar.gz/70249da -> noto-mayan-numerals-70249da.tar.gz
mirror://githubcl/notofonts/medefaidrin/tar.gz/cf13299 -> noto-medefaidrin-cf13299.tar.gz
mirror://githubcl/notofonts/meetei-mayek/tar.gz/c1371a7 -> noto-meetei-mayek-c1371a7.tar.gz
mirror://githubcl/notofonts/mende-kikakui/tar.gz/d8a79d7 -> noto-mende-kikakui-d8a79d7.tar.gz
mirror://githubcl/notofonts/meroitic/tar.gz/6e8991a -> noto-meroitic-6e8991a.tar.gz
mirror://githubcl/notofonts/miao/tar.gz/4b35497 -> noto-miao-4b35497.tar.gz
mirror://githubcl/notofonts/modi/tar.gz/f9b93d5 -> noto-modi-f9b93d5.tar.gz
mirror://githubcl/notofonts/mongolian/tar.gz/666f7b3 -> noto-mongolian-666f7b3.tar.gz
mirror://githubcl/notofonts/mro/tar.gz/67d04c8 -> noto-mro-67d04c8.tar.gz
mirror://githubcl/notofonts/multani/tar.gz/0335677 -> noto-multani-0335677.tar.gz
mirror://githubcl/notofonts/music/tar.gz/0d82442 -> noto-music-0d82442.tar.gz
mirror://githubcl/notofonts/myanmar/tar.gz/101dc16 -> noto-myanmar-101dc16.tar.gz
mirror://githubcl/notofonts/nabataean/tar.gz/2332bfd -> noto-nabataean-2332bfd.tar.gz
mirror://githubcl/notofonts/nag-mundari/tar.gz/df08916 -> noto-nag-mundari-df08916.tar.gz
mirror://githubcl/notofonts/nandinagari/tar.gz/7b930ed -> noto-nandinagari-7b930ed.tar.gz
mirror://githubcl/notofonts/nastaliq/tar.gz/8f640db -> noto-nastaliq-8f640db.tar.gz
mirror://githubcl/notofonts/new-tai-lue/tar.gz/f105853 -> noto-new-tai-lue-f105853.tar.gz
mirror://githubcl/notofonts/newa/tar.gz/c5a6556 -> noto-newa-c5a6556.tar.gz
mirror://githubcl/notofonts/nko/tar.gz/48e8c4c -> noto-nko-48e8c4c.tar.gz
mirror://githubcl/notofonts/nushu/tar.gz/c79dce7 -> noto-nushu-c79dce7.tar.gz
mirror://githubcl/notofonts/nyiakeng-puachue-hmong/tar.gz/c2683e2 -> noto-nyiakeng-puachue-hmong-c2683e2.tar.gz
mirror://githubcl/notofonts/ogham/tar.gz/b327608 -> noto-ogham-b327608.tar.gz
mirror://githubcl/notofonts/ol-chiki/tar.gz/ba1a9d4 -> noto-ol-chiki-ba1a9d4.tar.gz
mirror://githubcl/notofonts/old-hungarian/tar.gz/298181e -> noto-old-hungarian-298181e.tar.gz
mirror://githubcl/notofonts/old-hungarian-ui/tar.gz/b5ccca6 -> noto-old-hungarian-ui-b5ccca6.tar.gz
mirror://githubcl/notofonts/old-italic/tar.gz/46581a7 -> noto-old-italic-46581a7.tar.gz
mirror://githubcl/notofonts/old-north-arabian/tar.gz/b40c845 -> noto-old-north-arabian-b40c845.tar.gz
mirror://githubcl/notofonts/old-permic/tar.gz/e961b27 -> noto-old-permic-e961b27.tar.gz
mirror://githubcl/notofonts/old-persian/tar.gz/79ae8f7 -> noto-old-persian-79ae8f7.tar.gz
mirror://githubcl/notofonts/old-sogdian/tar.gz/3587e3a -> noto-old-sogdian-3587e3a.tar.gz
mirror://githubcl/notofonts/old-south-arabian/tar.gz/4ff6d28 -> noto-old-south-arabian-4ff6d28.tar.gz
mirror://githubcl/notofonts/old-turkic/tar.gz/f8fff56 -> noto-old-turkic-f8fff56.tar.gz
mirror://githubcl/notofonts/old-uyghur/tar.gz/10e7317 -> noto-old-uyghur-10e7317.tar.gz
mirror://githubcl/notofonts/oriya/tar.gz/d15a9a4 -> noto-oriya-d15a9a4.tar.gz
mirror://githubcl/notofonts/osage/tar.gz/030216c -> noto-osage-030216c.tar.gz
mirror://githubcl/notofonts/osmanya/tar.gz/44a359d -> noto-osmanya-44a359d.tar.gz
mirror://githubcl/notofonts/ottoman-siyaq-numbers/tar.gz/93c52b0 -> noto-ottoman-siyaq-numbers-93c52b0.tar.gz
mirror://githubcl/notofonts/pahawh-hmong/tar.gz/b26509a -> noto-pahawh-hmong-b26509a.tar.gz
mirror://githubcl/notofonts/palmyrene/tar.gz/da30d60 -> noto-palmyrene-da30d60.tar.gz
mirror://githubcl/notofonts/pau-cin-hau/tar.gz/e800706 -> noto-pau-cin-hau-e800706.tar.gz
mirror://githubcl/notofonts/phags-pa/tar.gz/cde0e5b -> noto-phags-pa-cde0e5b.tar.gz
mirror://githubcl/notofonts/phoenician/tar.gz/6f1dbc2 -> noto-phoenician-6f1dbc2.tar.gz
mirror://githubcl/notofonts/psalter-pahlavi/tar.gz/e1de727 -> noto-psalter-pahlavi-e1de727.tar.gz
mirror://githubcl/notofonts/rejang/tar.gz/d882878 -> noto-rejang-d882878.tar.gz
mirror://githubcl/notofonts/runic/tar.gz/b873e6b -> noto-runic-b873e6b.tar.gz
mirror://githubcl/notofonts/samaritan/tar.gz/1bf5f64 -> noto-samaritan-1bf5f64.tar.gz
mirror://githubcl/notofonts/saurashtra/tar.gz/7ce6340 -> noto-saurashtra-7ce6340.tar.gz
mirror://githubcl/notofonts/sharada/tar.gz/1f3a5d1 -> noto-sharada-1f3a5d1.tar.gz
mirror://githubcl/notofonts/shavian/tar.gz/be26665 -> noto-shavian-be26665.tar.gz
mirror://githubcl/notofonts/siddham/tar.gz/53b1701 -> noto-siddham-53b1701.tar.gz
mirror://githubcl/notofonts/sign-writing/tar.gz/3667f71d -> noto-sign-writing-3667f71d.tar.gz
mirror://githubcl/notofonts/sinhala/tar.gz/293b5f5 -> noto-sinhala-293b5f5.tar.gz
mirror://githubcl/notofonts/sogdian/tar.gz/c2173ad -> noto-sogdian-c2173ad.tar.gz
mirror://githubcl/notofonts/sora-sompeng/tar.gz/eaca34e -> noto-sora-sompeng-eaca34e.tar.gz
mirror://githubcl/notofonts/soyombo/tar.gz/58f9ba7 -> noto-soyombo-58f9ba7.tar.gz
mirror://githubcl/notofonts/sundanese/tar.gz/6dc0d37 -> noto-sundanese-6dc0d37.tar.gz
mirror://githubcl/notofonts/syloti-nagri/tar.gz/e4bafd9 -> noto-syloti-nagri-e4bafd9.tar.gz
mirror://githubcl/notofonts/symbols/tar.gz/179fca1a -> noto-symbols-179fca1a.tar.gz
mirror://githubcl/notofonts/syriac/tar.gz/59d7614 -> noto-syriac-59d7614.tar.gz
mirror://githubcl/notofonts/tagalog/tar.gz/c053879 -> noto-tagalog-c053879.tar.gz
mirror://githubcl/notofonts/tagbanwa/tar.gz/59b2ddb -> noto-tagbanwa-59b2ddb.tar.gz
mirror://githubcl/notofonts/tai-le/tar.gz/a4e3dd1 -> noto-tai-le-a4e3dd1.tar.gz
mirror://githubcl/notofonts/tai-tham/tar.gz/7b9359e -> noto-tai-tham-7b9359e.tar.gz
mirror://githubcl/notofonts/tai-viet/tar.gz/4a3950d -> noto-tai-viet-4a3950d.tar.gz
mirror://githubcl/notofonts/takri/tar.gz/7f68fed -> noto-takri-7f68fed.tar.gz
mirror://githubcl/notofonts/tamil/tar.gz/09e7ffc -> noto-tamil-09e7ffc.tar.gz
mirror://githubcl/notofonts/tangsa/tar.gz/6b869a4 -> noto-tangsa-6b869a4.tar.gz
mirror://githubcl/notofonts/tangut/tar.gz/53ca052 -> noto-tangut-53ca052.tar.gz
mirror://githubcl/notofonts/telugu/tar.gz/af5b949 -> noto-telugu-af5b949.tar.gz
mirror://githubcl/notofonts/thaana/tar.gz/2868b17 -> noto-thaana-2868b17.tar.gz
mirror://githubcl/notofonts/thai/tar.gz/63db752 -> noto-thai-63db752.tar.gz
mirror://githubcl/notofonts/tibetan/tar.gz/0934d8e -> noto-tibetan-0934d8e.tar.gz
mirror://githubcl/notofonts/tifinagh/tar.gz/b486dbd -> noto-tifinagh-b486dbd.tar.gz
mirror://githubcl/notofonts/tirhuta/tar.gz/250d409 -> noto-tirhuta-250d409.tar.gz
mirror://githubcl/notofonts/toto/tar.gz/17f7583 -> noto-toto-17f7583.tar.gz
mirror://githubcl/notofonts/ugaritic/tar.gz/38af29f -> noto-ugaritic-38af29f.tar.gz
mirror://githubcl/notofonts/vai/tar.gz/682cbf5 -> noto-vai-682cbf5.tar.gz
mirror://githubcl/notofonts/vithkuqi/tar.gz/6761d1c -> noto-vithkuqi-6761d1c.tar.gz
mirror://githubcl/notofonts/wancho/tar.gz/27ddd09 -> noto-wancho-27ddd09.tar.gz
mirror://githubcl/notofonts/warang-citi/tar.gz/de2e3f6 -> noto-warang-citi-de2e3f6.tar.gz
mirror://githubcl/notofonts/yezidi/tar.gz/0fa34b8 -> noto-yezidi-0fa34b8.tar.gz
mirror://githubcl/notofonts/yi/tar.gz/52421a9 -> noto-yi-52421a9.tar.gz
mirror://githubcl/notofonts/zanabazar-square/tar.gz/bf39818 -> noto-zanabazar-square-bf39818.tar.gz
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
