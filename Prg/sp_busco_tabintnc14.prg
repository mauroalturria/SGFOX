parameters tcCodEsp, tcWhere, tcCursor,tcAlgoMas,msector

If Parameters() = 0
	tcCodEsp = '    '
Endif 

If Vartype(tcWhere) # "C"
	tcWhere = ""
Endif 	

If Vartype(tcCursor) # "C"
	tcCursor = "mwknece"
Endif	

mfecNull = ctod("01/01/1900")

mRet = Sqlexec(mcon1, "Select Cast(00000 AS INTEGER) as Ordenar, TabIntNecCui.* " + ;
	" from TabIntNecCui " + ;
	" Inner join TabIntNecSec on Tabintnecsec.NS_idNecesidad = Tabintneccui.ID " + ;
	" where Tabintnecsec.NS_sector = ?msector and Tabintnecsec.NS_fecpasiva = ?mfecnull "+;
	" and NNC_Fecpasiva = ?mfecNull " + tcWhere + " " + ;
	" Order By NNC_orden, NNC_descrip", tcCursor)

If mRet <= 0
	Messagebox("ERROR DE LECTURA ",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 
*-----------------------------------------------------------------------------------------
Private lnOrden
lnOrden = 0

select * ;
	from &tcCursor ;
	into cursor mwkAntTAux
	
select mwkAntTAux
scan all for NNC_Padre = 0
	do Ordenar_Rama with  mwkAntTAux.Id
	select mwkAntTAux
endscan 
select mwkAntTAux
use 
*-----------------------------------------------------------------------------------------
procedure Ordenar_Rama
lparameters lnIdRama
*-----------------------------------------------------------------------------------------
do ActuaOrden with lnIdRama

local lcCursorName
lcCursorName = sys(2015)

select * ;
	from mwkAntTAux ;
	where NNC_Padre = lnIdRama ;
	into cursor &lcCursorName 

*	order by NNC_Descrip 

select &lcCursorName
scan all 	
	do Ordenar_Rama with  &lcCursorName..Id
	select &lcCursorName
endscan 

select &lcCursorName
use 


*-----------------------------------------------------------------------------------------
procedure ActuaOrden
lparameters lnId
*-----------------------------------------------------------------------------------------
lnOrden = lnOrden + 1 
update &tcCursor set Ordenar = lnOrden where Id = lnId
