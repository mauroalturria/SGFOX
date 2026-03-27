****
* Protocolos del despacho
*****
parameters mnrodesp


*!*		mret=SQLEXEC(mcon1,"SELECT	Despachosdetallenfhc.CORRIDA, Despachosdetallenfhc.NROADM,"+;
*!*			" Despachosdetallenfhc.NUIN, Despachosdetallenfhc.SECUENCIA,"+;
*!*			" Nfrendinv.corrida, Nfrendinv.nroAdmision, Nfrendinv.sq, Nfrendinv.tc,"+;
*!*			" Nfrendinv.vale,tabambulatorio.*,guardia.*,PAC_nombrepaciente,PAC_codhci, PAC_codhce,"+;
*!*			" PAC_Tipopac		"+;
*!*			" FROM Despachosdetallenfhc "+;
*!*			" inner join Nfrendinv on (Despachosdetallenfhc.CORRIDA=Nfrendinv.corrida "+;
*!*			" and Despachosdetallenfhc.NROADM = Nfrendinv.nroAdmision "+;
*!*			" and Despachosdetallenfhc.SECUENCIA = Nfrendinv.periodo )"+;
*!*			" inner join pacientes on  Despachosdetallenfhc.NROADM = pacientes.pac_codadmision "+;
*!*			" left join TabAmbulatorio on TabAmbulatorio.nrovale = Nfrendinv.vale "+;
*!*			" left join guardiavale on guardiavale.nrovale = Nfrendinv.vale "+;
*!*			" left join guardia on guardiavale.protocolo = guardia.protocolo"+;
*!*			" where NUIN= ?mnrodesp " +;
*!*			" group by vale ","mwkprotodesp")

*!*	mret=SQLEXEC(mcon1,"SELECT	Despachosdetallenfhc.CORRIDA, Despachosdetallenfhc.NROADM,"+;
*!*			" Despachosdetallenfhc.NUIN, Despachosdetallenfhc.SECUENCIA,"+;
*!*			" Nfrendinv.corrida, Nfrendinv.nroAdmision, Nfrendinv.sq, Nfrendinv.tc,"+;
*!*			" Nfrendinv.vale,tabambulatorio.*,guardia.*,PAC_nombrepaciente,PAC_codhci, PAC_codhce,"+;
*!*			" PAC_Tipopac,"+;
*!*			" afiliacion.afi_nroafiliado,entidades.ent_descrient,"+;
*!*			" registracio.reg_nrohclinica,reg_telefonos,reg_domicilio,reg_numdocumento,"+;
*!*			" especialid.esp_descripcion, "+;
*!*			" valesasist.val_codservvale,valesasist.val_codmnemoserv,val_codsector " +;		
*!*			" FROM Despachosdetallenfhc "+;
*!*			" inner join Nfrendinv on (Despachosdetallenfhc.CORRIDA=Nfrendinv.corrida "+;
*!*			" and Despachosdetallenfhc.NROADM = Nfrendinv.nroAdmision "+;
*!*			" and Despachosdetallenfhc.SECUENCIA = Nfrendinv.periodo )"+;
*!*			" inner join pacientes on  Despachosdetallenfhc.NROADM = pacientes.pac_codadmision "+;
*!*			" left join TabAmbulatorio on TabAmbulatorio.nrovale = Nfrendinv.vale "+;
*!*			" left join guardiavale on guardiavale.nrovale = Nfrendinv.vale "+;
*!*			" left join guardia on guardiavale.protocolo = guardia.protocolo "+;
*!*			" left join afiliacion on guardia.nroregistrac = afiliacion.registracio" + ;
*!*			" left join PRESTACIONS on prestacions.pre_codprest	= guardia.codprest" + ;
*!*			" left join especialid on prestacions.pre_especialidad = especialid.esp_codesp " + ;
*!*			" left join entidades on guardia.codent = entidades.ent_codent" + ;
*!*			" left join registracio on guardia.nroregistrac = registracio.reg_nroregistrac " + ;		
*!*			" left join valesasist on Nfrendinv.vale = valesasist.VAL_CODVALEASIST " + ;
*!*			" where NUIN= ?mnrodesp " +;
*!*			" group by vale ","mwkprotodesp")
 
