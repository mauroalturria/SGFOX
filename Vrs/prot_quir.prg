
SELECT Guardia.codprest, Tabguaevol.EG_motConsulta,;
  Tabguaevol.EG_exFisico, Tabguaevolmed.EGM_codmed,;
  Tabguaevolmed.EGM_evol, Tabguaevol.EG_evolHist, Guardia.protocolo,;
  Tabguaevol.EG_codmed, Tabguaevol.EG_evolucion, Guardia.fechahoraing,;
  Guardia.nroregistrac;
 FROM SQLUser.TabGuaEvol Tabguaevol, SQLUser.Guardia Guardia,;
  SQLUser.TabGuaEvolMed Tabguaevolmed;
 WHERE Guardia.protocolo = Tabguaevol.EG_protocolo;
   AND Tabguaevol.EG_protocolo = Tabguaevolmed.EGM_proto;
   AND (Guardia.fechahoraing >= ?fecha;
   AND Guardia.codprest IN (42010104,42010105);
   AND Guardia.protocolo > '0935049-09');
 ORDER BY Guardia.fechahoraing




select protocolo from guaevolquir where (at('TRAUMA',upper(egm_evol))>0 or at('HERIDA',upper(eg_motconsulta))>0);
or at('TRAUMA',upper(eg_motconsulta))>0 into cursor quiro


select * from guaevolquir where protocolo in (select protocolo from quiro) order by protocolo into cursor protquir
copy to prot_quir2 type xl5