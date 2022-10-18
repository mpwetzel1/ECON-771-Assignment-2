/***************************************

Project: ECON 771, Assignment 2
Program: 01_Prep
Date: 9/30/22
Author: Martha

Notes: 

****************************************/

/* Set-up */
options mergenoby = error compress=binary symbolgen ;

/* Pathways */
%let root = C:\Users\mwetze2\OneDrive - Emory University\PhD Coursework\2022b_Fall\ECON 771\Assignments\Assignment 2;
%let indata = &root.\Raw Data;
libname temp "&root.\Output\SAS Temp";

/* Set up output stye template */

ODS PATH WORK.TEMPLAT(UPDATE)
   SASUSR.TEMPLAT(UPDATE) SASHELP.TMPLMST(READ);

   PROC TEMPLATE;
	   DEFINE STYLE STYLES.TABLES;
	   NOTES "MY TABLE STYLE"; 
	   PARENT=STYLES.MINIMAL;

	     STYLE SYSTEMTITLE /FONT_SIZE = 12pt     FONT_FACE = "TIMES NEW ROMAN";

	     STYLE HEADER /
	           FONT_FACE = "TIMES NEW ROMAN"
	            CELLPADDING=8
	            JUST=C
	            VJUST=C
	            FONT_SIZE = 10pt
	           FONT_WEIGHT = BOLD; 

	     STYLE TABLE /
	            FRAME=HSIDES            /* outside borders: void, box, above/below, vsides/hsides, lhs/rhs */
	            RULES=GROUP              /* internal borders: none, all, cols, rows, groups */
	            CELLPADDING=6            /* the space between table cell contents and the cell border */
	            CELLSPACING=6           /* the space between table cells, allows background to show */
	            JUST=C
	            FONT_SIZE = 10pt
	            BORDERWIDTH = 0.5pt;  /* the width of the borders and rules */

	     STYLE DATAEMPHASIS /
	           FONT_FACE = "TIMES NEW ROMAN"
	           FONT_SIZE = 10pt
	           FONT_WEIGHT = BOLD;

	     STYLE DATA /
	           FONT_FACE = "TIMES NEW ROMAN" 
	           FONT_SIZE = 10pt;

	     STYLE SYSTEMFOOTER /FONT_SIZE = 9pt FONT_FACE = "TIMES NEW ROMAN" JUST=C;
	   END;

   RUN; 


/*----------------------------------------*/
/*			Read in and Prep MDPPAS		  */
/*----------------------------------------*/

