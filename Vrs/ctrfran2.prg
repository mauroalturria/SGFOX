select  FRAN
set step on
go top
scan
    mimed = codmed
    midia = diasem
    hd = hhmmdes+1
    hh = hhmmhas-1
    vd = fecvigend
    vh = fecvigenh
    ca=codambito
    df= desde
    hf=hasta
    mid = id
    select * from fran where id#mid and mimed = codmed and midia = diasem and ca=codambito;
        and ( (between(vd ,fecvigend,fecvigenh) or between(vh,fecvigend,fecvigenh)) and ;
        (between(hd,hhmmdes,hhmmhas) or between(hh,hhmmdes,hhmmhas)) 	)	into cursor maaal
    if reccount('maaal')>0
        set step on
    endif
    select fran
endscan

select *,ctot(dtoc(fecvigend)+" "+transf(hhmmdes+1,"@L 99:99")) as desde,ctot(dtoc(fecvigenh)+" "+transf(hhmmhas,"@L 99:99")) as hasta from b_franja order by codambito,codmed,diasem,hasta desc into cursor fran
