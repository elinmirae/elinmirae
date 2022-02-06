#1 sbp

##데이터 sbp 불러오기
install.packages("readxl")
library(readxl)
sbp<-read_xlsx("rex_example.xlsx", sheet = "sbp")

install.packages("dplyr")
library(dplyr)
group1<-sbp%>%filter(Group==1)
group2<-sbp%>%filter(Group==2)

##그룹별 정규성 검정
shapiro.test(group1$SBP)
shapiro.test(group2$SBP)

qqnorm(group1$SBP)
qqline(group1$SBP)
qqnorm(group2$SBP)
qqline(group2$SBP)

##등분산 검정
install.packages("car")
library(car)
leveneTest(SBP~as.factor(Group),data = sbp, center=mean) #rex에선 center가 mean으로 지정

##2독립표본t검정
library(stats)
t.test(SBP~Group, data=sbp, var.equal=TRUE) #When homogeneity of variance between groups is assumed.
t.test(SBP~Group, data=sbp) #When heterogeneity of variance between groups is assumed.

-----------------------------------------------------------------------------------------------------------
#2 memory
  
##데이터 memory 불러오기
install.packages("readxl")
library(readxl)
memory<-read_xlsx("rex_example.xlsx", sheet = "memory")

install.packages("dplyr")
library(dplyr)
group1<-memory%>%filter(그룹==1)
group2<-memory%>%filter(그룹==2)

##그룹별 정규성 검정
shapiro.test(group1$단기간기억력)
shapiro.test(group2$단기간기억력)

qqnorm(group1$단기간기억력)
qqline(group1$단기간기억력)
qqnorm(group2$단기간기억력)
qqline(group2$단기간기억력)

##등분산 검정
install.packages("car")
library(car)
leveneTest(단기간기억력~as.factor(그룹),data = memory, center=mean) #defalut:center=median

##2독립표본t검정
library(stats)
t.test(단기간기억력~그룹, data=memory, var.equal=TRUE) #When homogeneity of variance between groups is assumed.
t.test(단기간기억력~그룹, data=memory) #When heterogeneity of variance between groups is assumed.
-----------------------------------------------------------------------------------------------------------

#3 radiation

##데이터 memory 불러오기
install.packages("readxl")
library(readxl)
radiation<-read_xlsx("rex_example.xlsx", sheet = "radiation")

##정규성 검정
attach(radiation)
difference<-before_h-after_h
shapiro.test(difference)

qqnorm(difference)
qqline(difference)

#대응표본t검정
library(stats)
t.test(before_h,after_h,paired = TRUE)
-----------------------------------------------------------------------------------------------------------

#4 ammonia

##데이터 ammonia 불러오기
install.packages("readxl")
library(readxl)
ammonia<-read_xlsx("rex_example.xlsx", sheet = "ammonia")

##정규성 검정
attach(ammonia)
difference<-복용전-복용후
shapiro.test(difference)

qqnorm(difference)
qqline(difference)

#대응표본t검정
library(stats)
t.test(복용전,복용후,paired = TRUE)
-----------------------------------------------------------------------------------------------------------

#5 Osteoporosis

##데이터 Osteoporosis 불러오기
install.packages("readxl")
library(readxl)
Osteo<-read_xlsx("rex_example.xlsx", sheet = "Osteoporosis")

##정규성 검정
shapiro.test(Osteo$Osteoporosis)

qqnorm(Osteo$Osteoporosis)
qqline(Osteo$Osteoporosis)

##등분산 검정
install.packages("car")
library(car)
leveneTest(Osteoporosis~as.factor(Group),data = Osteo) #default : center=median 사용

##ANOVA Table
library(stats)
lm1<-lm(Osteoporosis~Group, data = Osteo)
anova(lm1) #ss type3

library(car)
Anova(lm1) #ss type2

##Welch's ANOVA
oneway.test(Osteoporosis~Group, data = Osteo, var.equal = F)

