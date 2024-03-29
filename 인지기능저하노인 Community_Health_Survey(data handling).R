#지역건강사회조사 데이터 불러오기
install.packages("haven")
library(haven)
data1<-read_sas("chs19_all.sas7bdat")

#엑셀파일로 저장하기
install.packages("writexl")
library(writexl)
write_xlsx(data1, path="community.xlsx")

---------------------------------------------------------------------------------------------------------------
#변수추리기
install.packages("dplyr")
library(dplyr)
data<-data1%>%select("kstrata","spot_no","wt_p","ctprvn_code","mtj_05z2","mtj_08z2",
                      "sex","age","fma_14z1","fma_24z2","sod_02z2","sob_01z1","fma_01z1",
                      "ena_01a1","enb_01z1","enb_02z1","enb_03z1",
                      "ena_01b1","ena_01c1","ena_01d1","ena_01e1","ena_01f1",
                      "enb_04z1","enb_05z1","enb_06z1","enb_07z1","ena_01g1","fma_04z1")

---------------------------------------------------------------------------------------------------------------
##응답자의 일반적 특성 (통제변수)
###1. age 연령

data<-data%>%filter(age>=65)
data$age_g<-ifelse(data$age<70, "65-70세 미만",
                   ifelse(data$age<75, "70세-75세 미만",
                          ifelse(data$age<80, "75세-80세미만", "80세 이상")))

###2. fma_24z2 월평균 가구 소득 그대로 사용

###3. sod_02z2 배우자 유무
data$sod_02z2_g<-ifelse(data$sod_02z2==1, "유", "무")

###4. sob_01z1 교육수준
table(data$sob_01z1)
data$sob_01z1_g<-ifelse(data$sob_01z1==1, "무학",
                        ifelse(data$sob_01z1==2, "서당/한학",
                               ifelse(data$sob_01z1==3, "초졸 중퇴/졸업",
                                      ifelse(data$sob_01z1==4, "중졸 중퇴/졸업",
                                             ifelse(data$sob_01z1==5, "고졸 중퇴/졸업",
                                                    ifelse(data$sob_01z1==6|data$sob_01z1==7|data$sob_01z1==8, "(전문)대학원 중퇴/졸업 이상", data$sob_01z1))))))

###5. fma_01z1 가구형태
data$fma_01z1_g<-ifelse(data$fma_01z1>1, "비독거가구", "독거가구")

---------------------------------------------------------------------------------------------------------------
##응답자 주요 변수 특성 (개인요인)
###1. 개인요인_사회자원_신뢰

#함수로 코드 바꾸기(방법1)
func<-function(x){
  ifelse(x==1, 1, ifelse(x==2, 0, x))
}

data$신뢰<-func(data$ena_01a1)

#ifelse로 코드 바꾸기(방법2)
data$신뢰<-ifelse(data$ena_01a1==1,1,
                ifelse(data$ena_01a1==2,0,data$ena_01a1))

###2. 개인요인_사회자원_네트워크
data$enb_01z1<-ifelse(data$enb_01z1==7 | data$enb_01z1==9, 0, data$enb_01z1)
data$enb_02z1<-ifelse(data$enb_02z1==7 | data$enb_02z1==9, 0, data$enb_02z1)
data$enb_03z1<-ifelse(data$enb_03z1==7 | data$enb_03z1==9, 0, data$enb_03z1)


data$네트워크<-(enb_01z1+enb_02z1+enb_03z1)/3

###3. 개인요인_사회자원_사회응집력
func2<-function(x){
  ifelse(x==1, 1, 0)
}

data$ena_01b1<-func2(data$ena_01b1)
data$ena_01c1<-func2(data$ena_01c1)
data$ena_01d1<-func2(data$ena_01d1)
data$ena_01e1<-func2(data$ena_01e1)
data$ena_01f1<-func2(data$ena_01f1)

data$사회응집력<-(data$ena_01b1+data$ena_01c1+data$ena_01d1+data$ena_01e1+data$ena_01f1)/5

###4. 개인요인_사회자원_시민참여
data$enb_04z1<-func2(data$enb_04z1)
data$enb_05z1<-func2(data$enb_05z1)
data$enb_06z1<-func2(data$enb_06z1)
data$enb_07z1<-func2(data$enb_07z1)

