set escape on
clear
public mh1

mfechades = ctod("22/07/2009")
mfechahas = ctod("22/07/2009")

mfechades = ctod("06/07/2009")
mfechahas = ctod("06/07/2009")

mh1 = fcreate("c:\salida3.txt")
msep = "" + chr(9) 
mTipoPac = " and Pac_TipoPac in (1) "

mret = SqlExec(mcon1, "Select Pacientes.pac_codadmision,  " + ;
		"Pacientes.Pac_nombrepaciente, " + ;
		"Pacientes.Pac_FECHAADMISION, " + ;
		"Pacientes.Pac_FECHAALTA, " + ;
		"Pacientes.Pac_DESCRIPDIAGN, " + ;
		"Pacientes.Pac_denuncia, " + ;
		"Pacientes.PAC_motivoalta, " + ;
		"Pacientes.Pac_Edad, " + ;
		"Pacientes.PAC_motivoalta, " + ;
		"Pacientes.Pac_descripdiagegr, " + ;
		"a.descrip as cie10ing, " + ;
		"b.Descrip as cie10egre, " + ;
		"coberturas.COB_CODENTIDAD, " + ;
		"Entidades.ENT_DESCRIENT, " + ;
		"ORDENINTERNAC.ORIOBSERVAC, " + ;
		"REGISTRACIO.Reg_numdocumento, " + ;
		"AFILIACION.AFI_NROAFILIADO " + ;
		"from Pacientes " + ;
		"Left join tabcie10 as a on a.Id = Pacientes.Pac_Codcie10diagn " + ;
		"Left join tabcie10 as b on b.Id = Pacientes.Pac_Codcie10diagegr " + ; 
		"Left join coberturas on coberturas.COB_pacientes = Pacientes.Pac_CodAdmision " + ;
		"Left Join Entidades on ENTIDADES.ENT_CODENT = coberturas.COB_CODENTIDAD " + ;
		"Left join ORDENINTERNAC on ORICODADMISION = Pacientes.Pac_CodAdmision " + ;
		"left join REGISTRACIO on REG_NROREGISTRAC = Pacientes.Pac_codhci " + ;
		"left join AFILIACION on AFILIACION.Registracio = Pacientes.Pac_codhci " + ;
		"where Pac_FECHAALTA = ?mfechahas and Pac_FECHAALTA is not null " + mTipoPac + ;
		"", "mwkPacientes")

*!*	?mret 		

mret = SqlExec(mcon1, "Select Sectores.*, SectorAgrup  " + ;
		"from Sectores " + ;
		"left join secagrup on sec_codsector = secagrup.sector " + ;
		"where sec_internacion = 1 " + ;
		"Order by sec_codsector", "mwkSectores")

*!*	?mret 		
Select Distinct SectorAgrup ;
	from mwkSectores ;
	Order by SectorAgrup ;
	into cursor cSectAgru


menca = "Entidad" 
menca = menca + msep + "Descripción" 
menca = menca + msep + "Nro.Admision" 
menca = menca + msep + "Paciente" 
menca = menca + msep + "Nro.Afiliado" 
menca = menca + msep + "F.Admisión" 
menca = menca + msep + "F.alta" 
&& Agrupados
Select cSectAgru
Scan All
	menca = menca + msep + alltrim(cSectAgru.SectorAgrup)
	Select cSectAgru
EndScan 
	
menca = menca + msep + "Diagnóstico" 
menca = menca + msep + "Documento" 
menca = menca + msep + "Orden" 
menca = menca + msep + "Denuncia policial"
&& Lugares
Select mwkSectores
Scan all
	menca = menca + msep + mwkSectores.sec_codsector
	Select mwkSectores
EndScan 

menca = menca + msep + "Obito" 
menca = menca + msep + "Paciente quirurgico" 
menca = menca + msep + "Servicios" 
menca = menca + msep + "Prestaciones" 
menca = menca + msep + "Edad" 
menca = menca + msep + "Diagnostico Egreso" 
menca = menca + msep + "CodCIE Ingreso" 
menca = menca + msep + "CodCIE Egreso" 

=fput(mh1,menca)

Select mwkPacientes
Scan All

	mcodadmision = mwkPacientes.pac_codadmision
*!*		if mcodadmision = '280901-2'
*!*	*		set step on
*!*		endif 

	mret = SqlExec(mcon1, "Select LugarIntern.*, SectorAgrup " + ;
			"from LugarIntern " + ;
			"left join secagrup on secagrup.sector = Lug_codsector " + ;
			"where lug_pacientes = ?mcodadmision " + ;
			"", "mwkLugarIntern")
			
	mret = SqlExec(mcon1, "Select VALESQUIROF.*, " + ;
			"SERVICIOS.SER_DESCRIPSERV, " + ;
			"PRESTVALEQF.PVQ_CODPREST, " + ;
			"PRESTACIONS.PRE_DESCRIPREST " + ;
			"from VALESQUIROF " + ;
			"left join SERVICIOS ON SERVICIOS.SER_CODSERV = VALESQUIROF.VAQ_CODSERVVALE " + ;
			"left join PRESTVALEQF ON PVQ_VALESQUIROF = VALESQUIROF.VAQ_CODPUNQ " + ;
			"left join PRESTACIONS ON PRE_CODPREST = PVQ_CODPREST " + ;
			"WHERE VAQ_CODADMISION = ?mcodadmision " + ;
			"", "mwkVALESQUIROF")