##Post-hoc Analysis
###Turkey's HSD
aov1<-aov(Osteoporosis~Group, data = Osteo)
TukeyHSD(aov1)

###Tamhane's T2
install.packages("PMCMRplus")
library(PMCMRplus)
tamhaneT2Test(Osteoporosis~as.factor(Group), data = Osteo) #*modified for Rex*

boxplot(Osteoporosis~Group, data = Osteo)
-----------------------------------------------------------------------------------------------------------

#6 vitamin

##데이터 vitamin 불러오기
install.packages("readxl")
library(readxl)
vitamin<-read_xlsx("rex_example.xlsx", sheet = "vitamin")

##정규성 검정
shapiro.test(vitamin$Vitamin_D)

qqnorm(vitamin$Vitamin_D)
qqline(vitamin$Vitamin_D)

##등분산 검정
install.packages("car")
library(car)
leveneTest(Vitamin_D~as.factor(Group),data = vitamin) #default : center=median 사용

##ANOVA Table
library(stats)
lm1<-lm(Vitamin_D~Group, data = vitamin)
anova(lm1) #type3

library(car)
Anova(lm1) #ss type2

##Welch's ANOVA
oneway.test(Vitamin_D~Group, data = vitamin, var.equal = F)

##Post-hoc Analysis
###Fisher's LSD 
install.packages("DescTools")
library(DescTools)
PostHocTest(aov1,method="lsd")

###Tamhane's T2
install.packages("PMCMRplus")
library(PMCMRplus)
tamhaneT2Test(Vitamin_D~as.factor(Group), data = vitamin) #*modified for Rex*

boxplot(Vitamin_D~Group, data = vitamin)
-----------------------------------------------------------------------------------------------------------

#9 vaccine

##데이터 vaccine 불러오기
install.packages("readxl")
library(readxl)
vaccine<-read_xlsx("rex_example.xlsx", sheet = "vaccine") 

##이표본비율검정
table(vaccine$A) #0:13개, 1:37개
table(vaccine$B) #0:23개, 1:27개

library(stats)
prop.test(x=c(37,27),n=c(50,50),correct = FALSE) #Homogeneity of variance is assumed
prop.test(x=c(37,27),n=c(50,50),correct = TRUE)
-----------------------------------------------------------------------------------------------------------

#11 memory

##데이터 memory 불러오기
install.packages("readxl")
library(readxl)
memory<-read_xlsx("rex_example.xlsx", sheet = "memory")

install.packages("dplyr")
library(dplyr)
group1<-memory%>%filter(그룹==1)
group2<-memory%>%filter(그룹==2)

##그룹별 정규성 검정
shapiro.test(group1$단기간기억력)
shapiro.test(group2$단기간기억력)

qqnorm(group1$단기간기억력)
qqline(group1$단기간기억력)
qqnorm(group2$단기간기억력)
qqline(group2$단기간기억력)

##F-Test for homogeneity of variance
library(stats)
var.test(group1$단기간기억력, group2$단기간기억력)
-----------------------------------------------------------------------------------------------------------

#12 sbp

##데이터 sbp 불러오기
install.packages("readxl")
library(readxl)
sbp<-read_xlsx("rex_example.xlsx", sheet = "sbp")

install.packages("dplyr")
library(dplyr)
group1<-sbp%>%filter(Group==1)
group2<-sbp%>%filter(Group==2)

##그룹별 정규성 검정
shapiro.test(group1$SBP)
shapiro.test(group2$SBP)

qqnorm(group1$SBP)
qqline(group1$SBP)
qqnorm(group2$SBP)
qqline(group2$SBP)

##Levene's Test for homogeneity of variance
library(car)
leveneTest(SBP~as.factor(Group),data = sbp, center=mean) #defalut:center=median
-----------------------------------------------------------------------------------------------------------

#13 chweight

##데이터 chweight 불러오기
install.packages("readxl")
library(readxl)
chweight<-read_xlsx("rex_example.xlsx", sheet = "chweight")

