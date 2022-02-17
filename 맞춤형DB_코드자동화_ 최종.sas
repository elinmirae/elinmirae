LIBNAME REX_jk "D:\ǥ����ȣƮDB\01.jk"; RUN; /*�ڰ� DB*/

LIBNAME REX_T120 "D:\ǥ����ȣƮDB\02.T120"; RUN; /*����DB(�ǰ�_���Ǳ��) - ����(20t)*/

LIBNAME REX_T130 "D:\ǥ����ȣƮDB\03.���᳻��_T130_S"; RUN; /*����DB(�ǰ�_���Ǳ��) - ���᳻��(30t)*/

LIBNAME REX_T140 "D:\ǥ����ȣƮDB\04.�󺴳���_T140_S"; RUN; /*����DB(�ǰ�_���Ǳ��) - �󺴳���(40t)*/

LIBNAME REX_T160 "D:\ǥ����ȣƮDB\05.ó��������_T160_S"; RUN; /*����DB(�ǰ�_���Ǳ��) - ó�������λ󼼳���(60t)*/

LIBNAME REX_T220 "D:\ǥ����ȣƮDB\06.T220"; RUN; /*����DB(ġ��_�ѹ�) - ����(20t)*/

LIBNAME REX_T230 "D:\ǥ����ȣƮDB\07.���᳻��_T230_S"; RUN; /*����DB(ġ��_�ѹ�) - ���᳻��(30t)*/

LIBNAME REX_T240 "D:\ǥ����ȣƮDB\08.�󺴳���_T240_S"; RUN; /*����DB(ġ��_�ѹ�) - �󺴳���(40t)*/

LIBNAME REX_T260 "D:\ǥ����ȣƮDB\09.ó��������_T260_S"; RUN; /*����DB(ġ��_�ѹ�) - ó�������λ󼼳���(60t)*/

LIBNAME REX_T320 "D:\ǥ����ȣƮDB\10.T320"; RUN; /*����DB(�౹) - ����(20t)*/

LIBNAME REX_T330 "D:\ǥ����ȣƮDB\11.���᳻��_T330_S"; RUN; /*����DB(�౹) - ���᳻��(30t)*/

LIBNAME REX_gj "D:\ǥ����ȣƮDB\12.gj"; RUN; /*�ǰ�����DB*/

LIBNAME REX_yk "D:\ǥ����ȣƮDB\13.�����_S"; RUN; /*�����DB*/

/*-------------------------------------------------------------------
- MACRO ����
- ��簳������(YYYYMMDD) �������� ���� �����ͼ����� �и�
--------------------------------------------------------------------*/
%MACRO TEST2(YEAR,LIB,TABLE); 
%DO I=&YEAR. %TO 2013;
	DATA &LIB..&TABLE._&I.;
	SET &LIB..&TABLE._&I.;
	RECU_FR_DT_M = SUBSTR(RECU_FR_DT,5,2);
	RECU_FR_DT_M=1*RECU_FR_DT_M;
	OUTPUT;
	RUN;
	QUIT;
%END;

%DO P=&YEAR. %TO 2013;
	%DO I=1 %TO 12;
		PROC SQL;
		CREATE TABLE &LIB..&TABLE._&P._&I. AS
		SELECT *
		FROM &LIB..&TABLE._&P.
		WHERE RECU_FR_DT_M_1=&I.;
		;
		QUIT;
	%END;
%END;
%MEND;

/*-------------------------------------------------------------------
- MACRO ����
--------------------------------------------------------------------*/

/*20t*/
%TEST2(2002, REX_T120, nhid_gy20_t1); /*�ǰ�_���Ǳ��*/
%TEST2(2002, REX_T220, nhid_gy20_t2); /*ġ��_�ѹ�*/
%TEST2(2002, REX_T320, nhid_gy20_t3); /*�౹*/

/*30t*/
%TEST2(2002, REX_T130, nhid_gy30_t1); /*�ǰ�_���Ǳ��*/
%TEST2(2002, REX_T230, nhid_gy30_t2); /*ġ��_�ѹ�*/
%TEST2(2002, REX_T330, nhid_gy30_t3); /*�౹*/

/*40t*/
%TEST2(2002, REX_T140, nhid_gy40_t1); /*�ǰ�_���Ǳ��*/
%TEST2(2002, REX_T240, nhid_gy40_t2); /*ġ��_�ѹ�*/

/*60t*/
%TEST2(2002, REX_T160, nhid_gy60_t1); /*�ǰ�_���Ǳ��*/
%TEST2(2002, REX_T260, nhid_gy60_t2); /*ġ��_�ѹ�*/