%macro read_mdppas;

	%let yr =2009;
	%do %while (&yr. <= 2009 );

	%put filename = "MDPPAS_&yr.";
	%put put ="&indata.\MDPPAS\PhysicianData_&yr..zip";

	filename MDP_&yr. ZIP "&indata.\MDPPAS\PhysicianData_&yr..zip" member="PhysicianData_&yr..csv" ;


       data temp.MDPPAS_&yr.  (drop = name_last name_first name_middle spec_prim_2_name
			tin: claim_count: phy_zip:);
       %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
       infile MDP_&yr. delimiter = ','
  		 MISSOVER DSD lrecl=32767 firstobs=2 ;
          informat npi best32. ;
          informat name_last $13. ;
          informat name_first $9. ;
          informat name_middle $10. ;
          informat sex $1. ;
          informat birth_dt DATE9. ;
          informat spec_broad best32. ;
          informat spec_prim_1 $2. ;
          informat spec_prim_1_name $46. ;
          informat spec_prim_2 best32. ;
          informat spec_prim_2_name $17. ;
          informat pos_office best32. ;
          informat pos_inpat best32. ;
          informat pos_opd best32. ;
          informat pos_er best32. ;
          informat pos_nursing best32. ;
          informat pos_asc best32. ;
          informat pos_resid best32. ;
          informat pos_other best32. ;
          informat npi_allowed_amt best32. ;
          informat npi_unq_benes best32. ;
          informat tin1_legal_name $47. ;
          informat tin1_allowed_amt best32. ;
          informat tin1_unq_benes best32. ;
          informat tin2_legal_name $50. ;
          informat tin2_allowed_amt best32. ;
          informat tin2_unq_benes best32. ;
          informat phy_zip1 best32. ;
          informat claim_count1 best32. ;
          informat phy_zip2 best32. ;
          informat claim_count2 best32. ;
          informat phy_zip3 best12. ;
          informat claim_count3 best12. ;
          informat phy_zip4 best12. ;
          informat claim_count4 best12. ;
          informat phy_zip5 best12. ;
          informat claim_count5 best12. ;
          informat phy_zip6 best12. ;
          informat claim_count6 best12. ;
          informat phy_zip7 best12. ;
          informat claim_count7 best12. ;
          informat phy_zip8 best12. ;
          informat claim_count8 best12. ;
          informat phy_zip9 best12. ;
          informat claim_count9 best12. ;
          informat phy_zip10 best12. ;
          informat claim_count10 best12. ;
          informat phy_zip11 best12. ;
          informat claim_count11 best12. ;
          informat phy_zip12 best12. ;
          informat claim_count12 best12. ;
          informat perc_male best32. ;
          informat perc_female best32. ;
          informat perc_white best32. ;
          informat perc_black best32. ;
          informat perc_asian best32. ;
          informat perc_hispanic best32. ;
          informat perc_amerindian best32. ;
          informat Year best32. ;
          informat group1 best32. ;
          informat group2 best32. ;
          format npi best12. ;
          format name_last $13. ;
          format name_first $9. ;
          format name_middle $10. ;
          format sex $1. ;
          format birth_dt DATE9. ;
          format spec_broad best12. ;
          format spec_prim_1 $2. ;
          format spec_prim_1_name $46. ;
          format spec_prim_2 best12. ;
          format spec_prim_2_name $17. ;
          format pos_office best12. ;
          format pos_inpat best12. ;
          format pos_opd best12. ;
          format pos_er best12. ;
         format pos_nursing best12. ;
         format pos_asc best12. ;
         format pos_resid best12. ;
         format pos_other best12. ;
         format npi_allowed_amt best12. ;
         format npi_unq_benes best12. ;
         format tin1_legal_name $47. ;
         format tin1_allowed_amt best12. ;
         format tin1_unq_benes best12. ;
         format tin2_legal_name $50. ;
         format tin2_allowed_amt best12. ;
         format tin2_unq_benes best12. ;
         format phy_zip1 best12. ;
         format claim_count1 best12. ;
         format phy_zip2 best12. ;
         format claim_count2 best12. ;
         format phy_zip3 best12. ;
         format claim_count3 best12. ;
         format phy_zip4 best12. ;
         format claim_count4 best12. ;
         format phy_zip5 best12. ;
         format claim_count5 best12. ;
         format phy_zip6 best12. ;
         format claim_count6 best12. ;
         format phy_zip7 best12. ;
         format claim_count7 best12. ;
         format phy_zip8 best12. ;
         format claim_count8 best12. ;
         format phy_zip9 best12. ;
         format claim_count9 best12. ;
         format phy_zip10 best12. ;
         format claim_count10 best12. ;
         format phy_zip11 best12. ;
         format claim_count11 best12. ;
         format phy_zip12 best12. ;
         format claim_count12 best12. ;
         format perc_male best12. ;
         format perc_female best12. ;
         format perc_white best12. ;
         format perc_black best12. ;
         format perc_asian best12. ;
         format perc_hispanic best12. ;
         format perc_amerindian best12. ;
         format Year best12. ;
         format group1 best12. ;
         format group2 best12. ;
      input
                  npi
                  name_last  $
                  name_first  $
                  name_middle  $
                  sex  $
                  birth_dt
                  spec_broad
                  spec_prim_1  $
                  spec_prim_1_name  $
                  spec_prim_2
                  spec_prim_2_name  $
                  pos_office
                  pos_inpat
                  pos_opd
                  pos_er
                  pos_nursing
                  pos_asc
                  pos_resid
                  pos_other
                  npi_allowed_amt
                  npi_unq_benes
                  tin1_legal_name  $
                  tin1_allowed_amt
                  tin1_unq_benes
                  tin2_legal_name  $
                  tin2_allowed_amt
                  tin2_unq_benes
                  phy_zip1
                  claim_count1
                  phy_zip2
                  claim_count2
                  phy_zip3  
                  claim_count3  
                  phy_zip4  
                  claim_count4  
                  phy_zip5  
                  claim_count5  
                  phy_zip6  
                  claim_count6  
                  phy_zip7  
                  claim_count7  
                  phy_zip8  
                  claim_count8  
                  phy_zip9  
                  claim_count9  
                  phy_zip10  
                  claim_count10  
                  phy_zip11  
                  claim_count11 
                  phy_zip12  
                  claim_count12  
                  perc_male
                  perc_female
                  perc_white
                  perc_black
                  perc_asian
                  perc_hispanic
                  perc_amerindian
                  Year
                  group1
                  group2
      ;
      if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
      run;

	  %let yr = %eval(&yr.+1);
	%end;