##정규성 검정
shapiro.test(chweight$몸무게)

qqnorm(chweight$몸무게)
qqline(chweight$몸무게)

##일표본분산검정
###Chi-square test for Normal distribution can only be use.
install.packages("EnvStats") 
library(EnvStats)
varTest(chweight$몸무게)

###Bonett test for any continuous distribution can be use.
install.packages("moments")
library(moments)
bonett.test(chweight$몸무게)
-----------------------------------------------------------------------------------------------------------

#15 height

##데이터 height 불러오기
install.packages("readxl")
library(readxl)
height<-read_xlsx("rex_example.xlsx", sheet = "height")

##선형회귀분석
lm1<-lm(child~parent, data=height) #모형 적합
summary(lm1)

library(stats)
confint(lm1) #신뢰구간

##Anova Table
anova(lm1)

##Variable Effect with Type III SS
install.packages("car")
library(car)
Anova(lm1,type=3)

##model fitness measurements
deviance(lm1)
-2*logLik(lm1)
AIC(lm1)
BIC(lm1)

##Goodness of Fit Test (Likelihood Ratio Test)
anova(lm1, test="LRT")

install.packages("qpcR")
library(qpcR)
RSS(lm1)

lm0<-lm(child~1,data = height)
RSS(lm0)

##Graphs for Regression Diagnostics
plot(lm1)
-----------------------------------------------------------------------------------------------------------

#16 bwt

##데이터 bwt 불러오기
install.packages("readxl")
library(readxl)
bwt<-read_xlsx("rex_example.xlsx", sheet = "bwt")

##선형회귀분석
lm1<-lm(bwt~age+lwt+as.factor(smoke), data=bwt) #모형 적합
summary(lm1)

library(stats)
confint(lm1) #신뢰구간

install.packages("rms")
library(rms)
vif(lm1) #VIF

lm2<-lm(bwt~as.factor(smoke), data=bwt) #단순회귀
summary(lm2)
lm3<-lm(bwt~age, data=bwt) #단순회귀
summary(lm3)
lm4<-lm(bwt~lwt, data=bwt) #단순회귀
summary(lm4)

##Anova Table
anova(lm1)

##Variable Effect with Type III SS
install.packages("car")
library(car)
Anova(lm1,type=3)

##model fitness measurements
deviance(lm1)
-2*logLik(lm1)
AIC(lm1)
BIC(lm1)

##Goodness of Fit Test (Likelihood Ratio Test)
anova(lm1, test="LRT")

install.packages("qpcR")
library(qpcR)
RSS(lm1)

lm0<-lm(bwt~1,data = bwt)
RSS(lm0)

##Graphs for Regression Diagnostics
plot(lm1)

##선형회귀분석(교호작용 포함)
lm5<-lm(bwt~age+lwt+smoke+smoke:age+smoke:lwt, data=bwt) #모형 적합
summary(lm5)
-----------------------------------------------------------------------------------------------------------

#17 CH

##데이터 bwt 불러오기
install.packages("readxl")
library(readxl)
CH<-read_xlsx("rex_example.xlsx", sheet = "CH")

##correlation analysis
library(stats)
cor.test(CH$총콜레스테롤,CH$관상동맥, method = "spearman", exact=TRUE, continuity=TRUE)

##Analysis of Covariance
cov(CH$총콜레스테롤,CH$관상동맥, method = "spearman")

##scatter matrix
library(dplyr)
select<-dplyr::select
CH<-CH%>%select(총콜레스테롤,관상동맥)

install.packages("corrplot")
library(corrplot)
cor<-cor(CH, method = "spearman")
corrplot(as.matrix(cor))

pairs(~CH$총콜레스테롤+CH$관상동맥, data=CH)
-----------------------------------------------------------------------------------------------------------

#18 ozone

##데이터 bwt 불러오기
install.packages("readxl")
library(readxl)
ozone<-read_xlsx("rex_example.xlsx", sheet = "ozone")

