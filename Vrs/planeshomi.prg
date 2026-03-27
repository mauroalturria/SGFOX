mid = 223
mant = '303'
Set Step On
Select newplan
Scan
	mient = codent
	cplan = plan
	cabrev = codplan
	Select nuevo
	Update nuevo Set abreviatura=Transform(mid),;
		abreviaent = cabrev ,codentag = mient,descripcion = cplan,idprepaga = mient
*	Set Step On

	Select planes
	mid = mid +1
	Append From Dbf('nuevo')
Endscan