func3<-function(x,...){
  ifelse(x<=1 & y<=1, (x+y)/n, 99 ) #가변변수있을경우
}

func3(data$enb_04z1,data$enb_05z1,data$enb_06z1,data$enb_07z1)

data$시민참여<-(data$enb_04z1+data$enb_05z1+data$enb_06z1+data$enb_07z1)/4

###5. 개인요인_사회자원_사회적지원
data$사회적지원<-func(data$ena_01g1)

---------------------------------------------------------------------------------------------------------------
##응답자 주요 변수 특성 (지역요인)
###ctprvn_code 시도번호 부여
table(data$ctprvn_code)
data$지역<-ifelse(data$ctprvn_code==11, "서울",
                ifelse(data$ctprvn_code==26, "부산",
                       ifelse(data$ctprvn_code==27, "대구",
                              ifelse(data$ctprvn_code==28, "인천",
                                     ifelse(data$ctprvn_code==29, "광주",
                                            ifelse(data$ctprvn_code==30, "대전",
                                                   ifelse(data$ctprvn_code==31, "울산",
                                                          ifelse(data$ctprvn_code==36, "세종",
                                                                 ifelse(data$ctprvn_code==41, "경기",
                                                                        ifelse(data$ctprvn_code==42, "강원",
                                                                               ifelse(data$ctprvn_code==43, "충북",
                                                                                      ifelse(data$ctprvn_code==44, "충남",
                                                                                             ifelse(data$ctprvn_code==45, "전북",
                                                                                                    ifelse(data$ctprvn_code==46, "전남",
                                                                                                           ifelse(data$ctprvn_code==47, "경북",
                                                                                                                  ifelse(data$ctprvn_code==48, "경남",
                                                                                                                         ifelse(data$ctprvn_code==50,"제주",data$ctprvn_code)))))))))))))))))

###지역요인_지역사회 빈곤율
data_인구<-data%>%group_by(지역)%>%summarise(인구수=n())
a<-data%>%filter(ctprvn_code==11 & fma_04z1==1)%>%select(ctprvn_code)%>%summarise(n())
a<-as.numeric(a)
a

func_지역사회빈곤율<-function(x){
  a<-data%>%filter(ctprvn_code==x & fma_04z1==1)%>%select(ctprvn_code)%>%summarise(n())
  a<-as.numeric(a)
  n<-data%>%filter(ctprvn_code==x)%>%select(ctprvn_code)%>%summarise(n())
  n<-as.numeric(n)
  return((a/n)*100)
}

attach(data)
data$지역사회빈곤율<-ifelse(ctprvn_code==11,func_지역사회빈곤율(11),
                     ifelse(ctprvn_code==26,func_지역사회빈곤율(26),
                            ifelse(ctprvn_code==27,func_지역사회빈곤율(27),
                                   ifelse(ctprvn_code==28,func_지역사회빈곤율(28),
                                          ifelse(ctprvn_code==29,func_지역사회빈곤율(29),
                                                 ifelse(ctprvn_code==30,func_지역사회빈곤율(30),
                                                        ifelse(ctprvn_code==31,func_지역사회빈곤율(31),
                                                               ifelse(ctprvn_code==36,func_지역사회빈곤율(36),
                                                                      ifelse(ctprvn_code==41,func_지역사회빈곤율(41),
                                                                             ifelse(ctprvn_code==42,func_지역사회빈곤율(42),
                                                                                    ifelse(ctprvn_code==43,func_지역사회빈곤율(43),
                                                                                           ifelse(ctprvn_code==44,func_지역사회빈곤율(44),
                                                                                                  ifelse(ctprvn_code==45,func_지역사회빈곤율(45),
                                                                                                         ifelse(ctprvn_code==46,func_지역사회빈곤율(46),
                                                                                                                ifelse(ctprvn_code==47,func_지역사회빈곤율(47),
                                                                                                                       ifelse(ctprvn_code==48,func_지역사회빈곤율(48),
                                                                                                                              ifelse(ctprvn_code==50,func_지역사회빈곤율(50),99)))))))))))))))))
table(data$지역사회빈곤율)


