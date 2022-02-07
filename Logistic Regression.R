getwd()

install.packages("haven")
library(haven)

#이분형 로지스틱 회귀분석
#관상동맥
View(exam)
head(exam)
exam<-read_spss("관상동맥의 심장병 자료(chd).sav")
g1<-glm(CHD~AGE,family = binomial,data=exam)
summary(g1)
confint(g1)

#출생아
exam2<-read_spss("저체중아 자료(lowbwtm).sav")
exam2$LWD<-ifelse(exam2$LWT<110,1,0)

install.packages("writexl")
library(writexl)
getwd()
write_xlsx(exam2,path="저체중아 자료.xlsx")

#binary data
setwd("D:/mirae/logistic")
exam3<-read_spss("브라운의 전립선암 자료(binary).sav")
g3<-glm(NODES~XRAY+STAGE+GRADE+AGE+ACID, family = binomial(), data=exam3)
deviance(g3)
head(exam3)
summary(g3)

install.packages("ResourceSelection")
library(ResourceSelection)
hoslem.test(g3$y,g3$fit)

anova(g3)

install.packages("car")
library(car)
Anova(g3, type = "III")

BIC(g3)
AIC(g3)
deviance(g3)

step_g33<-step(g3,scope=list(lower=~1, uppper= ~XRAY+STAGE+GRADE+AGE+ACID),direction = "forward" )
summary(step_g33)

step_g33<-step(g3,direction = "forward" )
summary(step_g33)

step_g3<-step(g3,direction = "both")
summary(step_g3)

step_g333<-step(g3,direction = "backward")
summary(step_g3)
Anova(step_g333, type = "III")


#ME data
exam4<-read_spss("유방 뢴트겐선 조영검사 자료(meexp).sav")
head(exam4)
exam4$ME<-relevel(exam4$ME,ref="0") #error

install.packages("VGAM")
library(VGAM)
vglm1<-vglm(ME~HIST,family = multinomial(refLevel = 1) ,data=exam4) #refLevel 지정시 범주의 순서(양의 정수)를 입력해야함. 
summary(vglm1)
coefficients(vglm1)
AIC(vglm1)
AICc(vglm1)
BIC(vglm1)
deviance(vglm1)
chisq.test(exam4$HIST,exam4$ME,correct = T) #뭐징

#Estimates-intercept
setwd("D:/mirae/logistic")
library(readxl)
exam5<-read_xlsx("medata.xlsx")
head(exam5)
vglm2<-vglm(me~factor(detc)+pb+hist+bse+symptd, family= multinomial(refLevel = 1),data=exam5 )
summary(vglm2)
summary(step4vglm(vglm2,direction = "forward"))
Anova(vglm2,type = "III")

getwd()

#reserch 1
exam6<-read_spss("사례연구1.sav")
head(exam6)
glm(RESTINGP~SMOKES+WEIGHT,family = "binomial",data=exam6)

#다항자료 회귀분석 (종속변수-순서형)
##ordinal logistic regression
getwd()

library(haven)
exam7<-read_spss("사례연구4.sav")

##vglm이용
library(VGAM)
head(exam7)
exam7$SURVIVAL<-factor(exam7$SURVIVAL,ordered = TRUE)
str(exam7$SURVIVAL)

vglm3<-vglm(SURVIVAL~REGION+TOXICLEV, family= cumulative(link = "logitlink"), data=exam7)
summary(vglm3)

table(exam7$SURVIVAL)
coef(vglm3)
AIC(vglm3)

##polr이용
install.packages("MASS")
library(MASS)
head(exam7)
polr1<-polr(as.factor(SURVIVAL)~REGION+TOXICLEV, data=exam7, method = "logistic")
str(exam7$SURVIVAL)
summary(polr1) #polr랑 vglm 값이 왜 다를까아아아........... fit이 다름??


#Hosmer-Lemeshow test
getwd()
exam8<-read_spss("관상동맥의 심장병 자료(chd).sav")
glm<-glm(CHD~AGE,family = binomial ,data = exam8)
?glm

library(ResourceSelection)
hoslem.test(glm$y,glm$fit)

install.packages("AICcmodavg")
library(AICcmodavg)
data(mtcars)

glm_a1 <- glm(mpg ~ cyl + disp + hp + drat + wt + qsec + vs + am + gear + carb,
              data = mtcars,
              family = gaussian(link = "identity"),
              trace = TRUE)
deviance(glm_a1)
#> Deviance = 147.4944 Iterations - 1
#> Deviance = 147.4944 Iterations - 2

(loglik <- logLik(glm_a1))
#> 'log Lik.' -69.85491 (df=12)

# thus the degrees of freedom r uses are 12 instead of 11

n   <- attributes(loglik)$nobs # following user20650 recommendation 
p   <- attributes(loglik)$df # following user20650 recommendation
dev <- -2*as.numeric(loglik)
my_AIC  <- dev + 2 * p
my_AICc <- my_AIC + (2 * p^2 + 2 * p)/(n - p - 1)
my_BIC  <- dev +  p * log(n)

n
p
dev
AIC(glm_a1)
my_AIC


#variable selection - forward
exam3<-read_spss("브라운의 전립선암 자료(binary).sav")
head(exam3)
setwd("D:/mirae/logistic")

nothing<-glm(NODES~1, family=binomial(), data=exam3)
step(nothing, scope=list(lower=~1, upper=~XRAY+STAGE+GRADE+AGE+ACID), direction = "forward")

#다항자료 회귀분석 (종속변수-순서형)
##ordinal logistic regression
getwd()

library(haven)
exam7<-read_spss("사례연구4.sav")

##vglm이용
library(VGAM)
head(exam7)
vglm3<-vglm(SURVIVAL~REGION+TOXICLEV, family= multinomial(refLevel = 1), data=exam7)
summary(vglm3)

getwd()

#ordered multinomial logistic regression 
library(readxl)
exam9<-read_excel("회귀분석_다항자료회귀분석(Disc).xlsx")
head(exam9)
exam9$Disc<-factor(exam9$Disc,ordered = TRUE)

str(exam9$Disc)
vglm4<-vglm(Disc~Sex+AGE+BMI, family = cumulative(link = "logitlink"), data = exam9)

#NA 확인
View(apply(exam9,1,is.na))
#NAN 확인
View(apply(exam9,1,is.nan)) 
#inf 확인
View(apply(exam9,1,is.infinite))

#row 0 제거
exam9_row=apply(exam9,1,mean)
exam9<-exam9[exam9_row!=0,]
#column 0 제거
exam9_column=apply(exam9,1,mean)
exam9<-exam9[exam9_column!=0,]

#retry
vglm4<-vglm(Disc~Sex+AGE+BMI, family = cumulative(link = "logitlink"), data = exam9) #왜 에러가 나지

levels(exam9$Disc)
