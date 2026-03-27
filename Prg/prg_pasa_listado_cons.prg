****
** Pasa dato en cursor mwklista a archivo de texto
****
lparameters mcarch

cfolderwork = justpath(mcarch)
mcpathact = allt(sys(5))+sys(2003)
if !empty(cfolderwork)
    cd alltrim(cfolderwork)
endif
jj=1
mnarch = fcreate(mcarch)
cd alltrim(mcpathact)
if mnarch > 0
    select mwklista
    scan
        mccad =  dato + iif(jj>1,'',chr(9)+"PROFESIONAL SOLICITANTE"+chr(9)+  "PROFESIONAL EFECTOR"  )
        mlinea = mccad
        nrocol= 1
        do while atc(chr(9), mlinea )>0 and jj>1
            nrocol= nrocol + 1
            mcontad  = atc(chr(9), mlinea )
            mvalor = alltrim(left( mlinea , mcontad - 1  ))
            do case
                case nrocol = 27
                    mcodmed =mvalor
                    if !empty(mcodmed )
                        select mwkmedicosall
                        locate for id = val(mcodmed)
                        if found()
                            mccad  = mccad +chr(9)+mwkmedicosall.nombre
                        else
                            mccad  = mccad +chr(9)+''
                        endif
                    endif
                case nrocol = 19
                    mcodmed =mvalor
                    if !empty(mcodmed )
                        select mwkmedicosall
                        locate for id = val(mcodmed)
                        if found()
                            mccad  = mccad +chr(9)+mwkmedicosall.nombre
                        else
                            mccad  = mccad +chr(9)+''
                        endif
                    endif

            endcase
            mlinea  = alltrim(substr( mlinea , mcontad + 1 ))
        enddo
        jj=jj+1
        fputs(mnarch, mccad)
    endscan
    fclose(mnarch)
endif

