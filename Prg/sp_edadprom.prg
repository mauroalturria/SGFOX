&&
lparameters lcArchivo

if !used("mwkserver1")
	do sp_conexion
	ldisconnec = .t.
endif

&& Comentar &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
set deleted on
set date french
&& &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
lcCursorFinal = "edadprom08"

create cursor EdadProm (HCLIN c(10), ;
	NOMBRE c(23), VALE n(9), NROADM c(9), FECSOL c(10) ,;
	serv c(6), NROAFI c(13), ENT n(4), NOMENTIDAD c(40), ;
	CODIGO n(9), descrip c(42), CANT n(6), SECTOR c(8), ;
	HORA c(6), FACTURA c(9), IMPORTE n(9), OPERADOR n(11), ;
	SOLIC n(6), docum n(9), FNACIM c(10), CONTRATO n(11), ;
	DESCRIPCIO c(25), CANTSUMI n(10), EDAD n(6), FNACIM_F c(10))

select EdadProm
lcArchivo = "c:\a\Cons010108.TXT"
append from &lcArchivo delimited with tab
ultreg = recno()
delete for recno() = 1
lcArchivo = "c:\a\Cons070108.TXT"
append from &lcArchivo delimited with tab
go ultreg
set step on

replace FNACIM_F with ;
	substr(FNACIM,1,atc("/",FNACIM,2)) + "19" + substr(FNACIM,atc("/",FNACIM,2)+1) ;
	for len(alltrim(FNACIM))=8

replace FNACIM_F with FNACIM for empty(FNACIM_F)

updater EdadProm set EDAD = prg_edad(ctod(FNACIM_F),"","N")

mret = Sqlexec(mCon1,"SELECT PRESTACIONS.PRE_codprest, " + ;
	"PRESTACIONS.Pre_Especialidad "+ ;
	"FROM PRESTACIONS " , "mwkPRESTACIONS")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	mret=0
	canc
endif
lcCursorFinal = "edadprom08"

select EdadProm.*, mwkPRESTACIONS.Pre_Especialidad, cmonth(ctod(fecsol)) as mes, month(ctod(fecsol)) as nmes  ;
	from EdadProm, mwkPRESTACIONS ;
	where EdadProm.CODIGO = mwkPRESTACIONS.PRE_codprest ;
	into cursor &lcCursorFinal

select EdadProm
use

select mwkPRESTACIONS
use
lcCursorFinal = "edadprom08"

select avg(Edad) as promedio, Mes, NomEntidad, Ent, CODIGO, descrip, Pre_Especialidad, nmes  ;
	from &lcCursorFinal ;
	group by mes, Ent, CODIGO, Pre_Especialidad, nmes  ;
	order by nmes, NomEntidad, descrip, Pre_Especialidad  ;
	into cursor EdadProm

do sp_control_aplicacion with "Microsoft Excel"

oleapp = createobject("Excel.Application")

#include excel.h

mcFile = alltrim(zzvolumen) + "\qepd1a1\xlt\infor_EntEspMes.XLT"

mcFile = "c:\qepd1a1\xlt\infor_EntEspMes.XLT"

if !file(mcFile)
	messagebox("No Existe la plantilla",54, "Validación")
	return
endif
oleapp.workbooks.open(mcFile)
*-------------------------------------------------------

I = 6
select EdadProm
scan all
	wait "CARGANDO PLANILLA DE EXCEL"  + str(recno(), 5) windows nowait

	oleapp.cells(i,2).value	= alltrim(str(nMes)) + " . " + Mes
	oleapp.cells(i,3).value	= NomEntidad
	oleapp.cells(i,4).value	= descrip
	oleapp.cells(i,5).value	= Pre_Especialidad
	oleapp.cells(i,6).value	= promedio

	I = I + 1
endscan

*-------------------------------------------------------
oleapp.Sheets("Entidad-Especialidad").select

select avg(Edad) as promedio, Mes, NomEntidad, Ent, Pre_Especialidad, nmes  ;
	from &lcCursorFinal ;
	group by mes, Ent, Pre_Especialidad, nmes  ;
	order by nMes, NomEntidad, Pre_Especialidad  ;
	into cursor EdadProm

I = 6
select EdadProm
scan all
	wait "CARGANDO PLANILLA DE EXCEL"  + str(recno(), 5) windows nowait

	oleapp.cells(i,2).value	= alltrim(str(nMes)) + " . " + Mes
	oleapp.cells(i,3).value	= NomEntidad
	oleapp.cells(i,4).value	= Pre_Especialidad
	oleapp.cells(i,5).value	= promedio

	I = I + 1
endscan

*-------------------------------------------------------
oleapp.Sheets("Entidad").select

select avg(Edad) as promedio, Mes, NomEntidad, Ent, nmes;
	from &lcCursorFinal ;
	group by mes, Ent, nmes ;
	order by nMes, NomEntidad ;
	into cursor EdadProm

I = 6
select EdadProm
scan all
	wait "CARGANDO PLANILLA DE EXCEL"  + str(recno(), 5) windows nowait

	oleapp.cells(i,2).value	= alltrim(str(nMes)) + " . " + Mes
	oleapp.cells(i,3).value	= NomEntidad
	oleapp.cells(i,4).value	= promedio

	I = I + 1
endscan
oleapp.Sheets("Completo").select
oleapp.Cells(6,2).select

oleapp.visible = .t.

select EdadProm
use

if ldisconnec
	do sp_desconexion
endif
