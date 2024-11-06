# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

# cmake/modules/define_bitstream_files.cmake
SRC_URI="https://www.itu.int/wftp3/av-arch/jvet-site/bitstream_exchange/VVC/FDIS/"
SRC_URI="
	test? (
		${SRC_URI}10b400_A_Bytedance_2.zip
		${SRC_URI}10b400_B_Bytedance_2.zip
		${SRC_URI}10b444_A_Kwai_3.zip
		${SRC_URI}10b444_B_Kwai_3.zip
		${SRC_URI}8b400_A_Bytedance_2.zip
		${SRC_URI}8b400_B_Bytedance_2.zip
		${SRC_URI}8b420_A_Bytedance_2.zip
		${SRC_URI}8b420_B_Bytedance_2.zip
		${SRC_URI}ACTPIC_A_Huawei_3.zip
		${SRC_URI}ACTPIC_B_Huawei_3.zip
		${SRC_URI}ACTPIC_C_Huawei_3.zip
		${SRC_URI}AFF_A_HUAWEI_2.zip
		${SRC_URI}AFF_B_HUAWEI_2.zip
		${SRC_URI}ALF_A_Huawei_3.zip
		${SRC_URI}ALF_B_Huawei_3.zip
		${SRC_URI}ALF_C_KDDI_3.zip
		${SRC_URI}ALF_D_Qualcomm_2.zip
		${SRC_URI}AMVR_A_HHI_3.zip
		${SRC_URI}AMVR_B_HHI_3.zip
		${SRC_URI}APSALF_A_Qualcomm_2.zip
		${SRC_URI}APSLMCS_A_Dolby_3.zip
		${SRC_URI}APSLMCS_B_Dolby_3.zip
		${SRC_URI}APSLMCS_C_Dolby_2.zip
		${SRC_URI}APSLMCS_D_Dolby_1.zip
		${SRC_URI}APSLMCS_E_Dolby_1.zip
		${SRC_URI}APSMULT_A_MediaTek_4.zip
		${SRC_URI}APSMULT_B_MediaTek_4.zip
		${SRC_URI}AUD_A_Broadcom_3.zip
		${SRC_URI}BCW_A_MediaTek_4.zip
		${SRC_URI}BDOF_A_MediaTek_4.zip
		${SRC_URI}BDPCM_A_Orange_2.zip
		${SRC_URI}BOUNDARY_A_Huawei_3.zip
		${SRC_URI}BUMP_A_LGE_2.zip
		${SRC_URI}BUMP_B_LGE_2.zip
		${SRC_URI}BUMP_C_LGE_2.zip
		${SRC_URI}CCALF_A_Sharp_3.zip
		${SRC_URI}CCALF_B_Sharp_3.zip
		${SRC_URI}CCALF_C_Sharp_3.zip
		${SRC_URI}CCALF_D_Sharp_3.zip
		${SRC_URI}CCLM_A_KDDI_2.zip
		${SRC_URI}CIIP_A_MediaTek_4.zip
		${SRC_URI}CodingToolsSets_A_Tencent_2.zip
		${SRC_URI}CodingToolsSets_B_Tencent_2.zip
		${SRC_URI}CodingToolsSets_C_Tencent_2.zip
		${SRC_URI}CodingToolsSets_D_Tencent_2.zip
		${SRC_URI}CodingToolsSets_E_Tencent_1.zip
		${SRC_URI}CROP_A_Panasonic_4.zip
		${SRC_URI}CROP_B_Panasonic_4.zip
		${SRC_URI}CST_A_MediaTek_4.zip
		${SRC_URI}CTU_A_MediaTek_4.zip
		${SRC_URI}CTU_B_MediaTek_4.zip
		${SRC_URI}CTU_C_MediaTek_4.zip
		${SRC_URI}CUBEMAP_A_MediaTek_3.zip
		${SRC_URI}CUBEMAP_B_MediaTek_3.zip
		${SRC_URI}CUBEMAP_C_MediaTek_3.zip
		${SRC_URI}DCI_A_Tencent_3.zip
		${SRC_URI}DCI_B_Tencent_3.zip
		${SRC_URI}DEBLOCKING_A_Sharp_3.zip
		${SRC_URI}DEBLOCKING_B_Sharp_2.zip
		${SRC_URI}DEBLOCKING_C_Huawei_3.zip
		${SRC_URI}DEBLOCKING_E_Ericsson_3.zip
		${SRC_URI}DEBLOCKING_F_Ericsson_2.zip
		${SRC_URI}DMVR_A_Huawei_3.zip
		${SRC_URI}DMVR_B_KDDI_4.zip
		${SRC_URI}DPB_A_Sharplabs_2.zip
		${SRC_URI}DPB_B_Sharplabs_2.zip
		${SRC_URI}DQ_A_HHI_3.zip
		${SRC_URI}DQ_B_HHI_3.zip
		${SRC_URI}ENT444HIGHTIER_A_Sony_3.zip
		${SRC_URI}ENT444HIGHTIER_B_Sony_3.zip
		${SRC_URI}ENT444HIGHTIER_C_Sony_3.zip
		${SRC_URI}ENT444HIGHTIER_D_Sony_3.zip
		${SRC_URI}ENT444MAINTIER_A_Sony_3.zip
		${SRC_URI}ENT444MAINTIER_B_Sony_3.zip
		${SRC_URI}ENT444MAINTIER_C_Sony_3.zip
		${SRC_URI}ENT444MAINTIER_D_Sony_3.zip
		${SRC_URI}ENTHIGHTIER_A_Sony_3.zip
		${SRC_URI}ENTHIGHTIER_B_Sony_3.zip
		${SRC_URI}ENTHIGHTIER_C_Sony_3.zip
		${SRC_URI}ENTHIGHTIER_D_Sony_3.zip
		${SRC_URI}ENTMAINTIER_A_Sony_3.zip
		${SRC_URI}ENTMAINTIER_B_Sony_3.zip
		${SRC_URI}ENTMAINTIER_C_Sony_3.zip
		${SRC_URI}ENTMAINTIER_D_Sony_3.zip
		${SRC_URI}ENTROPY_A_Chipsnmedia_2.zip
		${SRC_URI}ENTROPY_B_Sharp_2.zip
		${SRC_URI}ENTROPY_C_Qualcomm_1.zip
		${SRC_URI}ERP_A_MediaTek_3.zip
		${SRC_URI}FIELD_A_Panasonic_4.zip
		${SRC_URI}FIELD_B_Panasonic_2.zip
		${SRC_URI}FILLER_A_Bytedance_1.zip
		${SRC_URI}GDR_A_ERICSSON_2.zip
		${SRC_URI}GDR_B_NOKIA_2.zip
		${SRC_URI}GDR_C_NOKIA_2.zip
		${SRC_URI}GDR_D_ERICSSON_1.zip
		${SRC_URI}GPM_A_Alibaba_3.zip
		${SRC_URI}GPM_B_Alibaba_1.zip
		${SRC_URI}HLG_A_NHK_4.zip
		${SRC_URI}HLG_B_NHK_4.zip
		${SRC_URI}HRD_A_Fujitsu_3.zip
		${SRC_URI}HRD_B_Fujitsu_2.zip
		${SRC_URI}IBC_A_Tencent_2.zip
		${SRC_URI}IBC_B_Tencent_2.zip
		${SRC_URI}IBC_C_Tencent_2.zip
		${SRC_URI}IBC_D_Tencent_2.zip
		${SRC_URI}IBC_E_Tencent_1.zip
		${SRC_URI}IP_A_Huawei_2.zip
		${SRC_URI}IP_B_Nokia_1.zip
		${SRC_URI}ISP_A_HHI_3.zip
		${SRC_URI}ISP_B_HHI_3.zip
		${SRC_URI}JCCR_A_Nokia_2.zip
		${SRC_URI}JCCR_B_Nokia_2.zip
		${SRC_URI}JCCR_C_HHI_3.zip
		${SRC_URI}JCCR_D_HHI_3.zip
		${SRC_URI}JCCR_E_Nokia_1.zip
		${SRC_URI}JCCR_F_Nokia_1.zip
		${SRC_URI}LFNST_A_LGE_4.zip
		${SRC_URI}LFNST_B_LGE_4.zip
		${SRC_URI}LFNST_C_HHI_3.zip
		${SRC_URI}LFNST_D_HHI_3.zip
		${SRC_URI}LMCS_A_Dolby_3.zip
		${SRC_URI}LMCS_B_Dolby_2.zip
		${SRC_URI}LMCS_C_Dolby_1.zip
		${SRC_URI}LOSSLESS_A_HHI_3.zip
		${SRC_URI}LOSSLESS_B_HHI_3.zip
		${SRC_URI}LTRP_A_ERICSSON_3.zip
		${SRC_URI}MERGE_A_Qualcomm_2.zip
		${SRC_URI}MERGE_B_Qualcomm_2.zip
		${SRC_URI}MERGE_C_Qualcomm_2.zip
		${SRC_URI}MERGE_D_Qualcomm_2.zip
		${SRC_URI}MERGE_E_Qualcomm_2.zip
		${SRC_URI}MERGE_F_Qualcomm_2.zip
		${SRC_URI}MERGE_G_Qualcomm_2.zip
		${SRC_URI}MERGE_H_Qualcomm_2.zip
		${SRC_URI}MERGE_I_Qualcomm_2.zip
		${SRC_URI}MERGE_J_Qualcomm_2.zip
		${SRC_URI}MIP_A_HHI_3.zip
		${SRC_URI}MIP_B_HHI_3.zip
		${SRC_URI}MMVD_A_SAMSUNG_3.zip
		${SRC_URI}MNUT_A_Nokia_4.zip
		${SRC_URI}MNUT_B_Nokia_3.zip
		${SRC_URI}MPM_A_LGE_3.zip
		${SRC_URI}MRLP_A_HHI_2.zip
		${SRC_URI}MRLP_B_HHI_2.zip
		${SRC_URI}MTS_A_LGE_4.zip
		${SRC_URI}MTS_B_LGE_4.zip
		${SRC_URI}MTS_LFNST_A_LGE_4.zip
		${SRC_URI}MTS_LFNST_B_LGE_4.zip
		${SRC_URI}MVCOMP_A_Sharp_2.zip
		${SRC_URI}PDPC_A_Qualcomm_3.zip
		${SRC_URI}PDPC_B_Qualcomm_3.zip
		${SRC_URI}PDPC_C_Qualcomm_2.zip
		${SRC_URI}PHSH_B_Sharp_1.zip
		${SRC_URI}PMERGE_A_MediaTek_1.zip
		${SRC_URI}PMERGE_B_MediaTek_1.zip
		${SRC_URI}PMERGE_C_MediaTek_1.zip
		${SRC_URI}PMERGE_D_MediaTek_1.zip
		${SRC_URI}PMERGE_E_MediaTek_1.zip
		${SRC_URI}POC_A_Nokia_1.zip
		${SRC_URI}POUT_A_Sharplabs_2.zip
		${SRC_URI}PPS_A_Bytedance_1.zip
		${SRC_URI}PPS_B_Bytedance_1.zip
		${SRC_URI}PPS_C_Bytedance_1.zip
		${SRC_URI}PQ_A_Dolby_1.zip
		${SRC_URI}PROF_A_Interdigital_3.zip
		${SRC_URI}PROF_B_Interdigital_3.zip
		${SRC_URI}PSEXT_A_Nokia_2.zip
		${SRC_URI}PSEXT_B_Nokia_2.zip
		${SRC_URI}QTBTT_A_MediaTek_4.zip
		${SRC_URI}QUANT_A_Huawei_2.zip
		${SRC_URI}QUANT_B_Huawei_2.zip
		${SRC_URI}QUANT_C_Huawei_2.zip
		${SRC_URI}QUANT_D_Huawei_4.zip
		${SRC_URI}QUANT_E_Interdigital_1.zip
		${SRC_URI}RAP_A_HHI_1.zip
		${SRC_URI}RAP_B_HHI_1.zip
		${SRC_URI}RAP_C_HHI_1.zip
		${SRC_URI}RAP_D_HHI_1.zip
		${SRC_URI}RPL_A_ERICSSON_2.zip
		${SRC_URI}RPR_A_Alibaba_4.zip
		${SRC_URI}RPR_B_Alibaba_3.zip
		${SRC_URI}RPR_C_Alibaba_3.zip
		${SRC_URI}RPR_D_Qualcomm_1.zip
		${SRC_URI}SAO_A_SAMSUNG_3.zip
		${SRC_URI}SAO_B_SAMSUNG_3.zip
		${SRC_URI}SAO_C_SAMSUNG_3.zip
		${SRC_URI}SBT_A_HUAWEI_2.zip
		${SRC_URI}SbTMVP_A_Bytedance_3.zip
		${SRC_URI}SbTMVP_B_Bytedance_3.zip
		${SRC_URI}SCALING_A_InterDigital_1.zip
		${SRC_URI}SCALING_B_InterDigital_1.zip
		${SRC_URI}SCALING_C_InterDigital_1.zip
		${SRC_URI}SDH_A_Dolby_2.zip
		${SRC_URI}SLICES_A_HUAWEI_3.zip
		${SRC_URI}SMVD_A_HUAWEI_2.zip
		${SRC_URI}SPS_A_Bytedance_1.zip
		${SRC_URI}SPS_B_Bytedance_1.zip
		${SRC_URI}SPS_C_Bytedance_1.zip
		${SRC_URI}STILL444_A_KDDI_1.zip
		${SRC_URI}STILL444_B_ERICSSON_1.zip
		${SRC_URI}STILL_A_KDDI_1.zip
		${SRC_URI}STILL_B_ERICSSON_1.zip
		${SRC_URI}SUBPIC_A_HUAWEI_3.zip
		${SRC_URI}SUBPIC_B_HUAWEI_3.zip
		${SRC_URI}SUBPIC_C_ERICSSON_1.zip
		${SRC_URI}SUBPIC_D_ERICSSON_1.zip
		${SRC_URI}SUBPIC_E_MediaTek_1.zip
		${SRC_URI}SUFAPS_A_HHI_1.zip
		${SRC_URI}TEMPSCAL_A_Panasonic_4.zip
		${SRC_URI}TEMPSCAL_B_Panasonic_7.zip
		${SRC_URI}TEMPSCAL_C_Panasonic_4.zip
		${SRC_URI}TILE_A_Nokia_2.zip
		${SRC_URI}TILE_B_Nokia_2.zip
		${SRC_URI}TILE_C_Nokia_2.zip
		${SRC_URI}TILE_D_Nokia_2.zip
		${SRC_URI}TILE_E_Nokia_2.zip
		${SRC_URI}TILE_F_Nokia_2.zip
		${SRC_URI}TILE_G_Nokia_2.zip
		${SRC_URI}TMVP_A_Chipsnmedia_3.zip
		${SRC_URI}TMVP_B_Chipsnmedia_3.zip
		${SRC_URI}TMVP_C_Chipsnmedia_3.zip
		${SRC_URI}TMVP_D_Chipsnmedia_3.zip
		${SRC_URI}TRANS_A_Chipsnmedia_2.zip
		${SRC_URI}TRANS_B_Chipsnmedia_2.zip
		${SRC_URI}TRANS_C_Chipsnmedia_4.zip
		${SRC_URI}TRANS_D_Chipsnmedia_4.zip
		${SRC_URI}TREE_A_HHI_3.zip
		${SRC_URI}TREE_B_HHI_3.zip
		${SRC_URI}TREE_C_HHI_3.zip
		${SRC_URI}VIRTUAL_A_MediaTek_3.zip
		${SRC_URI}VIRTUAL_B_MediaTek_3.zip
		${SRC_URI}WP_A_InterDigital_3.zip
		${SRC_URI}WP_B_InterDigital_3.zip
		${SRC_URI}WPP_A_Sharp_3.zip
		${SRC_URI}WPP_B_Sharp_2.zip
		${SRC_URI}WRAP_A_InterDigital_4.zip
		${SRC_URI}WRAP_B_InterDigital_4.zip
		${SRC_URI}WRAP_C_InterDigital_4.zip
		${SRC_URI}WRAP_D_InterDigital_4.zip
	)
"
if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/fraunhoferhhi/${PN}.git"
	inherit git-r3
	SLOT="0/${PV}"
else
	MY_PV="31d0e25"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI+="
		mirror://githubcl/fraunhoferhhi/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
	SLOT="0/$(ver_cut 1-2)"
fi

DESCRIPTION="Fraunhofer Versatile Video (H.266/VVC) Decoder"
HOMEPAGE="https://www.hhi.fraunhofer.de/en/departments/vca/technologies-and-solutions/h266-vvc.html"

LICENSE="BSD"

IUSE="test"
RESTRICT="!test? ( test )"
RESTRICT+=" primaryuri"
BDEPEND="
	test? (
		app-arch/unzip
	)
"

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		git-r3_src_unpack
	else
		unpack ${P}.tar.gz
	fi
	use test || return
	local _z _d="${S}/ext/bitstreams"
	mkdir -p "${_d}"
	for _z in ${A}; do
		[[ -z ${_z%%*.zip} ]] && unzip -qo -d "${_d}/${_z%.zip}" "${DISTDIR}/${_z}"
	done
}

src_prepare() {
	sed -e 's:\${VVDEC_TESTS_DEBUGGER_COMMAND}::' -i CMakeLists.txt
	cmake_src_prepare
}