/*�ǰ�����DB*/
%TEST2(2002, REX_gj, nhid_gy30_t1);

/*-------------------------------------------------------------------
- rename ���� �ҷ�����;
- ����!! ���������� ���������� �����߻�, �������� �����Ŀ� �����Ź�帳�ϴ�!!
-------------------------------------------------------------------*/
filename reffile 'D:\ǥ����ȣƮDB\rename_file.xlsx';

PROC IMPORT OUT=name_list 
DATAFILE=reffile
DBMS=xlsx replace;
SHEET="variable";
getnames=yes;
run;

/*-------------------------------------------------------------------
- macro variable ����;
-------------------------------------------------------------------*/
proc sql;
select catx("=" , name, new_name)
into :list_rename separated by " "
from name_list;                    
quit;

%put &=list_rename.;

/*-------------------------------------------------------------------
- �ڰ�DB �ڵ� �ڵ�;
-------------------------------------------------------------------*/
%macro jkmacro_y (start, stop, lib, table);
	%do i=&start. %to &stop.;
		proc datasets lib=&lib.;
		modify &table._&i.;
		rename &list_rename.;
		run;
	%end;

	%do i=&start. %to &stop.;
		DATA &lib..&table._&i.(DROP = DTH_CODE1 DTH_CODE2 AGE_GROUP SIDO CTRB_PT_TYPE_CD DFAB_REG_YM RECU_FR_DT_m MDCARE_STRT_DT RECU_FR_DT_M_1);
		SET &lib..&table._&i.;
		CALC_CTRB_FD = RAND("integer", 33350 , 3322170);
		CALC_CTRB_VTILE_FD=RAND("integer",1 , 20);
		OUTPUT;
		RUN;
		QUIT;
	%END;
%mend;

/*MACRO ����*/
%jkmacro_y(2002,2013,REX_jk,nhid_jk);

/*-------------------------------------------------------------------
- ����DB_T20 �ڵ� �ڵ�;
-------------------------------------------------------------------*/
%macro T20macro_m(start, stop, lib, table);
%do i=&start. %to &stop.;
	%do j=1 %to 12;
		proc datasets lib=&lib.;
		modify &table._&i._&j.;
		rename &list_rename.;
		run;
		QUIT;
	%end;

	%do j=1 %to 12;
		DATA &lib..&table._&i._&j.(DROP=DMD_TRAMT DMD_SBRDN_AMT DMD_JBRDN_AMT DMD_CT_TOT_AMT DMD_MRI_TOT_AMT EDEC_CT_TOT_AMT EDEC_MRI_TOT_AMT MPRSC_ISSUE_ADMIN_ID MPRSC_GRANT_NO);
		SET &lib..&table._&i._&j.;
		OUTPUT;
		RUN;
		QUIT;
	%END;
%END;
%mend;

/*MACRO ����*/
%T20macro_m(2002,2013,REX_T120,NHID_GY20_T1); /*�ǰ�_���Ǳ��*/
%T20macro_m(2002,2013,REX_T220,NHID_GY20_T2); /*ġ��_�ѹ�*/
%T20macro_m(2002,2013,REX_T320,NHID_GY20_T3); /*�౹*/

/*-------------------------------------------------------------------
- ����DB_T30 �ڵ� �ڵ�;
-------------------------------------------------------------------*/
%macro T30macro_m(start, stop, lib, table);
%do i=&start. %to &stop.;
	%do j=1 %to 12;
		proc datasets lib=&lib.;
		modify &table._&i._&j.;
		rename &list_rename.;
		run;
		QUIT;
	%end;

	%do j=1 %to 12;
		DATA &lib..&table._&i._&j.(DROP=RECU_FR_DT I_II_TYPE UN_COST AMT);
		SET &lib..&table._&i._&j.;
		OUTPUT;
		RUN;
		QUIT;
	%END;
%END;
%mend;

/*MACRO ����*/
%T30macro_m(2002,2013,REX_T130,NHID_GY30_T1); /*�ǰ�_���Ǳ��*/
%T30macro_m(2002,2013,REX_T230,NHID_GY30_T2); /*ġ��_�ѹ�*/
%T30macro_m(2002,2013,REX_T330,NHID_GY30_T3); /*�౹*/

