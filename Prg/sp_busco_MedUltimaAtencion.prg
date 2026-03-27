** Marcelo Torres, 28/03/2022
** Antes devolvia .f. en caso de error.
** Buscamos la ultima hora de atencion para un medico+fecha dados

Lparameters mCodMed, mFecha

Local cResult

cResult = ""

mRet = SQLExec(mcon1,"select a.codmed,a.fechaate,b.EAM_fechaH " +;
	"from TabAmbulatorio as A " +;
	"left join TabAmbEvolMed as B on a.protocolo = b.EAM_proto " +;
	"where a.CodMed = ?mCodMed and a.FechaAte = ?mFecha and a.demanda <> 9 ","mwkUltAteMed")

If mRet <= 0
	***Messagebox("ERROR EN LA LECTURA DE TABAMBULATORIO - TABAMBEVOLMED",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return cResult
Else
	Select mwkUltAteMed
	Go Bottom

	If Reccount() > 0
		cResult = Ttoc(mwkUltAteMed.EAM_fechaH,2)
	Endif

	Use In Select("mwkUltAteMed")
Endif

Return cResult
