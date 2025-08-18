# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FONT_SRCDIR=src
# https://github.com/notofonts/notofonts.github.io/raw/main/fontrepos.json
SRC_URI="
mirror://githubcl/notofonts/adlam/tar.gz/35cfefd -> noto-adlam-35cfefd.tar.gz
mirror://githubcl/notofonts/ahom/tar.gz/b729459 -> noto-ahom-b729459.tar.gz
mirror://githubcl/notofonts/anatolian-hieroglyphs/tar.gz/c66edd8 -> noto-anatolian-hieroglyphs-c66edd8.tar.gz
mirror://githubcl/notofonts/arabic/tar.gz/5b213e56 -> noto-arabic-5b213e56.tar.gz
mirror://githubcl/notofonts/armenian/tar.gz/9cf9428 -> noto-armenian-9cf9428.tar.gz
mirror://githubcl/notofonts/avestan/tar.gz/ec07550 -> noto-avestan-ec07550.tar.gz
mirror://githubcl/notofonts/balinese/tar.gz/595aa68 -> noto-balinese-595aa68.tar.gz
mirror://githubcl/notofonts/bamum/tar.gz/f7525e9 -> noto-bamum-f7525e9.tar.gz
mirror://githubcl/notofonts/bassa-vah/tar.gz/75d3c40 -> noto-bassa-vah-75d3c40.tar.gz
mirror://githubcl/notofonts/batak/tar.gz/fc86bc4 -> noto-batak-fc86bc4.tar.gz
mirror://githubcl/notofonts/bengali/tar.gz/a43cbb8 -> noto-bengali-a43cbb8.tar.gz
mirror://githubcl/notofonts/bhaiksuki/tar.gz/342b753 -> noto-bhaiksuki-342b753.tar.gz
mirror://githubcl/notofonts/brahmi/tar.gz/d93a535 -> noto-brahmi-d93a535.tar.gz
mirror://githubcl/notofonts/buginese/tar.gz/ac43417 -> noto-buginese-ac43417.tar.gz
mirror://githubcl/notofonts/buhid/tar.gz/5bce8a8 -> noto-buhid-5bce8a8.tar.gz
mirror://githubcl/notofonts/canadian-aboriginal/tar.gz/4ee1ff2f -> noto-canadian-aboriginal-4ee1ff2f.tar.gz
mirror://githubcl/notofonts/carian/tar.gz/f3e58b0 -> noto-carian-f3e58b0.tar.gz
mirror://githubcl/notofonts/caucasian-albanian/tar.gz/4fabb84 -> noto-caucasian-albanian-4fabb84.tar.gz
mirror://githubcl/notofonts/chakma/tar.gz/bef1d2a -> noto-chakma-bef1d2a.tar.gz
mirror://githubcl/notofonts/cham/tar.gz/2e2f9ce -> noto-cham-2e2f9ce.tar.gz
mirror://githubcl/notofonts/cherokee/tar.gz/9910f4e -> noto-cherokee-9910f4e.tar.gz
mirror://githubcl/notofonts/chorasmian/tar.gz/99bd940 -> noto-chorasmian-99bd940.tar.gz
mirror://githubcl/notofonts/coptic/tar.gz/d343224 -> noto-coptic-d343224.tar.gz
mirror://githubcl/notofonts/cuneiform/tar.gz/d9d6875 -> noto-cuneiform-d9d6875.tar.gz
mirror://githubcl/notofonts/cypriot/tar.gz/c7aee17 -> noto-cypriot-c7aee17.tar.gz
mirror://githubcl/notofonts/cypro-minoan/tar.gz/7982b97 -> noto-cypro-minoan-7982b97.tar.gz
mirror://githubcl/notofonts/deseret/tar.gz/40f6667 -> noto-deseret-40f6667.tar.gz
mirror://githubcl/notofonts/devanagari/tar.gz/d44d6edf -> noto-devanagari-d44d6edf.tar.gz
mirror://githubcl/notofonts/dives-akuru/tar.gz/6b7b4e78 -> noto-dives-akuru-6b7b4e78.tar.gz
mirror://githubcl/notofonts/dogra/tar.gz/3e5f4a3 -> noto-dogra-3e5f4a3.tar.gz
mirror://githubcl/notofonts/duployan/tar.gz/b4c306a -> noto-duployan-b4c306a.tar.gz
mirror://githubcl/notofonts/egyptian-hieroglyphs/tar.gz/1736787 -> noto-egyptian-hieroglyphs-1736787.tar.gz
mirror://githubcl/notofonts/elbasan/tar.gz/6f0ba8b -> noto-elbasan-6f0ba8b.tar.gz
mirror://githubcl/notofonts/elymaic/tar.gz/161b8d4 -> noto-elymaic-161b8d4.tar.gz
mirror://githubcl/notofonts/ethiopic/tar.gz/ee41b50 -> noto-ethiopic-ee41b50.tar.gz
mirror://githubcl/notofonts/georgian/tar.gz/20f7e8b -> noto-georgian-20f7e8b.tar.gz
mirror://githubcl/notofonts/glagolitic/tar.gz/4c6b5b8 -> noto-glagolitic-4c6b5b8.tar.gz
mirror://githubcl/notofonts/gothic/tar.gz/5e3d7af -> noto-gothic-5e3d7af.tar.gz
mirror://githubcl/notofonts/grantha/tar.gz/b37d48a -> noto-grantha-b37d48a.tar.gz
mirror://githubcl/notofonts/gujarati/tar.gz/263b93c -> noto-gujarati-263b93c.tar.gz
mirror://githubcl/notofonts/gunjala-gondi/tar.gz/a815dc0 -> noto-gunjala-gondi-a815dc0.tar.gz
mirror://githubcl/notofonts/gurmukhi/tar.gz/16cbc91 -> noto-gurmukhi-16cbc91.tar.gz
mirror://githubcl/notofonts/hanifi-rohingya/tar.gz/f54cf74 -> noto-hanifi-rohingya-f54cf74.tar.gz
mirror://githubcl/notofonts/hanunoo/tar.gz/0d3115a -> noto-hanunoo-0d3115a.tar.gz
mirror://githubcl/notofonts/hatran/tar.gz/f5ce042 -> noto-hatran-f5ce042.tar.gz
mirror://githubcl/notofonts/hebrew/tar.gz/27874fd -> noto-hebrew-27874fd.tar.gz
mirror://githubcl/notofonts/imperial-aramaic/tar.gz/75e0de4 -> noto-imperial-aramaic-75e0de4.tar.gz
mirror://githubcl/notofonts/indic-siyaq-numbers/tar.gz/e3ad73d -> noto-indic-siyaq-numbers-e3ad73d.tar.gz
mirror://githubcl/notofonts/inscriptional-pahlavi/tar.gz/7261995 -> noto-inscriptional-pahlavi-7261995.tar.gz
mirror://githubcl/notofonts/inscriptional-parthian/tar.gz/9e011cd -> noto-inscriptional-parthian-9e011cd.tar.gz
mirror://githubcl/notofonts/javanese/tar.gz/e9b06cb -> noto-javanese-e9b06cb.tar.gz
mirror://githubcl/notofonts/kaithi/tar.gz/6503a58 -> noto-kaithi-6503a58.tar.gz
mirror://githubcl/notofonts/kawi/tar.gz/2354468 -> noto-kawi-2354468.tar.gz
mirror://githubcl/notofonts/kannada/tar.gz/fddf53f -> noto-kannada-fddf53f.tar.gz
mirror://githubcl/notofonts/kayah-li/tar.gz/888f423 -> noto-kayah-li-888f423.tar.gz
mirror://githubcl/notofonts/kharoshthi/tar.gz/729cc58 -> noto-kharoshthi-729cc58.tar.gz
mirror://githubcl/notofonts/khitan-small-script/tar.gz/da947d69 -> noto-khitan-small-script-da947d69.tar.gz
mirror://githubcl/notofonts/khmer/tar.gz/ecd45f7 -> noto-khmer-ecd45f7.tar.gz
mirror://githubcl/notofonts/khojki/tar.gz/87bad76 -> noto-khojki-87bad76.tar.gz
mirror://githubcl/notofonts/khudawadi/tar.gz/9c897b3 -> noto-khudawadi-9c897b3.tar.gz
mirror://githubcl/notofonts/lao/tar.gz/239b9a8 -> noto-lao-239b9a8.tar.gz
mirror://githubcl/notofonts/latin-greek-cyrillic/tar.gz/cb097900c -> noto-latin-greek-cyrillic-cb097900c.tar.gz
mirror://githubcl/notofonts/lepcha/tar.gz/fa8474a -> noto-lepcha-fa8474a.tar.gz
mirror://githubcl/notofonts/limbu/tar.gz/f3f2570 -> noto-limbu-f3f2570.tar.gz
mirror://githubcl/notofonts/linear-a/tar.gz/42483eb -> noto-linear-a-42483eb.tar.gz
mirror://githubcl/notofonts/linear-b/tar.gz/2e1131f -> noto-linear-b-2e1131f.tar.gz
mirror://githubcl/notofonts/lisu/tar.gz/c41a9c1 -> noto-lisu-c41a9c1.tar.gz
mirror://githubcl/notofonts/lycian/tar.gz/aff7f12 -> noto-lycian-aff7f12.tar.gz
mirror://githubcl/notofonts/lydian/tar.gz/282468b -> noto-lydian-282468b.tar.gz
mirror://githubcl/notofonts/mahajani/tar.gz/212764e -> noto-mahajani-212764e.tar.gz
mirror://githubcl/notofonts/makasar/tar.gz/257db69 -> noto-makasar-257db69.tar.gz
mirror://githubcl/notofonts/malayalam/tar.gz/246d37a -> noto-malayalam-246d37a.tar.gz
mirror://githubcl/notofonts/mandaic/tar.gz/71352e0 -> noto-mandaic-71352e0.tar.gz
mirror://githubcl/notofonts/manichaean/tar.gz/79b6968 -> noto-manichaean-79b6968.tar.gz
mirror://githubcl/notofonts/marchen/tar.gz/bf09f82 -> noto-marchen-bf09f82.tar.gz
mirror://githubcl/notofonts/masaram-gondi/tar.gz/b9fde21 -> noto-masaram-gondi-b9fde21.tar.gz
mirror://githubcl/notofonts/math/tar.gz/8e921086 -> noto-math-8e921086.tar.gz
mirror://githubcl/notofonts/mayan-numerals/tar.gz/ff79df5 -> noto-mayan-numerals-ff79df5.tar.gz
mirror://githubcl/notofonts/medefaidrin/tar.gz/b5d6e4e -> noto-medefaidrin-b5d6e4e.tar.gz
mirror://githubcl/notofonts/meetei-mayek/tar.gz/5f93a3a -> noto-meetei-mayek-5f93a3a.tar.gz
mirror://githubcl/notofonts/mende-kikakui/tar.gz/481df85 -> noto-mende-kikakui-481df85.tar.gz
mirror://githubcl/notofonts/meroitic/tar.gz/34cadfd -> noto-meroitic-34cadfd.tar.gz
mirror://githubcl/notofonts/miao/tar.gz/47065c4 -> noto-miao-47065c4.tar.gz
mirror://githubcl/notofonts/modi/tar.gz/27358a0 -> noto-modi-27358a0.tar.gz
mirror://githubcl/notofonts/mongolian/tar.gz/1621964 -> noto-mongolian-1621964.tar.gz
mirror://githubcl/notofonts/mro/tar.gz/80fc63a -> noto-mro-80fc63a.tar.gz
mirror://githubcl/notofonts/multani/tar.gz/3831630 -> noto-multani-3831630.tar.gz
mirror://githubcl/notofonts/music/tar.gz/81817dc -> noto-music-81817dc.tar.gz
mirror://githubcl/notofonts/myanmar/tar.gz/44c4eac -> noto-myanmar-44c4eac.tar.gz
mirror://githubcl/notofonts/nabataean/tar.gz/2785ce5 -> noto-nabataean-2785ce5.tar.gz
mirror://githubcl/notofonts/nag-mundari/tar.gz/67045c6 -> noto-nag-mundari-67045c6.tar.gz
mirror://githubcl/notofonts/nandinagari/tar.gz/f405f4f -> noto-nandinagari-f405f4f.tar.gz
mirror://githubcl/notofonts/nastaliq/tar.gz/b61629d -> noto-nastaliq-b61629d.tar.gz
mirror://githubcl/notofonts/new-tai-lue/tar.gz/eaf7cb4 -> noto-new-tai-lue-eaf7cb4.tar.gz
mirror://githubcl/notofonts/newa/tar.gz/fe00e75 -> noto-newa-fe00e75.tar.gz
mirror://githubcl/notofonts/nko/tar.gz/adab271 -> noto-nko-adab271.tar.gz
mirror://githubcl/notofonts/nushu/tar.gz/649503f -> noto-nushu-649503f.tar.gz
mirror://githubcl/notofonts/nyiakeng-puachue-hmong/tar.gz/9a7be5a -> noto-nyiakeng-puachue-hmong-9a7be5a.tar.gz
mirror://githubcl/notofonts/ogham/tar.gz/1eddb45 -> noto-ogham-1eddb45.tar.gz
mirror://githubcl/notofonts/ol-chiki/tar.gz/fda8b68 -> noto-ol-chiki-fda8b68.tar.gz
mirror://githubcl/notofonts/old-hungarian/tar.gz/f3b2b51 -> noto-old-hungarian-f3b2b51.tar.gz
mirror://githubcl/notofonts/old-hungarian-ui/tar.gz/e3125a6 -> noto-old-hungarian-ui-e3125a6.tar.gz
mirror://githubcl/notofonts/old-italic/tar.gz/9d28496 -> noto-old-italic-9d28496.tar.gz
mirror://githubcl/notofonts/old-north-arabian/tar.gz/761c4f8 -> noto-old-north-arabian-761c4f8.tar.gz
mirror://githubcl/notofonts/old-permic/tar.gz/5304804 -> noto-old-permic-5304804.tar.gz
mirror://githubcl/notofonts/old-persian/tar.gz/0a50cae -> noto-old-persian-0a50cae.tar.gz
mirror://githubcl/notofonts/old-sogdian/tar.gz/a4baf51 -> noto-old-sogdian-a4baf51.tar.gz
mirror://githubcl/notofonts/old-south-arabian/tar.gz/dcb07b3 -> noto-old-south-arabian-dcb07b3.tar.gz
mirror://githubcl/notofonts/old-turkic/tar.gz/b7c866b -> noto-old-turkic-b7c866b.tar.gz
mirror://githubcl/notofonts/old-uyghur/tar.gz/4b787c5 -> noto-old-uyghur-4b787c5.tar.gz
mirror://githubcl/notofonts/oriya/tar.gz/524f4a2 -> noto-oriya-524f4a2.tar.gz
mirror://githubcl/notofonts/osage/tar.gz/57f0aa8 -> noto-osage-57f0aa8.tar.gz
mirror://githubcl/notofonts/osmanya/tar.gz/7323ed1 -> noto-osmanya-7323ed1.tar.gz
mirror://githubcl/notofonts/ottoman-siyaq-numbers/tar.gz/0ad333a -> noto-ottoman-siyaq-numbers-0ad333a.tar.gz
mirror://githubcl/notofonts/pahawh-hmong/tar.gz/c066eb2 -> noto-pahawh-hmong-c066eb2.tar.gz
mirror://githubcl/notofonts/palmyrene/tar.gz/83a6774 -> noto-palmyrene-83a6774.tar.gz
mirror://githubcl/notofonts/pau-cin-hau/tar.gz/5322a56 -> noto-pau-cin-hau-5322a56.tar.gz
mirror://githubcl/notofonts/phags-pa/tar.gz/23ae894 -> noto-phags-pa-23ae894.tar.gz
mirror://githubcl/notofonts/phoenician/tar.gz/c215dbb -> noto-phoenician-c215dbb.tar.gz
mirror://githubcl/notofonts/psalter-pahlavi/tar.gz/03a5ec8 -> noto-psalter-pahlavi-03a5ec8.tar.gz
mirror://githubcl/notofonts/rejang/tar.gz/e8d647c -> noto-rejang-e8d647c.tar.gz
mirror://githubcl/notofonts/runic/tar.gz/ed55a39 -> noto-runic-ed55a39.tar.gz
mirror://githubcl/notofonts/samaritan/tar.gz/56aecb9 -> noto-samaritan-56aecb9.tar.gz
mirror://githubcl/notofonts/saurashtra/tar.gz/cb1c4b5 -> noto-saurashtra-cb1c4b5.tar.gz
mirror://githubcl/notofonts/sharada/tar.gz/d7fc03c -> noto-sharada-d7fc03c.tar.gz
mirror://githubcl/notofonts/shavian/tar.gz/9be01d3 -> noto-shavian-9be01d3.tar.gz
mirror://githubcl/notofonts/siddham/tar.gz/780aa94 -> noto-siddham-780aa94.tar.gz
mirror://githubcl/notofonts/sign-writing/tar.gz/4c4ff9d6 -> noto-sign-writing-4c4ff9d6.tar.gz
mirror://githubcl/notofonts/sinhala/tar.gz/c59d95d -> noto-sinhala-c59d95d.tar.gz
mirror://githubcl/notofonts/sogdian/tar.gz/c075553 -> noto-sogdian-c075553.tar.gz
mirror://githubcl/notofonts/sora-sompeng/tar.gz/da16e8f -> noto-sora-sompeng-da16e8f.tar.gz
mirror://githubcl/notofonts/soyombo/tar.gz/5e319d9 -> noto-soyombo-5e319d9.tar.gz
mirror://githubcl/notofonts/sundanese/tar.gz/449e3c4 -> noto-sundanese-449e3c4.tar.gz
mirror://githubcl/notofonts/sunuwar/tar.gz/e08c76c -> noto-sunuwar-e08c76c.tar.gz
mirror://githubcl/notofonts/syloti-nagri/tar.gz/a9439b2 -> noto-syloti-nagri-a9439b2.tar.gz
mirror://githubcl/notofonts/symbols/tar.gz/d8bee720 -> noto-symbols-d8bee720.tar.gz
mirror://githubcl/notofonts/syriac/tar.gz/ba11708 -> noto-syriac-ba11708.tar.gz
mirror://githubcl/notofonts/tagalog/tar.gz/a403815 -> noto-tagalog-a403815.tar.gz
mirror://githubcl/notofonts/tagbanwa/tar.gz/5c2681f -> noto-tagbanwa-5c2681f.tar.gz
mirror://githubcl/notofonts/tai-le/tar.gz/1ab9081 -> noto-tai-le-1ab9081.tar.gz
mirror://githubcl/notofonts/tai-tham/tar.gz/8cc930d -> noto-tai-tham-8cc930d.tar.gz
mirror://githubcl/notofonts/tai-viet/tar.gz/7600ade -> noto-tai-viet-7600ade.tar.gz
mirror://githubcl/notofonts/takri/tar.gz/6014093 -> noto-takri-6014093.tar.gz
mirror://githubcl/notofonts/tamil/tar.gz/f016a59 -> noto-tamil-f016a59.tar.gz
mirror://githubcl/notofonts/tangsa/tar.gz/408a728 -> noto-tangsa-408a728.tar.gz
mirror://githubcl/notofonts/tangut/tar.gz/bc79cdc4 -> noto-tangut-bc79cdc4.tar.gz
mirror://githubcl/notofonts/telugu/tar.gz/8e5b27c -> noto-telugu-8e5b27c.tar.gz
mirror://githubcl/notofonts/thaana/tar.gz/2876a41 -> noto-thaana-2876a41.tar.gz
mirror://githubcl/notofonts/thai/tar.gz/db1ea1aa -> noto-thai-db1ea1aa.tar.gz
mirror://githubcl/notofonts/tibetan/tar.gz/dc93090 -> noto-tibetan-dc93090.tar.gz
mirror://githubcl/notofonts/tifinagh/tar.gz/50db48f -> noto-tifinagh-50db48f.tar.gz
mirror://githubcl/notofonts/tirhuta/tar.gz/53753d7 -> noto-tirhuta-53753d7.tar.gz
mirror://githubcl/notofonts/toto/tar.gz/77284d9 -> noto-toto-77284d9.tar.gz
mirror://githubcl/notofonts/ugaritic/tar.gz/b6bfea1 -> noto-ugaritic-b6bfea1.tar.gz
mirror://githubcl/notofonts/vai/tar.gz/86eb4a4 -> noto-vai-86eb4a4.tar.gz
mirror://githubcl/notofonts/vithkuqi/tar.gz/9ed0bd5 -> noto-vithkuqi-9ed0bd5.tar.gz
mirror://githubcl/notofonts/wancho/tar.gz/5a0a8cf -> noto-wancho-5a0a8cf.tar.gz
mirror://githubcl/notofonts/warang-citi/tar.gz/5b3f97b -> noto-warang-citi-5b3f97b.tar.gz
mirror://githubcl/notofonts/yezidi/tar.gz/21d6280 -> noto-yezidi-21d6280.tar.gz
mirror://githubcl/notofonts/yi/tar.gz/0351618 -> noto-yi-0351618.tar.gz
mirror://githubcl/notofonts/zanabazar-square/tar.gz/3476fa3 -> noto-zanabazar-square-3476fa3.tar.gz
mirror://githubcl/notofonts/znamenny/tar.gz/f0e5e48 -> noto-znamenny-f0e5e48.tar.gz
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
