select tabintevolmedcodmed1
scan
	if eim_codmed <2 
		miproto = alltrim(strtran(ih_admision,"-",""))+"-"+transform(ih_secuencia,"@L 999")
		mifecha = eim_fechah
		select * from tabacchcepisos where  protocolo = miproto and fechamod = mifecha into cursor esta
		if reccount("esta") >= 1
			mimed = idcodmed
			select tabintevolmedcodmed1
			replace eim_codmed with mimed
		else
			mifecha = tabintevolmedcodmed1.eim_fechah-1
			select * from tabacchcepisos where  protocolo = miproto and fechamod = mifecha into cursor esta
			if reccount("esta") >= 1
				mimed = idcodmed
				select tabintevolmedcodmed1
				replace eim_codmed with mimed
			endif

		endif
	endif
endscan
set step on

select * from tabacchcepisos order by protocolo into cursor nuevo
select nuevo
locate for left(protocolo,6) = '440458'
