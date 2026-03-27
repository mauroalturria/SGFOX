*
* Busco Deposito segun Sector
*
Lparameters msector

Use In Select("mwkdepsec")

mbus = Alltrim(msector)

mret = SQLExec(mcon1,"select Min(Deposito) as Deposito from DepositoSector where sector = ?mbus","mwkdepsec")

If mret < 0
	mltabla = "DEPOSITO/SECTOR"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.
