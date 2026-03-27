****
** Busco todas las camas con pacientes
****

Lparameter  mfechah

mfecha = Ttod(mfechah)
Use In Select('mwkcbioca')
Use In Select('mwkcambios')
Use In Select('mwkcambioant')
mret = SQLExec(mcon1, "select Lugarintern.* from lugarintern " + ;
	" inner join pacinternad on  pin_codadmision = lug_pacientes "+;
	"order by lug_fechaingreso,lug_horaingreso", "mwkcbiocat")

If mret <= 0
*	messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
Else
	Select Ctot(Dtoc(lug_fechaingreso)+" "+Left(Ttoc(lug_horaingreso, 2), 5)) As hora, * ;
		from mwkcbiocat ;
		ORDER By hora Into Cursor mwkcbioca

	Select lug_pacientes,hora,lug_codsector From mwkcbioca	Where hora >= mfechah ;
		GROUP By lug_pacientes Into Cursor mwkcambios

	Select lug_pacientes,hora,lug_codsector From mwkcbioca	Where hora < mfechah And lug_pacientes In (Select lug_pacientes  From  mwkcambios );
		GROUP By lug_pacientes Into Cursor mwkcambioant
Endif
