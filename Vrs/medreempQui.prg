select preregmed
scan
insert into medexpac (fechaIngreso,matricula, nombre, codesp,fechaBaja, gerenciadora,tipoMat, usuarpas);
	values (ctod("01/01/1900"),val(preregmed.matriculas),preregmed.nombre,preregmed.codesp,ctod("01/01/2100"),222,"MN",'')
endscan
select medexpac 
scan
	mimat = transform(matricula)
	mcodmed = id
	update preregmed set codmed = mcodmed where matriculas = mimat
endscan
