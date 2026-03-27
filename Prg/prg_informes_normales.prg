Parameters tfechdesde,tfechasta,MLHERE
mwhere      = ""
LCEXPRESION = "SIN SERVICIO"
Create Cursor meses (nummes I Autoinc Unique,nommes c (20) Not Null)
Insert Into meses (nommes) Values ("Enero")
Insert Into meses (nommes) Values ("Febrero")
Insert Into meses (nommes) Values ("Marzo")
Insert Into meses (nommes) Values ("Abril")
Insert Into meses (nommes) Values ("Mayo")
Insert Into meses (nommes) Values ("Junio")
Insert Into meses (nommes) Values ("Julio")
Insert Into meses (nommes) Values ("Agosto")
Insert Into meses (nommes) Values ("Setiembre")
Insert Into meses (nommes) Values ("Octubre")
Insert Into meses (nommes) Values ("Noviembre")
Insert Into meses (nommes) Values ("Diciembre")
*!* ELABORACIÓN DE LA CONSULTA Y EJECUCIÓN DE LA MISMA
*NORMAL	   		6
*NO NORMAL		7
*NEGATIVO	    21
*NO NEGATIVO	20

mwhere = " fechainforme BETWEEN ?tfechdesde and ?tfechasta and informes.estadoinforme < 5 " +;
	" and (tabestados.descrip = 'NORMAL' OR tabestados.descrip = 'NO NORMAL' "+;
	" OR tabestados.descrip='NEGATIVO' OR tabestados.descrip='NO NEGATIVO' )"+;
	" and val_tipopaciente In ('INT','GUA','AMB')" + Iif(!Empty(MLHERE)," AND " + MLHERE,"")

textsql= " SELECT informes.id as numinfo,"+;
	" nroprotocolo,nrovale,fechainforme,val_tipopaciente as sector,"+;
	" estadoinforme,tipolog,tabestados.descrip,fechalog,SER_descripserv as servicios"+;
	" from informes"+;
	" inner JOIN VALESASIST  ON nroVALE   =  VAL_CODVALEASIST"+;
	" inner JOIN informeslog ON informes.id = idinforme"+;
	" inner join tabestados  on informeslog.tipolog = tabestados.estado and propietario=10"+;
	" inner JOIN servicios   ON SER_codserv =  CodServVale"+;
	iif(Empty(mwhere)," "," Where " + mwhere)

If !prg_ejecutosql(textsql,'mwkinfonor')
	Messagebox("NO SE REALIZO CONSULTA",64,"VALIDACIÓN")
	Return .F.
Endif

*!* CURSOR DE INTERNACIÓN
Select * From mwkinfonor Where sector = 'INT';
	INTO Cursor MWKINFINT