##correlation analysis
library(stats)
cor.test(ozone$Ozone,ozone$Solar.R, method = "pearson")
cor.test(ozone$Ozone,ozone$Temp, method = "pearson")
cor.test(ozone$Solar.R,ozone$Temp, method = "pearson")

##Analysis of Covariance
cov(ozone$Ozone,ozone$Solar.R, method = "pearson")
cov(ozone$Ozone,ozone$Temp, method = "pearson")
cov(ozone$Solar.R,ozone$Temp, method = "pearson")

##scatter matrix
install.packages("corrplot")
library(corrplot)
cor<-cor(ozone, method = "pearson")
corrplot(as.matrix(cor))

pairs(~ozone$Ozone+ozone$Solar.R+ozone$Temp)
-----------------------------------------------------------------------------------------------------------

#19 heart

##데이터 heart불러오기
install.packages("readxl")
library(readxl)
heart<-read_xlsx("rex_example.xlsx", sheet = "heart")  

##correlation analysis
library(stats)
cor.test(heart$심근경색,heart$혈압, method = "spearman", exact=TRUE, continuity=TRUE)

##Analysis of Covariance
cov(heart$심근경색,heart$혈압, method = "spearman")

##partial correlation
install.packages("ppcor")
library(ppcor)
pcor.test(heart$심근경색,heart$혈압,heart$나이, method="spearman") #z is a controlling variable
-----------------------------------------------------------------------------------------------------------

#20 anemia

##데이터 anemia불러오기
install.packages("readxl")
library(readxl)
anemia<-read_xlsx("rex_example.xlsx", sheet = "anemia")  

##correlation analysis
library(stats)
cor.test(anemia$HE_Folate,anemia$HE_HB, method = "pearson")

##Analysis of Covariance
cov(anemia$HE_Folate,anemia$HE_HB, method = "pearson")

##partial correlation
install.packages("ppcor")
library(ppcor)
pcor.test(anemia$HE_Folate,anemia$HE_HB,anemia$age,method="pearson") #z is a controlling variable
-----------------------------------------------------------------------------------------------------------

#21 exercise

##데이터 exercise 불러오기
install.packages("readxl")
library(readxl)
exercise<-read_xlsx("rex_example.xlsx", sheet = "exercise") 
table(exercise)

##contingency table
con<-table(exercise$스트레칭,exercise$부상)
con<-matrix(c(231,219,55,295),2,2)
rownames(con)<-c("스트레칭(0)","스트레칭(1)")
colnames(con)<-c("부상(1)","부상(0)")

con<-as.table(con)
con

##contingency table analysis
library(stats)
chisq.test(con, correct = FALSE) #Without Yates' Continuity Correction
chisq.test(con) #With Yates' Continuity Correction

##Likelihood Ratio Test (G-test) of Independence
install.packages("DescTools")
library(DescTools)
GTest(con, correct = "williams")

##Odds Ratio and Relative Risks
OddsRatio(con, conf.level=0.95)
RelRisk(t(con), conf.level=0.95) #스트레칭(0) RR Col(1)
RelRisk(t(con)[,c(2,1)], conf.level=0.95) #스트레칭(0) RR Col(2)

##mosaicplot
mosaicplot(con)
-----------------------------------------------------------------------------------------------------------

#22 infection

##데이터 infection 불러오기
install.packages("readxl")
library(readxl)
infection<-read_xlsx("rex_example.xlsx", sheet = "infection") 

##contingency table
con<-table(infection)
con

##contingency table analysis
library(stats)
chisq.test(con, correct = FALSE) #Without Yates' Continuity Correction
chisq.test(con) #With Yates' Continuity Correction

##Likelihood Ratio Test (G-test) of Independence
install.packages("DescTools")
library(DescTools)
GTest(con, correct = "williams")

##Odds Ratio and Relative Risks
library(dplyr)
con1<-infection%>%filter(race=="1. White"|race=="4. Other")
con1<-table(con1)