*!*	 **** Marcelo Torres, comentado el 10/03/2014 
*!*	mret=SQLEXEC(mcon1,"SELECT	Despachosdetallenfhc.CORRIDA, Despachosdetallenfhc.NROADM,"+;
*!*			" Despachosdetallenfhc.NUIN, Despachosdetallenfhc.SECUENCIA,"+;
*!*			" Nfrendinv.corrida, Nfrendinv.nroAdmision, Nfrendinv.sq, Nfrendinv.tc,"+;
*!*			" Nfrendinv.vale,tabambulatorio.*,guardia.*,PAC_nombrepaciente,PAC_codhci, PAC_codhce,"+;
*!*			" PAC_Tipopac,"+;
*!*			" afiliacion.afi_nroafiliado,"+;
*!*			" registracio.reg_nrohclinica,reg_telefonos,reg_domicilio,reg_numdocumento,"+;
*!*			" especialid.esp_descripcion, "+;
*!*			" valesasist.val_codservvale,valesasist.val_codmnemoserv,val_codsector " +;		
*!*			" FROM Despachosdetallenfhc "+;
*!*			" inner join Nfrendinv on (Despachosdetallenfhc.CORRIDA=Nfrendinv.corrida "+;
*!*			" and Despachosdetallenfhc.NROADM = Nfrendinv.nroAdmision "+;
*!*			" and Despachosdetallenfhc.SECUENCIA = Nfrendinv.periodo )"+;
*!*			" inner join pacientes on  Despachosdetallenfhc.NROADM = pacientes.pac_codadmision "+;
*!*			" left join TabAmbulatorio on TabAmbulatorio.nrovale = Nfrendinv.vale "+;
*!*			" left join guardiavale on guardiavale.nrovale = Nfrendinv.vale "+;
*!*			" left join guardia on guardiavale.protocolo = guardia.protocolo "+;
*!*			" left join afiliacion on guardia.nroregistrac = afiliacion.registracio" + ;
*!*			" left join PRESTACIONS on prestacions.pre_codprest	= guardia.codprest" + ;
*!*			" left join especialid on prestacions.pre_especialidad = especialid.esp_codesp " + ;
*!*			" left join registracio on guardia.nroregistrac = registracio.reg_nroregistrac " + ;		
*!*			" left join valesasist on Nfrendinv.vale = valesasist.VAL_CODVALEASIST " + ;
*!*			" where NUIN= ?mnrodesp " +;
*!*			" group by vale ","mwkprotodesp")


mret=SQLEXEC(mcon1,"SELECT	Despachosdetallenfhc.CORRIDA, Despachosdetallenfhc.NROADM,"+;
		" Despachosdetallenfhc.NUIN, Despachosdetallenfhc.SECUENCIA,"+;
		" Nfrendinv.corrida, Nfrendinv.nroAdmision, Nfrendinv.sq, Nfrendinv.tc," + ;
		" Nfrendinv.vale,tabambulatorio.*,guardia.*,PAC_nombrepaciente,PAC_codhci, PAC_codhce," + ;
		" PAC_Tipopac,PAC_fechaadmision		" + ;
		" FROM Despachosdetallenfhc " + ;
		" inner join Nfrendinv on (Despachosdetallenfhc.CORRIDA=Nfrendinv.corrida " + ;
		" and Despachosdetallenfhc.NROADM = Nfrendinv.nroAdmision " + ;
		" and Despachosdetallenfhc.SECUENCIA = Nfrendinv.periodo )" + ;
		" inner join pacientes on  Despachosdetallenfhc.NROADM = pacientes.pac_codadmision " + ;
		" left join TabAmbulatorio on TabAmbulatorio.nrovale = Nfrendinv.vale " + ;
		" left join guardiavale on guardiavale.nrovale = Nfrendinv.vale " + ;
		" left join guardia on guardiavale.protocolo = guardia.protocolo" + ;		
		" where NUIN= ?mnrodesp " + ;
		" group by vale ","mwkprotodesp")
		
		  
If mRet<=0
	Messagebox("ERROR EN LA LECTURA DE DATOS PROTOCOLO/DESPACHOS",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
Endif

SELECT * FROM mwkprotodesp ORDER BY nroadmision DESC INTO CURSOR mwkprotodespacho

select * from mwkprotodespacho where id>0 or id1>0 group by protocolo, protocolo1 into cursor mwkprotodespa1
**select * from mwkprotodespacho WHERE id=0 AND id1=0 into cursor mwkprotodespa2
SELECT * FROM mwkprotodespacho WHERE NOT exists ;
(SELECT mwkprotodespa1.nroadm FROM mwkprotodespa1 WHERE mwkprotodespa1.nroadm = mwkprotodespacho.nroadm) ;
AND mwkprotodespacho.id=0 AND mwkprotodespacho.id1=0 ;
 INTO CURSOR mwkprotodespa2

**select * from mwkprotodesp WHERE (id=0 AND id1=0) AND val_codsector in ('AMB','GUA') into cursor mwkprotodespa2

SELECT * FROM mwkprotodespa1 ;
union ;
select * FROM mwkprotodespa2 ;
INTO CURSOR mwkprotodespa
