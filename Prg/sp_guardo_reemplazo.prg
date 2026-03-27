*******************************
* Claudia Antoniow
*****************************
** Fecha 02/11/2004
****************************
 parameters vcodmed, vmedreemp, vfranja, vhoraD, vhoraH, vfdesde, vfhasta, vusuario, vfhgraba, v_matri

 if isnull(vhoraD) or isblank(vhoraD)
 	vhoraD = '1900-01-01 00:00:00' 
  endif	 

if isnull(vhorah) or isblank(vhorah)
  	 vhorah = '1900-01-01 00:00:00'	
 endif	 
 
 vconfirmado = iif(vmedreemp='SIN CONFIRMAR',vmedreemp,'CONFIRMADO')
  
 mret=sqlexec(mcon1,'Insert into tabReemplazoAmb (confirmado, matricula, codmed,'+;
 								'fechagraba, fvigend, fvigenh, horadesde, '+;
 								'horahasta, idfranja, nombre, usuario,bloqanulado) '+;
 								'VALUES (?vconfirmado, ?v_matri, ?vcodmed, ?vfhgraba,'+;
 								'?vfdesde, ?vfhasta, ?vhoraD, ?vhoraH, ?vfranja, '+;
 								'?vmedreemp, ?vusuario, 0)')
 								
 if mret < 0
 	messagebox('ERROR EN EL INGRESO DE REEMPLAZOS ',16,'VALIDACION')
 	do prg_cancelo 
 	mret=0
 else
 	messagebox('EL REEMPLAZO SE GUARDO EXITOSAMENTE ',64,'VALIDACION')
 endif	
 								