LPARAMETERS mRegistracio

LOCAL lReturn

lReturn = .t.

mret = SQLEXEC(mcon1,"select NVL(TRDA_vacCovid,0) as TRDA_vacCovid from TabRegDatos " + ;
"where TRDA_Registracio = ?mRegistracio","mwkRegVacCovid")

IF mRet < 0
    Messagebox("ERROR LEYENDO REGISTRO DE VACUNA COVID",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
    lReturn = .f.   
ENDIF 

RETURN lReturn