/*-------------------------------------------------------------------
- ����DB_T40 �ڵ� �ڵ�;
-------------------------------------------------------------------*/
%macro T40macro_m(start, stop, lib, table);
%do i=&start. %to &stop.;
	%do j=1 %to 12;
		proc datasets lib=&lib.;
		modify &table._&i._&j.;
		rename &list_rename.;
		run;
		QUIT;
	%end;

	%do j=1 %to 12;
		DATA &lib..&table._&i._&j.(DROP=SEQ_NO RECU_FR_DT);
		SET &lib..&table._&i._&j.;
		OUTPUT;
		RUN;
		QUIT;
	%END;
%END;
%mend;

/*MACRO ����*/
%T40macro_m(2002,2013,REX_T140,NHID_GY40_T1); /*�ǰ�_���Ǳ��*/
%T40macro_m(2002,2013,REX_T240,NHID_GY40_T2); /*ġ��_�ѹ�*/

/*-------------------------------------------------------------------
- ����DB_T60 �ڵ� �ڵ�;
-------------------------------------------------------------------*/
%macro T60macro_m(start, stop, lib, table);
%do i=&start. %to &stop.;
	%do j=1 %to 12;
		proc datasets lib=&lib.;
		modify &table._&i._&j.;
		rename &list_rename.;
		run;
		QUIT;
	%end;

	%do j=1 %to 12;
		DATA &lib..&table._&i._&j.(DROP=GNL_NM_CD UN_COST AMT);
		SET &lib..&table._&i._&j.;
		OUTPUT;
		RUN;
		QUIT;
	%END;
%END;
%mend;

/*MACRO ����*/
%T60macro_m(2002,2013,REX_T160,NHID_GY60_T1); /*�ǰ�_���Ǳ��*/
%T60macro_m(2002,2013,REX_T260,NHID_GY60_T2); /*ġ��_�ѹ�*/

