SELECT  175 as AV_codent, 0 as AV_codcont,'AMB' as  AV_tipopaciente,INT(codprest) as  AV_prestacion, aviso as AV_aviso,;
 DATE() as AV_Fecha, DATETIME() as AV_FechaUM, CTOD("01/01/1900") as AV_FechaPasiva FROM carteles INTO CURSOR nuevos
 UPDATE avisos SET av_fechapasiva = DATE()
APPEND FROM DBF('nuevos')
