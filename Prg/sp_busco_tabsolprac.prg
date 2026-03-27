parameters tnOpcion, tcWhere, tcCursor

if vartype(tcWhere) # "C"
	tcWhere = ' '
endif

if vartype(tcCursor) # "C"
	tcCursor= 'mwksolprac'
endif

do case
	case tnOpcion = 1
		lcSql = "select TabSolPract.*,pre_descriprest,pre_codservicio, ser_descripserv "+;
			",guardia.codcie9 ,tabambulatorio.codcie9,pre_especialidad,pre_tipomuestra,tabambulatorio.codent as codentamb "+;
			",guardia.codent as codentgua, tabbacteriotipomuestra.BAC_descripmuestra,TabSolPract.ASP_codmuestra"+;
			",tabbacteriotipomuestra.BAC_codigomuestra,tabambulatorio.centromedico " +;
			" from TabSolPract  " + ;
			" left join prestacions on ASP_codprest = pre_codprest "+;
			" left join tabambulatorio on ASP_protocolo = tabambulatorio.protocolo "+;
			" left join guardia on ASP_protocolo = guardia.protocolo "+;
			" left join servicios on pre_codservicio = ser_codserv "+;
			" left join tabbacteriotipomuestra on TabSolPract.ASP_codmuestra = tabbacteriotipomuestra.id " +;
			tcWhere
	case tnOpcion = 2
				
		lcSql = "select TabSolPract.*,pre_descriprest,pre_codservicio, pre_especialidad ,ser_descripserv,pre_tipomuestra, "+;
		    " tabbacteriotipomuestra.BAC_descripmuestra,TabSolPract.ASP_codmuestra,tabbacteriotipomuestra.BAC_codigomuestra, " +;
		    " tabambulatorio.centromedico " +;
		    " from TabSolPract  " + ;			
			" left join prestacions on ASP_codprest = pre_codprest "+;
			" left join tabambulatorio on ASP_protocolo = tabambulatorio.protocolo "+;
			" left join servicios on pre_codservicio = ser_codserv "+;
			" left join tabbacteriotipomuestra on TabSolPract.ASP_codmuestra = tabbacteriotipomuestra.id " +;
			tcWhere
	otherwise
		lcSql =''
endcase
if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	return .f.
endif
