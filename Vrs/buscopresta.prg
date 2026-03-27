Public mcon1
Do sp_conexion
mret=SQLExec(mcon1,"select sum ( pia_cantsolicitada ) as cantidad ,pia_codprest "+;
	" from presinsuvas  group by pia_codprest ","mkwpresta")
If mret<0
	=aerr(eros)
	Set step on
Endif
mret = sqlexec(mcon1,"select pre_descriprest, pre_codprest " + ;
						"FROM prestacions " + ;
						"group by pre_codprest " + ;
						"", "mwkbustexto")
do sp_desconexion
select * from mkwpresta,mwkbustexto where pia_codprest = pre_codprest into cursor prestaciones
