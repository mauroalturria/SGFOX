*!*	-------------------------------------------------------
*!*	Parametros
*!*	-------------------------------------------------------
lparameters mOpcion, mfecdes, mfechas, mwhere, mtipo
*--------------------------
If mtipo
	&& obtengo fecha inicial
	Do sp_busco_prestacion with " and PRE_AgendaTurnos = 'S' "

	Select max(PRE_retiroestudios) as demora ;
		from mwkprestac ;
		into cursor mwkdemo
	mfechaini = prg_calcula_diahabil(mfecdes-1,mwkdemo.demora*(-1),"1,7")

	Use In mwkprestac
	Use In mwkdemo
Else
	mfechaini = mfecdes
Endif 	
*--------------------------
*Set Step On 
mret = sqlexec(mcon1, "SELECT tpprotocolo, tpregistrac FROM Tabprotocolo"+;
	" Where tpestado in ( 2, 4, 5, 7) and tpfecharetiro >= ?mfechaini "+;
	" group by tpprotocolo" ,"mwkanulados")

if mret <=0
	messagebox("ERROR DE LECTURA, REINTENTE", 48, "VALIDACION")
	aerror(eros)
	return .f.
Endif

do case
	case mOpcion = 1  && Guardia
		mcwhere = " and Val_TipoPaciente = 'GUA' "
	case mOpcion = 2  && Ambulatorio
		mcwhere = " and Val_TipoPaciente = 'AMB' "
	case mOpcion = 3  && Internación
		mcwhere = " and Val_TipoPaciente = 'INT' "
Endcase

mret = sqlexec(mcon1, "SELECT valesasist.VAL_NroProtocolo FROM TabValObs, valesasist "+;
	" Where TabValObs.TVO_CodPun = valesasist. Val_CodPun and " + ;
	" TVO_SubEstado in (23,82,98) and " + ;
	" TVO_fechaestudio >= ?mfechaini " ,"mwkanula2")

if mret <=0
	messagebox("ERROR DE LECTURA, REINTENTE", 48, "VALIDACION")
	aerror(eros)
	return .f.
endif

mret = sqlexec(mcon1, "select " + ;
	"valesasist.VAL_codadmision, valesasist.VAL_codservvale, " + ;
	"valesasist.VAL_NroProtocolo, Val_CodPun, VAL_fechasolicitud, " + ;
	"Val_codValeAsist, informes.Id, Val_TipoPaciente, " + ;
	"informes.FechaRecepcion, Prestacions.PRE_retiroestudios,informes.estadoinforme " + ;
	"from valesasist " + ;
	"Left Join informes on valesasist.VAL_CodPun = Informes.CodPun " + ;
	"left join presinsuvas on valesasist.valesasist = presinsuvas.pia_valesasist " + ;
	"left join Prestacions on Pre_CodPrest = presinsuvas.pia_codprest "+;
	"where VAL_fechasolicitud >= ?mfechaini and " + ;
	"VAL_fechasolicitud <= ?mfechas and " + ;
	"Pre_CodPrest not in ( 84020100, 84020101, 18010403,34100402) " + ;
	mwhere + mcwhere  , "cInformes")

if mret <=0
	messagebox("ERROR DE LECTURA, REINTENTE", 48, "VALIDACION")
	aerror(eros)
	return .f.
Endif

select prg_calcula_diahabil(VAL_fechasolicitud ,PRE_retiroestudios,"1,7") as fechaentrega, ;
	cinformes.* ;
	from cinformes ;
	where VAL_NroProtocolo not in (select tpprotocolo from mwkanulados) and ;
	VAL_NroProtocolo not in (select VAL_NroProtocolo from mwkanula2) ;
	into cursor mwkinfopre

use in mwkanula2

select a.* , "VERIFICAR  " as VER ;
	from mwkinfopre a, mwkinfopre b ;
	where a.val_codadmision = b.val_codadmision and ;
	a.val_codservvale = b.val_codservvale and;	
	a.id = 0 and b.id > 0;
	union ;
	select a.*, "SIN INFORME" as VER ;
	from mwkinfopre a, mwkinfopre b ;
	where a.val_codpun = b.val_codpun And ;
	((a.id = 0 and b.id > 0) Or (a.id > 0 and b.id > 0));
	And (a.estadoinforme = 5 And b.estadoinforme in (2,3,4));
	Group By a.val_codpun;
	into cursor mwkValsInf	


Select * From mwkValsInf Into Cursor mwkValsInf
Select mwkValsInf

If Used('mwkinfopre')
  	use in mwkinfopre
endif
if used('cInformes')
	use in cinformes
Endif
if used("mwkvalsinf1")
	use in mwkvalsinf1
endif 