OddsRatio(con1, conf.level=0.95) #race(1. White) OR
RelRisk(con1, conf.level=0.95) #race(1. White) RR Col(1)
RelRisk(con1[,c(2,1)], conf.level=0.95) #race(1. White) RR Col(2)

con2<-infection%>%filter(race=="2. Black"|race=="4. Other")
con2<-table(con2)

OddsRatio(con2, conf.level=0.95) #race(2. Black) OR
RelRisk(con2, conf.level=0.95) #race(2. Black) RR Col(1)
RelRisk(con2[,c(2,1)], conf.level=0.95) #race(2. Black) RR Col(2)


con3<-infection%>%filter(race=="3. Asian"|race=="4. Other")
con3<-table(con3)

OddsRatio(con3, conf.level=0.95) #race(3. Asian) OR
RelRisk(con3, conf.level=0.95) #race(3. Asian) RR Col(1)
RelRisk(con3[,c(2,1)], conf.level=0.95) #race(3. Asian) RR Col(2)
-----------------------------------------------------------------------------------------------------------

#23 smoke

##데이터 smoke 불러오기
install.packages("readxl")
library(readxl)
smoke<-read_xlsx("rex_example.xlsx", sheet = "smoke")

##contingency table
con<-matrix(c(8,3,4,20),2,2)
rownames(con)<-c("sex(1)","sex(2)")
colnames(con)<-c("smoke(1)","smoke(0)")

con<-as.table(con)
con

##contingency table analysis
library(stats)
chisq.test(con, correct = FALSE) #Without Yates' Continuity Correction
chisq.test(con) #With Yates' Continuity Correction
###Warning : Chi-squared approximation may be incorrect

##Likelihood Ratio Test (G-test) of Independence
install.packages("DescTools")
library(DescTools)
GTest(con, correct = "williams")

##Fisher's Exact Test
fisher.test(con, alternative = "two.sided", conf.int = TRUE)
fisher.test(con, alternative = "greater", conf.int = TRUE)
fisher.test(con, alternative = "less", conf.int = TRUE)

##Odds Ratio and Relative Risks
OddsRatio(con, conf.level=0.95)
RelRisk(t(con), conf.level=0.95) #스트레칭(0) RR Col(1)
RelRisk(t(con)[,c(2,1)], conf.level=0.95) #스트레칭(0) RR Col(2)

##mosaicplot
mosaicplot(con)
-----------------------------------------------------------------------------------------------------------

#24

##contingency table
con<-matrix(c(31,27,10,16),2,2)
rownames(con)<-c("투약전 발생","투약전 미발생")
colnames(con)<-c("투약후 발생","투약후 미발생")

con<-as.table(con)
con

##contingency table analysis
###Homogeneity Test : Cohen's Kappa Test
install.packages("vcd")
library(vcd)
Kappa(con)

###Homogeneity Test : McNemar's Chi-squared Test
library(stats)
mcnemar.test(con, correct = FALSE) #Without Continuity Correction
mcnemar.test(con) #With Continuity Correction
-----------------------------------------------------------------------------------------------------------

#25 cardiovascular

##데이터 cardiovascular 불러오기
install.packages("readxl")
library(readxl)
cardio<-read_xlsx("rex_example.xlsx", sheet = "cardiovascular")
cardio

##contingency table
cardio$나이<-as.factor(cardio$나이)
cardio$당뇨병<-as.factor(cardio$당뇨병)
cardio$심혈관질환<-as.factor(cardio$심혈관질환)

con<- xtabs(빈도~당뇨병+심혈관질환+나이, data=cardio) #conditional table
con
margi.con<- xtabs(빈도~당뇨병+심혈관질환, data=cardio) #marginal table
margi.con

##contingency table analysis
###Cochran-Mantel-Haenszel Test
library(stats)
mantelhaen.test(con) #common OR = 9.883375

###Breslow-Day Test
install.packages("DescTools")
library(DescTools)
BreslowDayTest(con)
BreslowDayTest(con,correct = TRUE)

