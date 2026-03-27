****
** busco los medicos de demanda espontanea para control horario
****

Parameters mfecha, mbusco1

If Type('mbusco1')#"C"
	mbusco1=""
Endif
mdia = Dow(mfecha)
If At('turnos.codesp',mbusco1)>0
	mbusco1 = Strtran(mbusco1,'turnos.codesp','medpresta.codesp')
Else
	If At('codesp',mbusco1)>0
		mbusco1 = Strtran(mbusco1,'codesp','medpresta.codesp')
	Endif

Endif
If At('turnos.',mbusco1)>0
	mbusco1 = Strtran(mbusco1,'turnos.','medpresta.')
Endif
If mxambito >1
	mccpoamb = "  medpresta.codambito = ?mxambito and "
Else
	mccpoamb = ''
Endif

mccentro = Iif(mxambito = 1,Iif(mxcentromedico =1," and (sala not like '%LIMA%' AND sala not like '%CP%' ) ",;
		Iif(mxcentromedico =2, " and sala like '%LIMA%' "," AND sala like '%CP%' "  )),' ')

mret = SQLExec(mcon1, "select codmed, nombre, diasem, fecvigend, fecvigenh, " + ;
	" hdesde1, hhasta1, sala, medpresta.codesp, ESP_descripcion, TPF_filtro  " + ;
	" from medpresta, especialid , prestadores " + ;
	" Left join TabProfFiltro on Prestadores.id = TabProfFiltro.TPF_codmed " + ;
	" where &mccpoamb medpresta.codmed = prestadores.id and " + ;
	" (prestadores.estado = 1 or prestadores.fecpasiva > ?mfecha) and " + ;
	" (?mfecha> bloquehasta  or ?mfecha< bloquedesde ) and " +;
	" fecvigend <= ?mfecha and fecvigenh >= ?mfecha and " + ;
	" diasem = ?mdia and (demanda = 1 or (demanda = 0 and generaagen = 0)) and " + ;
	mbusco1 + " medpresta.codesp = ESP_codesp " +mccentro+ ;
	"order by nombre", "mwkdemanda")
If mret < 0
	=Aerr(eros)
	Do prg_error With eros,'sp_busco_phorarios_demanda'
	Cancel
Endif
&&	" codmed not in(306, 368, 401, 402, 545, 546, 547, 548, 549, 1070, 1048 ) and "
Select mfecha As fechatur, nombre,  ESP_descripcion, ;
	hdesde1, hhasta1, codmed, diasem, sala,codesp,Left(sala,1) As piso, ;
	'*' + Str(diasem,1) + Strtran(Str(codmed,4), ' ', '0') + ;
	strtran(Substr(Dtoc(mfecha),1, 5),'/','') +  Left(Ttoc(hdesde1,2), 2)+Substr(Ttoc(hdesde1,2), 4,2) + '*' As codbarra ;
	from mwkdemanda 		;
	where Inlist(Nvl(TPF_filtro,0),0,6,7) ;
	order By nombre, hdesde1, fechatur ;
	into Cursor mwkphorariodem
