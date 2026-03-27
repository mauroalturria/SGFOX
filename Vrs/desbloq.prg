Select  bloq
Go Top
Set Step On
Scan
	mimed = codmed
	midia = diasem
	hd = Val(Strtran(Left(Ttoc(horadesde,2),5),":",""))
	hh =  Val(Strtran(Left(Ttoc(horahasta,2),5),":",""))
	vd = fvigend
	vh = fvigenh
	tt = tipoturno
	Select * From turnoid Where codmed = mimed And midia = diasem And Between(fechatur,vd,vh) And Between(hhmmtur,hd,hh) and tt = tipoturno Into Cursor baja
	If Reccount('baja')>0
		*SELECT * FROM view12  Where codmed = mimed And midia = diasem And Between(fechatur,vd,vh) And Between(hhmmtur,hd,hh) AND tt = tipoturno	
*		Set Step On
		Update turnoid Set bloqueado = 1 Where codmed = mimed And midia = diasem And Between(fechatur,vd,vh) And Between(hhmmtur,hd,hh) AND tt = tipoturno
	Endif
	Select  bloq
Endscan
SET STEP ON
Skip
Do While !Eof()
	Do While mimed = codmed And midia = diasem And !Eof()
		If 	hhmmdes<hh
			If fecvigend<vh
				Set Step On
			Endif
		Endif
		mimed = codmed
		midia = diasem
		hd = hhmmdes
		hh = hhmmhas
		vd = fecvigend
		df= desde
		hf=hasta
		vh = fecvigenh
		Skip
	Enddo
	If codmed = 131
		Set Step On
	Endif
	mimed = codmed
	df= desde
	hf=hasta

	midia = diasem
	hd = hhmmdes
	hh = hhmmhas
	vd = fecvigend
	vh = fecvigenh
	Skip
Enddo




