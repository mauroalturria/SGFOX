*
* Busqueda de Turnos no tomados para hacer estadísticos de demoras x Especialidad
*
Lparameters mfecdes

mfechades = Ttod(mfecdes)
mfechahora = mfecdes+2*3600
If Used('mwkpdemora')
	Use In mwkpdemora
Endif
If mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
Else
	mccpoamb = ''
Endif

Use In Select("mwkespecag")
mret = SQLExec(mcon1,"select TE_codambito, TE_codesp,TE_codespag"+;
	" from Tabespecialid where TE_codambito = ?mxambito ", "mwkespecag")

mret = SQLExec(mcon1,"SELECT medpresta.*, prestacions.pre_descriprest, " + ;
	"prestacions.pre_especialidad " + ;
	"FROM medpresta, prestacions " + ;
	"WHERE &mccpoamb medpresta.codprest = prestacions.pre_codprest and " + ;
	' fecvigend <> fecvigenh and ' + ;
	' fecvigenh >= ?mfechades  and generaagen = 1 and '   +;
	" medpresta.diasem > 0 order by codesp,codprest desc" ,"Mwkpresta")

&& modifico la seleccion carga de la grilla 091223

Select * ;
	from Mwkpresta ;
	where codprest In (Select Pre_codprest From mwkGrilla) ;
	into Cursor Mwkmedpre

mret = SQLExec(mcon1, 'select turnos.id as lid, fechatur, horatur, '     +;
	'turnos.diasem,abreviatura,turnos.codmed,turnos.tipoturno,hhmmTur ' +;
	'from turnos '+;
	'left outer join tabtipoturno on turnos.tipoturno = tabtipoturno.tipoturno ' +;
	'where &mccpoamb turnos.tipoturno in (0,1,5,7,15) and turnos.afiliado = 0 and ' +;
	"fechatur >= ?mfechades and UPPER(LEFT(observa,3)) NOT IN ('INC','REC') " +;
	'group by codmed,horatur','mwktodos')


Select * From mwktodos,Mwkmedpre;
	where mwktodos.fechatur >= Mwkmedpre.fecvigend And ;
	mwktodos.fechatur <  Mwkmedpre.fecvigenh And ;
	hhmmtur >= Mwkmedpre.hhmmdes And hhmmtur<Mwkmedpre.hhmmhas And ;
	mwktodos.codmed = Mwkmedpre.codmed And ;
	mwktodos.diasem = Mwkmedpre.diasem And horatur > mfechahora  ;
	group By codesp,Mwkmedpre.codprest,horatur Into Cursor mwkpdemora

If Used('mwkespdemora')
	Use In mwkespdemora
Endif

If mret < 0
	=Aerror(merror)
	Messagebox("EN CONSULTA DE TURNOS"+Chr(10)+;
		merror(3)+Chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Else

	mret = SQLExec(mcon1,"select * from especialid " +;
		" where ESP_GrupoDemora in('A','B','C','D','E')" +;
		" ","mwkespdemora")

	If mret < 0
		=Aerror(merror)
		Messagebox("EN CONSULTA DE ESPECIALIDADES"+Chr(10)+;
			merror(3)+Chr(10)+;
			"AVISE A SISTEMAS",16,"ERROR")
	Else
		If Used('mwkdemora2')
			Use In mwkdemora2
		Endif


		Select lid,fechatur,horatur,abreviatura,tipoturno,ESP_descripcion,ESP_GrupoDemora,;
			nvl(ESP_demora,0) As  deseado,codprest,pre_descriprest ;
			from mwkpdemora Join mwkespdemora On mwkespdemora.ESP_codesp=mwkpdemora.codesp ;
			order By ESP_GrupoDemora,ESP_descripcion,codprest,horatur,abreviatura ;
			into Cursor mwkdemora2


	Endif
Endif
