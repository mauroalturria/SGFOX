*!*	for yu = 37250 to 37262
*!*		insert into tabbonodet (bonoserie,codambito,nrobono,nroregistrac,tipobono,usuario) values ("Z",1,yu,0,5,'')
*!*	next yu
SET STEP ON
SELECT bonos

SCAN
bh= INT(bonos.nrohasta)
bd = INT(bonos.nrodesde)
serie = bonoserie
mt = idbono
REQUERY('tabbonodet')
IF RECCOUNT('tabbonodet')>0
	SELECT COUNT(id) as cuantos,MAX(nrobono) as hasta,Min(nrobono) as desde FROM tabbonodet INTO CURSOR mwkcontrol
	SELECT bonos
	replace bonosv WITH  mwkcontrol.cuantos,bdesde  WITH  mwkcontrol.desde ,bhasta WITH  mwkcontrol.hasta
	
endif
SELECT bonos

ENDSCAN


for mnrobono = 79751 to 79776
										
		insert into TabbonoDet (BonoSerie, NroBono,TipoBono,usuario)   values ( '', mnrobono, 8 ,'')
			
	
	next