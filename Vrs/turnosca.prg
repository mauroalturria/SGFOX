select apasar.*,pre_especialidad from apasar,vista2 where pre_codprest = codprest into cursor arreglo
select arreglo 
scan
	if confirmado = 0
		scatter memvar
		insert into turnoscancel(afiliado, codcancela, codent, codesp,;
			 codmed, codmedsoli, codprest, codreserva, diasem, feccancela, fechatomado, ;
			fechatur, hhmmTur, horatur, solicigia, tipotomado, tipoturno, usuario, usucancela, ;
			observa,UsuarioSector ) ;
			values(m.afiliado, 1, m.codent, m.pre_especialidad ,;
			 m.codmed, m.codmedsoli, m.codprest, m.codreserva, m.diasem, date(), m.fechatomad, ;
			m.fechatur, m.hhmmTur, m.horatur, m.solicigia, m.tipotomado, m.tipoturno, m.usuariocon, m.usuariocon, ;
			m.observa1,1)
		select arreglo 
	endif
endscan


	
select t.*,medpresta.codprest from apasar as t,medpresta ;
	where		t.codmed   = medpresta.codmed and  ;
	t.diasem	= medpresta.diasem and ;
	t.fechatur >= medpresta.fecvigend and;
	t.fechatur <  medpresta.fecvigenh and;
	medpresta.fecvigenh <> medpresta.fecvigend and ;
	t.hhmmtur >= medpresta.hhmmDes and ;
	t.hhmmtur < medpresta.hhmmHas  ;
	group by id;
	order by id into cursor codprest
select codprest
scan
	mcod=codprest_b
	mid = id
	update apasar set codprest = mcod where id = mid
endscan

update apasar set codreserva = right(strtran(str(turnoid, 8, 0), " ", "0") + '-' + str(resto(turnoid), 1), 9)

function resto()
	lparameters idtur
	mcuit = '20-' + strtran(str((idtur), 8, 0), " ", "0")
	num01 = val(substr(mcuit,1,1))
	num02 = val(substr(mcuit,2,1))
	num03 = val(substr(mcuit,4,1))
	num04 = val(substr(mcuit,5,1))
	num05 = val(substr(mcuit,6,1))
	num06 = val(substr(mcuit,7,1))
	num07 = val(substr(mcuit,8,1))
	num08 = val(substr(mcuit,9,1))
	num09 = val(substr(mcuit,10,1))
	num10 = val(substr(mcuit,11,1))

	msuma = 0
	msuma = msuma + (num10 * 9)
	msuma = msuma + (num09 * 8)
	msuma = msuma + (num08 * 7)
	msuma = msuma + (num07 * 6)
	msuma = msuma + (num06 * 5)
	msuma = msuma + (num05 * 4)
	msuma = msuma + (num04 * 9)
	msuma = msuma + (num03 * 8)
	msuma = msuma + (num02 * 7)
	msuma = msuma + (num01 * 6)

	mresto = round(msuma % 11, 0)

	if mresto > 9
		mresto = 1
	endif
	return mresto
endfun
