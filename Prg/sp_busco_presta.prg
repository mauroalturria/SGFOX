*****
***** busco prestadores
*****
lparameters mcobs

if vartype(mcobs)#"C"
	mcobs="N"
endif
mret = sqlexec(mcon1,"select TE_codambito, TE_codesp,TE_codespag"+;
		" from Tabespecialid where TE_codambito = ?mxambito ", "mwkespecag")

if !used("MwkEspepr")
	mret=sqlexec(mcon1,"SELECT ESP_codesp,ESP_descripcion FROM Especialid " ,"MwkEspepr")
	if mret < 0
		messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
		mret=0
	endif
endif
mret = sqlexec(mcon1,'select nombre, telefono, telcelular, telradio, email, codesp, ' + ;
	'id, matriculas, fecvtoanssal , fecvtoseg, codpcia, codloca, codprof, coduniv, codiva, cuil, fecpasivag, fecpasivai, ' + ;
	'fecpasiva, fecalta, fecaltag, fecaltai, estado, codpostal, bloquedesde, bloquehasta, ' + ;
	'dambula, dinterna, dguardia, bloqueo, fecnac, domicilio, codespe ' + ;
	',nroproveedor, lanssal, lcertdef, ldocum, lhepat, '+;
	'lseguro , matprov,lregincomp,fecvtomatricula,nrolegajo   ' +;
	', fecaltap, fecpasivap,enreldep,sexo,web,fechamod,idseguro,nom,ape '+iif(mcobs="S",',obser ','')+;
	',fecaltaq, fecpasivaq, dquirofano '+;
	'from &marchivo ' + ;
	'order by nombre', "auxiliar" )
if mret<0
	messagebox("ERROR AL CREAR EL CURSOR, REINTENTE", 16, "Validación")
	do prg_cancelo
endif
mret = sqlexec(mcon1,'select TPF_codmed ,TPF_filtro '+ ;
		" FROM TabProfFiltro ","mwkfiltro")
if mret<0
	messagebox("ERROR AL CREAR EL CURSOR, REINTENTE", 16, "Validación")
	do prg_cancelo
endif


mfecnul = ctod("01/01/1900")
mret = sqlexec(mcon1,'select CodAmbito , CodMed from tabprofambito '+;
	'where codambito = ?mxambito group by codmed ','mwkprofambito')
mwhere = ''
if mxambito=1
	mret = sqlexec(mcon1,'select CodAmbito , CodMed from tabprofambito '+;
		'where codambito <> ?mxambito group by codmed ','mwkprofambitootros')
	mwhere = '	where auxiliar.id not in(select codmed from mwkprofambitootros) '
endif
select auxiliar.*,MwkEspepr.*, mwkprofambito.codambito,mwkfiltro.TPF_filtro ;
	from auxiliar ;
	left join MwkEspepr on trim(codesp) = esp_codesp  ;
	left join mwkfiltro  on auxiliar.id = mwkfiltro.TPF_codmed;
	left join mwkprofambito on auxiliar.id = mwkprofambito.codmed;
	&mwhere into cursor &mcursor

use in MwkEspepr
use in auxiliar
select (mcursor)