##Mantel-Haenszel Common OR Estimate
library(vcd)
oddsratio(con,log = FALSE)
-----------------------------------------------------------------------------------------------------------

#26 BP

##데이터 BP 불러오기
install.packages("readxl")
library(readxl)
BP<-read_xlsx("rex_example.xlsx", sheet = "BP")

##contingency table
BP$center<-as.factor(BP$center)
BP$treatment<-as.factor(BP$treatment)
BP$BP<-as.factor(BP$BP)

con<- xtabs(total~treatment+BP+center, data=BP) #conditional table
con
margi.con<- xtabs(total~treatment+BP, data=BP) #marginal table
margi.con

##contingency table analysis
###Cochran-Mantel-Haenszel Test
library(stats)
mantelhaen.test(con) #common OR = 0.487569

###Breslow-Day Test
install.packages("DescTools")
library(DescTools)
BreslowDayTest(con)
BreslowDayTest(con,correct = TRUE)

##Mantel-Haenszel Common OR Estimate
library(vcd)
oddsratio(con,log = FALSE)
-----------------------------------------------------------------------------------------------------------

#27 glu

##데이터 glu 불러오기
install.packages("readxl")
library(readxl)
glu<-read_xlsx("rex_example.xlsx", sheet = "glu") 

##Results of One Sample Sign Test
install.packages("BSDA")
library(BSDA)
SIGN.test(glu$glucose, md=80, alternative = "two.sided")

##Results of One Sample Signed Rank Test
library(stats)
wilcox.test(glu$glucose, mu=80, alternative = "two.sided", exact=TRUE)

install.packages("exactRankTests")
-----------------------------------------------------------------------------------------------------------

#28 BMI

##데이터 BMI 불러오기
install.packages("readxl")
library(readxl)
bmi<-read_xlsx("rex_example.xlsx", sheet = "BMI") 

##Results of One Sample Sign Test
install.packages("BSDA")
library(BSDA)
SIGN.test(bmi$BMI, md=24, alternative = "two.sided")
-----------------------------------------------------------------------------------------------------------

#29 bacteroides

##데이터 bacteroides 불러오기
install.packages("readxl")
library(readxl)
bacte<-read_xlsx("rex_example.xlsx", sheet = "bacteroides")

##Results of Two Sample Wilcoxon Rank-Sum Test
library(stats)
wilcox.test(bacte$Bacteroides~bacte$Group, exact=TRUE)

install.packages("exactRankTests")
library(exactRankTests)
wilcox.exact(bacte$Bacteroides~bacte$Group)


library(exactRankTests)
wilcox.exact(glu$glucose, mu=80, alternative = "two.sided")
-----------------------------------------------------------------------------------------------------------

#30 Rhino

##데이터 Rhino 불러오기
install.packages("readxl")
library(readxl)
rhino<-read_xlsx("rex_example.xlsx", sheet = "Rhino")
rhino$Rhino<-as.numeric(rhino$Rhino)

##Results of Two Sample Wilcoxon Rank-Sum Test
library(stats)
wilcox.test(rhino$Rhino~rhino$Group,exact=TRUE)
wilcox.exact(rhino$Rhino~rhino$Group)
-----------------------------------------------------------------------------------------------------------

#31 chol

##데이터 chol 불러오기
install.packages("readxl")
library(readxl)
chol<-read_xlsx("rex_example.xlsx", sheet = "chol")

##Results of Two Sample Wilcoxon Rank-Sum Test
library(stats)
wilcox.test(chol$Chol~chol$Group,exact=TRUE)

install.packages("exactRankTests")
library(exactRankTests)
wilcox.exact(chol$Chol~chol$Group)
-----------------------------------------------------------------------------------------------------------

#33 hyperlipi

##데이터 hyperlipi 불러오기
install.packages("readxl")
library(readxl)
hyperlipi<-read_xlsx("rex_example.xlsx", sheet = "hyperlipi")

