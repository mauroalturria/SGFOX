SELECT codesp, nombre, codent, codestado,fechaate, PRE_descriprest, demanda,;
  fechahoraate, descrip,codprest, PRE_codservicio;
  ,sum(codestado) as suma from tabambula group by protocolo where ;
!inlist( pre_codservicio,5163,6300,6500,6800,6900,9100,7000,7100,7700,7800) ;
and nrovale >0 and !inlist(codesp ,'ERGO','ECGR','KINE') AND DEMANDA#8 into cursor total