# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FONT_SRCDIR=src
# https://github.com/notofonts/notofonts.github.io/raw/main/fontrepos.json
SRC_URI="
mirror://githubcl/notofonts/adlam/tar.gz/f1905ad -> noto-adlam-f1905ad.tar.gz
mirror://githubcl/notofonts/ahom/tar.gz/677b3a9 -> noto-ahom-677b3a9.tar.gz
mirror://githubcl/notofonts/anatolian-hieroglyphs/tar.gz/8f0efa1 -> noto-anatolian-hieroglyphs-8f0efa1.tar.gz
mirror://githubcl/notofonts/arabic/tar.gz/ead1416 -> noto-arabic-ead1416.tar.gz
mirror://githubcl/notofonts/armenian/tar.gz/59bd7ba -> noto-armenian-59bd7ba.tar.gz
mirror://githubcl/notofonts/avestan/tar.gz/d9d0f78 -> noto-avestan-d9d0f78.tar.gz
mirror://githubcl/notofonts/balinese/tar.gz/e19e6b9 -> noto-balinese-e19e6b9.tar.gz
mirror://githubcl/notofonts/bamum/tar.gz/9dc9742 -> noto-bamum-9dc9742.tar.gz
mirror://githubcl/notofonts/bassa-vah/tar.gz/d9db328 -> noto-bassa-vah-d9db328.tar.gz
mirror://githubcl/notofonts/batak/tar.gz/9aae886 -> noto-batak-9aae886.tar.gz
mirror://githubcl/notofonts/bengali/tar.gz/da7d217 -> noto-bengali-da7d217.tar.gz
mirror://githubcl/notofonts/bhaiksuki/tar.gz/c82f80d -> noto-bhaiksuki-c82f80d.tar.gz
mirror://githubcl/notofonts/brahmi/tar.gz/bcddf4d -> noto-brahmi-bcddf4d.tar.gz
mirror://githubcl/notofonts/buginese/tar.gz/2db2a4e -> noto-buginese-2db2a4e.tar.gz
mirror://githubcl/notofonts/buhid/tar.gz/9fd06e7 -> noto-buhid-9fd06e7.tar.gz
mirror://githubcl/notofonts/canadian-aboriginal/tar.gz/7a92bdb2 -> noto-canadian-aboriginal-7a92bdb2.tar.gz
mirror://githubcl/notofonts/carian/tar.gz/5bf5c9f -> noto-carian-5bf5c9f.tar.gz
mirror://githubcl/notofonts/caucasian-albanian/tar.gz/b6550f3 -> noto-caucasian-albanian-b6550f3.tar.gz
mirror://githubcl/notofonts/chakma/tar.gz/0133998 -> noto-chakma-0133998.tar.gz
mirror://githubcl/notofonts/cham/tar.gz/344b221 -> noto-cham-344b221.tar.gz
mirror://githubcl/notofonts/cherokee/tar.gz/02c260d -> noto-cherokee-02c260d.tar.gz
mirror://githubcl/notofonts/chorasmian/tar.gz/3d41206 -> noto-chorasmian-3d41206.tar.gz
mirror://githubcl/notofonts/coptic/tar.gz/5bf24c1 -> noto-coptic-5bf24c1.tar.gz
mirror://githubcl/notofonts/cuneiform/tar.gz/5691cb1 -> noto-cuneiform-5691cb1.tar.gz
mirror://githubcl/notofonts/cypriot/tar.gz/ec91172 -> noto-cypriot-ec91172.tar.gz
mirror://githubcl/notofonts/cypro-minoan/tar.gz/6f286af -> noto-cypro-minoan-6f286af.tar.gz
mirror://githubcl/notofonts/deseret/tar.gz/ea3eb37 -> noto-deseret-ea3eb37.tar.gz
mirror://githubcl/notofonts/devanagari/tar.gz/f8f27e4 -> noto-devanagari-f8f27e4.tar.gz
mirror://githubcl/notofonts/dives-akuru/tar.gz/6115d3d -> noto-dives-akuru-6115d3d.tar.gz
mirror://githubcl/notofonts/dogra/tar.gz/2c86e4f -> noto-dogra-2c86e4f.tar.gz
mirror://githubcl/notofonts/duployan/tar.gz/7c72b99 -> noto-duployan-7c72b99.tar.gz
mirror://githubcl/notofonts/egyptian-hieroglyphs/tar.gz/4565d57 -> noto-egyptian-hieroglyphs-4565d57.tar.gz
mirror://githubcl/notofonts/elbasan/tar.gz/5b95413 -> noto-elbasan-5b95413.tar.gz
mirror://githubcl/notofonts/elymaic/tar.gz/816979c -> noto-elymaic-816979c.tar.gz
mirror://githubcl/notofonts/ethiopic/tar.gz/1cc6933 -> noto-ethiopic-1cc6933.tar.gz
mirror://githubcl/notofonts/georgian/tar.gz/d2b52e1 -> noto-georgian-d2b52e1.tar.gz
mirror://githubcl/notofonts/glagolitic/tar.gz/2efe5a7 -> noto-glagolitic-2efe5a7.tar.gz
mirror://githubcl/notofonts/gothic/tar.gz/a30a2ad -> noto-gothic-a30a2ad.tar.gz
mirror://githubcl/notofonts/grantha/tar.gz/7daa56c -> noto-grantha-7daa56c.tar.gz
mirror://githubcl/notofonts/gujarati/tar.gz/786af29 -> noto-gujarati-786af29.tar.gz
mirror://githubcl/notofonts/gunjala-gondi/tar.gz/4c782d1 -> noto-gunjala-gondi-4c782d1.tar.gz
mirror://githubcl/notofonts/gurmukhi/tar.gz/231c5c6 -> noto-gurmukhi-231c5c6.tar.gz
mirror://githubcl/notofonts/hanifi-rohingya/tar.gz/1318e53 -> noto-hanifi-rohingya-1318e53.tar.gz
mirror://githubcl/notofonts/hanunoo/tar.gz/f5468a5 -> noto-hanunoo-f5468a5.tar.gz
mirror://githubcl/notofonts/hatran/tar.gz/8387911 -> noto-hatran-8387911.tar.gz
mirror://githubcl/notofonts/hebrew/tar.gz/8bc2f9d -> noto-hebrew-8bc2f9d.tar.gz
mirror://githubcl/notofonts/imperial-aramaic/tar.gz/c490354 -> noto-imperial-aramaic-c490354.tar.gz
mirror://githubcl/notofonts/indic-siyaq-numbers/tar.gz/6dfe115 -> noto-indic-siyaq-numbers-6dfe115.tar.gz
mirror://githubcl/notofonts/inscriptional-pahlavi/tar.gz/4c2649d -> noto-inscriptional-pahlavi-4c2649d.tar.gz
mirror://githubcl/notofonts/inscriptional-parthian/tar.gz/299cabd -> noto-inscriptional-parthian-299cabd.tar.gz
mirror://githubcl/notofonts/javanese/tar.gz/308e82a -> noto-javanese-308e82a.tar.gz
mirror://githubcl/notofonts/kaithi/tar.gz/542856c -> noto-kaithi-542856c.tar.gz
mirror://githubcl/notofonts/kawi/tar.gz/83d11ae -> noto-kawi-83d11ae.tar.gz
mirror://githubcl/notofonts/kannada/tar.gz/0c2a7a4 -> noto-kannada-0c2a7a4.tar.gz
mirror://githubcl/notofonts/kayah-li/tar.gz/98b87d4 -> noto-kayah-li-98b87d4.tar.gz
mirror://githubcl/notofonts/kharoshthi/tar.gz/8f50ada -> noto-kharoshthi-8f50ada.tar.gz
mirror://githubcl/notofonts/khitan-small-script/tar.gz/fa1dd1cb -> noto-khitan-small-script-fa1dd1cb.tar.gz
mirror://githubcl/notofonts/khmer/tar.gz/63b9cea -> noto-khmer-63b9cea.tar.gz
mirror://githubcl/notofonts/khojki/tar.gz/336366f -> noto-khojki-336366f.tar.gz
mirror://githubcl/notofonts/khudawadi/tar.gz/9219227 -> noto-khudawadi-9219227.tar.gz
mirror://githubcl/notofonts/lao/tar.gz/ab77daf -> noto-lao-ab77daf.tar.gz
mirror://githubcl/notofonts/latin-greek-cyrillic/tar.gz/cf303fc1d -> noto-latin-greek-cyrillic-cf303fc1d.tar.gz
mirror://githubcl/notofonts/lepcha/tar.gz/d524d9a -> noto-lepcha-d524d9a.tar.gz
mirror://githubcl/notofonts/limbu/tar.gz/6b002f7 -> noto-limbu-6b002f7.tar.gz
mirror://githubcl/notofonts/linear-a/tar.gz/bdfcca0 -> noto-linear-a-bdfcca0.tar.gz
mirror://githubcl/notofonts/linear-b/tar.gz/bae4d3f -> noto-linear-b-bae4d3f.tar.gz
mirror://githubcl/notofonts/lisu/tar.gz/e1f0c06 -> noto-lisu-e1f0c06.tar.gz
mirror://githubcl/notofonts/lycian/tar.gz/bbe7f20 -> noto-lycian-bbe7f20.tar.gz
mirror://githubcl/notofonts/lydian/tar.gz/91c7f24 -> noto-lydian-91c7f24.tar.gz
mirror://githubcl/notofonts/mahajani/tar.gz/fc19654 -> noto-mahajani-fc19654.tar.gz
mirror://githubcl/notofonts/makasar/tar.gz/3b46257 -> noto-makasar-3b46257.tar.gz
mirror://githubcl/notofonts/malayalam/tar.gz/0fd65e5 -> noto-malayalam-0fd65e5.tar.gz
mirror://githubcl/notofonts/mandaic/tar.gz/312651a -> noto-mandaic-312651a.tar.gz
mirror://githubcl/notofonts/manichaean/tar.gz/8c699a0 -> noto-manichaean-8c699a0.tar.gz
mirror://githubcl/notofonts/marchen/tar.gz/78e668a -> noto-marchen-78e668a.tar.gz
mirror://githubcl/notofonts/masaram-gondi/tar.gz/7ee41be -> noto-masaram-gondi-7ee41be.tar.gz
mirror://githubcl/notofonts/math/tar.gz/6f43eff -> noto-math-6f43eff.tar.gz
mirror://githubcl/notofonts/mayan-numerals/tar.gz/29f826d -> noto-mayan-numerals-29f826d.tar.gz
mirror://githubcl/notofonts/medefaidrin/tar.gz/caf9f3f -> noto-medefaidrin-caf9f3f.tar.gz
mirror://githubcl/notofonts/meetei-mayek/tar.gz/fa5b63a -> noto-meetei-mayek-fa5b63a.tar.gz
mirror://githubcl/notofonts/mende-kikakui/tar.gz/eb71403 -> noto-mende-kikakui-eb71403.tar.gz
mirror://githubcl/notofonts/meroitic/tar.gz/88e912d -> noto-meroitic-88e912d.tar.gz
mirror://githubcl/notofonts/miao/tar.gz/f5b9032 -> noto-miao-f5b9032.tar.gz
mirror://githubcl/notofonts/modi/tar.gz/b76f5a2 -> noto-modi-b76f5a2.tar.gz
mirror://githubcl/notofonts/mongolian/tar.gz/096239f -> noto-mongolian-096239f.tar.gz
mirror://githubcl/notofonts/mro/tar.gz/8549a3e -> noto-mro-8549a3e.tar.gz
mirror://githubcl/notofonts/multani/tar.gz/39bcd91 -> noto-multani-39bcd91.tar.gz
mirror://githubcl/notofonts/music/tar.gz/bd4f6fd -> noto-music-bd4f6fd.tar.gz
mirror://githubcl/notofonts/myanmar/tar.gz/bd34805 -> noto-myanmar-bd34805.tar.gz
mirror://githubcl/notofonts/nabataean/tar.gz/b2c44e7 -> noto-nabataean-b2c44e7.tar.gz
mirror://githubcl/notofonts/nag-mundari/tar.gz/5a5a8eb -> noto-nag-mundari-5a5a8eb.tar.gz
mirror://githubcl/notofonts/nandinagari/tar.gz/ab99160 -> noto-nandinagari-ab99160.tar.gz
mirror://githubcl/notofonts/nastaliq/tar.gz/69686d4 -> noto-nastaliq-69686d4.tar.gz
mirror://githubcl/notofonts/new-tai-lue/tar.gz/2a391c3 -> noto-new-tai-lue-2a391c3.tar.gz
mirror://githubcl/notofonts/newa/tar.gz/f56d175 -> noto-newa-f56d175.tar.gz
mirror://githubcl/notofonts/nko/tar.gz/9779705 -> noto-nko-9779705.tar.gz
mirror://githubcl/notofonts/nushu/tar.gz/836ef3c -> noto-nushu-836ef3c.tar.gz
mirror://githubcl/notofonts/nyiakeng-puachue-hmong/tar.gz/6b66893 -> noto-nyiakeng-puachue-hmong-6b66893.tar.gz
mirror://githubcl/notofonts/ogham/tar.gz/089614c -> noto-ogham-089614c.tar.gz
mirror://githubcl/notofonts/ol-chiki/tar.gz/c9811b4 -> noto-ol-chiki-c9811b4.tar.gz
mirror://githubcl/notofonts/old-hungarian/tar.gz/48261fd -> noto-old-hungarian-48261fd.tar.gz
mirror://githubcl/notofonts/old-hungarian-ui/tar.gz/8f051f2 -> noto-old-hungarian-ui-8f051f2.tar.gz
mirror://githubcl/notofonts/old-italic/tar.gz/9c001d6 -> noto-old-italic-9c001d6.tar.gz
mirror://githubcl/notofonts/old-north-arabian/tar.gz/2a29b5e -> noto-old-north-arabian-2a29b5e.tar.gz
mirror://githubcl/notofonts/old-permic/tar.gz/0fb8194 -> noto-old-permic-0fb8194.tar.gz
mirror://githubcl/notofonts/old-persian/tar.gz/81cc54a -> noto-old-persian-81cc54a.tar.gz
mirror://githubcl/notofonts/old-sogdian/tar.gz/c11da34 -> noto-old-sogdian-c11da34.tar.gz
mirror://githubcl/notofonts/old-south-arabian/tar.gz/5e48951 -> noto-old-south-arabian-5e48951.tar.gz
mirror://githubcl/notofonts/old-turkic/tar.gz/ea64559 -> noto-old-turkic-ea64559.tar.gz
mirror://githubcl/notofonts/old-uyghur/tar.gz/32ba53c -> noto-old-uyghur-32ba53c.tar.gz
mirror://githubcl/notofonts/oriya/tar.gz/b8bd327 -> noto-oriya-b8bd327.tar.gz
mirror://githubcl/notofonts/osage/tar.gz/6c8b4a4 -> noto-osage-6c8b4a4.tar.gz
mirror://githubcl/notofonts/osmanya/tar.gz/dc466ed -> noto-osmanya-dc466ed.tar.gz
mirror://githubcl/notofonts/ottoman-siyaq-numbers/tar.gz/83a14dc -> noto-ottoman-siyaq-numbers-83a14dc.tar.gz
mirror://githubcl/notofonts/pahawh-hmong/tar.gz/a602899 -> noto-pahawh-hmong-a602899.tar.gz
mirror://githubcl/notofonts/palmyrene/tar.gz/3f47763 -> noto-palmyrene-3f47763.tar.gz
mirror://githubcl/notofonts/pau-cin-hau/tar.gz/24e7d48 -> noto-pau-cin-hau-24e7d48.tar.gz
mirror://githubcl/notofonts/phags-pa/tar.gz/cf070f3 -> noto-phags-pa-cf070f3.tar.gz
mirror://githubcl/notofonts/phoenician/tar.gz/0000679 -> noto-phoenician-0000679.tar.gz
mirror://githubcl/notofonts/psalter-pahlavi/tar.gz/0e201dc -> noto-psalter-pahlavi-0e201dc.tar.gz
mirror://githubcl/notofonts/rejang/tar.gz/c4c0047 -> noto-rejang-c4c0047.tar.gz
mirror://githubcl/notofonts/runic/tar.gz/a6c4795 -> noto-runic-a6c4795.tar.gz
mirror://githubcl/notofonts/samaritan/tar.gz/824cc35 -> noto-samaritan-824cc35.tar.gz
mirror://githubcl/notofonts/saurashtra/tar.gz/8cbea13 -> noto-saurashtra-8cbea13.tar.gz
mirror://githubcl/notofonts/sharada/tar.gz/01b2368 -> noto-sharada-01b2368.tar.gz
mirror://githubcl/notofonts/shavian/tar.gz/58ab9c9 -> noto-shavian-58ab9c9.tar.gz
mirror://githubcl/notofonts/siddham/tar.gz/5e2558e -> noto-siddham-5e2558e.tar.gz
mirror://githubcl/notofonts/sign-writing/tar.gz/793d2783 -> noto-sign-writing-793d2783.tar.gz
mirror://githubcl/notofonts/sinhala/tar.gz/add62c1 -> noto-sinhala-add62c1.tar.gz
mirror://githubcl/notofonts/sogdian/tar.gz/24a5ec5 -> noto-sogdian-24a5ec5.tar.gz
mirror://githubcl/notofonts/sora-sompeng/tar.gz/6ba83c3 -> noto-sora-sompeng-6ba83c3.tar.gz
mirror://githubcl/notofonts/soyombo/tar.gz/fa7ad05 -> noto-soyombo-fa7ad05.tar.gz
mirror://githubcl/notofonts/sundanese/tar.gz/15e1e7d -> noto-sundanese-15e1e7d.tar.gz
mirror://githubcl/notofonts/syloti-nagri/tar.gz/8df2a6e -> noto-syloti-nagri-8df2a6e.tar.gz
mirror://githubcl/notofonts/symbols/tar.gz/b61fa7f8 -> noto-symbols-b61fa7f8.tar.gz
mirror://githubcl/notofonts/syriac/tar.gz/270488b -> noto-syriac-270488b.tar.gz
mirror://githubcl/notofonts/tagalog/tar.gz/88cb9c5 -> noto-tagalog-88cb9c5.tar.gz
mirror://githubcl/notofonts/tagbanwa/tar.gz/2d4a2f8 -> noto-tagbanwa-2d4a2f8.tar.gz
mirror://githubcl/notofonts/tai-le/tar.gz/9fa6d7f -> noto-tai-le-9fa6d7f.tar.gz
mirror://githubcl/notofonts/tai-tham/tar.gz/d5c44ee -> noto-tai-tham-d5c44ee.tar.gz
mirror://githubcl/notofonts/tai-viet/tar.gz/5a72fb7 -> noto-tai-viet-5a72fb7.tar.gz
mirror://githubcl/notofonts/takri/tar.gz/d2fc0f8 -> noto-takri-d2fc0f8.tar.gz
mirror://githubcl/notofonts/tamil/tar.gz/626575f -> noto-tamil-626575f.tar.gz
mirror://githubcl/notofonts/tangsa/tar.gz/24bf2bd -> noto-tangsa-24bf2bd.tar.gz
mirror://githubcl/notofonts/tangut/tar.gz/c5bad32 -> noto-tangut-c5bad32.tar.gz
mirror://githubcl/notofonts/telugu/tar.gz/9823741 -> noto-telugu-9823741.tar.gz
mirror://githubcl/notofonts/thaana/tar.gz/18c0dfe -> noto-thaana-18c0dfe.tar.gz
mirror://githubcl/notofonts/thai/tar.gz/8e9122e -> noto-thai-8e9122e.tar.gz
mirror://githubcl/notofonts/tibetan/tar.gz/7159f3f -> noto-tibetan-7159f3f.tar.gz
mirror://githubcl/notofonts/tifinagh/tar.gz/67f2330 -> noto-tifinagh-67f2330.tar.gz
mirror://githubcl/notofonts/tirhuta/tar.gz/f0ce3f4 -> noto-tirhuta-f0ce3f4.tar.gz
mirror://githubcl/notofonts/toto/tar.gz/b41e188 -> noto-toto-b41e188.tar.gz
mirror://githubcl/notofonts/ugaritic/tar.gz/c60b126 -> noto-ugaritic-c60b126.tar.gz
mirror://githubcl/notofonts/vai/tar.gz/512b784 -> noto-vai-512b784.tar.gz
mirror://githubcl/notofonts/vithkuqi/tar.gz/b1538fa -> noto-vithkuqi-b1538fa.tar.gz
mirror://githubcl/notofonts/wancho/tar.gz/778a10c -> noto-wancho-778a10c.tar.gz
mirror://githubcl/notofonts/warang-citi/tar.gz/a66de5a -> noto-warang-citi-a66de5a.tar.gz
mirror://githubcl/notofonts/yezidi/tar.gz/0706f1d -> noto-yezidi-0706f1d.tar.gz
mirror://githubcl/notofonts/yi/tar.gz/7cdbf44 -> noto-yi-7cdbf44.tar.gz
mirror://githubcl/notofonts/zanabazar-square/tar.gz/dc60eb1 -> noto-zanabazar-square-dc60eb1.tar.gz
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

src_prepare() {
	use clean-as-you-go && HELPER_ARGS=( clean )
	mkdir -p src
	mv -t src */sources/*
	fontmake_src_prepare
}