##correlation
cor(hyperlipi$before, hyperlipi$after)

##Results of Paired Sample Sign Test
library(stats)
SIGN.test(hyperlipi$before, hyperlipi$after, alternative = "greater", paired = TRUE)

##Results of Paired Sample Signed Rank Test
wilcox.test(hyperlipi$before, hyperlipi$after, alternative = "greater", paired = TRUE)
wilcox.exact(hyperlipi$before, hyperlipi$after, alternative = "greater", paired = TRUE)
-----------------------------------------------------------------------------------------------------------

#35 NH3

##데이터 NH3 불러오기
install.packages("readxl")
library(readxl)
NH3<-read_xlsx("rex_example.xlsx", sheet = "NH3")

##Results of K Sample Kruskal-Wallis Test
library(stats)
kruskal.test(암모니아~그룹,NH3)

##Pairwise Test for Multiple Comparisons of Mean Rank Sums (Dunn’sTest) '그룹'
install.packages("PMCMRplus")
library(PMCMRplus)
kwAllPairsDunnTest(암모니아~그룹, NH3, p.adjust.method= "bonferroni")
-----------------------------------------------------------------------------------------------------------

#36 depression

##데이터 depression 불러오기
install.packages("readxl")
library(readxl)
depress<-read_xlsx("rex_example.xlsx", sheet = "depression")

##Results of K Sample Jonckheere Test
install.packages("PMCMRplus")
library(PMCMRplus)
jonckheereTest(우울점수~그룹, data=depress, alternative = "less", continuity=FALSE)

str(depress)
depress$그룹<-as.ordered(depress$그룹)

install.packages("DescTools")
library(DescTools)
JonckheereTerpstraTest(depress$우울점수,depress$그룹, alternative = "decreasing")
-----------------------------------------------------------------------------------------------------------

#37 selfesteem

##데이터 selfesteem 불러오기
install.packages("readxl")
library(readxl)
self<-read_xlsx("rex_example.xlsx", sheet = "selfesteem")  

a<-rep(1,10)
b<-rep(2,10)
c<-rep(3,10)
group<-cbind(c(a,b,c))
id<-rep(1:10,3)

self<-cbind(c(self$t1,self$t2,self$t3))
self<-cbind(id,self,group)
View(self)

colnames(self)<-c("id","selfesteem","group")
self<-as.data.frame(self)

##Results of K-paired Sample Friedman Test
library(stats)
friedman.test(self$selfesteem, self$group, self$id)

##Comparison of multiple joint samples by conover.test
install.packages("PMCMR")
library(PMCMR)
posthoc.friedman.conover.test(selfesteem, group, id, data=self)

install.packages("PMCMRplus")
library(PMCMRplus)
ad<-frdAllPairsConoverTest(y=self$selfesteem, groups=self$group, blocks=self$id, p.adjust="bonferroni")
summary(ad)
-----------------------------------------------------------------------------------------------------------

#38 happiness

##데이터 happiness 불러오기
install.packages("readxl")
library(readxl)
happy<-read_xlsx("rex_example.xlsx", sheet = "happiness")  

a<-rep("before",10)
b<-rep("after1",10)
c<-rep("after2",10)
group<-cbind(c(a,b,c))
id<-rep(1:10,3)

happy<-cbind(c(happy$before,happy$after1,happy$after2))
happy<-cbind(id,happy,group)
View(happy)

colnames(happy)<-c("id","happiness","time")
happy<-as.data.frame(happy) 

##Results of K-paired Sample Friedman Test
library(stats)
friedman.test(happy$happiness, happy$time, happy$id )

##Comparison of multiple joint samples by conover.test
install.packages("PMCMR")
library(PMCMR)
posthoc.friedman.conover.test(happiness, time, id, data=happy)

install.packages("PMCMRplus")
library(PMCMRplus)
ad<-frdAllPairsConoverTest(y=happy$happiness, groups=happy$time, blocks=happy$id, p.adjust="bonferroni")
summary(ad)




