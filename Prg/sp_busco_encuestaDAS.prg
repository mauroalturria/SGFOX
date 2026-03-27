*
* Control de Informes Confirmados sin PDF generado
*
lparameters mfdes,mfhas
If used('mwkValeInf')
	Use in mwkValeInf
Endif

mret = sqlexec(mcon1, " select tabencuestas.id,TEC_protocolo, fechahoraate, codent, reg_nrohclinica, "+;
	" reg_nombrepac,reg_numdocumento, tec_encuesta, tec_fecmov, tec_usuario"+;
	" from TabEncuestas "+;
	" left join GUARDIA ON protocolo = tec_protocolo "+;
	" left join registracio on registracio.REG_nroregistrac = guardia.nroregistrac "+;
	" where tec_fecmov >= ?mfdes and tec_fecmov < ?mfhas ","mwkencuesta")

If mret < 0
	Messagebox("EN CONSULTA DE ENCUESTAS",48,"Validació")
Endif
