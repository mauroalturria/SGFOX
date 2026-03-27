for i=101 to 119
ncons = transform(i,"@L 999") 
mpuesto = '172.18.11.' +ncons 
nnom = "BRISTOL_VAR_CONS"+NCONS
NMAQ = "BVAR"+NCONS
NUBICA = 'BRISTOL - VARELA CONSULTORIO'
select ncons as NroConsultorio, nnom  AS nombre,mpuesto as  Puesto, NMAQ  AS Maquina, Observaciones,NUBICA AS Ubicacion, idModelo, idSector,;
  interno, nroserie, pachera,ppuesto, rack, solicencia,FecPasiva,idstcaja from altas into cursor nuevo
select tabstpuesto 
append from dbf('nuevo')
next i
