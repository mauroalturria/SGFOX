Select idcpdefine
Set Step On

Scan
	Requery('resp_cpde')
	Select resp_cpde.*,pre_especialidad,PRE_descriprest From resp_cpde Left Join presta On leist=codigo  Into Cursor datos
	Select * From datos Where Isnull(pre_especialidad )  Into Cursor mal
	If Reccount('mal')> 1
		Insert Into idcpdefine (Id,codigomal,codigobien,codesp) Values (mal.Id,Val(mal.leist  ),0,ALLTRIM(mal.fachr))
	Else
		Select idcpdefine
		Replace codigomal With Val(mal.leist),codesp WITH ALLTRIM(mal.fachr)
	Endif
	Select idcpdefine
Endscan