###지역요인_사회복지예산비중
#국가통계포털 e-지방지표 2019년 사용
data$사회복지예산비중<-ifelse(ctprvn_code==11,42.5,
                      ifelse(ctprvn_code==26,47.9,
                             ifelse(ctprvn_code==27,46.2,
                                    ifelse(ctprvn_code==28,43.8,
                                           ifelse(ctprvn_code==29,47.2,
                                                  ifelse(ctprvn_code==30,46.8,
                                                         ifelse(ctprvn_code==31,37.9,
                                                                ifelse(ctprvn_code==36,30.3,
                                                                       ifelse(ctprvn_code==41,37.2,
                                                                              ifelse(ctprvn_code==42,27.4,
                                                                                     ifelse(ctprvn_code==43,30.8,
                                                                                            ifelse(ctprvn_code==44,28.9,
                                                                                                   ifelse(ctprvn_code==45,30.3,
                                                                                                          ifelse(ctprvn_code==46,25.8,
                                                                                                                 ifelse(ctprvn_code==47,27.1,
                                                                                                                        ifelse(ctprvn_code==48,31.9,
                                                                                                                               ifelse(ctprvn_code==50,23.5,99)))))))))))))))))

View(data)

###지역요인_복지자원_주거시설
#e-나라지표 노인복지시설 현황 2019년 이용
data$주거시설<-ifelse(ctprvn_code==11,26/1410.297,
                  ifelse(ctprvn_code==26,7/589.961,
                         ifelse(ctprvn_code==27,6/362.934,
                                ifelse(ctprvn_code==28,22/362.675,
                                       ifelse(ctprvn_code==29,3/187.186,
                                              ifelse(ctprvn_code==30,8/188.530,
                                                     ifelse(ctprvn_code==31,2/123.910,
                                                            ifelse(ctprvn_code==36,4/29.178,
                                                                   ifelse(ctprvn_code==41,121/1551.801,
                                                                          ifelse(ctprvn_code==42,32/289.386,
                                                                                 ifelse(ctprvn_code==43,37/261.763,
                                                                                        ifelse(ctprvn_code==44,21/372.515,
                                                                                               ifelse(ctprvn_code==45,21/358.410,
                                                                                                      ifelse(ctprvn_code==46,26/413.132,
                                                                                                             ifelse(ctprvn_code==47,35/529.349,
                                                                                                                    ifelse(ctprvn_code==48,17/523.165,
                                                                                                                           ifelse(ctprvn_code==50,2/96.207,99)))))))))))))))))

###지역요인_복지자원_여가시설
#e-나라지표 노인복지시설 현황 2019년 이용
data$여가시설<-ifelse(ctprvn_code==11,3885/1410.297,
                  ifelse(ctprvn_code==26,2509/589.961,
                         ifelse(ctprvn_code==27,1562/362.934,
                                ifelse(ctprvn_code==28,1540/362.675,
                                       ifelse(ctprvn_code==29,1364/187.186,
                                              ifelse(ctprvn_code==30,837/188.530,
                                                     ifelse(ctprvn_code==31,841/123.910,
                                                            ifelse(ctprvn_code==36,486/29.178,
                                                                   ifelse(ctprvn_code==41,9834/1551.801,
                                                                          ifelse(ctprvn_code==42,3226/289.386,
                                                                                 ifelse(ctprvn_code==43,4154/261.763,
                                                                                        ifelse(ctprvn_code==44,5816/372.515,
                                                                                               ifelse(ctprvn_code==45,6795/358.410,
                                                                                                      ifelse(ctprvn_code==46,9092/413.132,
                                                                                                             ifelse(ctprvn_code==47,8131/529.349,
                                                                                                                    ifelse(ctprvn_code==48,7483/523.165,
                                                                                                                           ifelse(ctprvn_code==50,458/96.207,99)))))))))))))))))

