Lparameters mdes, mhas

*mfecdes = Dtot(mdes)
*mfechas = Dtot(mhas)+1

mfecdes = mdes
mfechas = mhas

&& Derivaciones Totales
Do sp_busco_derivaciones With  mfecdes, mfechas

&& Derivaciones ingresadas
Select fechahora,REG_nombrepac,ent_descrient,Substr(Alltrim(diagnostico),1,200) As diag, ;
	sectorint,estado1,Iif(fechahoraingreso > Ctot('01/01/1900'),Ttoc(fechahoraingreso),Space(16)) As fechahorai, ;
	nvl(habitacion,Space(50)) + ' ' + Nvl(cama,'') As habcam , ;
	observa,codent,codint,denpolicial,derivadopor,edad,estado, ;
	notifica,nroafi,nroregistrac,padron,sexo,traslado,usuario,Id,diagnostico,ltipreg ;
	from mwkderiva ;
	where estado = 2 ; 
	Order By fechahora ;
	Into Cursor mwkderivaIng
	
	
&& Derivaciones rechazadas
Select fechahora,REG_nombrepac,ent_descrient,Substr(Alltrim(diagnostico),1,200) As diag, ;
	sectorint,estado1,Iif(fechahoraingreso > Ctot('01/01/1900'),Ttoc(fechahoraingreso),Space(16)) As fechahorai, ;
	nvl(habitacion,Space(50)) + ' ' + Nvl(cama,'') As habcam , ;
	observa,codent,codint,denpolicial,derivadopor,edad,estado, ;
	notifica,nroafi,nroregistrac,padron,sexo,traslado,usuario,Id,diagnostico,ltipreg ;
	from mwkderiva ;
	where estado = 1 ; 
	Order By fechahora ;
	Into Cursor mwkderivaRecha


Select Ttod(mwkderivaIng.fechahora)As fecha ,Count(*) As cuenta From mwkderivaIng Group By fecha Into Cursor mwkingresa

Select Ttod(mwkderivaRecha.fechahora)As fecha ,Count(*) As cuenta From mwkderivaRecha Group By fecha Into Cursor mwkrechaza

Select Ttod(mwkderiva.fechahora) As fecha, Count(*) As cuenta From mwkderiva Group By fecha Into Cursor mwkderivados

Use In Select("mwkderivaIng")
Use In Select("mwkderivarecha")
Use In Select("mwkderiva")
Use In Select("mwkderiva4a")
Use In Select("mwkderiva4")
Use In Select("mwkderiva3")
Use In Select("mwkderiva3a")
Use In Select("mwkfecserv")

