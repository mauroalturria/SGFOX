select *,count(id) as cuantos  from turnoid group by codmed,afiliado,codreserva order by cuantos desc into cursor coesa
select * from coesa where !INLIST(codesp,'KINE','PSIC','FONI') into cursor mal
select mal
scan
    requery('turnoidafi')
    select 	turnoidafi
	MIFECHA = FECHATUR
    mihora = horatur
    mihorant  = horatur
    if reccount('turnoidafi')>1
        mihora = mihora + mal.pre_duracion *60
        do while !eof() and horatur < mihora 
            skip
        enddo
        do while !eof() AND MIFECHA = FECHATUR

            wait windows transform(mal.pre_duracion ) +"="+transform(mihorant  )  +"="+transform(mihora ) nowait
          
            replace  usuario with '', usuariosector with 0, codent with 0,codesp with '', ;
                codmedsoli with 0, codprest with 0, codreserva with '',;
                codserv with 0, afiliado with 0, tipotomado with 0
            skip
        enddo
    endif
    select mal
endscan
