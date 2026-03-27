****
** Armo evolucion del paciente
****

parameter mnadmis, mnsec ,mevoluc,mmedico,midevol
 
if vartype(mnsec )#"N"
	mnsec = 1
endif
if vartype(mevoluc)#"C"
	mevoluc= ''
endif
if vartype(mmedico)#"N"
	mmedico = 359
endif
mifeclim = sp_busco_fecha_serv("DT")-24*3600
mifeclim2 = mifeclim -24*3600
mcfeclim = prg_dtoc(mifeclim)
mcfeclim2 = prg_dtoc(mifeclim2)

IF !USED("mwkMedicointall")
	DO sp_busco_med_pisos
	select  id, nombre,codesp,matricula as matriculas  from mwkmedicoint where 1=2 into cursor mwkMedicouno
	use in select("mwksinmed")
	use dbf('mwkMedicouno') in 0 again alias mwksinmed
	select mwksinmed
	insert into mwksinmed (id, nombre,codesp,matriculas  ) values (1,"MEDICO INTERNACION","",0)
	select  id, nombre,codesp,matricula as matriculas  from mwkmedicoint union all;
		select * from mwksinmed into cursor mwkMedicointall
	use in select("mwksinmed")
	use in select("mwkMedicouno")
endif

mret = sqlexec(mcon1, "SELECT pacientes.Pac_codhci,TabintHCE.*,TabintEvol.* "+;
	" FROM pacientes "+;
	" left join TabintHCE on pacientes.pac_codadmision = tabintHCE.IH_admision " + ;
	" left join TabintEvol on tabintHCE.id = tabintevol.EI_idevol " + ;
	" where EXISTS(SELECT 1 FROM pacientes WHERE pac_codadmision = ?mnadmis) AND " + ;
	" pac_codadmision = ?mnadmis", "mwkEvolReg0")

mret = sqlexec(mcon1, "SELECT tabintevolmed.id,eim_idevol,EIM_GAtipoHD,EIM_Ccultivo,eim_fechah,eim_evol,eim_codmed,eim_aislamiento,Eim_Html"+;
	",EIM_ALalimenta,EIM_ALcalorias,EIM_ALtolera,EIM_ALfecSusp,EIM_ALmotSusp,EIM_indicacion  "+;
	" FROM tabintevolmed "+;
	" where EXISTS(SELECT 1 FROM tabintevolmed WHERE EIM_idevol = ?Midevol and EIm_fechaH >= ?mcfeclim ) AND " + ;
	" EIM_idevol = ?Midevol and EIM_fechaH >= ?mcfeclim ", "mwkEvolMED01")

SELECT mwkEvolReg0.*,mwkEvolMED01.id as id2,EIM_GAtipoHD,EIM_Ccultivo,eim_fechah,eim_evol,eim_codmed,eim_aislamiento,Eim_Html,EIM_indicacion ;
	,EIM_ALalimenta,EIM_ALcalorias,EIM_ALtolera,EIM_ALfecSusp,EIM_ALmotSusp FROM mwkEvolReg0 left join mwkEvolMED01 ON eim_idevol = mwkEvolReg0.id INTO CURSOR mwkEvolReg01 


mret = sqlexec(mcon1, "SELECT TabintHCE.*,TabintEvolnurse.* "+;
	" FROM TabintHCE "+;
	" left join tabintevolnurse on tabintevolnurse.ein_idevol = TabintHCE.id " + ;
	" where 1= 2 ", "mwkEvolRegNur")

*!*		" where EXISTS(SELECT 1 FROM TabintHCE WHERE IH_admision = ?mnadmis and EIN_fechaH >= ?mcfeclim ) AND " + ;
*!*		" IH_admision = ?mnadmis   and EIN_fechaH >= ?mcfeclim  order by ein_fechah ", "mwkEvolRegNur")

IF !USED("mwkevolparcial")
	mret = sqlexec(mcon1, "select TabIntEvolParcial.* ,EIP_usuario->nomape  "+;
		" from TabIntEvolParcial "+;
		" inner join TabintHCE on EIP_idevol = TabintHCE.id "+;
		" where IH_admision = ?mnadmis   and EIP_fechaH>= ?mcfeclim  order by EIP_fechaH,TabIntEvolParcial.id desc "  , "mwkevolparcial")
endif
select mwkevolregnur
go bott

if mret < 0
	=aerr(eros)
	messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
endif
select mwkevolreg01.*,nombre,matriculas from mwkevolreg01,mwkmedicointall ;
	where nvl(EIM_codmed,351) =mwkmedicointall.id ;
	order by EIM_fechah desc ;
	into cursor mwkevolreg


use in mwkevolreg01
if isnull(IH_secuencia)
	select mwkevolreg
	go top
	mnsec = nvl(IH_secuencia,1)
endif
select * from mwkevolreg ;
	where nvl(IH_secuencia,1) = mnsec ;
	group by id2 ;
	order by EIM_fechah desc;
	into cursor mwkevolprot

mevoluc = ''
select mwkevolprot
*!*	scan
*!*		if !isnull(EIM_evol)
*!*			mevoluc = mevoluc + chr(10)+ ttoc(EIM_fechah)+" - "+ left(nombre,15)+" -> " + alltrim(EIM_evol)
*!*		endif
*!*	endscan
go bottom