*!* LOS DATOS TIPOLOG LOS TRANSFORMO EN CAMPOS
Select Count(numinfo) As cnorm,;
	Month(Nvl(fechainforme,{//})) As Mesnor,;
	servicios From MWKINFINT Where Descrip = 'NORMAL' ;
	GROUP By Mesnor,servicios ;
	INTO Cursor MWKINFINTNORM

Select Count(numinfo) As cnonorm,;
	Month(Nvl(fechainforme,{//})) As Mesnonor,;
	servicios From MWKINFINT Where Descrip = 'NO NORMAL' ;
	GROUP By Mesnonor,servicios;
	INTO Cursor MWKINFINTNONORM

Select Count(numinfo) As cneg,;
	Month(Nvl(fechainforme,{//})) As Mesneg,;
	servicios From MWKINFINT Where Descrip = 'NEGATIVO' ;
	GROUP By Mesneg,servicios ;
	INTO Cursor MWKINFINTNEG


Select Count(numinfo) As cnoneg,;
	Month(Nvl(fechainforme,{//})) As Mesnoneg,;
	servicios From MWKINFINT Where Descrip = 'NO NEGATIVO';
	GROUP By Mesnoneg,servicios ;
	INTO Cursor MWKINFINTNONEG

Select Nvl(cnoneg,000000000000) As cnoneg ,Nvl(cnonorm,000000000000) As cnonorm,Nvl(cneg,000000000000) As cneg,;
	Nvl(cnorm,000000000000) As cnorm,nommes As mes,Nvl(MWKINFINTNONEG.servicios,LCEXPRESION) As SER,;
	NVL(MWKINFINTNEG.servicios,LCEXPRESION) As SER1,Nvl(MWKINFINTNONORM.servicios,LCEXPRESION) As SER2,;
	NVL(MWKINFINTNORM.servicios,LCEXPRESION) As SER3;
	from meses ;
	LEFT Join   MWKINFINTNONORM	 On Mesnonor = nummes  ;
	LEFT Join   MWKINFINTNONEG 	 On Mesnoneg = nummes ;
	LEFT Join   MWKINFINTNORM  	 On Mesnor   = nummes ;
	LEFT Join   MWKINFINTNEG   	 On Mesneg   = nummes ;
	GROUP BY nummes,SER;
	ORDER By nummes;
	into Cursor mwkinfoint


*WHERE nummes = Mesnonor  Or Mesnoneg     = nummes ;
OR Mesnor    = nummes Or Mesneg = nummes ;

Select *,SER As servicios From mwkinfoint;
	WHERE (SER = SER2 Or SER1 = SER3) Or (SER = SER3 Or SER1 = SER2);
	into Cursor mwkinfoint

*MWKINFINTNONORM,MWKINFINTNONEG,MWKINFINTNEG,MWKINFINTNORM,

*!* CURSOR DE GUARDIA
Select * From mwkinfonor Where sector = 'GUA';
	INTO Cursor MWKINFGUA
*!* LOS DATOS TIPOLOG LOS TRANSFORMO EN CAMPOS
Select Count(numinfo) As cnorm,;
	IIF(Isnull(fechainforme),fechainforme,Month(fechainforme)) As mes,;
	servicios From MWKINFGUA Where Descrip = 'NORMAL' ;
	GROUP By mes,servicios ;
	INTO Cursor MWKINFGUANORM

Select Count(numinfo) As cnonorm,;
	IIF(Isnull(fechainforme),fechainforme,Month(fechainforme)) As mes,;
	servicios From MWKINFGUA Where Descrip = 'NO NORMAL' ;
	GROUP By mes,servicios ;
	INTO Cursor MWKINFGUANONORM

Select Count(numinfo) As cneg,;
	IIF(Isnull(fechainforme),fechainforme,Month(fechainforme)) As mes,;
	servicios From MWKINFGUA Where Descrip = 'NEGATIVO' ;
	GROUP By mes,servicios ;
	INTO Cursor MWKINFGUANEG

Select Count(numinfo) As cnoneg,;
	IIF(Isnull(fechainforme),fechainforme,Month(fechainforme)) As mes,servicios;
	FROM MWKINFGUA Where Descrip = 'NO NEGATIVO';
	GROUP By mes,servicios ;
	INTO Cursor MWKINFGUANONEG

Select Nvl(cnoneg,000000000000) As cnoneg ,Nvl(cnonorm,000000000000) As cnonorm,Nvl(cneg,000000000000) As cneg,;
	Nvl(cnorm,000000000000) As cnorm,nommes As mes,Nvl(MWKINFGUANONEG.servicios,LCEXPRESION) As SER,;
	NVL(MWKINFGUANEG.servicios,LCEXPRESION) As SER1,Nvl(MWKINFGUANONORM.servicios,LCEXPRESION) As SER2,;
	NVL(MWKINFGUANORM.servicios,LCEXPRESION) As SER3;
	from meses ;
	LEFT Join MWKINFGUANONORM On MWKINFGUANONORM.mes = nummes ;
	LEFT Join MWKINFGUANONEG  On MWKINFGUANONEG.mes  = nummes ;
	LEFT Join MWKINFGUANORM   On MWKINFGUANORM.mes 	 = nummes ;
	LEFT Join MWKINFGUANEG    On MWKINFGUANEG.mes  	 = nummes ;
	GROUP BY nummes,SER;
	Order By nummes;
	into Cursor mwkinfogua
	
*WHERE nummes = MWKINFGUANONORM.mes Or MWKINFGUANONEG.mes = nummes ;
	OR MWKINFGUANORM.mes = nummes Or MWKINFGUANEG.mes = nummes 	

Select *, SER As servicios From  mwkinfogua;
	WHERE (SER = SER2 OR  SER1=SER3) Or (SER = SER3 OR SER1 = SER2);
	into Cursor mwkinfogua

*!* CURSOR DE AMBULATORIO
Select * From mwkinfonor Where sector = 'AMB';
	INTO Cursor MWKINFAMB
*!* LOS DATOS TIPOLOG LOS TRANSFORMO EN CAMPOS
Select Count(numinfo) As cnorm,;
	IIF(Isnull(fechainforme),fechainforme,Month(fechainforme)) As mes,;
	servicios From MWKINFAMB Where Descrip = 'NORMAL' ;
	GROUP By mes,servicios ;
	INTO Cursor MWKINFAMBNORM

Select Count(numinfo) As cnonorm,;
	IIF(Isnull(fechainforme),fechainforme,Month(fechainforme)) As mes,;
	servicios From MWKINFAMB Where Descrip = 'NO NORMAL' ;
	GROUP By mes,servicios ;
	INTO Cursor MWKINFAMBNONORM

Select Count(numinfo) As cneg,;
	IIF(Isnull(fechainforme),fechainforme,Month(fechainforme)) As mes,;
	servicios From MWKINFAMB Where Descrip = 'NEGATIVO' ;
	GROUP By mes,servicios;
	INTO Cursor MWKINFAMBNEG

Select Count(numinfo) As cnoneg,;
	IIF(Isnull(fechainforme),fechainforme,Month(fechainforme)) As mes,;
	servicios From MWKINFAMB Where Descrip = 'NO NEGATIVO';
	GROUP By mes,servicios ;
	INTO Cursor MWKINFAMBNONEG

Select Nvl(cnoneg,000000000000) As cnoneg ,Nvl(cnonorm,000000000000) As cnonorm,Nvl(cneg,000000000000) As cneg,;
	Nvl(cnorm,000000000000) As cnorm,nommes As mes,Nvl(MWKINFAMBNONEG.servicios,LCEXPRESION) As SER,;
	NVL(MWKINFAMBNEG.servicios,LCEXPRESION) As SER1,Nvl(MWKINFAMBNONORM.servicios,LCEXPRESION) As SER2,;
	NVL(MWKINFAMBNORM.servicios,LCEXPRESION) As SER3;
	from meses ;
	LEFT Join MWKINFAMBNONORM On MWKINFAMBNONORM.mes = nummes ;
	LEFT Join MWKINFAMBNONEG  On MWKINFAMBNONEG.mes  = nummes ;
	LEFT Join MWKINFAMBNORM   On MWKINFAMBNORM.mes 	 = nummes ;
	LEFT Join MWKINFAMBNEG    On MWKINFAMBNEG.mes  	 = nummes ;
	GROUP BY nummes,SER;
	Order By nummes;
	into Cursor mwkinfoamb
	
*HERE nummes = MWKINFAMBNONORM.mes Or MWKINFAMBNONEG.mes = nummes ;
	OR MWKINFAMBNORM.mes = nummes Or MWKINFAMBNEG.mes = nummes 

Select *,SER As servicios From mwkinfoamb;
	WHERE (SER = SER2 OR  SER1 = SER3) Or (SER = SER3 OR SER1 = SER2);
	into Cursor mwkinfoamb

Use In meses
Use In mwkinfonor
Use In MWKINFGUA
Use In MWKINFAMB
Use In MWKINFINT
Use In MWKINFAMBNONORM
Use In MWKINFAMBNONEG
Use In MWKINFAMBNORM
Use In MWKINFAMBNEG
Use In MWKINFGUANONORM
Use In MWKINFGUANONEG
Use In MWKINFGUANORM
Use In MWKINFGUANEG
Use In MWKINFINTNONORM
Use In MWKINFINTNONEG
Use In MWKINFINTNORM
Use In MWKINFINTNEG