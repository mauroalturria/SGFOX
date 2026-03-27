** Traemos los Estados ordenados
Lparameters mPropietario,mTipo,mCursor

**mPropietario = 40
**mTipo = 27
**SET STEP ON


If vartype(mcursor) # "C"
	mcursor = "mwkEstado"
Endif

USE IN SELECT(mCursor)

mret = SQLExec(mcon1,"select a.id,a.descrip,a.estado,a.propietario,a.subestado,a.tipo,b.subestado as orden " + ;
	"from tabestados as a " +;
	"left join tabestados as b on a.subestado = b.estado and b.propietario = ?mPropietario and b.tipo = ?mTipo " +;
	"where a.propietario = ?mTipo and a.tipo > 0" +;
	"Order By b.subestado",mCursor)


If mret <= 0
	Messagebox("ERROR EN LA LECTURA DE TABESTADOS. CURSOR : " + mCursor,26,"ERROR")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

Return .T.
