set date french
set century on
set talk on
suspend

mcon1= sqlconnect('conec01','_system','sys')

mret=SQLEXEC(mcon1, "select registracio,afi_codentidad,afi_nroafiliado,afi_fechabaja "+;
	",registracio->reg_nombrepac,registracio->reg_nrohclinica," + ;
	"registracio->reg_numdocumento,CAST(0 as integer) as estado,CAST(0 as integer) as estado2 " +;
	"from afiliacion where AFI_codentidad = 988","mwkregistracio")

mret=SQLEXEC(mcon1, "select *,CAST(0 as integer) as estado,CAST(0 as integer) as estado2 " +;
	"from padcabe where entidad = 988","mwkpadron")




SQLDISCONNECT(mcon1)

select mwkpadron
index on nroafiliado to mwkpadron
go top
select mwkpadron
go top
select mwkregistracio
go top
do while !eof()
	mregistro=recno()
	@ 2,0 say recno()
	if isnull(mwkregistracio->afi_fechabaja)
		select mwkpadron
		seek val(mwkregistracio->afi_nroafiliado)
		if !eof()
			mnombre= CHRTRAN(mwkregistracio->reg_nombrepac, "ÑðÐ^/\'$:ñ¥·ÿº?¿!¡%&()=¨;.ª|¬[]{}", "###  ")
			if !( alltrim(mnombre)== alltrim(CHRTRAN(mwkpadron->apeynom, "ÑðÐ^/\'$:ñ¥·ÿº?¿!¡%&()=¨;.ª|¬[]{}", "###  ")) )
				replace mwkpadron->estado with 5
				replace mwkpadron->apellido with mnombre
			endif
			if mwkpadron->estado = 0
				if mwkpadron->fecegreso = ctod('01/01/2100')
					replace mwkpadron->estado with 1
					select mwkregistracio
					replace mwkregistracio->estado with 1
				else
					replace mwkpadron->estado with 2
					select mwkregistracio
					replace mwkregistracio->estado with 2

				endif
			else
				replace mwkpadron->estado with mwkpadron->estado*10
				select mwkregistracio
				replace mwkregistracio->estado with mwkregistracio->estado*10
			endif
		else
			select mwkregistracio
			replace mwkregistracio->estado with 9
		endif
	endif

	select mwkregistracio
	skip
enddo


select mwkregistracio
index on val(afi_nroafiliado) to mwkregistracio
go top
select mwkpadron
go top
do while !eof()
	mregistro=recno()
	@ 2,0 say recno()
*IF mwkpadron->NroAfiliado = 23924395869
* SUSPEND
*ENDIF

	if mwkpadron->fecegreso == ctod('01/01/2100')
		select mwkregistracio
		seek mwkpadron->nroafiliado
		if !eof()
			if mwkregistracio->estado2 = 0
				if isnull(mwkregistracio->afi_fechabaja)
					replace mwkregistracio->estado2 with 1
					select mwkpadron
					replace mwkpadron->estado2 with 1
				else
					replace mwkregistracio->estado2 with 2
					select mwkpadron
					replace mwkpadron->estado2 with 2

				endif
			else
				replace mwkregistracio->estado2 with mwkregistracio->estado2*10
				select mwkpadron
				replace mwkpadron->estado2 with mwkpadron->estado2*10
			endif
		else
			select mwkpadron
			replace mwkpadron->estado2 with 9
		endif

	endif

	select mwkpadron
	skip
enddo




select mwkpadron
copy to mwkpad for estado > 1 or estado2 > 1
select mwkregistracio
copy to mwkregis for estado > 1 or estado2 > 1






