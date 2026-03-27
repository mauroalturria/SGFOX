****
** Actualizo datos para auditoria
****
Parameter mbloque, mnroreg

miusu = mwkusuario.codigovax
mfecha = sp_busco_fecha_serv("DD")
mobserv=  Iif(Vartype(mbloque)="N","Se bloquea paciente","Se libera Paciente")

mret = SQLExec(mcon1, "update registracio set REG_bloqueo = ?mbloque, " + ;
	"REG_bloq_comen = ?mobserv, REG_bloq_fecha = ?mfecha, " + ;
	"REG_bloq_oper = ?miusu where REG_nroregistrac = ?mnroreg")
miobserva = Alltrim(Nvl(mwkbuspacie1.REG_bloq_comen,''))
If miobserva > "!" 
	mfechaant = mwkbuspacie1.REG_bloq_fecha
	miobserva = Left(Transform(mwkbuspacie1.REG_bloq_oper) + "-" + miobserva,200)
	mret = SQLExec(mcon1, "insert into TabRegObs (TROObserva , TRO_Registracio,TRO_FechaHora ) "+;
		"values (?miobserva ,?mnroreg, ?mfechaant)")
Endif
If mret < 0
	=Aerr(eros)
	Messagebox(eros(3))
Endif
