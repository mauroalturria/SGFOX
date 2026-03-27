****
** Armo evolucion del paciente
****
Parameter mnroregis,mfecha

mfiltroe = ''
mfiltroIC = ''
mfiltroBH = ''
mfiltroNur = ''
If Vartype(mfecha)="D"
	mcfecha = prg_dtoc(mfecha)
	mfiltroe =  " and (pac_fechaadmision>= '"+mcfecha +"' or pac_fechaalta is null ) "
	mfiltroIC =  " and EIC_fechaHora >= '"+mcfecha +"' "
	mfiltroBH =  " BHI_fechaH >= '"+mcfecha +"' "
	mfiltroNur =  " and EIN_fechaH >= '"+mcfecha +"' "
Endif
If Vartype(block_ent)# "C"
	Public block_ent
	block_ent =''
ENDIF


cbusp = ''
IF !Empty(block_ent) AND block_ent <> "ALL" 

* ---------------------------------
	Alines(aBlock,block_ent,",")

	Create Cursor bBlockEnt (codent I)
	Local i
	For i = 1 To Alen(aBlock)
		Insert Into bBlockEnt (codent) Values (VAL(aBlock[i]))
	Endfor
* ---------------------------------

	cbusp =  " where INLIST(sp_busco_entcob(IH_admision,,1,1),"+block_ent +") "
Endif

*!*	mret = sqlexec(mcon1,"SELECT id, nombre,codesp,matriculas   FROM prestadores  " + ;
*!*		"order by nombre", "mwkMedicointall" )

mret = SQLExec(mcon1, "select  TabIntAnam.* "+;
	" FROM pacientes "+;
	" inner join TabintHCE on pacientes.pac_codadmision = tabintHCE.IH_admision " + ;
	" inner join TabIntAnam on TabIntAnam.IA_idevol = tabintHCE.id"+;
	" where pac_codhci = ?mnroregis "+mfiltroe   , "mwkhistanam")

mret = SQLExec(mcon1, "select top 1 TabIntevolIC.*,nomape "+;
	" FROM pacientes "+;
	" inner join TabintHCE on pacientes.pac_codadmision = tabintHCE.IH_admision " + ;
	" inner join TabIntevolIC on TabIntevolIC.EIC_idevol = tabintHCE.id"+;
	" inner join tabusuario on tabusuario.id = TabIntevolIC.EIC_usuario " + ;
	" where pac_codhci = ?mnroregis "+mfiltroIC  +" group by TabIntevolIC.id"  , "mwkhistIC")


mret = SQLExec(mcon1, "SELECT pacientes.Pac_codhci,TabintHCE.*,TabintEvol.*"+;
	",cieingreso.descrip as Eg_motconsulta,cieegreso.descrip as motivoalta,mte_descripcion,pacientes.Pac_centromedico "+;
	" FROM pacientes "+;
	" left join TabintHCE on pacientes.pac_codadmision = tabintHCE.IH_admision " + ;
	" left join TabintEvol on tabintHCE.id = tabintevol.EI_idevol " + ;
	" left join TabCie10 cieingreso on cieingreso.id = TabintHCE.IH_motIngreso " + ;
	" left join TabCie10 cieegreso on cieegreso.id = TabintHCE.IH_codcie " + ;
	" left join motivoegreso on  mte_codmotivo = pac_motivoalta " + ;
	" where pac_codhci = ?mnroregis "+mfiltroe , "mwkEvolInt01")


If mret < 0
	=Aerr(eros)
	Messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
Else
	If  !Used('mwkmedicoant')
		If !Used('mwkMedicointall')
			Do sp_busco_med_pisos && with sp_busco_fecha_serv("DD") saco esto porque omite los pasivos!!!
			Select  Id, nombre,codesp,matricula As matriculas  From mwkmedicoint Where 1=2 Into Cursor mwkMedicouno
			Use In Select("mwksinmed")
			Use Dbf('mwkMedicouno') In 0 Again Alias mwksinmed
			Select mwksinmed
			Insert Into mwksinmed (Id, nombre,codesp,matriculas  ) Values (1,"SIN ANAMNESIS","",0)
			Select  Id, nombre,codesp,matricula As matriculas  From mwkmedicoint Union All;
				select * From mwksinmed Into Cursor mwkMedicointall
			Use In Select("mwksinmed")
			Use In Select("mwkMedicouno")
		Endif

*!*			Select mwkevolint01.*,medcab.nombre As nombrecab,medcab.matriculas As matcab ;
*!*				from mwkevolint01 ;
*!*				INNER Join mwkMedicointall As medcab On medcab.Id = ih_codmed;
*!*				&cbusp Order By id1 Desc ;
*!*				into Cursor mwkevolint

		Select mwkevolint01.*,medcab.nombre As nombrecab,medcab.matriculas As matcab, sp_busco_entcob(IH_admision,,1,1) As entcob ;
			from mwkevolint01 ;
			INNER Join mwkMedicointall As medcab On medcab.Id = ih_codmed;
			Order By id1 Desc ;
			into Cursor mwkevolint

		If Used("bBlockEnt")

			Select a.* ;
			From mwkevolint As a ;
				where a.entcob In (Select codent From bBlockEnt) ;
				into Cursor mwkevolint2

			Use In Select("mwkevolint")

			Select * From mwkevolint2 Into Cursor mwkevolint

		Endif


	Else
*!*			Select mwkevolint01.*,mwkmedicoant.nombre As nombrecab,mwkmedicoant.matricula  As matcab ;
*!*				from mwkevolint01 ;
*!*				INNER Join mwkmedicoant  On mwkmedicoant.Id = ih_codmed;
*!*				&cbusp Order By id1 Desc ;
*!*				into Cursor mwkevolint

		Select mwkevolint01.*,mwkmedicoant.nombre As nombrecab,mwkmedicoant.matricula  As matcab, sp_busco_entcob(IH_admision,,1,1) As entcob ;
			from mwkevolint01 ;
			INNER Join mwkmedicoant  On mwkmedicoant.Id = ih_codmed;
			Order By id1 Desc ;
			into Cursor mwkevolint

		If Used("bBlockEnt")

			Select a.* ;
			From mwkevolint As a ;
				where a.entcob In (Select codent From bBlockEnt) ;
				into Cursor mwkevolint2

			Use In Select("mwkevolint")

			Select * From mwkevolint2 Into Cursor mwkevolint

		Endif


	Endif

	Select * From mwkevolint ;
		group By Id ;
		order By id1  Desc;
		into Cursor mwkevolinterna

Endif

USE IN SELECT("bBlockEnt")


