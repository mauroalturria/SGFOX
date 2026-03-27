Parameters mNroVale, mCodMed

*!*	Set Step On

*!*	mNroVale = 46238123
*!*	mCodMed = 4

mEstado = 1
mFecPasiva = '1900-01-01'

TEXT To lcsql Textmerge Noshow Pretext 7
	insert into InformesLock 
		(IL_NroVale, IL_CodMed, IL_Estado, IL_FecPasiva)
	Select ?mNroVale, ?mCodMed, ?mEstado, ?mFecPasiva  
		from TabDatos 
		where not exists(
			select id 
				from InformesLock 
				where  IL_NroVale = ?mNroVale and IL_Estado = ?mEstado and IL_FecPasiva = ?mFecPasiva )
     
Endtext

If !Prg_EjecutoSql(lcSql,"mwkAux", .f.)
	Return .F.
Endif

TEXT To lcsql Textmerge Noshow Pretext 7
	select InformesLock.*, 
	  {fn concat(trim(Nvl(TabMedExterno.nombre,'')), Trim(Nvl(prestadores.nombre,'')))} as nombre 
		from InformesLock 
		left join prestadores on prestadores.id = IL_CodMed
		left join TabMedExterno on TabMedExterno.id = IL_CodMed 
		where  IL_NroVale = ?mNroVale and 
			IL_Estado = ?mEstado and 
			IL_FecPasiva = ?mFecPasiva
     
Endtext

If !Prg_EjecutoSql(lcSql,"mwkCtrlTomado", .f.)
	Return .F.
Endif


If Reccount("mwkCtrlTomado") = 0
	Messagebox("ESTUDIO NO PUDO SER TOMADO",48,"AVISO DEL SISTEMA")
	Use In Select("mwkCtrlTomado")
	Return .F.
Endif 

If mwkCtrlTomado.IL_CodMed = mCodMed
*!*		Messagebox("EL ESTUDIO ES TUYO",64,"AVISO DEL SISTEMA")
	Use In Select("mwkCtrlTomado")
	Return .T.
Else
	If Messagebox("EL ESTUDIO FUE TOMADO " + Chr(13)+ ;
		"PROFESIONAL: " + Alltrim(mwkCtrlTomado.nombre) + Chr(13) + ;
		"HS: " + Ttoc(mwkCtrlTomado.FecHorDbAdd) + Chr(13) + ;
		"DESEA CONTINUAR ?",4+32+256,"PREGUNTA DEL SISTEMA") = 7
		Use In Select("mwkCtrlTomado")
		Return .F.
	Else
		Use In Select("mwkCtrlTomado")
		Return .t.
	Endif 
Endif 

