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
mirror://githubcl/notofonts/brahmi/tar.gz/aef5a32 -> noto-brahmi-aef5a32.tar.gz
mirror://githubcl/notofonts/buginese/tar.gz/2db2a4e -> noto-buginese-2db2a4e.tar.gz
mirror://githubcl/notofonts/buhid/tar.gz/9fd06e7 -> noto-buhid-9fd06e7.tar.gz
mirror://githubcl/notofonts/canadian-aboriginal/tar.gz/f4a9216e -> noto-canadian-aboriginal-f4a9216e.tar.gz
mirror://githubcl/notofonts/carian/tar.gz/5bf5c9f -> noto-carian-5bf5c9f.tar.gz
mirror://githubcl/notofonts/caucasian-albanian/tar.gz/b6550f3 -> noto-caucasian-albanian-b6550f3.tar.gz
mirror://githubcl/notofonts/chakma/tar.gz/0133998 -> noto-chakma-0133998.tar.gz
mirror://githubcl/notofonts/cham/tar.gz/32f3bda -> noto-cham-32f3bda.tar.gz
mirror://githubcl/notofonts/cherokee/tar.gz/02c260d -> noto-cherokee-02c260d.tar.gz
mirror://githubcl/notofonts/chorasmian/tar.gz/3d41206 -> noto-chorasmian-3d41206.tar.gz
mirror://githubcl/notofonts/coptic/tar.gz/b2bad35 -> noto-coptic-b2bad35.tar.gz
mirror://githubcl/notofonts/cuneiform/tar.gz/5691cb1 -> noto-cuneiform-5691cb1.tar.gz
mirror://githubcl/notofonts/cypriot/tar.gz/ec91172 -> noto-cypriot-ec91172.tar.gz
mirror://githubcl/notofonts/cypro-minoan/tar.gz/6f286af -> noto-cypro-minoan-6f286af.tar.gz
mirror://githubcl/notofonts/deseret/tar.gz/ea3eb37 -> noto-deseret-ea3eb37.tar.gz
mirror://githubcl/notofonts/devanagari/tar.gz/f8f27e4 -> noto-devanagari-f8f27e4.tar.gz
mirror://githubcl/notofonts/dives-akuru/tar.gz/6115d3d -> noto-dives-akuru-6115d3d.tar.gz
mirror://githubcl/notofonts/dogra/tar.gz/0f4a8ba -> noto-dogra-0f4a8ba.tar.gz
mirror://githubcl/notofonts/duployan/tar.gz/7c72b99 -> noto-duployan-7c72b99.tar.gz
mirror://githubcl/notofonts/egyptian-hieroglyphs/tar.gz/4565d57 -> noto-egyptian-hieroglyphs-4565d57.tar.gz
mirror://githubcl/notofonts/elbasan/tar.gz/79d28ae -> noto-elbasan-79d28ae.tar.gz
mirror://githubcl/notofonts/elymaic/tar.gz/662e374 -> noto-elymaic-662e374.tar.gz
mirror://githubcl/notofonts/ethiopic/tar.gz/1cc6933 -> noto-ethiopic-1cc6933.tar.gz
mirror://githubcl/notofonts/georgian/tar.gz/16b7c8a -> noto-georgian-16b7c8a.tar.gz
mirror://githubcl/notofonts/glagolitic/tar.gz/2efe5a7 -> noto-glagolitic-2efe5a7.tar.gz
mirror://githubcl/notofonts/gothic/tar.gz/a30a2ad -> noto-gothic-a30a2ad.tar.gz
mirror://githubcl/notofonts/grantha/tar.gz/1bde702 -> noto-grantha-1bde702.tar.gz
mirror://githubcl/notofonts/gujarati/tar.gz/786af29 -> noto-gujarati-786af29.tar.gz
mirror://githubcl/notofonts/gunjala-gondi/tar.gz/d59d786 -> noto-gunjala-gondi-d59d786.tar.gz
mirror://githubcl/notofonts/gurmukhi/tar.gz/231c5c6 -> noto-gurmukhi-231c5c6.tar.gz
mirror://githubcl/notofonts/hanifi-rohingya/tar.gz/3e2402d -> noto-hanifi-rohingya-3e2402d.tar.gz
mirror://githubcl/notofonts/hanunoo/tar.gz/0edece1 -> noto-hanunoo-0edece1.tar.gz
mirror://githubcl/notofonts/hatran/tar.gz/8387911 -> noto-hatran-8387911.tar.gz
mirror://githubcl/notofonts/hebrew/tar.gz/8bc2f9d -> noto-hebrew-8bc2f9d.tar.gz
mirror://githubcl/notofonts/imperial-aramaic/tar.gz/c490354 -> noto-imperial-aramaic-c490354.tar.gz
mirror://githubcl/notofonts/indic-siyaq-numbers/tar.gz/6dfe115 -> noto-indic-siyaq-numbers-6dfe115.tar.gz
mirror://githubcl/notofonts/inscriptional-pahlavi/tar.gz/61b1262 -> noto-inscriptional-pahlavi-61b1262.tar.gz
mirror://githubcl/notofonts/inscriptional-parthian/tar.gz/299cabd -> noto-inscriptional-parthian-299cabd.tar.gz
mirror://githubcl/notofonts/javanese/tar.gz/f6ee754 -> noto-javanese-f6ee754.tar.gz
mirror://githubcl/notofonts/kaithi/tar.gz/542856c -> noto-kaithi-542856c.tar.gz
mirror://githubcl/notofonts/kawi/tar.gz/f09ec8d -> noto-kawi-f09ec8d.tar.gz
mirror://githubcl/notofonts/kannada/tar.gz/41412a8 -> noto-kannada-41412a8.tar.gz
mirror://githubcl/notofonts/kayah-li/tar.gz/98b87d4 -> noto-kayah-li-98b87d4.tar.gz
mirror://githubcl/notofonts/kharoshthi/tar.gz/8f50ada -> noto-kharoshthi-8f50ada.tar.gz
mirror://githubcl/notofonts/khitan-small-script/tar.gz/8769c8b0 -> noto-khitan-small-script-8769c8b0.tar.gz
mirror://githubcl/notofonts/khmer/tar.gz/4e6b9a1 -> noto-khmer-4e6b9a1.tar.gz
mirror://githubcl/notofonts/khojki/tar.gz/cb7b2a3 -> noto-khojki-cb7b2a3.tar.gz
mirror://githubcl/notofonts/khudawadi/tar.gz/9219227 -> noto-khudawadi-9219227.tar.gz
mirror://githubcl/notofonts/lao/tar.gz/6c469b7 -> noto-lao-6c469b7.tar.gz
mirror://githubcl/notofonts/latin-greek-cyrillic/tar.gz/cf303fc1d -> noto-latin-greek-cyrillic-cf303fc1d.tar.gz
mirror://githubcl/notofonts/lepcha/tar.gz/d524d9a -> noto-lepcha-d524d9a.tar.gz
mirror://githubcl/notofonts/limbu/tar.gz/6b002f7 -> noto-limbu-6b002f7.tar.gz
mirror://githubcl/notofonts/linear-a/tar.gz/bdfcca0 -> noto-linear-a-bdfcca0.tar.gz
mirror://githubcl/notofonts/linear-b/tar.gz/bae4d3f -> noto-linear-b-bae4d3f.tar.gz
mirror://githubcl/notofonts/lisu/tar.gz/e1f0c06 -> noto-lisu-e1f0c06.tar.gz
mirror://githubcl/notofonts/lycian/tar.gz/bbe7f20 -> noto-lycian-bbe7f20.tar.gz
mirror://githubcl/notofonts/lydian/tar.gz/a6c4221 -> noto-lydian-a6c4221.tar.gz
mirror://githubcl/notofonts/mahajani/tar.gz/fc19654 -> noto-mahajani-fc19654.tar.gz
mirror://githubcl/notofonts/makasar/tar.gz/3b46257 -> noto-makasar-3b46257.tar.gz
mirror://githubcl/notofonts/malayalam/tar.gz/0fd65e5 -> noto-malayalam-0fd65e5.tar.gz
mirror://githubcl/notofonts/mandaic/tar.gz/48916c8 -> noto-mandaic-48916c8.tar.gz
mirror://githubcl/notofonts/manichaean/tar.gz/9a831aa -> noto-manichaean-9a831aa.tar.gz
mirror://githubcl/notofonts/marchen/tar.gz/dc99802 -> noto-marchen-dc99802.tar.gz
mirror://githubcl/notofonts/masaram-gondi/tar.gz/7ee41be -> noto-masaram-gondi-7ee41be.tar.gz
mirror://githubcl/notofonts/math/tar.gz/6f43eff -> noto-math-6f43eff.tar.gz
mirror://githubcl/notofonts/mayan-numerals/tar.gz/29f826d -> noto-mayan-numerals-29f826d.tar.gz
mirror://githubcl/notofonts/medefaidrin/tar.gz/caf9f3f -> noto-medefaidrin-caf9f3f.tar.gz
mirror://githubcl/notofonts/meetei-mayek/tar.gz/fa5b63a -> noto-meetei-mayek-fa5b63a.tar.gz
mirror://githubcl/notofonts/mende-kikakui/tar.gz/eb71403 -> noto-mende-kikakui-eb71403.tar.gz
mirror://githubcl/notofonts/meroitic/tar.gz/e724c10 -> noto-meroitic-e724c10.tar.gz
mirror://githubcl/notofonts/miao/tar.gz/f5b9032 -> noto-miao-f5b9032.tar.gz
mirror://githubcl/notofonts/modi/tar.gz/e7749f2 -> noto-modi-e7749f2.tar.gz
mirror://githubcl/notofonts/mongolian/tar.gz/096239f -> noto-mongolian-096239f.tar.gz
mirror://githubcl/notofonts/mro/tar.gz/8549a3e -> noto-mro-8549a3e.tar.gz
mirror://githubcl/notofonts/multani/tar.gz/39bcd91 -> noto-multani-39bcd91.tar.gz
mirror://githubcl/notofonts/music/tar.gz/ef0cfba -> noto-music-ef0cfba.tar.gz
mirror://githubcl/notofonts/myanmar/tar.gz/bd34805 -> noto-myanmar-bd34805.tar.gz
mirror://githubcl/notofonts/nabataean/tar.gz/b2c44e7 -> noto-nabataean-b2c44e7.tar.gz
mirror://githubcl/notofonts/nag-mundari/tar.gz/5a5a8eb -> noto-nag-mundari-5a5a8eb.tar.gz
mirror://githubcl/notofonts/nandinagari/tar.gz/ab99160 -> noto-nandinagari-ab99160.tar.gz
mirror://githubcl/notofonts/nastaliq/tar.gz/69686d4 -> noto-nastaliq-69686d4.tar.gz
mirror://githubcl/notofonts/new-tai-lue/tar.gz/2a391c3 -> noto-new-tai-lue-2a391c3.tar.gz
mirror://githubcl/notofonts/newa/tar.gz/f56d175 -> noto-newa-f56d175.tar.gz
mirror://githubcl/notofonts/nko/tar.gz/a600bbe -> noto-nko-a600bbe.tar.gz
mirror://githubcl/notofonts/nushu/tar.gz/836ef3c -> noto-nushu-836ef3c.tar.gz
mirror://githubcl/notofonts/nyiakeng-puachue-hmong/tar.gz/6b66893 -> noto-nyiakeng-puachue-hmong-6b66893.tar.gz
mirror://githubcl/notofonts/ogham/tar.gz/089614c -> noto-ogham-089614c.tar.gz
mirror://githubcl/notofonts/ol-chiki/tar.gz/c9811b4 -> noto-ol-chiki-c9811b4.tar.gz
mirror://githubcl/notofonts/old-hungarian/tar.gz/4b0705e -> noto-old-hungarian-4b0705e.tar.gz
mirror://githubcl/notofonts/old-hungarian-ui/tar.gz/8f051f2 -> noto-old-hungarian-ui-8f051f2.tar.gz
mirror://githubcl/notofonts/old-italic/tar.gz/9c001d6 -> noto-old-italic-9c001d6.tar.gz
mirror://githubcl/notofonts/old-north-arabian/tar.gz/2a29b5e -> noto-old-north-arabian-2a29b5e.tar.gz
mirror://githubcl/notofonts/old-permic/tar.gz/0fb8194 -> noto-old-permic-0fb8194.tar.gz
mirror://githubcl/notofonts/old-persian/tar.gz/81cc54a -> noto-old-persian-81cc54a.tar.gz
mirror://githubcl/notofonts/old-sogdian/tar.gz/c11da34 -> noto-old-sogdian-c11da34.tar.gz
mirror://githubcl/notofonts/old-south-arabian/tar.gz/5e48951 -> noto-old-south-arabian-5e48951.tar.gz
mirror://githubcl/notofonts/old-turkic/tar.gz/f7dd1e6 -> noto-old-turkic-f7dd1e6.tar.gz
mirror://githubcl/notofonts/old-uyghur/tar.gz/32ba53c -> noto-old-uyghur-32ba53c.tar.gz
mirror://githubcl/notofonts/oriya/tar.gz/3bbbaf0 -> noto-oriya-3bbbaf0.tar.gz
mirror://githubcl/notofonts/osage/tar.gz/6c8b4a4 -> noto-osage-6c8b4a4.tar.gz
mirror://githubcl/notofonts/osmanya/tar.gz/dc466ed -> noto-osmanya-dc466ed.tar.gz
mirror://githubcl/notofonts/ottoman-siyaq-numbers/tar.gz/784a4bb -> noto-ottoman-siyaq-numbers-784a4bb.tar.gz
mirror://githubcl/notofonts/pahawh-hmong/tar.gz/a602899 -> noto-pahawh-hmong-a602899.tar.gz
mirror://githubcl/notofonts/palmyrene/tar.gz/3f47763 -> noto-palmyrene-3f47763.tar.gz
mirror://githubcl/notofonts/pau-cin-hau/tar.gz/24e7d48 -> noto-pau-cin-hau-24e7d48.tar.gz
mirror://githubcl/notofonts/phags-pa/tar.gz/aff41d2 -> noto-phags-pa-aff41d2.tar.gz
mirror://githubcl/notofonts/phoenician/tar.gz/0000679 -> noto-phoenician-0000679.tar.gz
mirror://githubcl/notofonts/psalter-pahlavi/tar.gz/7fb3c05 -> noto-psalter-pahlavi-7fb3c05.tar.gz
mirror://githubcl/notofonts/rejang/tar.gz/254d474 -> noto-rejang-254d474.tar.gz
mirror://githubcl/notofonts/runic/tar.gz/a6c4795 -> noto-runic-a6c4795.tar.gz
mirror://githubcl/notofonts/samaritan/tar.gz/824cc35 -> noto-samaritan-824cc35.tar.gz
mirror://githubcl/notofonts/saurashtra/tar.gz/8cbea13 -> noto-saurashtra-8cbea13.tar.gz
mirror://githubcl/notofonts/sharada/tar.gz/01b2368 -> noto-sharada-01b2368.tar.gz
mirror://githubcl/notofonts/shavian/tar.gz/58ab9c9 -> noto-shavian-58ab9c9.tar.gz
mirror://githubcl/notofonts/siddham/tar.gz/78e3b9e -> noto-siddham-78e3b9e.tar.gz
mirror://githubcl/notofonts/sign-writing/tar.gz/9c10f21d -> noto-sign-writing-9c10f21d.tar.gz
mirror://githubcl/notofonts/sinhala/tar.gz/add62c1 -> noto-sinhala-add62c1.tar.gz
mirror://githubcl/notofonts/sogdian/tar.gz/24a5ec5 -> noto-sogdian-24a5ec5.tar.gz
mirror://githubcl/notofonts/sora-sompeng/tar.gz/6ba83c3 -> noto-sora-sompeng-6ba83c3.tar.gz
mirror://githubcl/notofonts/soyombo/tar.gz/fa7ad05 -> noto-soyombo-fa7ad05.tar.gz
mirror://githubcl/notofonts/sundanese/tar.gz/3aeca47 -> noto-sundanese-3aeca47.tar.gz
mirror://githubcl/notofonts/syloti-nagri/tar.gz/5463a96 -> noto-syloti-nagri-5463a96.tar.gz
mirror://githubcl/notofonts/symbols/tar.gz/44003dc2 -> noto-symbols-44003dc2.tar.gz
mirror://githubcl/notofonts/syriac/tar.gz/270488b -> noto-syriac-270488b.tar.gz
mirror://githubcl/notofonts/tagalog/tar.gz/65e44cf -> noto-tagalog-65e44cf.tar.gz
mirror://githubcl/notofonts/tagbanwa/tar.gz/2d4a2f8 -> noto-tagbanwa-2d4a2f8.tar.gz
mirror://githubcl/notofonts/tai-le/tar.gz/9fa6d7f -> noto-tai-le-9fa6d7f.tar.gz
mirror://githubcl/notofonts/tai-tham/tar.gz/d5c44ee -> noto-tai-tham-d5c44ee.tar.gz
mirror://githubcl/notofonts/tai-viet/tar.gz/9cb8921 -> noto-tai-viet-9cb8921.tar.gz
mirror://githubcl/notofonts/takri/tar.gz/d399eb9 -> noto-takri-d399eb9.tar.gz
mirror://githubcl/notofonts/tamil/tar.gz/626575f -> noto-tamil-626575f.tar.gz
mirror://githubcl/notofonts/tangsa/tar.gz/e8dff27 -> noto-tangsa-e8dff27.tar.gz
mirror://githubcl/notofonts/tangut/tar.gz/c5bad32 -> noto-tangut-c5bad32.tar.gz
mirror://githubcl/notofonts/telugu/tar.gz/68a6a81 -> noto-telugu-68a6a81.tar.gz
mirror://githubcl/notofonts/test/tar.gz/e927104 -> noto-test-e927104.tar.gz
mirror://githubcl/notofonts/thaana/tar.gz/18c0dfe -> noto-thaana-18c0dfe.tar.gz
mirror://githubcl/notofonts/thai/tar.gz/4af08a8 -> noto-thai-4af08a8.tar.gz
mirror://githubcl/notofonts/tibetan/tar.gz/7159f3f -> noto-tibetan-7159f3f.tar.gz
mirror://githubcl/notofonts/tifinagh/tar.gz/dddd975 -> noto-tifinagh-dddd975.tar.gz
mirror://githubcl/notofonts/tirhuta/tar.gz/f0ce3f4 -> noto-tirhuta-f0ce3f4.tar.gz
mirror://githubcl/notofonts/toto/tar.gz/b41e188 -> noto-toto-b41e188.tar.gz
mirror://githubcl/notofonts/ugaritic/tar.gz/c60b126 -> noto-ugaritic-c60b126.tar.gz
mirror://githubcl/notofonts/vai/tar.gz/512b784 -> noto-vai-512b784.tar.gz
mirror://githubcl/notofonts/vithkuqi/tar.gz/5e5ead4 -> noto-vithkuqi-5e5ead4.tar.gz
mirror://githubcl/notofonts/wancho/tar.gz/778a10c -> noto-wancho-778a10c.tar.gz
mirror://githubcl/notofonts/warang-citi/tar.gz/a66de5a -> noto-warang-citi-a66de5a.tar.gz
mirror://githubcl/notofonts/yezidi/tar.gz/0706f1d -> noto-yezidi-0706f1d.tar.gz
mirror://githubcl/notofonts/yi/tar.gz/7cdbf44 -> noto-yi-7cdbf44.tar.gz
mirror://githubcl/notofonts/zanabazar-square/tar.gz/d52f4f5 -> noto-zanabazar-square-d52f4f5.tar.gz
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
