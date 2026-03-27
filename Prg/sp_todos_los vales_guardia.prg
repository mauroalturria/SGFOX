**
**
**




select VAL_fechasolicitud, VAL_horasolicitud, PAC_nombrepaciente,
 his_codentidad, ENT_descrient, VAL_codservvale, ser_descripserv,
 pia_codprest, pre_descriprest, nombre
 from pacientes, servicios, histambgua, presinsuvas,
 prestacions, entidades ,
 valesasist left outer join prestadores 
      on VAL_prestador = prestadores.id 
 where his_codadmision = PAC_codadmision and 
 PAC_codadmision = VAL_codadmision and 
 valesasist = pia_valesasist and
 pia_codprest = pre_codprest and
 his_codentidad = ENT_codent and
 VAL_codservvale = ser_codserv and
 VAL_fechasolicitud = to_date('01/11/2003','dd/mm/yyyy') and
 VAL_tipopaciente = 'GUA'