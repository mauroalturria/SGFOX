Select idcpdefine
Set Step On

Scan
	Requery('resp_cpde')
	Select resp_cpde.*,pre_especialidad,PRE_descriprest From resp_cpde Left Join presta On leist=codigo  Into Cursor datos
	Select * From datos Where Empty(fachr )  Into Cursor mal
	Select mal
	Scan
		mid = Id
		cespe = Nvl(pre_especialidad,'')
		If !Empty(cespe)
			Select resp_cpde
			Update resp_cpde Set fachr = cespe Where Id = mid
		Else
			Select idcpdefine
			Replace codigomal With Val(mal.leist),codesp With Alltrim(mal.fachr)
		Endif
	Endscan
	Select idcpdefine
Endscan
