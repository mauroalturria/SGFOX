*
* select de enlace de prestacioens y ranqueo
*
select pre_codprest, pre_descriprest, ppsnropantalla, ppsnroitem
 from prestacions left outer join protprssec
 on prestacions.pre_codprest = protprssec.ppscodprest
 and ppscodsector = 'AMB'
 Where pre_codservicio = 7000
 order by ppsnropantalla desc, pre_descriprest