###지역요인_복지자원_재가시설
#e-나라지표 노인복지시설 현황 2019년 이용
data$재가시설<-ifelse(ctprvn_code==11,586/1410.297,
                  ifelse(ctprvn_code==26,201/589.961,
                         ifelse(ctprvn_code==27,138/362.934,
                                ifelse(ctprvn_code==28,145/362.675,
                                       ifelse(ctprvn_code==29,232/187.186,
                                              ifelse(ctprvn_code==30,132/188.530,
                                                     ifelse(ctprvn_code==31,40/123.910,
                                                            ifelse(ctprvn_code==36,9/29.178,
                                                                   ifelse(ctprvn_code==41,610/1551.801,
                                                                          ifelse(ctprvn_code==42,217/289.386,
                                                                                 ifelse(ctprvn_code==43,86/261.763,
                                                                                        ifelse(ctprvn_code==44,133/372.515,
                                                                                               ifelse(ctprvn_code==45,232/358.410,
                                                                                                      ifelse(ctprvn_code==46,267/413.132,
                                                                                                             ifelse(ctprvn_code==47,193/529.349,
                                                                                                                    ifelse(ctprvn_code==48,226/523.165,
                                                                                                                           ifelse(ctprvn_code==50,47/96.207,99)))))))))))))))))

###지역요인_복지자원_의료시설
#e-나라지표 노인복지시설 현황 2019년 이용
data$의료시설<-ifelse(ctprvn_code==11,512/1410.297,
                  ifelse(ctprvn_code==26,109/589.961,
                         ifelse(ctprvn_code==27,244/362.934,
                                ifelse(ctprvn_code==28,368/362.675,
                                       ifelse(ctprvn_code==29,96/187.186,
                                              ifelse(ctprvn_code==30,123/188.530,
                                                     ifelse(ctprvn_code==31,47/123.910,
                                                            ifelse(ctprvn_code==36,11/29.178,
                                                                   ifelse(ctprvn_code==41,1681/1551.801,
                                                                          ifelse(ctprvn_code==42,311/289.386,
                                                                                 ifelse(ctprvn_code==43,283/261.763,
                                                                                        ifelse(ctprvn_code==44,296/372.515,
                                                                                               ifelse(ctprvn_code==45,224/358.410,
                                                                                                      ifelse(ctprvn_code==46,299/413.132,
                                                                                                             ifelse(ctprvn_code==47,386/529.349,
                                                                                                                    ifelse(ctprvn_code==48,232/523.165,
                                                                                                                           ifelse(ctprvn_code==50,65/96.207,99)))))))))))))))))


View(data)
---------------------------------------------------------------------------------------------------------------
#인지기능 저하 노인 추출
data<-data%>%filter(mtj_05z2==1)

---------------------------------------------------------------------------------------------------------------
#도움 수혜 정도
data$result<-ifelse(data$mtj_08z2==1|data$mtj_08z2==2|data$mtj_08z2==3,1,0)

---------------------------------------------------------------------------------------------------------------
#복합표본설계

install.packages("survey")
library(survey)
svy<-svydesign(id=spot_no, strats=kstrata, weights = wt_p, data = data)
summary(svy)

install.packages("descr")
library(descr)

sex_freq<-freq(svy$variables$sex)
sex_freq #성별빈도

age_g_freq<-freq(svy$variables$age_g)
age_g_freq #연령대 빈도

age_mean<-svymean(age,svy)
age_mean #평균 연령

#결측치를 서브셋으로 뺐을때 월소득 빈도
svy$variables$subset_income<-ifelse(svy$variables$fma_24z2<=8,1,0)
df<-subset(svy,subset_income==1)
subset_income_freq<-freq(df$variables$fma_24z2)
subset_income_freq
#결측치를 포함시켰을때 월소득 빈도
income_freq<-freq(svy$variables$fma_24z2)
income_freq

partner_freq<-freq(svy$variables$sod_02z2_g)
partner_freq #배우자 유무 빈도

#결측치를 서브셋으로 뺐을때 교육수준 빈도
svy$variables$subset_edu<-ifelse(svy$variables$sob_01z1_g==77|svy$variables$sob_01z1_g==99,0,1)
df2<-subset(svy,subset_edu==1)
subset_edu_freq<-freq(df2$variables$sob_01z1_g)
subset_edu_freq
#결측치를 포함시켰을때 교육수준 빈도
edu_freq<-freq(svy$variables$sob_01z1_g)
edu_freq

fam_freq<-freq(svy$variables$fma_01z1_g)
fam_freq #가구형태 빈도

fam_mean<-svymean(fma_01z1,svy)
fam_mean #평균 가구원 수

