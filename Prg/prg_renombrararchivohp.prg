* Renombrar archivos de HP a Ricoh (Fecha/Hora a Secuencial) - 2021/08
Lparameters mpathorigen

Create Cursor mwkFileHP (admision c(10),pathhp c(200),Nombrehp c(200), fechahorahp T,milisegundohp N, fechaarch T, archivoricoh c(30))
Create Cursor mwkFileHPfinal (orden N,admision c(10),pathhp c(200),Nombrehp c(200), fechahorahp T,milisegundohp N, fechaarch T, archivoricoh c(30))

mfullpath = Fullpath(Curdir())
*mpathhp = 'z:\impresorahp'
mpathhp = mpathorigen

If !Directory(mpathhp)
	Messagebox('El nombre de carpeta Origen de Archivos Adjuntos no es compatible.',48,'AVISO')
	Return .F.
Endif

Chdir (mpathhp)

mnroarch = Adir(quehay,'*')

mSigo = .T.
For a = 1 To mnroarch
	mArchivo = Juststem(quehay(a,1))
	mbusco1 = At('_',mArchivo)
	mbusco2 = Substr(mArchivo,mbusco1+1)
	If Len(mbusco2)<14
		mSigo = .F.
	Endif
Endfor

If !mSigo
	Messagebox('Hay archivos que no corresponden al formato HP. Verifique para poder continuar',0,'AVISO')
	Chdir &mfullpath
	Return .F.
Endif

Set Step On 

For a = 1 To mnroarch
	mArchivo = quehay(a,1)
	mfechaarch = Fdate(mArchivo,1)
	mfechahp1 = At('_',mArchivo)+1
	madmision = Substr(mArchivo,1,mfechahp1-2)
	marchivohp = Juststem(mArchivo)
	mfechahp_año  = Int(Val(Substr(mArchivo,mfechahp1,4)))
	mfechahp_mes = Int(Val(Substr(mArchivo,mfechahp1+4,2)))
	mfechahp_dia = Int(Val(Substr(mArchivo,mfechahp1+6,2)))
	mfechahp_hora = Int(Val(Substr(mArchivo,mfechahp1+8,2)))
	mfechahp_minuto = Int(Val(Substr(mArchivo,mfechahp1+10,2)))
	mfechahp_segundo = Int(Val(Substr(mArchivo,mfechahp1+12,2)))
	mfechahp_milisegundo = Int(Val(Substr(mArchivo,mfechahp1+14,2)))
	
	
	mfechahp = Datetime(mfechahp_año,mfechahp_mes,mfechahp_dia,mfechahp_hora,mfechahp_minuto,mfechahp_segundo)
	Insert Into mwkFileHP  (admision,Nombrehp,fechahorahp,fechaarch,milisegundohp,pathhp) Values (madmision,marchivohp,mfechahp,mfechaarch,mfechahp_milisegundo,mArchivo)
Endfor

Select admision From mwkFileHP Group By admision Into Cursor mwkFileHPtmp1 Readwrite
Select mwkFileHPtmp1
Scan All
	mbuscoadmi = Alltrim(mwkFileHPtmp1.admision)
	Select 0 As orden, * From mwkFileHP Where admision = mbuscoadmi Order By fechahorahp Asc Into Cursor mwkFileHPtmp Readwrite
	Select mwkFileHPtmp
	mOrden = 0
	marchivohp = ''
	Select mwkFileHPtmp
	Scan All
		marchivohp = Alltrim(mwkFileHPtmp.admision)
		If mOrden = 0
			Replace archivoricoh With marchivohp
		Else
			marchivohp = marchivohp + '-' + Alltrim(Str(mOrden))
			Replace archivoricoh With marchivohp
			Replace orden With mOrden
		Endif
		mOrden = mOrden + 1
	Endscan
	Select mwkFileHPtmp
	Scan All
		mv1 = mwkFileHPtmp.orden
		mv2 = mwkFileHPtmp.admision
		mv3 = mwkFileHPtmp.pathhp
		mv4 = mwkFileHPtmp.Nombrehp
		mv5 = mwkFileHPtmp.fechahorahp
		mv6 = mwkFileHPtmp.milisegundohp
		mv7 = mwkFileHPtmp.fechaarch
		mv8 = mwkFileHPtmp.archivoricoh
		Insert Into mwkFileHPfinal (orden,admision,pathhp,Nombrehp,fechahorahp,milisegundohp,fechaarch,archivoricoh) Values ;
			(mv1,mv2,mv3,mv4,mv5,mv6,mv7,mv8)
		Select mwkFileHPtmp
	Endscan
	Select mwkFileHPtmp1
Endscan

* Renombro los archivos
Select mwkFileHPfinal
Scan All
	mOrigen = mpathhp + '\' + Alltrim(mwkFileHPfinal.pathhp)
	mDestino = mpathhp + '\' + Alltrim(mwkFileHPfinal.archivoricoh)+'.pdf'
	lcRun = 'Rename '+mOrigen+' To '+mDestino
	&lcRun
	Select mwkFileHPfinal
Endscan

Chdir &mfullpath

