if used('controlaes')
	use in controlaes
endif
create cursor controlaes (entsal n(1),fechahora t,nombre c (50),fechahant t,horadesde t,horahasta t,sala c(20),fechahsig t)
select fich_e_s
mihora =ctot("01/01/1900")
scan
	if mihora # ctot("01/01/1900")
		if mihora > fechahora
			 mentsal = fich_e_s->entsal 
			 mfechahora = fich_e_s->fechahora
			 mnombre = fich_e_s->nombre
			 mhoradesde = fich_e_s->horadesde
			 mhorahasta = fich_e_s->horahasta
			 msala = fich_e_s->sala 	
			 select fich_e_s
			 skip 1
			 mhoras = fechahora
			 skip -1
			 insert into controlaes values ( mentsal , mfechahora, mnombre,mihora,mhoradesde,mhorahasta,msala,mhoras ) 
		else
			mihora = fechahora
		endif
	else
		mihora = fechahora
	endif
endscan
