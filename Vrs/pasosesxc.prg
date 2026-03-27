update vista1 set web="S"
update vista1 set observa = ''
tablerevert(.t.)
update vista1 set sexo = 'M'
update vista1 set sexo = 'F'
go top
locate for at("JOSE",nombre)>1
locate for at("JOSE",nombre)> 1 next
locate for at("JOSE",nombre)> 1  all
locate for at("JOSE ",nombre)> 1
locate for at("MARIA",nombre)> 1 and sexo="M"

locate for at("CARMEN",nombre)> 1 and sexo="M"
update prestadores set sexo = 'M' WHERE EXPRESSION_5='N'
update prestadores set sexo = 'F' WHERE at("INES",nombre)> 1 

SELECT *;
 FROM SQLUser.PRESTADORES Prestadores;
 WHERE {fn SUBSTRING(Prestadores.nombre,{fn LENGTH({fn RTRIM(Prestadores.nombre)})},1)} = "S";
   AND Prestadores.sexo = "M"
select prestadores
scan
	mid= id
	select med_sex 
	locate for id=mid
	if found()
		msex = sexo
		select prestadores
		replace sexo with msex	
	endif
	select prestadores

endscan
