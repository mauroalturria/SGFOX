****
** BUSCO MENSAJES PARA LAS PRESTACIONES
****

parameter mwhere, mopcion,mweb

LOCAL mConect 

mfecha2 = ctot('01/01/1900')
mfechaVig = prg_dtoc(ttod(mwkfecserv.fechahora))
if vartype(mweb) # "C"
	mweb= "N"
endif
if mweb = "N"
	mbusco =  " and tabmensaje.turnos = 'S' "
else
	mbusco =  " and tabmensaje.web = 'S' "
endif
mccpoamb = ''
if mxambito >1
	mccpoamb = " and codambito = ?mxambito "
endif

* Marcelo Torres, 11/03/2024
* Porque tiraba error al no encontrar valor en mcon1
mConect = IIF(mcon1 = 0,mcon3,mcon1)


DO CASE 
CASE  mopcion = 1
	mret = sqlexec(mConect, 'select id, mensaje,fecbaja,turnos,web from tabmensaje ' + ;
		mwhere +  mbusco +mccpoamb+' and ( fecbaja = ?mfecha2 or fecbaja >= ?mfechaVig )  ' , 'mwkmensaje')
CASE mopcion = 2
	mret = sqlexec(mConect, 'select tabmensaje.id, nombre as nombre, mensaje,tabmensaje.fecbaja'+;
		' ,turnos,tabmensaje.web ,codmed ,codprest,codespm,codservm,fecpasiva as fpasiva '+;
		' from prestadores, tabmensaje  '+;
		' Where tabmensaje.codmed = prestadores.id' + ;
		' and tabmensaje.codmed > 0 ' +  mbusco  + mccpoamb+;
		' and ( fecbaja = ?mfecha2 or fecbaja >= ?mfechaVig )  order by nombre', 'mwkmensaje1')

	mret = sqlexec(mConect, 'select id, pre_descriprest as nombre, mensaje,tabmensaje.fecbaja,turnos,web ' + ;
		',codmed ,codprest,codespm,codservm,PRE_fechapasiva as fpasiva '+;
		' from prestacions, tabmensaje '+;
		' Where tabmensaje.codprest = prestacions.pre_codprest' + ;
		' and tabmensaje.codprest > 0  ' +  mbusco  + mccpoamb +;
		' and ( fecbaja = ?mfecha2 or fecbaja >= ?mfechaVig ) order by nombre', 'mwkmensaje2')

	mret = sqlexec(mConect, 'select tabmensaje.id, esp_descripcion as nombre, mensaje,tabmensaje.fecbaja,turnos,web ' + ;
		',codmed ,codprest,codespm,codservm,tabmensaje.fecbaja as fpasiva '+;
		' from tabmensaje , especialid '+;
		' Where trim(codespm) = trim(esp_codesp) ' + mbusco  + mccpoamb+;
		' and ( fecbaja = ?mfecha2 or fecbaja >= ?mfechaVig ) order by nombre', 'mwkmensaje3')

	mret = sqlexec(mConect, 'select tabmensaje.id, ser_descripserv as nombre, mensaje,tabmensaje.fecbaja,turnos,web ' + ;
		',codmed ,codprest,codespm,codservm,tabmensaje.fecbaja as fpasiva '+;
		' from tabmensaje , servicios '+;
		' Where codservm = ser_codserv ' + mbusco  + mccpoamb+;
		' and ( fecbaja = ?mfecha2 or fecbaja >= ?mfechaVig ) order by nombre', 'mwkmensaje4')

	select nombre, mensaje, fecbaja,nvl(fpasiva,ctod("01/01/1900")) as fpasiva  , id, codmed ,codprest, codespm ,codservm,turnos,web from mwkmensaje1 ;
		union all ;
		select left(nombre, 40) as nombre, mensaje, fecbaja,nvl(fpasiva,ctod("01/01/1900")) as fpasiva  , id,codmed ,codprest, codespm,codservm,turnos,web from mwkmensaje2 ;
		union all ;
		select left(nombre, 40) as nombre, mensaje, fecbaja,ttod(nvl(fpasiva,ctot("01/01/1900"))) as fpasiva  , id,codmed ,codprest, codespm,codservm,turnos,web from mwkmensaje3 ;
		union all ;
		select left(nombre, 40) as nombre, mensaje, fecbaja,ttod(nvl(fpasiva,ctot("01/01/1900"))) as fpasiva  , id,codmed ,codprest, codespm,codservm,turnos,web from mwkmensaje4 ;
		into cursor mwkmensaje
CASE mopcion = 3

	mret = sqlexec(mConect, 'select tabmensaje.id, ser_descripserv as nombre, mensaje,tabmensaje.fecbaja,turnos,web ' + ;
		',codmed ,codprest,codespm,codservm,tabmensaje.fecbaja as fpasiva '+;
		' from tabmensaje , servicios '+;
		' Where codservm = ser_codserv ' + mbusco  + mccpoamb+;
		' and ( fecbaja = ?mfecha2 or fecbaja >= ?mfechaVig ) order by nombre', 'mwkmensaje4')

	select left(nombre, 40) as nombre, mensaje, fecbaja,ttod(nvl(fpasiva,ctot("01/01/1900"))) as fpasiva  ;
		, id,codmed ,codprest, codespm,codservm,turnos,web from mwkmensaje4 ;
		into cursor mwkmensaje
endcase
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	do prg_cancelo
endif
