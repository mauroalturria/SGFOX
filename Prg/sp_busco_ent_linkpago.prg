* Busca la entidad y devuelve si está habilitada para link de pago.
Lparameters mCodEnt

Local lHabCobro

lHabCobro = .F.

* ------------------------------
mret = SQLExec(mcon1,"select ENT_Linkpago " + ;
	"from Entidades " + ;
	"where Ent_codent = ?mCodEnt","mwkLinkPago")

If mret <= 0

	Messagebox("ERROR EN LA LECTURA DE ENTIDADES-LINKPAGO",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()

	Return .F.

Endif

Select mwkLinkPago
Go Top

If Reccount() > 0
	If mwkLinkPago.Ent_LinkPago
		lHabCobro = .T.  &&habilitado para cobro
	Endif
Endif

Use In Select("mwkLinkPago")

Return lHabCobro
* -------------------------------