/*-------------------------------------------------------------------
- �ǰ�����DB(2002~2008) �ڵ� �ڵ�;
-------------------------------------------------------------------*/
%macro gjmacro_m1(start, stop, lib, table);
	%do i=&start. %to &stop.;
		%do j=1 %to 12;
			proc datasets lib=&lib.;
			modify &table._&i._&j.;
			rename &list_rename.;
			run;
		%end;
	%end;

	%do i=&start. %to &stop.;
		%do j=1 %to 12;
			DATA &lib..&table._&i._&j.(KEEP = Q_DRK_FRQ_V0108 Q_DRK_AMT_V0108 Q_SMK_YN Q_SMK_NOW_AMT_V0108 Q_PA_FRQ EXMD_BZ_YYYY HMC_NO G1E_HGHT G1E_WGHT G1E_BP_SYS G1E_BP_DIA G1E_URN_GLU G1E_URN_PROT G1E_URN_OCC_BLD G1E_URN_PH G1E_HGB G1E_SGOT G1E_SGPT G1E_GGT G1E_WSTC G1E_TG G1E_HDL G1E_LDL G1E_CRTN INDI_DSCM_NO Q_SMK_DRT Q_FHX_LVDZ Q_FHX_HTN Q_FHX_STK Q_FHX_HTDZ Q_FHX_DM Q_FHX_CC Q_PHX1_DZ_V0208 Q_PHX2_DZ_V0208 Q_PHX3_DZ_V0208);
			SET &lib..&table._&i._&j.;
			IF Q_FHX_LVDZ ='' THEN Q_FHX_LVDZ = 0;
			IF Q_FHX_HTN ='' THEN Q_FHX_HTN = 0;
			IF Q_FHX_STK ='' THEN Q_FHX_STK = 0;
			IF Q_FHX_HTDZ ='' THEN Q_FHX_HTDZ = 0;
			IF Q_FHX_DM ='' THEN Q_FHX_DM = 0;
			IF Q_FHX_CC ='' THEN Q_FHX_CC = 0;
			IF Q_PHX1_DZ_V0208 ='' THEN Q_PHX1_DZ_V0208 = 0;
			IF Q_PHX2_DZ_V0208 ='' THEN Q_PHX2_DZ_V0208 = 0;
			IF Q_PHX3_DZ_V0208 ='' THEN Q_PHX3_DZ_V0208 = 0;
			OUTPUT;
			RUN;
			QUIT;
		%END;
	%END;

	%do i=&start. %to &stop.;
		%do j=1 %to 12;
			DATA &lib..&table._&i._&j.;
			SET &lib..&table._&i._&j.;
			Q_NTR_PRF=RAND("integer",1,3);
			Q_NTR_MEAT_FRQ=RAND("integer",1,7);
			Q_PA_DRT=RAND("integer",1,3);
			Q_AWR_YN=RAND("integer",1,2);
			Q_MH_STR=RAND("integer",1,4);
			Q_WH_AUB=RAND("integer",1,2);
			Q_WH_VDC=RAND("integer",1,2);
			Q_WH_MRG_AGE=RAND("integer",1,5);
			Q_PHX_DX_STK=RAND("integer",0,1);
			Q_PHX_DX_HTDZ=RAND("integer",0,1);
			Q_PHX_DX_HTN=RAND("integer",0,1);
			Q_PHX_DX_DM=RAND("integer",0,1);
			Q_PHX_DX_DLD=RAND("integer",0,1);
			Q_PHX_DX_ETC=RAND("integer",0,1);
			Q_PHX_TX_STK=RAND("integer",0,1);
			Q_PHX_TX_HTDZ=RAND("integer",0,1);
			Q_PHX_TX_HTN=RAND("integer",0,1);
			Q_PHX_TX_DM=RAND("integer",0,1);
			Q_PHX_TX_DLD=RAND("integer",0,1);
			Q_PHX_TX_ETC=RAND("integer",0,1);
			Q_FHX_ETC=RAND("integer",0,1);
			Q_HBV_AG=RAND("integer",0,1);
			Q_SMK_PRE_DRT=RAND("integer",5,10);
			Q_SMK_PRE_AMT=RAND("integer",5,15);
			Q_SMK_NOW_DRT=RAND("integer",5,15);
			Q_PA_VD=RAND("integer",0,7);
			Q_PA_MD=RAND("integer",0,7);
			Q_PA_WALK=RAND("integer",0,7);
			Q_KDSQ_C_1=RAND("integer",1,3);
			Q_KDSQ_C_2=RAND("integer",1,3);
			Q_KDSQ_C_3=RAND("integer",1,3);
			Q_KDSQ_C_4=RAND("integer",1,3);
			Q_KDSQ_C_5=RAND("integer",1,3);
			Q_PHX_DX_PTB=RAND("integer",0,1);
			Q_PHX_TX_PTB=RAND("integer",0,1);
			G1E_BMI=RANUNI(1234)*(15-30)+30;
			G1E_BMI=round(G1E_BMI,0.1);
			G1E_VA_LT = RANUNI(1234)*(2-0)+0;
			G1E_VA_LT = round(G1E_VA_LT,0.1);
			IF G1E_VA_LT=2 THEN G1E_VA_LT=9.9;
			G1E_VA_RT = RANUNI(1234)*(2-0)+0;
			G1E_VA_RT = round(G1E_VA_RT,0.1);
			IF G1E_VA_RT=2 THEN G1E_VA_LT=9.9;
			G1E_HA_LT=RAND("integer",1,2);
			G1E_HA_RT=RAND("integer",1,2);
			G1E_OBS_DGR=RAND("integer",1,4);
			G1E_FBS=RAND("integer",70,126);
			G1E_TOT_CHOL=RAND("integer",100,300);
			G1E_CHST_XRAY_MTHD=RAND("integer",1,3);
			G1E_EKG_RST=RAND("integer",1,7);
			G1E_PHX_YN=RAND("integer",1,2);
			G1E_PHX_LVDZ=RAND("integer",0,1);
			G1E_PHX_HTN=RAND("integer",0,1);
			G1E_PHX_STK=RAND("integer",0,1);
			G1E_PHX_HTDZ=RAND("integer",0,1);
			G1E_PHX_DM=RAND("integer",0,1);
			G1E_PHX_CC=RAND("integer",0,1);
			G1E_PHX_ETC=RAND("integer",0,1);
			G1E_HB_RST=RAND("integer",1,2);
			G1E_HB_DRK=RAND("integer",0,1);
			G1E_HB_SMK=RAND("integer",0,1);
			G1E_HB_PA=RAND("integer",0,1);
			G1E_HB_WGHT=RAND("integer",0,1);
			G1E_HB_NTR=RAND("integer",0,1);
			G1E_TRM_SEQ=RAND("integer",1,2);
			G1E_GN_HTH=RAND("integer",1,3);
			CXCE_GEC_YN=RAND("integer",1,2);
			G1E_GFR=RAND("integer",80,130);
			G1E_KDSQ_C=RAND("integer",1,2);
			G1E_LDL_CALC=RAND("integer",100,300);
			G1E_LDL_MSR=RAND("integer",100,300);
			Q_PHX1_CR=RAND("integer",1,2);
			Q_PHX2_CR=RAND("integer",1,2);
			Q_PHX3_CR=RAND("integer",1,2);
			OUTPUT;
			RUN;
			QUIT;
		%END;
	%END;
