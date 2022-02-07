#복합표본설계_국민건강영양조사

install.packages("haven", dependencies = TRUE)

library(haven)
?read_spss
?read_sas

DB <- read_spss("HN18_ALL.sav")
DB22 <- read_spss("제목없음2.sav")

head(DB)
View(DB)

install.packages("writexl")
library(writexl)
write_xlsx(DB,path = "DB_18.xlsx")

sextable<-table(DB$sex)
names(sextable)<-c("man", "women")
lbls<-paste(names(sextable),":",sextable)
pie(sextable,labels = lbls)
hist(DB$age,xlab = "age")

#흡연량과 폐기능검사
red<-DB%>%select(BS3_2,HE_fev1fvc,sex,age,HE_BMI,HE_COPD)
head(red)
dim(red)
red2<-red["BS3_2" != 999 && "BS3_2" != 888 && is.na("HE_fev1fvc")!=T,]
dim(red2)

cor.test(red2$BS3_2,red2$HE_fev1fvc,method = "pearson") #correlation test

temp_red2<-red2[,Bin_group:=cut(-lnf,5,10,15,20,25,30,lnf),paste0(1:7)]
boxplot(temp_red2$HE_fev1fvc~temp_red2$Bin_group)  #cancel

#NA값 포함시 계산진행 안됨 
mean(DB$HE_sbp)
dim(DB)
na.omit(DB)
DB2<-data.frame(c(2:80,10),c(1:10))
names(DB2)<-c("id","rate")
head(DB2)
mean(DB2$id2)
DB2$id2<-ifelse(DB2$id==2,NA,DB2$id)

#기술통계량1-성별에 따른 수축기 혈압 평균 
hist(DB$HE_sbp)
DB%>%ggplot(aes(HE_sbp))+geom_histogram()+facet_wrap(~factor(sex))
DB%>%ggplot(aes(group=sex,y=HE_sbp))+geom_boxplot()
DB%>%
  group_by(sex)%>%
  summarize(mean = mean(HE_sbp,na.rm = T))
var.test(HE_sbp~sex, data=DB)

#복합표본설계
install.packages("survey")
library(survey)            

table(is.na(DB$wt_itvex))
DB<-subset(DB,!is.na(wt_itvex))

#복합표본설계
DB_18<-svydesign(id=~psu, strata=~kstrata, weights=~wt_itvex, data=DB)
#복원추출-가중치 적용
DB_181<-as.svrepdesign(DB_18, type="BRR") #error

#two sample ttest
#svymean by each groups
svyby(~HE_sbp,~sex,DB_18,svymean,na.rm = T)
#svyttest
svyttest(HE_sbp~sex,DB_18)
#svyhist svyboxplot
SBP1<-subset(DB_18,sex==1)
SBP2<-subset(DB_18,sex==2)
g1<-svyhist(~HE_sbp,SBP1,main="SBP in case of male")
g2<-svyhist(~HE_sbp,SBP2,main="SBP in case of female") #남자여자 어떻게 한꺼번에 출력?

svyboxplot(HE_sbp~sex,DB_18)
g11<-svyboxplot(HE_sbp~sex,SBP1,main="SBP in case of male")
g22<-svyboxplot(HE_sbp~sex,SBP2,main="SBP in case of female")

#svyttest-고혈압유병여부에 따른 bmi
#HE_HP:고혈압유병여부, 1~3
DB$HP<-ifelse(DB$HE_HP==1|DB$HE_HP==2,0,1)
table(DB$HP)
table(DB$HE_HP)
DB_18<-svydesign(id=~psu, strata=~kstrata, weights=~wt_itvex, data = DB)
svyby(~HE_BMI,~HP,DB_18,svymean,na.rm=T)
svyttest(HE_BMI~HP,DB_18)

#one sample ttest
svymean(~HE_sbp,DB_18,na.rm = T)
svyttest(HE_sbp~0,mu=120,DB_18,na.rm=T) #mu설정 안됨

#paired sample ttest
#연령그룹에 따른 수축기혈압 평균비교
DB$age_g<- ifelse(DB$age>=70,7,
                  ifelse(DB$age>=60,6,
                         ifelse(DB$age>=50,5,
                                ifelse(DB$age>=40,4,
                                       ifelse(DB$age>=30,3,0)))))

DB_18<-svydesign(id=~psu, strata=~kstrata, weights=~wt_itvex, data=DB)
svyby(~HE_sbp,~age_g,DB_18,svymean,na.rm=T)

#model fitting : svyglm
summary(svyglm(HE_sbp~age_g,DB_18))
g1<-svyglm(HE_sbp~age_g,DB_18)
g1

#model fitness and ANOVA table : regTermTest
regTermTest(g1, ~age_g)
anova(g1) #NULL:요인한개일때 null
AIC(g1)
deviance(g1)

install.packages("nnet")
library(nnet)
g0<-multinom(age_g~HE_sbp,data=DB)
summary(g0)

#Post-hoc Analysis : svyttest
svyttest(HE_sbp~age_g,DB_18) #error : group must be binary
anova()
pairwise.table()
attach(DB_18)
pairwise.t.test(HE_sbp)

#linear regression : 연령대와 BMI에 따른 수축기 혈압
g2<-svyglm(HE_sbp~HE_BMI+factor(age_g),DB_18) #다중회귀분석
summary(g2)
anova(g2)
aov(g2)

regTermTest(g2,~HE_BMI+factor(age_g))