%mend read_mdppas;

%read_mdppas;


/*----------------------------------------*/
/*			Read in and Prep PUF		  */
/*----------------------------------------*/

/* Subroutine to deal with this credential mess */
%macro creds;
	NewCred = compress(upcase(nppes_credentials), " ", "AK");
	/* Drop fake MDs */
	NewCred = tranwrd(NewCred, "DMD", "~");
	NewCred = tranwrd(NewCred, "MDT", "~");
	NewCred = tranwrd(NewCred, "NMD", "~");
	/* Keep real MDs */
	if  find(NewCred, "MD") > 0 or find(NewCred, "MEDICALDOCTOR" )>0;
%mend creds;

/* 2012 */
DATA temp.puf_2012;
	LENGTH
		npi              					$ 10
		nppes_provider_last_org_name 		$ 70
		nppes_provider_first_name 			$ 20
		nppes_provider_mi					$ 1
		nppes_credentials 					$ 20
		nppes_provider_gender				$ 1
		nppes_entity_code 					$ 1
		nppes_provider_street1 				$ 55
		nppes_provider_street2				$ 55
		nppes_provider_city 				$ 40
		nppes_provider_zip 					$ 20
		nppes_provider_state				$ 2
		nppes_provider_country				$ 2
		provider_type 						$ 43
		medicare_participation_indicator 	$ 1
		place_of_service					$ 1
		hcpcs_code       					$ 5
		hcpcs_description 					$ 256
		hcpcs_drug_indicator				$ 1
		line_srvc_cnt      					8
		bene_unique_cnt    					8
		bene_day_srvc_cnt   				8
		average_Medicare_allowed_amt   		8
		stdev_Medicare_allowed_amt  		8
		average_submitted_chrg_amt  		8
		stdev_submitted_chrg_amt   			8
		average_Medicare_payment_amt   		8
		stdev_Medicare_payment_amt   		8;

	INFILE "&indata.\Utilization_Payment\utilization-payment-puf\2012\Medicare_Provider_Util_Payment_PUF_CY2012.TXT"
		lrecl=32767
		dlm='09'x
		pad missover
		firstobs = 3
		dsd;

	INPUT
		npi             
		nppes_provider_last_org_name 
		nppes_provider_first_name 
		nppes_provider_mi 
		nppes_credentials 
		nppes_provider_gender 
		nppes_entity_code 
		nppes_provider_street1 
		nppes_provider_street2 
		nppes_provider_city 
		nppes_provider_zip 
		nppes_provider_state 
		nppes_provider_country 
		provider_type 
		medicare_participation_indicator 
		place_of_service 
		hcpcs_code       
		hcpcs_description 
		hcpcs_drug_indicator
		line_srvc_cnt    
		bene_unique_cnt  
		bene_day_srvc_cnt 
		average_Medicare_allowed_amt 
		stdev_Medicare_allowed_amt 
		average_submitted_chrg_amt 
		stdev_submitted_chrg_amt 
		average_Medicare_payment_amt 
		stdev_Medicare_payment_amt;

	LABEL
		npi     							= "National Provider Identifier"       
		nppes_provider_last_org_name 		= "Last Name/Organization Name of the Provider"
		nppes_provider_first_name 			= "First Name of the Provider"
		nppes_provider_mi					= "Middle Initial of the Provider"
		nppes_credentials 					= "Credentials of the Provider"
		nppes_provider_gender 				= "Gender of the Provider"
		nppes_entity_code 					= "Entity Type of the Provider"
		nppes_provider_street1 				= "Street Address 1 of the Provider"
		nppes_provider_street2 				= "Street Address 2 of the Provider"
		nppes_provider_city 				= "City of the Provider"
		nppes_provider_zip 					= "Zip Code of the Provider"
		nppes_provider_state 				= "State Code of the Provider"
		nppes_provider_country 				= "Country Code of the Provider"
		provider_type	 					= "Provider Type of the Provider"
		medicare_participation_indicator 	= "Medicare Participation Indicator"
		place_of_service 					= "Place of Service"
		hcpcs_code       					= "HCPCS Code"
		hcpcs_description 					= "HCPCS Description"
		hcpcs_drug_indicator				= "Identifies HCPCS As Drug Included in the ASP Drug List"
		line_srvc_cnt    					= "Number of Services"
		bene_unique_cnt  					= "Number of Medicare Beneficiaries"
		bene_day_srvc_cnt 					= "Number of Distinct Medicare Beneficiary/Per Day Services"
		average_Medicare_allowed_amt 		= "Average Medicare Allowed Amount"
		stdev_Medicare_allowed_amt 			= "Standard Deviation of Medicare Allowed Amount"
		average_submitted_chrg_amt 			= "Average Submitted Charge Amount"
		stdev_submitted_chrg_amt 			= "Standard Deviation of Submitted Charge Amount" 
		average_Medicare_payment_amt 		= "Average Medicare Payment Amount"
		stdev_Medicare_payment_amt 			= "Standard Deviation of Medicare Payment Amount";

		/* Only keep MDs  */
		%creds;
