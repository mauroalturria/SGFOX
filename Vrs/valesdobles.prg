select count(VAL_codadmision),* from vales_realprest group by pre_codprest,VAL_codadmision having count(VAL_codadmision)>1;
into cursor dobles
select * from vales_realprest where PIA_cantsolicitada>0 and alltrim(VAL_codadmision)+transform(pre_codprest) ;
in (select alltrim(VAL_codadmision)+transform(pre_codprest) from dobles ) and VAL_codvaleasist not in (select nrovale from turnoid);
into cursor bajas


SELECT Valesasist.VAL_fechasolicitud, Valesasist.VAL_codvaleasist,;
  Valesasist.VAL_NroProtocolo, Prestacions.PRE_descriprest,;
  Prestacions.PRE_codprest, Presinsuvas.PIA_cantsolicitada,;
  Valesasist.VAL_tipopaciente, Valesasist.VAL_codsector,;
  Valesasist.VAL_codpun, Valesasist.VAL_codadmision;
 FROM SQLUser.VALESASIST Valesasist,;
  SQLUser.PRESINSUVAS Presinsuvas, SQLUser.PRESTACIONS Prestacions;
 WHERE Presinsuvas.PIA_VALESASIST = Valesasist.VALESASIST;
   AND Prestacions.PRE_codprest = Presinsuvas.PIA_codprest;
   AND (Valesasist.VAL_codservvale = 2200;
   AND Valesasist.VAL_fechasolicitud >= '2015-08-15';
   AND Valesasist.VAL_OperadorCarga = 57594)

select count(VAL_codadmision),* from vales_realprest group by pia_codprest,VAL_codadmision having count(VAL_codadmision)>1;
into cursor dobles

select * from vales_realprest where val(PIA_cantsolicitada)>0 and alltrim(VAL_codadmision)+transform(PIA_codprest) ;
in (select alltrim(VAL_codadmision)+transform(PIA_codprest) from dobles ) and VAL_codvaleasist not in (select nrovale from guardia_vales);
into cursor bajas
