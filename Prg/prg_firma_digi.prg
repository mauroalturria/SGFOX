Parameters mcodmed,mlmed,mlmat,lbusresp,msec,mlmedjefe,mlmatjefe,lmedsinfirma,msolfirma

lfirma = .T.
mfiltra = .T.
mcodmedfirma = mcodmed

lfirma = .t.
lmedsinfirma = .T.
mfirma = "C:\temp\imagenes\firmas\"+Alltrim(Transform(mcodmedfirma))+"_firma_ms.tif"

prg_carga_firmamia(mcodmedfirma,2,lfirma,mfirma )

 Return lfirma
