Lparameters mDirOrig, mDirDest
*--------------------------------------------------------------------
mDirOrig = Addbs(mDirOrig)
mDirDest = Addbs(mDirDest)

If !Directory(mDirDest)
	Md (mDirDest)
Endif	
	
Local mi As Integer
Local miLargo As Integer
Local mcDestino as String
Local Array aArch[1,5]

If Adir(aArch, mDirOrig + "*.*", "D") > 0
	miLargo = Alen(aArch,1)
	For mi = 1 To miLargo
		If "D" $ aArch[mi,5]
			If aArch[mi,1] # "." And aArch[mi,1] # ".."
				Prg_CopiarDirectorio(mDirOrig + aArch[mi,1], mDirDest + aArch[mi,1])
			Endif
		Else
			If "A" $ aArch[mi,5]
				mcDestino = mDirDest + aArch[mi,1]
				Copy File (mDirOrig + aArch[mi,1]) To (mcDestino)
			Endif
		Endif
	Next
Endif
