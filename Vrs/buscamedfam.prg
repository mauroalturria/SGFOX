SELECT pedidos
 
SCAN
REQUERY('medfamMedCab')
IF RECCOUNT('medfamMedCab')=0 AND !INLIST(reg_numdocumento,24225928)
SET STEP ON 
endif

endscan