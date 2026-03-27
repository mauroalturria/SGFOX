**** busco mails por especialidad
mfecnul = CTOD("01/01/1900")
mret = sqlexec(mcon1, "select ID, TM_email, TM_especialidad, TM_grupo, TM_servicio, TM_tipo "+;
" where tm_fecpasiva = ?mfecnul from tabmail", "mwktabmail")

