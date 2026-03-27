*******************************
**  Rutina de Monto Escrito
**  Autor: Alejandro G. Saul 
**  Fecha: 25/08/1998
*******************************

parameters ximporte

UX   ="uno   dos   tres  cuatrocinco seis  siete ocho  nueve"
D1X  ="once   doce   trece  catorcequince "
DX0  ="diez     veinte   treinta  cuarenta cincuentasesenta  setenta  "
DX0  =DX0+"ochenta  noventa  "
CX00 ="ciento       doscientos   trescientos  cuatrocientosquinientos   "
CX00 =CX00+"seiscientos  setecientos  ochocientos  novecientos  "
store " " to xcentena,xdecena,xunid
store 0 to VALOR

E_NUM = int(ximporte)
D_NUM = ximporte - E_NUM
D_NUM = D_NUM * 100
xcifra = trim(str(E_NUM))
xcifra = ltrim(xcifra)
L = len(xcifra)
xvalor = 0
LET = ""

if L>6
    xveces=3
else
    if L>3
        xveces=2
    else
        xveces=1
    endif
endif

do while xveces <> 0
    if L=9 .or. L=6 .or. L=3
        xcentena=substr(xcifra,1,1)
        xdecena =substr(xcifra,2,1)
        xunid =substr(xcifra,3,1)
        xvalor  =val(substr(xcifra,1,3))
    endif
    if L=8 .or. L=5 .or. L=2
        xcentena=" "
        xdecena =substr(xcifra,1,1)
        xunid =substr(xcifra,2,1)
        xvalor  =val(substr(xcifra,1,2))
    endif
    if L=7 .or. L=4 .or. L=1
        xcentena=" "
        xdecena =" "
        xunid =substr(xcifra,1,1)
        xvalor  =val(xunid)
    endif
    if xcentena<>" " .and. xcentena<>"0"
        xdesde=(13*val(xcentena))-12
        xverso=trim(substr(CX00,xdesde,13))
        if xvalor=100
            xverso="cien"
        endif
        LET=LET+xverso+" "
    endif
    xverso=""
    if xdecena<>" " .and. xdecena<>"0"
        xdesde=(9*val(xdecena))-8
        xverso=trim(substr(DX0,xdesde,9))+" "
        if xdecena="1" .and. xunid<>"0"
            if xunid<"6"
                xdesde=(7*val(xunid))-6
                xverso=trim(substr(D1X,xdesde,7))+" "
            else
                xverso="dieci"
            endif
        else
            if xunid<>"0"
                if xdecena="2"
                    xverso="veinti"
                else
                    xverso=xverso+"y "
                endif
            endif
        endif
        LET=LET+xverso
    endif
    xverso=""
    if xunid<>"0"
        if xdecena<>"1"
            xdesde=(6*val(xunid))-5
            xverso=trim(substr(UX,xdesde,6))+" "
            if xunid="1" .and. xveces<>1
                xverso="un "
            endif
        else
            if xunid>"5"
                xdesde=(6*val(xunid))-5
                xverso1 = trim(substr(UX,xdesde,6))+" "
                xverso=xverso+xverso1
            endif
       endif
       LET=LET+xverso
    endif
    if xvalor=0.and.ximporte<1000           && se usa ximporte aqui !!
        LET=LET+"cero "
    endif
    do case
    case xveces = 3
        if xvalor = 1
            LET=LET+"millon "
        else
            LET=LET+"millones "
        endif
        xcifra = substr(xcifra,(L-5),6)
        L=6
    case xveces = 2
        if xvalor<>0
            LET=LET+"mil "
        endif
        xcifra = substr(xcifra,(L-2),3)
        L=3
    case xveces = 1
        LET=LET+"con "+substr(str(D_NUM),9,2)+"/100"
    endcase
    xveces=xveces-1
enddo
L=len(LET)
mlet = let
store "" to LET1,LET2,LET3
if L>50
    I=50
    do while substr(LET,I,1)<>" "
        I=I-1
    enddo
    LET1=substr(LET,1,I)
    LET2=substr(LET,I+1)
    L = len(LET2)
    if L>50
        I=50
        do while substr(LET2,I,1)<>" "
            I=I-1
        enddo
        LET=LET2
        LET2=substr(LET,1,I)
        LET3=substr(LET,I+1)
    endif
    mlet1 = let1 + iif(empty(let2),'',chr(10) + let2) + iif(empty(let3),'',chr(10) + let3)
else
    MLET1=LET
endif
