public mcon1, mc,ant,ef
do sp_conexion

mApv_Reshistclin  = "Mot.Cons.:49 AÑOS HIPERT SC"+chr(10)+;
	+chr(10)+;
	"DEL 26.10.15  ATG <10 "+chr(10)+;
	"DEL 26.11.15  ATPO 7.9  NEG , TRABS 3 (HASTA 2)  CEMIC "+chr(10)+;
	+chr(10)+;
	"ECO DE TIROIDES DEL 15.9.15"+chr(10)+;
	"LD 36X14X15"+chr(10)+;
	"LI 32X11X14 "+chr(10)+;
	"ISTMO 2 "+chr(10)+;
	"NO IMAGENES NODUALRES SOLIDAS NI QUISTICAS "+chr(10)+;
	+chr(10)+;
	"C Y C (PEDIDO POR DR FARIAS )"+chr(10)+;
	"28.10.15  "+chr(10)+;
	"1 H 5.1 %  "+chr(10)+;
	"24 HS 25.9 % "+chr(10)+;
	"CURVA NORMAL "+chr(10)+;
	"LA GL TIROIDES SE REGISTRA ON FORMA TAMAÑO Y POSICION CONSERVADAS , DISTRIBUCION IRREGULAR DEL RADIOTRAZADOR POR MAYOR CAPTACION EN LI (NODULO CALIENTE? )"+chr(10)+;
	"Antec.:MH: BISOPROLOL, ATORVASTATINA, AAS, DILTIAZEM, OMEPRAZOL "+chr(10)+;
	"IAM EN EL 2010 "+chr(10)+;
	"E 2 C 2 (< 4 KG)"+chr(10)+;
	"HISTERECTOMIA A LOS 36 AÑOS SIN OOFORECTOMIA "+chr(10)+;
	+chr(10)+;
	"ATC FLIARES : SOBRINA HIPOTIROIDISMO , NO DBT , NO ENF CELIACA , MADRE IAM"+chr(10)+;
	"Evol.:CYC DEL 23.3.16  "+chr(10)+;
	"1 H 10% "+chr(10)+;
	"24 HS  23%"+chr(10)+;
	"48 HS 23%"+chr(10)+;
	+chr(10)+;
	"ACTUALIZO LABO , EN PROX VER MMI "+chr(10)+;
	"PACIENTE QUE MAL TRATA , "+chr(10)
jj=0
if vartype(mApv_Reshistclin ) #"C"
	mApv_Reshistclin  = ''
endif
if len(mApv_Reshistclin )>0
	jj = int(len(alltrim(mApv_Reshistclin ))/250)
	for i = 0 to jj
		clin = "linea" + padl(i,3,"0")
		public &clin
	next

	mApvReshistclin  = prg_concat(alltrim(mApv_Reshistclin ),0)
else
	mApvReshistclin  = "''"
endif
if vartype(mApvReshistclin  )#"C"
	mApvReshistclin  = "''"
endif
set step on
for tt =  231868 to 231875
	mid = tt

	mRet = sqlexec(mcon1,"Update TabAutPrevias Set  Apv_resprev = '...' ,Apv_Reshistclin = " + mApvReshistclin + " Where Id = ?mId ")

next tt
do sp_desconexion

