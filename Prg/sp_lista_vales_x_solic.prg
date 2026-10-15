****
** Listado de turnos para medicosolic
****

Parameter mopcion,mfecdes, mfechas, mbusco1

If mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
Else
	mccpoamb = ' '
Endif
If Vartype(mbusco1)<>"C"
	mbusco1= ''
Endif
If mxambito >1
	mcamb = "  ,turnos.codambito "
	mcamb2 = "  ,codambito "
Else
	mcamb = ' '
	mcamb2 = ' '
Endif
If !Used('mwkselcm')
	Do sp_busco_tabCM
	Use In Select('mwkselcm')
	Select * From mwkambitocm Group By abreviatura Order By orden Into Cursor mwkselcm Readwrite
Endif
Select mwkselcm
Locate For centromedico = mxcentromedico
cmmk = centromedicomk
mccpocmed = " ambcentro = ?cmmk and "

mbusq = mbusco1+' and turnos.fechatur between ?mfecdes and ?mfechas '
mret = SQLExec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	' where &mccpoamb id < 100000  order by fechacierre ','mwkctrlfecha')
mret = SQLExec(mcon1,"select * from tabambito ","mwkdescamb")
If mret < 0
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Cancel
Endif
mret = SQLExec(mcon1,"select * from tabambito ","mwkdescamb")
If mret < 0
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Cancel
Endif
mjoin = ' '
mcpojoin = ' '
If  mopcion = 1
	mjoin = ' left join registracio on afiliado = reg_nroregistrac   '
	mcpojoin = ',reg_nombrepac,REG_nrohclinica, REG_numdocumento, REG_fecnacimiento '
Endif
*!*--------------- ---------------------------------------------------------------------------------------------------------------
mret = SQLExec(mcon1,'select afiliado,turnos.fechatomado, turnos.horatur,turnos.observa,   usuario,nomape,'    +;
	'tabsectores.descrip as sector,  usuariosector,' +;
	'  turnos.id, turnos.tipotomado ' +;
	',turnos.codreserva, turnos.codesp, turnos.diasem, turnos.codprest, turnos.codmedsoli,  '+;
	'turnos.codserv, turnos.nrovale,turnos.confirmado,turnos.codent, turnos.codmed'+;
	', turnos.tipoturno, tabtipoturno.abreviatura, tomado,ambcentro,idturnoexterno '+;
	' ,turnos.fechatur, turnos.hhmmtur' +mcamb  + mcpojoin + ;
	'from turnos '+;
	'left join tabusuario on turnos.usuario= tabusuario.idusuario ' +;
	'left join tabsectores on tabsectores.ID = usuariosector  '+mjoin+;
	'left join tabtipoturno on turnos.tipoturno = tabtipoturno.tipoturno ' + ;
	" where &mccpocmed &mccpoamb turnos.codreserva<>'' "  + mbusq , 'mwktomadosa')

If mret < 0
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Cancel
Endif

If mret < 0
	=Aerr(eros)
	Do prg_error With eros,'sp_lista_vales_usuario'
	Do prg_cancelo
Endif
