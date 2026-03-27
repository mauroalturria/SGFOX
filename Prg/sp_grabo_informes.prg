****
**** actualiza datos informes
*****
parameters mid, mestadoorigen,miopcion,midoc
if vartype(miopcion)#"N"
	miopcion = 0
endif
if vartype(midoc)#"C"
	midoc = ''
endif
mfecha 		= sp_busco_fecha_serv('DT')
mfechahoy 	= ttod(mfecha)
go top in mwkusuario
musu		= mwkusuario.codigovax
mestadoinforme = mestadoorigen - 1
do case
	case mestadoinforme = 3
		ccampo = " fechaaprobacion "
	case mestadoinforme = 2
		ccampo = " FechaRecepcion "
endcase
if miopcion = 0
	mret = sqlexec(mcon1," UPDATE informes SET estadoinforme = ?mestadoinforme,"+;
		ccampo + "= ?mfechahoy WHERE id  = ?mid ")
	if mret<1
		=aerr(eros)
		messagebox(eros(3))
	endif
else
	mestadoinforme = miopcion
endif

mret = sqlexec(mcon1," insert into InformesLog (DocumentoBase , FechaLog , IdInforme , "+;
	"TipoLog , Usuario) values ( ?midoc, ?mfecha, ?mid, ?mestadoinforme, ?musu )")

if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif
