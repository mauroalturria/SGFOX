parameters tcCodEsp, tcWhere, tcCursor,tcAlgoMas

*!*	tcCodEsp = ""
*!*	tcWhere = " and Trim(TA_tipo) = 'P'"
*!*	tcCursor = "mwkAntec"
*!*	tcAlgoMas = .f.

If Parameters() = 0
	tcCodEsp = '    '
Endif 

If Vartype(tcWhere) # "C"
	tcWhere = ""
Endif 	

If Vartype(tcCursor) # "C"
	tcCursor = "mwkCodEspTa"
Endif	

mfecNull = ctod("01/01/1900")

mRet = Sqlexec(mcon1, "Select TA_Idnt as Ordenar, TabAntecedentes.* " + ;
	"from TabAntecedentes " + ;
	"where (TA_CodEsp = ?tcCodEsp Or TA_CodEsp = '')  and TA_Fecpasiva = ?mfecNull" + tcWhere + " " + ;
	"Order By TA_tipo, TA_padre Asc, TA_orden, TA_descrip", tcCursor)

If mRet <= 0
	Messagebox("ERROR DE LECTURA ",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 

Return .t.
*-----------------------------------------------------------------------------------------
*!*	Viejo
*-----------------------------------------------------------------------------------------

Private lnOrden
lnOrden = 0

select * ;
	from &tcCursor ;
	into cursor mwkAntTAux

Select mwkAntTAux
Index on TA_Padre Tag c1

Select &tcCursor	
Index on Id Tag c2	
Set Order To 

	
select mwkAntTAux
scan all for TA_Padre = 0
	?mwkAntTAux.Id
	do Ordenar_RamaL with  mwkAntTAux.Id
	select mwkAntTAux
endscan 

select mwkAntTAux
use 
*-----------------------------------------------------------------------------------------
procedure Ordenar_RamaL
lparameters lnIdRama
*-----------------------------------------------------------------------------------------
do ActuaOrden with lnIdRama

local lcCursorName
**lcCursorName = sys(2015) + "_" + Strtran(Time(),":","")

lcCursorName = ObtCurName()

select Id ;
	from mwkAntTAux ;
	where TA_Padre = lnIdRama ;
	into cursor &lcCursorName 

*	order by TA_Descrip 

	select &lcCursorName
	scan all 	
		?"--"
		?&lcCursorName..Id
		=Ordenar_RamaL(&lcCursorName..Id)
		select &lcCursorName
	endscan 

If Used(lcCursorName)
	select &lcCursorName
	use 
Endif 	

*-----------------------------------------------------------------------------------------
Function ObtCurName
Local lcCurName

lcCurName = "mn" + Strtran(Time(),":","")
Do While Used(lcCurName)
	*!*	sys(2015) + "_" + Strtran(Time(),":","")
	lcCurName = "mn" + Strtran(Time(),":","")
enddo
	
Return (lcCurName)
*-----------------------------------------------------------------------------------------
procedure ActuaOrden
lparameters lnId
*-----------------------------------------------------------------------------------------
lnOrden = lnOrden + 1 
update &tcCursor set Ordenar = lnOrden where Id = lnId
