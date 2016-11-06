#!/bin/sed -f
:a
N
$!ba
s_},\n{\nname = familyName\;\nvalue = "Fira Sans Condensed"\;\n}\n\()\;\ninterpolationWeight = [0-9]\+\;\ninterpolationWidth = [0-9]\+\;\nname = [a-zA-Z]\+\)\;_}\n\1Condensed\;_g
s_},\n{\nname = familyName\;\nvalue = "Fira Sans Condensed"\;\n}\n\()\;\ninterpolationWeight = [0-9]\+\;\ninterpolationWidth = [0-9]\+\;\nisBold = 1\;\nname = [a-zA-Z]\+\)\;_}\n\1Condensed\;_g
s_},\n{\nname = familyName\;\nvalue = "Fira Sans Condensed"\;\n}\n\()\;\ninterpolationWeight = [0-9]\+\;\ninterpolationWidth = [0-9]\+\;\nisItalic = 1\;\nlinkStyle = [a-zA-Z]\+\;\nname = ["a-zA-Z ]*\)\(Italic["]*\)\;_}\n\1Condensed\2\;_g
s_},\n{\nname = familyName\;\nvalue = "Fira Sans Condensed"\;\n}\n\()\;\ninterpolationWeight = [0-9]\+\;\ninterpolationWidth = [0-9]\+\;\nisBold = 1\;\nisItalic = 1\;\nlinkStyle = [a-zA-Z]\+\;\nname = ["a-zA-Z ]*\)\(Italic["]*\)\;_}\n\1Condensed\2\;_g
