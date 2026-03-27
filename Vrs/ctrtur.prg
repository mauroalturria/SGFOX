Do sp_conexion
cDirLocal = "C:\Temp_doc\"
cNameLog = "Turnos.txt"
ctrol = 1
mnarch = 0
nroind  = 0
hayalgo = .f.
Select tt
Go top
Do while !eof()
	mid = id
	mcodmed = codmed
	Wait windows ttoc(horatur)+" - "+ transf(mid) nowait
	mret = sqlexec(mcon1, "update turnos set codmed = ?mcodmed "+;
		" where id = ?mid ")
	If mret<1
		If mnarch = 0
			mnarch = fcreate("turnos.txt")
		Endif
		ctrol = ctrol + 1
		If ctrol = 10
			ctrol = 1
			Fclose(mnarch)
			mcarch = "Tur"+alltrim(str(nroind,5,0))+'.txt'
			mnarch = fcreate(mcarch)
			nroind = nroind +1
		Endif
		mccad = transf(codmed)+" _ " +ttoc(horatur)+" - "+ transf(mid)
		Fputs(mnarch, mccad)
	Endif
	Select tt
	Skip
Enddo
Do sp_desconexion
