SELECT varios
SET STEP ON

scan
miprot = ea_protocolo
REQUERY('b_amevolerr')
UPDATE b_amevolerr SET EA_nroregistrac =1 WHERE ea_evolucion = ' PACIENTE NO ADMITIDO AL MOMENTO DEL CIERRE DE CONSULTORIO'

endscan