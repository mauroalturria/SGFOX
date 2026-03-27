****
** busco Observaciones
****
Parameters mId,ccursor,miorigen
miori =''
If Vartype(miorigen)="N"
	miori = " (origen is null or origen = ?miorigen ) and "
Else
	If Vartype(miorigen)="C"
		miori = " (origen is null or origen in  ("+miorigen+") ) and "
	Endif
Endif

If Vartype(ccursor) # "C"
	ccursor = "mwkTabAutobs"
Endif
mret = SQLExec(mcon1," select  idautprevias ,fechaobs,tabautobs.usuario,observa,"+;
"tabautobs.estado as subestado, tabestados.descrip, tabestados.estado,tabusuario.codigovax "+;
" from tabautobs "+;
"  left join tabestados on tabestados.id = tabautobs.estado "+;
"  left join tabusuario on tabusuario.idusuario = tabautobs.usuario"+;
" where "+miori+" idautprevias in ("+ Transf(mId) +") ", "mwkobsautp")    &&& (origen is null or origen = ?miorigen) and

If mret<1
	=Aerr(eros)
	Messagebox(eros(3))
Endif
mfecpas = Ctod("01/01/1900")
mret = SQLExec(mcon1, "SELECT CodAmbito, PA_idAutprevia, PA_idPresu,PA_idTabautpre, PA_tipopac"+;
" FROM  Zabpresuaut  Where PA_idAutprevia in ("+ Transf(mId) +")  and PA_fechapas = ?mfecpas ", "mwkPresaut")
If Reccount("mwkPresaut")>0
	midpresu  = mwkPresaut.PA_idPresu
	Do sp_busco_detpresu  With midpresu
	If Reccount('mwkDetEstado')>0
	Select Val(Transform(idautprevias)) As idautprevias ,fechaobs,Padr(usuario,50) As usuario,Padr(Left(observa,200),200) As observa;
		,subestado,LEFT(Descrip,50) As Descrip,  estado,codigovax From mwkobsautp;
		 Union All Select Val(Transform(mid)) As idautprevias,fecha As fechaobs, ;
		Padr(usuario,50) As usuario,observaciones As observa,UltEstado As subestado,;
		 estado As Descrip, UltEstado As estado,codigovax From mwkDetEstado Into Cursor &ccursor

	Else
		Select * From mwkobsautp Into Cursor &ccursor
	Endif
Else
	Select * From mwkobsautp Into Cursor &ccursor
Endif
