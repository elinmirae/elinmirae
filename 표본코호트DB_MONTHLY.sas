LIBNAME T220 "D:\표본코호트DB\06.T220"; RUN;

LIBNAME jk "D:\표본코호트DB\01.jk"; RUN;

LIBNAME gj "D:\표본코호트DB\12.gj"; RUN;

LIBNAME T120 "D:\표본코호트DB\02.T120"; RUN;

=========================================================================================================================================================================

/*2. 진료DB*/
/*T20*/
/*요양개시일자에서 월 뽑아내서 숫자형으로 전환*/
%MACRO TEST2_T20_1(YEAR);
%DO I=&YEAR %TO 2013;
DATA T120.NHID_GY20_T1_&I.__2;
SET T120.NHID_GY20_T1_&I;
RECU_FR_DT_M = SUBSTR(RECU_FR_DT,5,2);
RECU_FR_DT_M_1=1*RECU_FR_DT_M;
OUTPUT;
RUN;
QUIT;
%END;
%MEND;

%TEST2_T20_1(2002); /*2002-2013년 모두 적용*/


/*월별로 자르기*/
%MACRO TEST2_T20_2(YEAR,MONTH);
%DO P=&YEAR %TO 2013;
%DO I=&MONTH %TO 12;
PROC SQL;
CREATE TABLE NHID_GY20_T1_&P._&I AS
SELECT *
FROM T120.NHID_GY20_T1_&P.__2
WHERE RECU_FR_DT_M_1=&I;
;
QUIT;
%END;
%END;
%MEND;

%TEST2_T20_2(2002,1); /*2002-2013년 월별로 모두 자르기*/

/*T30*/
/*요양개시일자에서 월 뽑아내서 숫자형으로 전환*/
%MACRO TEST2_T30_1(YEAR);
%DO I=&YEAR %TO 2013;
DATA T120.NHID_GY30_T1_&I.__2;
SET T120.NHID_GY30_T1_&I;
RECU_FR_DT_M = SUBSTR(RECU_FR_DT,5,2);
RECU_FR_DT_M_1=1*RECU_FR_DT_M;
OUTPUT;
RUN;
QUIT;
%END;
%MEND;

%TEST2_T30_1(2002); /*2002-2013년 모두 적용*/


/*월별로 자르기*/
%MACRO TEST2_T30_2(YEAR,MONTH);
%DO P=&YEAR %TO 2013;
%DO I=&MONTH %TO 12;
PROC SQL;
CREATE TABLE NHID_GY30_T1_&P._&I AS
SELECT *
FROM T120.NHID_GY30_T1_&P.__2
WHERE RECU_FR_DT_M_1=&I;
;
QUIT;
%END;
%END;
%MEND;

%TEST2_T30_2(2002,1); /*2002-2013년 월별로 모두 자르기*/

/*T40*/
/*요양개시일자에서 월 뽑아내서 숫자형으로 전환*/
%MACRO TEST2_T40_1(YEAR);
%DO I=&YEAR %TO 2013;
DATA T120.NHID_GY40_T1_&I.__2;
SET T120.NHID_GY40_T1_&I;
RECU_FR_DT_M = SUBSTR(RECU_FR_DT,5,2);
RECU_FR_DT_M_1=1*RECU_FR_DT_M;
OUTPUT;
RUN;
QUIT;
%END;
%MEND;

%TEST2_T40_1(2002); /*2002-2013년 모두 적용*/


/*월별로 자르기*/
%MACRO TEST2_T40_2(YEAR,MONTH);
%DO P=&YEAR %TO 2013;
%DO I=&MONTH %TO 12;
PROC SQL;
CREATE TABLE NHID_GY40_T1_&P._&I AS
SELECT *
FROM T120.NHID_GY40_T1_&P.__2
WHERE RECU_FR_DT_M_1=&I;
;
QUIT;
%END;
%END;
%MEND;

%TEST2_T40_2(2002,1); /*2002-2013년 월별로 모두 자르기*/

/*T60*/
/*요양개시일자에서 월 뽑아내서 숫자형으로 전환*/
%MACRO TEST2_T60_1(YEAR);
%DO I=&YEAR %TO 2013;
DATA T120.NHID_GY60_T1_&I.__2;
SET T120.NHID_GY60_T1_&I;
RECU_FR_DT_M = SUBSTR(RECU_FR_DT,5,2);
RECU_FR_DT_M_1=1*RECU_FR_DT_M;
OUTPUT;
RUN;
QUIT;
%END;
%MEND;

%TEST2_T60_1(2002); /*2002-2013년 모두 적용*/


/*월별로 자르기*/
%MACRO TEST2_T60_2(YEAR,MONTH);
%DO P=&YEAR %TO 2013;
%DO I=&MONTH %TO 12;
PROC SQL;
CREATE TABLE NHID_GY60_T1_&P._&I AS
SELECT *
FROM T120.NHID_GY60_T1_&P.__2
WHERE RECU_FR_DT_M_1=&I;
;
QUIT;
%END;
%END;
%MEND;

%TEST2_T60_2(2002,1); /*2002-2013년 월별로 모두 자르기*/

=========================================================================================================================================================================

/*3.건강검진DB*/
/*표본코호트DB 데이터 불러오기(개인일련번호 - PERSON_ID)*/
%MACRO TEST3_1(CUT_STRT);
%DO I=&CUT_STRT. %TO 2013;
DATA gj.NHID_GJ_&I.;
SET gj.NHID_GJ_&I;
SEED =1234;
RECU_FR_DT_m = RAND("integer",1,12);
RUN; 
QUIT;
%END; 
%MEND; 

%TEST3_1(2002);

/*월별로 자르기*/
%MACRO TEST3_2(YEAR,MONTH);
%DO P=&YEAR %TO 2013;
%DO I=&MONTH %TO 12;
PROC SQL;
CREATE TABLE REX_gj.NHID_GJ_&P._&I AS
SELECT *
FROM gj.NHID_GJ_&P.
WHERE RECU_FR_DT_m=&I;
;
QUIT;
%END;
%END;
%MEND;

%TEST3_1(2002,1);
