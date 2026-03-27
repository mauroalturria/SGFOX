****
** Armo evolucion del paciente
****

parameter mnadmis, mnsec ,mevoluc,mmedico
if vartype(mnsec )#"N"
	mnsec = 1
endif
if vartype(mevoluc)#"C"
	mevoluc= ''
endif
if vartype(mmedico)#"N"
	mmedico = 359
endif

mret = sqlexec(mcon1,"SELECT id, nombre,codesp  FROM prestadores  " + ;
	"order by nombre", "mwkMedicointall" )


mret = sqlexec(mcon1, "SELECT pacientes.Pac_codhci,TabintHCE.*,TabintEvol.*,TabintEvolmed.*"+;
	" FROM pacientes "+;
	" left join TabintHCE on pacientes.pac_codadmision = tabintHCE.IH_admision " + ;
	" left join TabintEvol on tabintHCE.id = tabintevol.EI_idevol " + ;
	" left join tabintevolmed on tabintevolmed.EIM_idevol = tabintHCE.id " + ;
	" where pac_codadmision = ?mnadmis", "mwkEvolReg01")



mret = sqlexec(mcon1, "SELECT TabintHCE.*,TabintEvolnurse.* "+;
	" FROM TabintEvol "+;
	" left join tabintevolnurse on tabintevolnurse.ein_idevol = TabintHCE.id " + ;
	" where IH_admision = ?mnadmis  order by ein_fechah ", "mwkEvolRegNur")


select mwkevolregnur
go bott

if mret < 0
	=aerr(eros)
	messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
endif
select mwkevolreg01.*,nombre from mwkevolreg01,mwkmedicointall ;
	where nvl(EIM_codmed,1) =mwkmedicointall.id ;
	order by EIM_fechah desc ;
	into cursor mwkevolreg
	

use in mwkevolreg01
if ISNULL(IH_secuencia)
	select mwkevolreg
	go top
	mnsec = NVL(IH_secuencia,1)
endif
select * from mwkevolreg ;
	where NVL(IH_secuencia,1) = mnsec ;
	group by id1 order by EIM_fechah;
	into cursor mwkevolprot

mevoluc = ''
select mwkevolprot
scan
	mevoluc = mevoluc + chr(10)+ ttoc(EIM_fechah)+" - "+ left(nombre,15)+" -> " + alltrim(EIM_evol)
endscan
go bottom

