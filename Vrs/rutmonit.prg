** Procedimientos y rutinas relacionados con Monitores de Impresión/comunicación.
*  -RLV

*** Procedimientos incluidos (para ser llamados desde aplicaciones):
*
*  CargaParam    := Carga en memoria variables ZZ* de configuración general (startup)
*  GetDatVapFile := Carga en cursors el contenido de un file de interfaz de monitor
*  GetFiles      := Carga en cursor los nombres de los files de interfaz de un tipo dado
*
******************************************************************************

** Obtiene los datos de un File interfaz de Vale Asistencial para impresión Impresión (vap file)
*  Devuelve los datos en una serie de cursores:
*  VAPHEAD1  = 1er. row del header
*  VAPHEAD2  = 2do. row del header
*  VAPPREST  = Items de Prestaciones (principales, asociadas, especiales,...)
*  VAPINSUM  = Items de Insumos/Medic (principales, asociados,...)
*  VAPFOOT1  = 1er. row del footer
*
Procedure GetDatVapFile

Parameters InputFile

VapCreaCursores()
VapCargaCursores(m.InputFile)

return

********************************


Procedure VapCreaCursores

*  cursor VAPHEAD1  = 1er. row del header: Datos inherentes al vale
create cursor VapHead1 ;
	( TipoReg N(1,0), Pun N(8,0), NroVale N(8,0), SeqVerif N(3,0), SqMae N(3,0), ;
		NroAjuste N(3,0), ModoImpre N(1,0), Prioridad N(2,0), FechaSolic D, ;
		HoraSolic C(5,0), Urgencia N(1,0), IdOperador N(5,0), NomOperador C(40), IdPrstdor C(6), ;
		NomPrstdor C(40), Comentario C(60), Bono C(10), MnemoServ C(2), ;
		IdServ N(4,0), NomServ C(25), NroProtoc C(10) )

*  cursor VAPHEAD2  = 2do. row del header: Datos inherentes al Paciente
create cursor VapHead2 ;
	( TipoReg N(1,0), TipoPac C(3), NroAdm C(8), NombrePac C(40), Sexo C(1), Edad N(3,0), ;
		NroHClinica C(8), CodSector C(3), NomSector C(35), Habitacion C(5), Cama C(3), ;
		CodEntidad N(6,0), NomEntidad C(45), CodContrato N(6,0), NomContrato C(45), NroAfiliado C(20) )

*  cursor VAPPRES3  = Prestaciones principales (tipo 3) (NO vales de Farmacia)
create cursor VapPres3 ;
	( TipoReg N(1,0), CodPrest N(10,0), DescPrest C(40), Cantidad N(4,0),MarcaEsp C(1) )

*  cursor VAPINSU4  = Insumos principales (tipo 4) (vales de Farmacia)
create cursor VapInsu4 ;
	( TipoReg N(1,0), CodInsumo C(15), DescInsumo C(40), Cantidad N(4,0) )

*  cursor VAPPASO5  = Prestaciones Asociadas (tipo 5) (NO vales de Farmacia)
create cursor VapPAso5 ;
	( TipoReg N(1,0), CodPrest N(10,0), DescPrest C(40), Cantidad N(4,0), MarcaEsp C(1) )

*  cursor VAPIASO6  = Insumos Asociados (tipo 6) (NO vales de Farmacia)
create cursor VapIAso6 ;
	( TipoReg N(1,0), CodInsumo C(15), DescInsumo C(40), Cantidad N(4,0) )

*  cursor VAPPESP7  = Prestaciones Especiales Asociadas al VALE (tipo 7) (NO vales de Farmacia)
create cursor VapPEsp7 ;
	( TipoReg N(1,0), CodPrest N(10,0), DescPrest C(40), Cantidad N(4,0), MarcaEsp C(1) )

return

*********************************


Procedure VapCargaCursores

parameter InpFile

*  cursor VAPHEAD1  = 1er. row del header: Datos inherentes al vale
select VapHead1
append from (m.InpFile) for TipoReg = 1 type delimited with tab

*  cursor VAPHEAD2  = 2do. row del header: Datos inherentes al Paciente
select VapHead2
append from (m.InpFile) for TipoReg = 2 type delimited with tab

*  cursor VAPPRES3  = Prestaciones principales (tipo 3) (NO vales de Farmacia)
select VapPres3
append from (m.InpFile) for TipoReg = 3 type delimited with tab

*  cursor VAPINSU4  = Insumos principales (tipo 4) (vales de Farmacia)
select VapInsu4
append from (m.InpFile) for TipoReg = 4 type delimited with tab

*  cursor VAPPASO5  = Prestaciones Asociadas (tipo 5) (NO vales de Farmacia)
select VapPAso5
append from (m.InpFile) for TipoReg = 5 type delimited with tab

*  cursor VAPIASO6  = Insumos Asociados (tipo 6) (NO vales de Farmacia)
select VapIAso6
append from (m.InpFile) for TipoReg = 6 type delimited with tab

*  cursor VAPPESP7  = Prestaciones Especiales Asociadas al VALE (tipo 7) (NO vales de Farmacia)
select VapPEsp7
append from (m.InpFile) for TipoReg = 7 type delimited with tab

return

*********************************************


** Procedimiento: CargaParam
*     Carga parametros de Startup del módulo en variables PUBLICAS
*     Por convención, definidas como ZZnombreVariable  (public, char)
*     Devuelve: si encontró el file y lo pudo abrir: OK -> .T.
*                  y además carga las variables ZZvar con su valor correspondiente
*               sino: Ok -> .F.
*
Procedure CargaParam

parameter Ok

private FileParam, Handle, row, variable, valor

m.FileParam = GetFileParam()   && Obtiene el path+nombre del file de parametros

m.Handle = fopen(m.FileParam)
if m.Handle < 0
	m.Ok = .F.    && fracaso
else
	do while not feof(m.Handle)
		m.row = fget(m.Handle, 600)
		m.row = alltrim(m.row)
		if left(m.row,1) <> '*' and '=' $ m.row && comentarios y rows vacios se saltean
			m.variable = alltrim(substr(m.row,1,at('=',m.row)-1))
			m.valor    = alltrim(substr(m.row,at('=',m.row)+1))
			if not empty(m.variable) and not empty(m.valor)
				public &variable
				&variable = m.valor
			endif
		endif
	enddo
	fclose(m.Handle)
	m.Ok = .T.   && Exito
endif

return

******************************************


** Obtiene el path + nombre del file de parametros:
*  Si existe la variable entorno (S.O.) MNTPARAM, lo carga de allí.
*  Sino, toma
Function GetFileParam

private DefFile, RetValue

** Default:
m.DefFile = "data\monitor.prm"

m.RetValue = getenv('MNTPARAM')
if empty(m.RetValue)
	m.RetValue = m.DefFile
endif

return (m.RetValue)

******************************************
** Procedure: GetFiles  := Carga en cursor los nombres de los files de interfaz de un tipo dado
*
*  parametros:
*       TipoFile (I):= Tipo de file de interfaz  (VAP,... etc)
*       NombreCursor (O) := Nombre del cursor de salida con los filenames
*
Procedure GetFiles

parameter TipoFile, NombreCursor

private pattern, VecDir, CantFiles, i

create cursor (m.NombreCursor) (FileInterf C(50))
m.pattern = alltrim(m.zzDirInterf) + '*.' + alltrim(m.TipoFile)
m.CantFiles = adir(VecDir, m.pattern)
for i = 1 to m.CantFiles
	insert into (m.NombreCursor) values ( VecDir[ m.i , 1 ] )
endfor

return

******************************************
