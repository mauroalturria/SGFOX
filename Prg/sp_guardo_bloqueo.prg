*******************************
* Claudia Antoniow
*****************************
** Fecha 02/11/2004
****************************
 parameters vcodmed, vreemplazo, vfranja,vfdesde,vfhasta,vhorad,vhorah,vusuario,vfhgraba
 
 
 mret=sqlexec(mcon1,'Insert into tabbloqueoAmb (codmed, fechagraba, fvigend, fvigenh,'+;
 								'horadesde,horahasta,idfranja, reemplazo, usuario,bloqanulado) '+;
 								'VALUES (?vcodmed,?vfhgraba,?vfdesde,?vfhasta, '+;
 								'?vhorad,?vhorah,?vfranja,?vreemplazo,?vusuario,0)')
 								
 if mret < 0
 	messagebox('ERROR EN EL INGRESO DE BLOQUEOS ',16,'VALIDACION')
 	mret=0
 	do prg_cancelo
 endif	
 								