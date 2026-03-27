****
** ranking de insumos por sector
***

parameters mfecdes, mfechas, mbuscaser

mret = sqlexec(mcon1, "select INS_codinsumo, INS_descriinsumo, INSaccion1, "+;
	"INSaparato1, VAL_fechasolicitud, " + ;
	"sum(pia_cantsolicitada) as pia_cantsolicitada, VAL_codsector " + ;
	"from valesasist, presinsuvas " + ;
	" left join insumos on presinsuvas.pia_codinsumo = insumos.insumos " + ;
	"where valesasist = pia_valesasist and INS_fechapasivo is null" + ;
	" and  VAL_codservvale	= 5410 and " + ;
	"VAL_fechasolicitud between ?mfecdes and ?mfechas " + mbuscaser +;
	"group by INS_codinsumo,VAL_codsector ", "mwkinsumos")

if mret < 0
	=aerr(eros)
	if eros(1) = 1526 and eros(5) = 400
		messagebox("ERROR EN LA GENERACION DEL CURSOR"+ chr(13) +"SELECCIONE UN RANGO MENOR", 16, "Validacion")
	else
		messagebox("ERROR "+eros(3)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
	endif
endif
mret = sqlexec(mcon1, "SELECT ID,accion,aparato,descripcion " + ;
	" FROM AparatoAccionMedic  ", "mwkaccmed")

select mwkinsumos.*,descripcion from mwkinsumos ;
	left join mwkaccmed on ( accion = INSaccion1 and aparato = INSaparato1);
	where !isnull(INS_codinsumo)  ;
	order by VAL_codsector asc ,pia_cantsolicitada desc ;
	into cursor mwkranking
