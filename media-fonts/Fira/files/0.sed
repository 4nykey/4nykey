/feature \(calt\|ccmp\) {/,/} \(calt\|ccmp\)\;/d
/feature \(calt\|ccmp\)\;/d
/^sub .*\<[tT]commaaccent\>/d
/^sub .*\<micro\>/d
/^sub .*\<\(glottalstopreversed\|equal\|minus\|plus\)\(inf\|sup\)erior\>/d
s_\<\(breve\|caron\|cedilla\|circumflex\|dblgrave\|dieresis\|dotaccent\|hungarumlaut\|macron\|ogonek\|ring\)comb\>_\1cmb_g
s_\(Upsilondieresishook\|kappa\|beta\|phi\|pi\)Symbol_\1symbolgreek_g
s_\<colonsign\>_colonmonetary_g
s_\<euro\>_Euro_g
s_\<G\(ermandbls\)\>_g\1_g
s_\<guillemet\(left\|right\)\>_guillemot\1_g
s_\<idotless\>_dotlessi_g
s_\<idotaccent\>\.sc_i.sc.loclTRK_g
s_\<idotaccent\>_i.loclTRK_g
/\<\(san\|Rsmall\)\>/d
s_-_._g