%mend;

/*MACRO ����*/
%gjmacro_m1(2002,2008,REX_gj,nhid_gj);

/*-------------------------------------------------------------------
- �ǰ�����DB(2009~2013) �ڵ� �ڵ�;
-------------------------------------------------------------------*/
%macro gjmacro_m2(start, stop, lib, table);
	%do i=&start. %to &stop.;
		%do j=1 %to 12;
			proc datasets lib=&lib.;
			modify &table._&i._&j.;
			rename &list_rename.;
			run;
		%end;
	%end;

	%do i=&start. %to &stop.;
		%do j=1 %to 12;
			DATA &lib..&table._&i._&j.(KEEP = EXMD_BZ_YYYY INDI_DSCM_NO HMC_NO G1E_HGHT G1E_WGHT G1E_BP_SYS G1E_BP_DIA G1E_URN_PROT G1E_HGB G1E_FBS G1E_TOT_CHOL G1E_SGOT G1E_SGPT G1E_GGT G1E_WSTC G1E_TG G1E_HDL G1E_LDL G1E_CRTN Q_SMK_NOW_AMT_V09N Q_DRK_AMT_V09N Q_PHX_DX_STK Q_PHX_DX_HTDZ Q_PHX_DX_HTN Q_PHX_DX_DM Q_PHX_DX_DLD Q_PHX_DX_ETC Q_FHX_ETC Q_SMK_PRE_DRT Q_SMK_PRE_AMT Q_SMK_NOW_DRT Q_PHX_DX_PTB Q_DRK_FRQ_V09N Q_PA_VD Q_PA_MD Q_PA_WALK G1E_HB_SMK);
			SET &lib..&table._&i._&j.;
			Q_DRK_FRQ_V09N=(Q_DRK_FRQ_V09N*1)-1;
			Q_PA_VD=(Q_PA_VD*1)-1;
			Q_PA_MD=(Q_PA_MD*1)-1;
			Q_PA_WALK=(Q_PA_WALK*1)-1;
			IF G1E_HB_SMK= '1' OR '2' THEN G1E_HB_SMK= '1';
			ELSE G1E_HB_SMK= '2';
			OUTPUT;
			RUN;
			QUIT;
		%END;
	%END;

	%do i=&start. %to &stop.;
		%do j=1 %to 12;
			DATA &lib..&table._&i._&j.;
			SET &lib..&table._&i._&j.;
			G1E_BMI = RANUNI(1234)*(15-30)+30;
			G1E_VA_LT = RANUNI(1234)*(2-0)+0;
			G1E_VA_LT = round(G1E_VA_LT,0.1);
			IF G1E_VA_LT=2 THEN G1E_VA_LT=9.9;
			G1E_VA_RT = RANUNI(1234)*(2-0)+0;
			G1E_VA_RT = round(G1E_VA_RT,0.1);
			IF G1E_VA_RT=2 THEN G1E_VA_LT=9.9;
			G1E_HA_LT=RAND("integer",1,2);
			G1E_HA_RT=RAND("integer",1,2);
			G1E_OBS_DGR=RAND("integer",1,4);
			G1E_CHST_XRAY_MTHD=RAND("integer",1,3);
			G1E_EKG_RST=RAND("integer",1,7);
			G1E_PHX_YN=RAND("integer",1,2);
			G1E_PHX_LVDZ=RAND("integer",0,1);
			G1E_PHX_HTN=RAND("integer",0,1);
			G1E_PHX_STK=RAND("integer",0,1);
			G1E_PHX_HTDZ=RAND("integer",0,1);
			G1E_PHX_DM=RAND("integer",0,1);
			G1E_PHX_CC=RAND("integer",0,1);
			G1E_PHX_ETC=RAND("integer",0,1);
			G1E_HB_RST=RAND("integer",1,2);
			G1E_HB_DRK=RAND("integer",1,2);
			G1E_HB_PA=RAND("integer",1,2);
			G1E_HB_WGHT=RAND("integer",1,2);
			G1E_HB_NTR=RAND("integer",0,1);
			G1E_TRM_SEQ=RAND("integer",1,2);
			G1E_GN_HTH=RAND("integer",1,3);
			CXCE_GEC_YN=RAND("integer",0,1);
			CXCE_CXC_FU_MTH=RAND("integer",1,12);
			G1E_GFR=RAND("integer",80,130);
			G1E_KDSQ_C=RAND("integer",1,2);
			G1E_LDL_CALC=RAND("integer",100,300);
			G1E_LDL_MSR=RAND("integer",100,300);
			Q_PHX1_CR=RAND("integer",1,2);
			Q_PHX2_CR=RAND("integer",1,2);
			Q_PHX3_CR=RAND("integer",1,2);
			Q_FHX_LVDZ=RAND("integer",0,2);
			Q_FHX_HTN=RAND("integer",0,1);
			Q_FHX_STK=RAND("integer",0,1);
			Q_FHX_HTDZ=RAND("integer",0,1);
			Q_FHX_DM=RAND("integer",0,1);
			Q_FHX_CC=RAND("integer",0,2);
			Q_NTR_PRF=RAND("integer",1,3);
			Q_NTR_MEAT_FRQ=RAND("integer",1,7);
			Q_SMK_YN=RAND("integer",1,3);
			Q_SMK_DRT=RAND("integer",1,5);
			Q_PA_FRQ=RAND("integer",1,5);
			Q_PA_DRT=RAND("integer",1,3);
			Q_AWR_YN=RAND("integer",1,2);
			Q_MH_STR=RAND("integer",1,4);
			Q_WH_AUB=RAND("integer",1,2);
			Q_WH_VDC=RAND("integer",1,2);
			Q_WH_MRG_AGE=RAND("integer",1,5);
			Q_PHX_TX_STK=RAND("integer",0,1);
			Q_PHX_TX_HTDZ=RAND("integer",0,1);
			Q_PHX_TX_HTN=RAND("integer",0,1);
			Q_PHX_TX_DM=RAND("integer",0,1);
			Q_PHX_TX_DLD=RAND("integer",0,1);
			Q_PHX_TX_ETC=RAND("integer",0,1);
			Q_HBV_AG=RAND("integer",0,1);
			Q_KDSQ_C_1=RAND("integer",1,3);
			Q_KDSQ_C_2=RAND("integer",1,3);
			Q_KDSQ_C_3=RAND("integer",1,3);
			Q_KDSQ_C_4=RAND("integer",1,3);
			Q_KDSQ_C_5=RAND("integer",1,3);
			Q_PHX_TX_PTB=RAND("integer",0,1);
			OUTPUT;
			RUN;
			QUIT;
		%END;
	%END;