RUN;



DATA temp.puf_2013;
	LENGTH
		npi              					$ 10
		nppes_provider_last_org_name 		$ 70
		nppes_provider_first_name 			$ 20
		nppes_provider_mi					$ 1
		nppes_credentials 					$ 20
		nppes_provider_gender				$ 1
		nppes_entity_code 					$ 1
		nppes_provider_street1 				$ 55
		nppes_provider_street2				$ 55
		nppes_provider_city 				$ 40
		nppes_provider_zip 					$ 20
		nppes_provider_state				$ 2
		nppes_provider_country				$ 2
		provider_type 						$ 43
		medicare_participation_indicator 	$ 1
		place_of_service					$ 1
		hcpcs_code       					$ 5
		hcpcs_description 					$ 256
		hcpcs_drug_indicator				$ 1
		line_srvc_cnt      					8
		bene_unique_cnt    					8
		bene_day_srvc_cnt   				8
		average_Medicare_allowed_amt   		8
		stdev_Medicare_allowed_amt  		8
		average_submitted_chrg_amt  		8
		stdev_submitted_chrg_amt   			8
		average_Medicare_payment_amt   		8
		stdev_Medicare_payment_amt   		8;

	INFILE "&indata.\Utilization_Payment\utilization-payment-puf\2013\Medicare_Provider_Util_Payment_PUF_CY2013.TXT"
		lrecl=32767
		dlm='09'x
		pad missover
		firstobs = 3
		dsd;

	INPUT
		npi             
		nppes_provider_last_org_name 
		nppes_provider_first_name 
		nppes_provider_mi 
		nppes_credentials 
		nppes_provider_gender 
		nppes_entity_code 
		nppes_provider_street1 
		nppes_provider_street2 
		nppes_provider_city 
		nppes_provider_zip 
		nppes_provider_state 
		nppes_provider_country 
		provider_type 
		medicare_participation_indicator 
		place_of_service 
		hcpcs_code       
		hcpcs_description 
		hcpcs_drug_indicator
		line_srvc_cnt    
		bene_unique_cnt  
		bene_day_srvc_cnt 
		average_Medicare_allowed_amt 
		stdev_Medicare_allowed_amt 
		average_submitted_chrg_amt 
		stdev_submitted_chrg_amt 
		average_Medicare_payment_amt 
		stdev_Medicare_payment_amt;

	LABEL
		npi     							= "National Provider Identifier"       
		nppes_provider_last_org_name 		= "Last Name/Organization Name of the Provider"
		nppes_provider_first_name 			= "First Name of the Provider"
		nppes_provider_mi					= "Middle Initial of the Provider"
		nppes_credentials 					= "Credentials of the Provider"
		nppes_provider_gender 				= "Gender of the Provider"
		nppes_entity_code 					= "Entity Type of the Provider"
		nppes_provider_street1 				= "Street Address 1 of the Provider"
		nppes_provider_street2 				= "Street Address 2 of the Provider"
		nppes_provider_city 				= "City of the Provider"
		nppes_provider_zip 					= "Zip Code of the Provider"
		nppes_provider_state 				= "State Code of the Provider"
		nppes_provider_country 				= "Country Code of the Provider"
		provider_type	 					= "Provider Type of the Provider"
		medicare_participation_indicator 	= "Medicare Participation Indicator"
		place_of_service 					= "Place of Service"
		hcpcs_code       					= "HCPCS Code"
		hcpcs_description 					= "HCPCS Description"
		hcpcs_drug_indicator				= "Identifies HCPCS As Drug Included in the ASP Drug List"
		line_srvc_cnt    					= "Number of Services"
		bene_unique_cnt  					= "Number of Medicare Beneficiaries"
		bene_day_srvc_cnt 					= "Number of Distinct Medicare Beneficiary/Per Day Services"
		average_Medicare_allowed_amt 		= "Average Medicare Allowed Amount"
		stdev_Medicare_allowed_amt 			= "Standard Deviation of Medicare Allowed Amount"
		average_submitted_chrg_amt 			= "Average Submitted Charge Amount"
		stdev_submitted_chrg_amt 			= "Standard Deviation of Submitted Charge Amount" 
		average_Medicare_payment_amt 		= "Average Medicare Payment Amount"
		stdev_Medicare_payment_amt 			= "Standard Deviation of Medicare Payment Amount";

		%creds;
