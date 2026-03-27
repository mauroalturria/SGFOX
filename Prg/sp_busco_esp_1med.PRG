Lparameters mCodMed

mret = sqlexec(mcon1," SELECT ESP_codesp, ESP_descripcion, Prestadores.ID as CodMed " + ;
	"FROM especialid " + ;
	"Inner join Prestadores On Especialid.Esp_CodEsp = Prestadores.CodEsp " + ;
	"WHERE  Prestadores.ID = ?mCodMed " +;
	"","MWKesp1Med")

If mRet <= 0
	Messagebox("ERROR DE LECTURA ",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 	