%mend;

/*MACRO ����*/
%gjmacro_m2(2009,2013,REX_gj,nhid_gj);

/*-------------------------------------------------------------------
- �����DB �ڵ� �ڵ�;
-------------------------------------------------------------------*/
%macro ykmacro_y(start, stop, lib, table);
	%do i=&start. %to &stop.;
		proc datasets lib=&lib.(DROP=SICKBED_CNT CT_YN MRI_YN PET_YN);
		modify &table._&i.;
		rename &list_rename.;
		run;
	%end;

	%do i=&start. %to &stop.;
		DATA &lib..&table._&i.;
		SET &lib..&table._&i.;
		CNT_MDR_SPC=RAND("integer",1,5);
		CNT_DDR_TOT=RAND("integer",1,5);
		CNT_DDR_SPC=RAND("integer",1,5);
		CNT_HDR_TOT=RAND("integer",1,5);
		CNT_HDR_SPC=RAND("integer",1,5);
		CNT_PHRM_TOT=RAND("integer",1,5);
		CNT_NRS_TOT=RAND("integer",5,20);
		CNT_NRS_AID_TOT=RAND("integer",5,20);
		CNT_ROOM_OP=RAND("integer",5,30);
		CNT_ROOM_ER=RAND("integer",5,30);
		CNT_ROOM_ICU_ADLT=RAND("integer",5,30);
		CNT_ROOM_NICU=RAND("integer",5,30);
		CNT_ROOM_INP_13=RAND("integer",5,30);
		CNT_BED_INP_13=RAND("integer",5,30);
		CNT_ROOM_INP_46=RAND("integer",5,30);
		CNT_BED_INP_46=RAND("integer",5,30);
		CNT_BED_OP=RAND("integer",8,60);
		CNT_BED_ER=RAND("integer",8,60);
		CNT_BED_ICU_ADLT=RAND("integer",8,60);
		CNT_BED_NICU=RAND("integer",8,60);
		OUTPUT;
		RUN;
		QUIT;
	%end;
%mend;

/*MACRO ����*/
%ykmacro_y(2002,2013,REX_yk,NHID_YK);