RUN;


/* Import 2014-2017 */
%macro get_puf;

	%let yr = 2014;
	%do %while (&yr. <= 2017);

		DATA temp.puf_&yr.;
			LENGTH
				npi              					$ 10
				nppes_provider_last_org_name 		$ 70
				nppes_provider_first_name 			$ 20
				nppes_provider_mi					$ 1
				nppes_credentials 					$ 20
				nppes_provider_gender				$ 1
				nppes_entity_code 					$ 1
				nppes_provider_street1 				$ 55
				nppes_provider_street2				$ 55
				nppes_provider_city 				$ 40
				nppes_provider_zip 					$ 20
				nppes_provider_state				$ 2
				nppes_provider_country				$ 2
				provider_type 						$ 43
				medicare_participation_indicator 	$ 1
				place_of_service					$ 1
				hcpcs_code       					$ 5
				hcpcs_description 					$ 256
				hcpcs_drug_indicator				$ 1
				line_srvc_cnt      					8
				bene_unique_cnt    					8
				bene_day_srvc_cnt   				8
				average_Medicare_allowed_amt   		8
				average_submitted_chrg_amt  		8
				average_Medicare_payment_amt   		8
				average_Medicare_standard_amt		8;
			INFILE "&indata.\Utilization_Payment\utilization-payment-puf\&yr.\Medicare_Provider_Util_Payment_PUF_CY&yr..TXT"

				lrecl=32767
				dlm='09'x
				pad missover
				firstobs = 3
				dsd;

			INPUT
				npi             
				nppes_provider_last_org_name 
				nppes_provider_first_name 
				nppes_provider_mi 
				nppes_credentials 
				nppes_provider_gender 
				nppes_entity_code 
				nppes_provider_street1 
				nppes_provider_street2 
				nppes_provider_city 
				nppes_provider_zip 
				nppes_provider_state 
				nppes_provider_country 
				provider_type 
				medicare_participation_indicator 
				place_of_service 
				hcpcs_code       
				hcpcs_description 
				hcpcs_drug_indicator
				line_srvc_cnt    
				bene_unique_cnt  
				bene_day_srvc_cnt 
				average_Medicare_allowed_amt 
				average_submitted_chrg_amt 
				average_Medicare_payment_amt
				average_Medicare_standard_amt;

			LABEL
				npi     							= "National Provider Identifier"       
				nppes_provider_last_org_name 		= "Last Name/Organization Name of the Provider"
				nppes_provider_first_name 			= "First Name of the Provider"
				nppes_provider_mi					= "Middle Initial of the Provider"
				nppes_credentials 					= "Credentials of the Provider"
				nppes_provider_gender 				= "Gender of the Provider"
				nppes_entity_code 					= "Entity Type of the Provider"
				nppes_provider_street1 				= "Street Address 1 of the Provider"
				nppes_provider_street2 				= "Street Address 2 of the Provider"
				nppes_provider_city 				= "City of the Provider"
				nppes_provider_zip 					= "Zip Code of the Provider"
				nppes_provider_state 				= "State Code of the Provider"
				nppes_provider_country 				= "Country Code of the Provider"
				provider_type	 					= "Provider Type of the Provider"
				medicare_participation_indicator 	= "Medicare Participation Indicator"
				place_of_service 					= "Place of Service"
				hcpcs_code       					= "HCPCS Code"
				hcpcs_description 					= "HCPCS Description"
				hcpcs_drug_indicator				= "Identifies HCPCS As Drug Included in the ASP Drug List"
				line_srvc_cnt    					= "Number of Services"
				bene_unique_cnt  					= "Number of Medicare Beneficiaries"
				bene_day_srvc_cnt 					= "Number of Distinct Medicare Beneficiary/Per Day Services"
				average_Medicare_allowed_amt 		= "Average Medicare Allowed Amount"
				average_submitted_chrg_amt 			= "Average Submitted Charge Amount"
				average_Medicare_payment_amt 		= "Average Medicare Payment Amount"
				average_Medicare_standard_amt		= "Average Medicare Standardized Payment Amount";

			/* Only keep MDs */
			%creds;
		RUN;

		%let yr = %eval(&yr.+1);
	%end;

