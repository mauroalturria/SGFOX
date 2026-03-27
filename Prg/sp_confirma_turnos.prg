****
**  confirmacion de turnos
***

Parameter mcodreserva, mfechatur, midtur, mvalor,mxcodmed, mNroDoc

mfecha = sp_busco_fecha_serv('DT')

If mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
Else
	mccpoamb = ''
Endif
mactmed = ''
If Vartype(mxcodmed)="N"
	mactmed = ' and codmed = ?mxcodmed '
Endif

mcicpoamb = ''
mvicpoamb = ''
If mxambito >1
	mcicpoamb = "  ,codambito "
	mvicpoamb = "  ,?mxambito "
ENDIF
mNroDoc = Iif(Vartype(mNroDoc) <> "N",0,mNroDoc)


mret = SQLExec(mcon1, "update turnos set confirmado = ?mvalor, " + ;
	"fechaconfirma = ?mfecha, usuarioconfirma = ?midusu " + ;
	"where &mccpoamb codreserva = ?mcodreserva and " + ;
	"fechatur = ?mfechatur "+mactmed )

If mret < 0
	Messagebox("ERROR EN LA CONFIRMACION DEL TURNO", 16, "Validacion")
	Do prg_cancelo
Else
	If mvalor = 0
		mcodigovax 	= mwkusuario.codigovax
		If Used('mwkphorarios')
			mnrohc 		= mwkphorarios.afiliado
		Else
			mnrohc 		= Val(mcodreserva)
		Endif
		mret = SQLExec(mcon1, "insert into turnosaudit (afiliado, turnoid, fechatomado, usuario, codigo &mcicpoamb ) "+;
			"values (  ?mnrohc, ?midtur, ?mfecha , ?mcodigovax, 1 &mvicpoamb  ) ")

* ----- Marcelo Torres, 30/08/2022
* ----- nIdTurno,mDNI,nOpcion
		*If mxambito = 1
			sp_markey_confirmaturno(midtur,mNroDoc,2)
		*Endif

		Messagebox("EL TURNO FUE DESCONFIRMADO", 48, "Validacion")

	Else
* ----- Marcelo Torres, 30/08/2022
* ----- nIdTurno,mDNI,nOpcion
		*If mxambito = 1
			sp_markey_confirmaturno(midtur,mNroDoc,1)
		*Endif

		Messagebox("EL TURNO FUE CONFIRMADO", 48, "Validacion")
	Endif
Endif
