Select *,Int(reg_numdocumento/100) As newdoc From  Tabregdocu Where trd_nrodoc = 0 Into Cursor arreglo readwrite


Select arreglo
Set Step On
Scan
	mid = Id
	nd = newdoc
	Select Tabregdocu
		Locate For Id = mid
		Replace   trd_nrodoc with nd&&,trd_fechapasiva with Ctod("01/01/1900")
	 Select arreglo

Endscan
SET STEP ON 
Select otro
Set Step On
Scan
	mid = Id_a
	nd = nrodoc
	If otro.nrodoc>0
		IF otro.nrodoc>99999999
			nd = Int(otro.nrodoc/100)  
		endif
		Select Tabregdocu
		Locate For Id = mid
		Replace   trd_nrodoc with nd,trd_fechapasiva with Ctod("01/01/1900")
		Select otro
	Endif
Endscan
