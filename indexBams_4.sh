#!/bin/bash
#SBATCH --job-name=index_bams_4
#SBATCH --output=../../logs/index_bams_4.%A.%a.log
#SBATCH --array=1-200
#SBATCH -t 400:00:00
#SBATCH -c 1
#SBATCH -D /scratch2/mkardos/methowRAD/results/aligned/allSamps

case $SLURM_ARRAY_TASK_ID in
1) IN=L07_46.RG.bam ;;
2) IN=L07_47.RG.bam ;;
3) IN=L07_48.RG.bam ;;
4) IN=L07_49.RG.bam ;;
5) IN=L07_4.RG.bam ;;
6) IN=L07_50.RG.bam ;;
7) IN=L07_51.RG.bam ;;
8) IN=L07_52.RG.bam ;;
9) IN=L07_53.RG.bam ;;
10) IN=L07_54.RG.bam ;;
11) IN=L07_55.RG.bam ;;
12) IN=L07_56.RG.bam ;;
13) IN=L07_57.RG.bam ;;
14) IN=L07_58.RG.bam ;;
15) IN=L07_59.RG.bam ;;
16) IN=L07_5.RG.bam ;;
17) IN=L07_60.RG.bam ;;
18) IN=L07_61.RG.bam ;;
19) IN=L07_62.RG.bam ;;
20) IN=L07_63.RG.bam ;;
21) IN=L07_64.RG.bam ;;
22) IN=L07_65.RG.bam ;;
23) IN=L07_66.RG.bam ;;
24) IN=L07_67.RG.bam ;;
25) IN=L07_68.RG.bam ;;
26) IN=L07_69.RG.bam ;;
27) IN=L07_6.RG.bam ;;
28) IN=L07_70.RG.bam ;;
29) IN=L07_71.RG.bam ;;
30) IN=L07_72.RG.bam ;;
31) IN=L07_73.RG.bam ;;
32) IN=L07_74.RG.bam ;;
33) IN=L07_75.RG.bam ;;
34) IN=L07_76.RG.bam ;;
35) IN=L07_77.RG.bam ;;
36) IN=L07_78.RG.bam ;;
37) IN=L07_79.RG.bam ;;
38) IN=L07_7.RG.bam ;;
39) IN=L07_80.RG.bam ;;
40) IN=L07_81.RG.bam ;;
41) IN=L07_82.RG.bam ;;
42) IN=L07_83.RG.bam ;;
43) IN=L07_84.RG.bam ;;
44) IN=L07_85.RG.bam ;;
45) IN=L07_86.RG.bam ;;
46) IN=L07_87.RG.bam ;;
47) IN=L07_88.RG.bam ;;
48) IN=L07_89.RG.bam ;;
49) IN=L07_8.RG.bam ;;
50) IN=L07_90.RG.bam ;;
51) IN=L07_91.RG.bam ;;
52) IN=L07_92.RG.bam ;;
53) IN=L07_93.RG.bam ;;
54) IN=L07_94.RG.bam ;;
55) IN=L07_95.RG.bam ;;
56) IN=L07_96.RG.bam ;;
57) IN=L07_9.RG.bam ;;
58) IN=L08_10.RG.bam ;;
59) IN=L08_11.RG.bam ;;
60) IN=L08_12.RG.bam ;;
61) IN=L08_13.RG.bam ;;
62) IN=L08_14.RG.bam ;;
63) IN=L08_15.RG.bam ;;
64) IN=L08_16.RG.bam ;;
65) IN=L08_17.RG.bam ;;
66) IN=L08_18.RG.bam ;;
67) IN=L08_19.RG.bam ;;
68) IN=L08_20.RG.bam ;;
69) IN=L08_21.RG.bam ;;
70) IN=L08_22.RG.bam ;;
71) IN=L08_23.RG.bam ;;
72) IN=L08_24.RG.bam ;;
73) IN=L08_25.RG.bam ;;
74) IN=L08_26.RG.bam ;;
75) IN=L08_27.RG.bam ;;
76) IN=L08_28.RG.bam ;;
77) IN=L08_2.RG.bam ;;
78) IN=L08_30.RG.bam ;;
79) IN=L08_31.RG.bam ;;
80) IN=L08_32.RG.bam ;;
81) IN=L08_33.RG.bam ;;
82) IN=L08_34.RG.bam ;;
83) IN=L08_35.RG.bam ;;
84) IN=L08_36.RG.bam ;;
85) IN=L08_37.RG.bam ;;
86) IN=L08_38.RG.bam ;;
87) IN=L08_39.RG.bam ;;
88) IN=L08_3.RG.bam ;;
89) IN=L08_40.RG.bam ;;
90) IN=L08_41.RG.bam ;;
91) IN=L08_42.RG.bam ;;
92) IN=L08_43.RG.bam ;;
93) IN=L08_44.RG.bam ;;
94) IN=L08_45.RG.bam ;;
95) IN=L08_46.RG.bam ;;
96) IN=L08_47.RG.bam ;;
97) IN=L08_48.RG.bam ;;
98) IN=L08_49.RG.bam ;;
99) IN=L08_4.RG.bam ;;
100) IN=L08_50.RG.bam ;;
101) IN=L08_51.RG.bam ;;
102) IN=L08_52.RG.bam ;;
103) IN=L08_53.RG.bam ;;
104) IN=L08_54.RG.bam ;;
105) IN=L08_55.RG.bam ;;
106) IN=L08_56.RG.bam ;;
107) IN=L08_57.RG.bam ;;
108) IN=L08_58.RG.bam ;;
109) IN=L08_59.RG.bam ;;
110) IN=L08_5.RG.bam ;;
111) IN=L08_60.RG.bam ;;
112) IN=L08_61.RG.bam ;;
113) IN=L08_62.RG.bam ;;
114) IN=L08_63.RG.bam ;;
115) IN=L08_64.RG.bam ;;
116) IN=L08_65.RG.bam ;;
117) IN=L08_66.RG.bam ;;
118) IN=L08_67.RG.bam ;;
119) IN=L08_68.RG.bam ;;
120) IN=L08_69.RG.bam ;;
121) IN=L08_6.RG.bam ;;
122) IN=L08_70.RG.bam ;;
123) IN=L08_71.RG.bam ;;
124) IN=L08_72.RG.bam ;;
125) IN=L08_73.RG.bam ;;
126) IN=L08_74.RG.bam ;;
127) IN=L08_75.RG.bam ;;
128) IN=L08_76.RG.bam ;;
129) IN=L08_77.RG.bam ;;
130) IN=L08_78.RG.bam ;;
131) IN=L08_79.RG.bam ;;
132) IN=L08_7.RG.bam ;;
133) IN=L08_80.RG.bam ;;
134) IN=L08_81.RG.bam ;;
135) IN=L08_82.RG.bam ;;
136) IN=L08_83.RG.bam ;;
137) IN=L08_84.RG.bam ;;
138) IN=L08_85.RG.bam ;;
139) IN=L08_86.RG.bam ;;
140) IN=L08_87.RG.bam ;;
141) IN=L08_88.RG.bam ;;
142) IN=L08_89.RG.bam ;;
143) IN=L08_8.RG.bam ;;
144) IN=L08_90.RG.bam ;;
145) IN=L08_91.RG.bam ;;
146) IN=L08_92.RG.bam ;;
147) IN=L08_93.RG.bam ;;
148) IN=L08_94.RG.bam ;;
149) IN=L08_95.RG.bam ;;
150) IN=L08_96.RG.bam ;;
151) IN=L08_9.RG.bam ;;
152) IN=L09_10.RG.bam ;;
153) IN=L09_11.RG.bam ;;
154) IN=L09_12.RG.bam ;;
155) IN=L09_13.RG.bam ;;
156) IN=L09_14.RG.bam ;;
157) IN=L09_15.RG.bam ;;
158) IN=L09_16.RG.bam ;;
159) IN=L09_17.RG.bam ;;
160) IN=L09_18.RG.bam ;;
161) IN=L09_19.RG.bam ;;
162) IN=L09_1.RG.bam ;;
163) IN=L09_20.RG.bam ;;
164) IN=L09_21.RG.bam ;;
165) IN=L09_22.RG.bam ;;
166) IN=L09_23.RG.bam ;;
167) IN=L09_24.RG.bam ;;
168) IN=L09_25.RG.bam ;;
169) IN=L09_26.RG.bam ;;
170) IN=L09_27.RG.bam ;;
171) IN=L09_28.RG.bam ;;
172) IN=L09_29.RG.bam ;;
173) IN=L09_2.RG.bam ;;
174) IN=L09_30.RG.bam ;;
175) IN=L09_31.RG.bam ;;
176) IN=L09_32.RG.bam ;;
177) IN=L09_33.RG.bam ;;
178) IN=L09_34.RG.bam ;;
179) IN=L09_35.RG.bam ;;
180) IN=L09_36.RG.bam ;;
181) IN=L09_37.RG.bam ;;
182) IN=L09_38.RG.bam ;;
183) IN=L09_39.RG.bam ;;
184) IN=L09_3.RG.bam ;;
185) IN=L09_40.RG.bam ;;
186) IN=L09_41.RG.bam ;;
187) IN=L09_42.RG.bam ;;
188) IN=L09_43.RG.bam ;;
189) IN=L09_44.RG.bam ;;
190) IN=L09_45.RG.bam ;;
191) IN=L09_46.RG.bam ;;
192) IN=L09_47.RG.bam ;;
193) IN=L09_48.RG.bam ;;
194) IN=L09_49.RG.bam ;;
195) IN=L09_4.RG.bam ;;
196) IN=L09_50.RG.bam ;;
197) IN=L09_51.RG.bam ;;
198) IN=L09_52.RG.bam ;;
199) IN=L09_53.RG.bam ;;
200) IN=L09_54.RG.bam ;;
esac

module load bio/samtools/1.19
samtools index ${IN}