%mend get_puf;
%get_puf;


/*----	PFS Update Date	----*/
/*proc import datafile = "&indata.\PFS_update_data.txt"*/
/*	out = temp.pfs replace*/
/*	dbms = tab;*/
/*	guessingrows = 10000;*/
/*run;*/

/*----------------------------------*/
/*----			Data Prep		----*/
/*----------------------------------*/

/* Iterate at year level b/c this laptop is not built for this */
%macro collapsepuf;

	%let yr = 2012;
	%do %while (&yr. <= 2017);

	/* Calculate total spending per service at physician/year level */
	options compress=no;
	data temp.puf_psy_&yr. (drop = medicare_participation_indicator nppes_provider_country);
		set temp.puf_&yr. (keep = 
					npi             
					nppes_entity_code 			
					nppes_provider_state 
					nppes_provider_country 
					provider_type 
					medicare_participation_indicator 
					place_of_service 
					hcpcs_code       
					line_srvc_cnt    
					bene_unique_cnt  
					bene_day_srvc_cnt 
					average_Medicare_allowed_amt 
					average_Medicare_payment_amt)	;

		where medicare_participation_indicator = "Y" and nppes_provider_country = "US";

		Total_Allowed = average_Medicare_allowed_amt*line_srvc_cnt;
		Year = &yr.;

		label Total_Allowed = "Total Amt Allowed";
	run;
	options compress=binary;

	/* Roll up at physician-year level */
	proc means data = temp.puf_psy_&yr. noprint nway;
		output out = temp.puf_phyr_&yr.
		sum(line_srvc_cnt bene_unique_cnt average_Medicare_allowed_amt average_Medicare_payment_amt Total_Allowed) =;
		class npi;
		id year;
	run;

	%let yr = %eval(&yr.+1);
	%end;

%mend collapsepuf;

%collapsepuf;