update medprestabk SET cantidad = 1 WHERE AT('EXTERNA',pre_descriprest)>0
update medprestabk SET cantidad = 1 WHERE AT('NIÑO SANO',pre_descriprest)>0
SELECT * FROM medprestabk WHERE AT('NIÑO SANO',pre_descriprest)>0
MODIFY VIEW ctrlunif
SELECT * FROM medprestabk WHERE AT('EXTERNA',pre_descriprest)>0
SELECT * FROM medprestabk WHERE AT('EXTERNA',pre_descriprest)>0 ORDER BY duracion, pre_descriprest 
SELECT * FROM medprestabk WHERE AT('DISTANC',pre_descriprest)>0 ORDER BY duracion, pre_descriprest
update medprestabk SET cantidad = 1  WHERE AT('DISTANC',pre_descriprest)>0
SELECT * FROM medprestabk WHERE AT('DISTANC',pre_descriprest)>0 ORDER BY duracion, pre_descriprest
SELECT * FROM medprestabk WHERE codesp= 'PSIC' GROUP BY DURACION,codprest
SELECT * FROM medprestabk WHERE INLIST(CODPREST,   42010148,   42010185 )
SELECT * FROM medprestabk WHERE INLIST(CODPREST,   42010148,   42010185 ) ORDER BY duracion, pre_descriprest
MODIFY VIEW medprestabk
SELECT * FROM medprestabk WHERE AT('ART',pre_descriprest)>0 ORDER BY duracion, pre_descriprest
update medprestabk SET cantidad = 1  WHERE CODPREST =    42030729
SELECT * FROM medprestabk WHERE AT('CONSULTA CONTROL',pre_descriprest)>0 ORDER BY duracion, pre_descriprest
SELECT * FROM medprestabk WHERE AT('CONSULTA CONTROL DEL RECIEN NACIDO',pre_descriprest)>0 ORDER BY duracion, pre_descriprest
update medprestabk SET cantidad = 1  WHERE AT('CONSULTA CONTROL DEL RECIEN NACIDO',pre_descriprest)>0
SELECT * FROM medprestabk WHERE AT('INTERDISCI',pre_descriprest)>0 ORDER BY duracion, pre_descriprest
update medprestabk SET cantidad = 1  WHERE AT('INTERDISCI',pre_descriprest)>0
update medprestabk SET cantidad = null  WHERE AT('INTERDISCI',pre_descriprest)>0
SELECT * FROM medprestabk WHERE AT('INTERDISCI',pre_descriprest)>0 ORDER BY duracion, pre_descriprest
SELECT * FROM medprestabk WHERE AT('CONSULTA CONTROL',pre_descriprest)>0 ORDER BY duracion, pre_descriprest
update medprestabk SET cantidad = null  WHERE AT('CONSULTA CONTROL DEL RECIEN NACIDO',pre_descriprest)>0
SELECT * FROM medprestabk WHERE AT('CONSULTA CONTROL',pre_descriprest)>0 ORDER BY duracion, pre_descriprest
SELECT * FROM medprestabk WHERE AT('CONSULTA CONTROL DEL RECIEN NACIDO',pre_descriprest)>0 ORDER BY duracion, pre_descriprest
update medprestabk SET DURACION ='01:00:00' WHERE AT('CONSULTA CONTROL DEL RECIEN NACIDO',pre_descriprest)>0
SELECT * FROM medprestabk WHERE AT('CONSULTA CONTROL DEL RECIEN NACIDO',pre_descriprest)>0 ORDER BY duracion, pre_descriprest
SELECT * FROM medprestabk WHERE AT('INTERDISCI',pre_descriprest)>0 ORDER BY duracion, pre_descriprest
update medprestabk SET DURACION ='01:00:00' WHERE AT('INTERDISCI',pre_descriprest)>0
SELECT * FROM medprestabk WHERE AT('INTERDISCI',pre_descriprest)>0 ORDER BY duracion, pre_descriprest
SELECT * FROM medprestabk WHERE AT('NIÑO SANO',pre_descriprest)>0
SELECT VAL(LEFT(duracion,2)+SUBSTR(duracion,4,2)) as dura,* FROM medprestabk,franjadrive WHERE medprestabk.codmed = franjadrive.codmed ;
AND medprestabk.diasem = franjadrive.diasem GROUP BY medprestabk.ID iNTO CURSOR cambio
BROWSE LAST
SELECT VAL(LEFT(duracion,2)+SUBSTR(duracion,4,2)) as dura,* FROM medprestabk,franjadrive WHERE medprestabk.codmed = franjadrive.codmed ;
AND medprestabk.diasem = franjadrive.diasem AND ISNULL(CANTIDAD) GROUP BY medprestabk.ID iNTO CURSOR cambio
BROWSE LAST
SELECT * FROM CAMBIO ORDER BY DURA
SELECT * FROM CAMBIO WHERE hhmmdes_a <=  hhmmhas_b ;
AND hhmmhas_a>= hhmmdes_b ORDER BY DURA
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b ;
AND hhmmhas_a>= hhmmdes_b ORDER BY DURA
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b ;
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b ;
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a WHERE dura<16
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b AND dura<16;
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a   dura<16
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b AND dura<16;
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a
SELECT * FROM medprestabk WHERE id in (SELECT id_a 
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b AND dura<16;
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a INTO CURSOR cambiadur
SELECT * FROM medprestabk WHERE id in (SELECT id_a FROM cambiadur)
SELECT * FROM medprestabk WHERE AT('EXTERNA',pre_descriprest)>0
SELECT * FROM medprestabk WHERE AT('EXTERNA',pre_descriprest)>0 ORDER BY duracion, pre_descriprest
SELECT * FROM medprestabk WHERE AT('EXTERNA',pre_descriprest)>0 ORDER BY  pre_descriprest
update medprestabk SET cantidad = null  WHERE AT('EXTERNA',pre_descriprest)>0
update medprestabk SET cantidad = 1  WHERE CODPREST =    42030455
SELECT * FROM medprestabk WHERE AT('EXTERNA',pre_descriprest)>0 ORDER BY  pre_descriprest
SELECT VAL(LEFT(duracion,2)+SUBSTR(duracion,4,2)) as dura,* FROM medprestabk,franjadrive WHERE medprestabk.codmed = franjadrive.codmed ;
AND medprestabk.diasem = franjadrive.diasem AND ISNULL(CANTIDAD) GROUP BY medprestabk.ID iNTO CURSOR cambio
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b AND dura<16;
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a INTO CURSOR cambiadur
SELECT * FROM medprestabk WHERE id in (SELECT id_a FROM cambiadur)
COPY TO duracionanterior
COPY TO duracionanterior TYPE xl5
SELECT * FROM medprestabk  WHERE id in (SELECT id_a FROM cambiadur)
SELECT * FROM medprestabk  WHERE id in (SELECT id_a FROM cambiadur) ORDER BY codesp,nombre
MODIFY VIEW medpresta
SELECT * FROM medprestabk  WHERE id in (SELECT id_a FROM cambiadur) AND codmed = 843 ORDER BY codesp,nombre
MODIFY VIEW turnoid
MODIFY VIEW turnoidrank
SELECT * FROM medprestabk  WHERE id in (SELECT id_a FROM cambiadur) AND LEFT(codesp,2)="EC" ORDER BY codesp,nombre
SELECT 2
BROWSE LAST
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b AND dura<16 AND codserv<>7900;
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a INTO CURSOR cambiadur
BROWSE LAST
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b AND dura<16 AND !INLIST(codserv,7900,7300);
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a INTO CURSOR cambiadur
BROWSE LAST
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b AND dura<16 AND !INLIST(codserv,2200,7900,7300);
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a INTO CURSOR cambiadur
BROWSE LAST
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b AND dura<16 AND !INLIST(codserv,2200,7900,7300);
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a GROUP BY codserv INTO CURSOR cambiadur
BROWSE LAST
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b AND dura<16 AND !INLIST(codserv,7900,7300);
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a GROUP BY codserv INTO CURSOR cambiadur
MODIFY VIEW gua_pac
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b AND dura<16 AND !INLIST(codserv,7900,7300);
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a GROUP BY codserv INTO CURSOR cambiadur
COPY TO cambiadura
SELECT * FROM medprestabk  WHERE id in (SELECT id_a FROM cambiadur) AND codserv = 7300 ORDER BY codesp,nombre
SELECT * FROM medprestabk  WHERE  codserv = 7300 ORDER BY codesp,nombre
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b AND dura<16 AND !INLIST(codserv,7900);
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a GROUP BY codserv INTO CURSOR cambiadur
SELECT * FROM medprestabk  WHERE id in (SELECT id_a FROM cambiadur) ORDER BY codesp,nombre
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b AND dura<16 AND !INLIST(codserv,7900,7300);
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a  INTO CURSOR cambiadur
SELECT * FROM medprestabk  WHERE id in (SELECT id_a FROM cambiadur) ORDER BY codesp,nombre
SELECT 13
COPY TO cambiadur
COPY TO duracionanterior
COPY TO duracionanterior TYPE xl5
UPDATE  medprestabk  SET duracion = '00:30:00' ,cantidad = 1 WHERE id in (SELECT id_a FROM cambiadur) 
USE franjadrive AGAIN IN 0 ALIAS Franjadrive_a
SELECT Franjadrive_a
BROWSE LAST
SELECT 13
CREATE VIEW REMOTE
MODIFY VIEW medprestabk
SELECT 13
SELECT VAL(LEFT(duracion,2)+SUBSTR(duracion,4,2)) as dura,* FROM medprestapp,franjadrive WHERE medprestapp.codmed = franjadrive.codmed ;
AND medprestapp.diasem = franjadrive.diasem AND ISNULL(CANTIDAD) GROUP BY medprestapp.ID iNTO CURSOR cambio
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b AND dura<16 AND !INLIST(codserv,7900);
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a  INTO CURSOR cambiadur
SELECT * FROM medprestapp  WHERE id in (SELECT id_a FROM cambiadur) ORDER BY codesp,nombre
UPDATE  medprestapp  SET duracion = '00:30:00' ,cantidad = 1 WHERE id in (SELECT id_a FROM cambiadur) 

UPDATE  medprestabk  SET duracion = '00:30:00' ,cantidad = 1 WHERE id in (SELECT id_a FROM cambiadur) 
update medprestapp SET DURACION ='01:00:00' WHERE AT('NIÑO SANO',pre_descriprest)>0
SELECT * FROM medprestapp  WHERE id in (SELECT id_a FROM cambiadur) AND AT('EXTERNA',pre_descriprest)>0 ORDER BY duracion

update medprestapp SET DURACION ='00:15:00' WHERE codprest = 42030455
