SELECT * FROM prestalabo UNION ALL SELECT * FROM prestavigen ;
UNION ALL SELECT * FROM guardiaprestac INTO CURSOR prestavig

USE c:\desaguemes\conv818.dbf IN 0 SHARED
SELECT * FROM prestavig WHERE pre_codprest NOT in (SELECT codigo FROM conv818);
 ORDER BY pre_codservicio,pre_especialidad INTO CURSOR novigen
COPY TO noconv818

DO clearall
SELECT   PC_FechaVigDesde, PC_FechaVigHasta,092 as  PC_codent,;
  pre_codprest as PC_codprest, PC_incluidaAMB,;
  PC_incluidaGUA, PC_incluidaINT FROM prestac_noconv,novigen INTO CURSOR nuevo
APPEND FROM DBF('nuevo')

SELECT   DATE() as PC_FechaVigDesde, CTOD("01/01/2100") as PC_FechaVigHasta,76 as  PC_codent,;
  pre_codprest as PC_codprest, 2 as PC_incluidaAMB,;
  2 as PC_incluidaGUA, 2 as PC_incluidaINT FROM nuevos INTO CURSOR nuevo
APPEND FROM DBF('nuevo')


USE c:\desaguemes\conv993.dbf IN 0 SHARED
SELECT * FROM prestavig WHERE pre_codprest NOT in (SELECT codigo FROM conv993);
 ORDER BY pre_codservicio,pre_especialidad INTO CURSOR novigen
COPY TO noconv993 TYPE xl5