/* In preparation for summary stats (Q1), stack all year-level data sets */
data temp.puf_phyr (drop = _TYPE_ _FREQ_);
	set temp.puf_phyr_:;

	NPI_N = input(npi, best32.);
run;

proc univariate data = temp.puf_phyr outtable = summary noprint;
	var Total_Allowed line_srvc_cnt bene_unique_cnt;
run;

/* All three have same N */
proc sql noprint;
	select _NOBS_ into :N
	from summary;
quit;


  OPTIONS ORIENTATION=PORTRAIT MISSING = "-" NODATE;

     ODS RTF STYLE=tables FILE= "&root.\Output\Table 1.doc"; 

	PROC REPORT DATA=summary HEADLINE HEADSKIP CENTER STYLE(REPORT)={JUST=CENTER} SPLIT='~' nowd 
	          SPANROWS LS=256;
	      COLUMNS _LABEL_  _MEAN_ _STD_ _MIN_ _MEDIAN_  _MAX_; 

	      DEFINE _LABEL_/ Order order=data  "Variable"  STYLE(COLUMN) = {JUST = L CellWidth=20%};


			DEFINE _MEAN_ / DISPLAY STYLE(COLUMN) = {JUST = C } format = comma10.0 ;
			DEFINE _STD_ / DISPLAY STYLE(COLUMN) = {JUST = C } format = comma10.0 ;
			DEFINE _MIN_ / DISPLAY STYLE(COLUMN) = {JUST = C } format = comma10.0;
			DEFINE _MEDIAN_ / DISPLAY STYLE(COLUMN) = {JUST = C  } format = comma10.0;
			DEFINE _MAX_ / DISPLAY STYLE(COLUMN) = {JUST = C } format = comma10.0 ;
	       
	   RUN; 

	   ODS text = "Summary statistics based on &N. physician-years.";

 
      ODS RTF CLOSE; 


/*------------------------------*/
/*----		Question 2		----*/
/*------------------------------*/

/* Define integration as:*/
/*	  INT = [(HOPD/(HOPD+OFFICE+ASC)>= 0.75] */
data all_mdppas (drop = pos: perc:)
	temp.excluded1 /* Physicians who are excluded due to having 0 share in office/op/asc */
	temp.always_integ; /* List of physicians who were already integrated in 2012 */
	set temp.MDPPAS_:;
	/* Drop therapists, PAs, NPs, LCSWs, Dentists */
	where spec_prim_1 not in ("42", "43", "50", "65", "67", "80", "89", "97", "C5"); 

	/* Calculate integration */
	OP_Ratio = pos_opd/(pos_office+pos_opd+pos_asc);
	if missing(OP_Ratio) then do;
		output temp.excluded1;
	end;
	if not missing(OP_Ratio) then do;
		Int = (OP_Ratio >= 0.75);
		output all_mdppas;
		if int = 1 and year = 2012 then output temp.always_integ;
	end;
run;

/* Prep to exclude physicians who were already integrated in 2012 */
proc sort data = all_mdppas;
	by npi year;
run;

proc sort data = temp.always_integ;
	by npi;
run;

/* Turn off compression because R doesn't like it */
options compress = no;

data temp.all_mdppas 
	temp.excluded2;
	merge all_mdppas (in=a drop = ) temp.always_integ (in=b keep = npi);
	by npi;


	if a and not b then output temp.all_mdppas;
		else if a and b then output temp.excluded2;
run;

options compress=binary;

/* Merge physician integration ratio with service counts */
proc sort data = temp.puf_phyr;
	by npi year;
run;

data temp.ppas_puf
	exclude_mismatch;
	merge temp.all_mdppas (in=a keep = npi sex birth_dt spec_prim_1 spec_prim_1_name year op_ratio int)
		temp.puf_phyr (in=b drop = npi rename = (npi_n = npi));
	by npi year;

	Age = intck("year", birth_dt, mdy(01, 01, year), "continuous");

	if a and b then output temp.ppas_puf;
		else output exclude_mismatch;
run;

/* Check that things make sense */
proc means data = temp.ppas_puf;
	var age ;
run;

proc freq data = temp.ppas_puf;
	table year;
run;
