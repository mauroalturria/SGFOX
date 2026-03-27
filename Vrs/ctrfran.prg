select  FRAN
go top
mimed = codmed
midia = diasem
hd = hhmmdes
hh = hhmmhas
vd = fecvigend
vh = fecvigenh
df= desde
hf=hasta
skip
do while !eof()
    do while mimed = codmed and midia = diasem and !eof()
        if 	hhmmdes<hh
            if fecvigend<vh
                set step on
            endif
        endif
        mimed = codmed
        midia = diasem
        hd = hhmmdes
        hh = hhmmhas
        vd = fecvigend
        df= desde
        hf=hasta
        vh = fecvigenh
        skip
    enddo
    if codmed = 131
        set step on
    endif
    mimed = codmed
    df= desde
    hf=hasta

    midia = diasem
    hd = hhmmdes
    hh = hhmmhas
    vd = fecvigend
    vh = fecvigenh
    skip
enddo

