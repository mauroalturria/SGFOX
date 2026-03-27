PARAMETERS mid, mnroadmisionRN , mnroregistraRN , mtiporegistro , mfechaHora , midevol , musuario , mayuno , mfechaviaoral , mnpt , mviaenteral ,;
 mcomp , mphp , maporte , mtcm , mpolime , mtipoleche , mincremento , mformadmin , maportecalprot

if mid = 0

	TEXT To lcsql Textmerge Noshow Pretext 7
		Insert into ZabNeoIENutri 
		( NUT_nroadmisionRN , NUT_nroregistraRN , NUT_tiporegistro , NUT_fechaHora , NUT_idevol , NUT_usuario , NUT_ayuno , NUT_fechaviaoral , NUT_npt , NUT_viaenteral , NUT_composicion , NUT_php , NUT_aporte , NUT_tcm , NUT_polime , NUT_tipoleche , NUT_incremento , NUT_formadmin , NUT_aportecalprot) 
		 Values 
		( ?mnroadmisionRN , ?mnroregistraRN , ?mtiporegistro , ?mfechaHora , ?midevol , ?musuario , ?mayuno , ?mfechaviaoral , ?mnpt , ?mviaenteral , ?mcomp , ?mphp , ?maporte , ?mtcm , ?mpolime , ?mtipoleche , ?mincremento , ?mformadmin , ?maportecalprot) 
	ENDTEXT

else

	TEXT To lcsql Textmerge Noshow Pretext 7
		Update ZabNeoIENutri 
		Set NUT_nroadmisionRN  = ?mnroadmisionRN , 
		NUT_nroregistraRN  = ?mnroregistraRN , 
		NUT_tiporegistro  = ?mtiporegistro , 
		NUT_fechaHora  = ?mfechaHora , 
		NUT_idevol  = ?midevol , 
		NUT_usuario  = ?musuario , 
		NUT_ayuno  = ?mayuno , 
		NUT_fechaviaoral  = ?mfechaviaoral , 
		NUT_npt  = ?mnpt , 
		NUT_viaenteral  = ?mviaenteral , 
		NUT_composicion  = ?mcomp , 
		NUT_php  = ?mphp , 
		NUT_aporte  = ?maporte , 
		NUT_tcm  = ?mtcm , 
		NUT_polime  = ?mpolime , 
		NUT_tipoleche  = ?mtipoleche , 
		NUT_incremento  = ?mincremento , 
		NUT_formadmin  = ?mformadmin ,
		NUT_aportecalprot = ?maportecalprot
		where ID = ?mid 
	ENDTEXT

endif

If !Prg_EjecutoSql(lcSql,"mwk")
	Messagebox("ERROR AL GUARDAR",16,"ERROR")
	Return .f.
ENDIF