*!*		?mret 		

	mdeta = str(mwkPacientes.Cob_codentidad)
	mdeta = mdeta + msep + nvl(mwkPacientes.ENT_DESCRIENT,'')
	mdeta = mdeta + msep + mcodadmision 
	mdeta = mdeta + msep + nvl(mwkPacientes.Pac_nombrepaciente,'')
	mdeta = mdeta + msep + mwkPacientes.AFI_NROAFILIADO
	mdeta = mdeta + msep + dtoc(mwkPacientes.Pac_FECHAADMISION)
	mdeta = mdeta + msep + dtoc(mwkPacientes.Pac_FECHAALTA)

	Select Sectoragrup, min(Lug_FechaIngreso) as fi, max(Lug_FechaEgreso) as fm, ;
		(max(Lug_FechaEgreso) - min(Lug_FechaIngreso)) as dife ;
		from mwkLugarIntern ;
		Group by Sectoragrup ;
		Order by Lug_FechaIngreso ;
		into cursor cAuxLugInt

	Select cAuxLugInt
	go bott
	
	mSecObito = cAuxLugInt.Sectoragrup
	
	&& Agrupados
	Select cSectAgru
	Scan All
			
		Select dife ;
			from cAuxLugInt ;
			where Sectoragrup =  cSectAgru.Sectoragrup ;
			into cursor cAux

		mCant = _tally
			
		if mCant > 0
			mResu = iif((dife) = 0, 1, dife)

			If mwkPacientes.PAC_motivoalta = 6  and mSecObito = cSectAgru.Sectoragrup 
				mResu = mResu + 1
			Endif 	
			
			Select cAux
			mdeta = mdeta + msep + iif(mResu > 0, str(mResu), '')
		else
			mdeta = mdeta + msep + ''
		Endif 		
		
		Use in cAux
			
		Select cSectAgru
	EndScan 	
	
	mdeta = mdeta + msep + nvl(mwkPacientes.Pac_DESCRIPDIAGN,'')
	mdeta = mdeta + msep + STR(mwkPacientes.Reg_numdocumento)
	mdeta = mdeta + msep + nvl(mwkPacientes.ORIOBSERVAC,'')
	mdeta = mdeta + msep + iif(mwkPacientes.Pac_denuncia = '1',"NO","SI")
	&& Lugares

	Select Lug_CodSector, min(Lug_FechaIngreso) as fi, max(Lug_FechaEgreso) as fm, ;
		(max(Lug_FechaEgreso) - min(Lug_FechaIngreso)) as dife ;
		from mwkLugarIntern ;
		Group by Lug_CodSector ;
		Order by Lug_FechaIngreso ;
		into cursor cAuxLugInt

	Select cAuxLugInt
	go bott
	
	mSecObito = cAuxLugInt.Lug_codSector
		
	Select mwkSectores
	Scan all

		Select dife ;
			from cAuxLugInt ;
			where Lug_CodSector =  mwkSectores.Sec_codsector ;
			into cursor cAux

		mCant = _tally
			
		if mCant > 0
			mResu = iif((dife) = 0, 1, dife)

			If mwkPacientes.PAC_motivoalta = 6  and mSecObito = mwkSectores.Sec_codsector
				mResu = mResu + 1
			Endif 	
			
			Select cAux
			mdeta = mdeta + msep + iif(mResu > 0, str(mResu), '')
		else
			mdeta = mdeta + msep + ''
		Endif 		
		
		Use in cAux
		
		Select mwkSectores
	EndScan 
	
	Use in cAuxLugInt

	mdeta = mdeta + msep + IIF(mwkPacientes.PAC_motivoalta = 6,"SI","NO")	
	mdeta = mdeta + msep + iif(Reccount("mwkVALESQUIROF")>0,"SI","NO")
	mdeta = mdeta + msep + nvl(mwkVALESQUIROF.SER_DESCRIPSERV,'')
	mdeta = mdeta + msep + nvl(mwkVALESQUIROF.PRE_DESCRIPREST,'')
	mdeta = mdeta + msep + Str(mwkPacientes.Pac_Edad)
	mdeta = mdeta + msep + nvl(mwkPacientes.Pac_descripdiagegr,'')
	mdeta = mdeta + msep + nvl(mwkPacientes.cie10ing,'')
	mdeta = mdeta + msep + nvl(mwkPacientes.cie10egre,'')

	=fput(mh1,mdeta)
	Select mwkPacientes
*!*		if recno() = 100
*!*			exit 
*!*		Endif 
	
	Select mwkPacientes
EndScan 

=fclose(mh1)

RETURN 

&& LOS PACIENTES SALEN DE PACINTERNAD 
&& CUNADO ESTAN CON ALTA Y SE CAMBIA EL TIPOPAC EN PACIENTES 


RETURN 

mret = SqlExec(mcon1, "Select PacInternad.*  " + ;
		"from PacInternad " + ;
		"where pin_codadmision = ?mcodadmision " + ;
		"Order by %id desc", "mwkPacInternad")
?mret 		

mret = SqlExec(mcon1, "Select VALESASIST.*  " + ;
		"from VALESASIST " + ;
		"where Val_Codadmision = ?mcodadmision " + ;
		"", "mwkVales")
?mret 		
