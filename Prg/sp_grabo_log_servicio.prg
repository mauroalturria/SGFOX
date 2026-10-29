****
** inserto log de llamadas a servicios
****
Parameter  mform,mlink,mresp
mfechagraba = sp_busco_fecha_srv2('DD')
diasant =  prg_calcula_diahabil(mfechagraba ,-2,"1,7")
mfechagraba = mfechagraba +IIF(mform= 'prg_osde',60,0)
mret = SQLExec(mcon1, "delete FROM Zabcontrolmk where CMK_Fecha<?diasant" )

mret = SQLExec(mcon1, "insert into Zabcontrolmk (CMK_Fecha, CMK_Formulario, CMK_Pedido, "+;
	" CMK_Respuesta ) values (?mfechagraba,?mform,?mlink,?mresp)")


