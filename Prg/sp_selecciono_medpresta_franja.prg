*******************************
* AUTOR:Claudia Antoniow
* FECHA:17/06/2003
*******************************
* MODIFICADO:17/06/2003
*************************************************
* Cursor de Impresion del listado de franjas
*************************************************
mccpoamb = ''
if mxambito >1
	mccpoamb = "  and C.codambito = ?mxambito "
endif

mfecnul = ctod("01/01/1900")
mhoy=sp_busco_fecha_serv('DD')
mret=SQLExec(mcon1," SELECT C.*,t.Abreviatura FROM Prestadores AS A,FranjaHoraria as C,TabTipoturno as T" + ;
	" WHERE T.tipoturno = C.tipoturno and  (fecpasivap = ?mfecnul or fecpasivap > ?mhoy) and  A.Id= c.Codmed " + ;
	" AND NOT c.diasem is Null  "+ mbusqlisf + mccpoamb , "mwkFranjapres")

mret =sqlexec(mcon1, "SELECT Prestadores.ID, Tabcargo.nivel,Tabcargo.descrip "+;
	" FROM Prestadores,Tabcargo,Tabprofesp"+;
	" WHERE  Tabprofesp.CodCargo = Tabcargo.ID "+;
	"  AND  Prestadores.ID = Tabprofesp.CodProf "+;
	" ORDER BY Prestadores.nombre, Tabcargo.orden desc ","mwkcargo1")
select * from mwkcargo1 group by id into cursor mwkcargo
 	
mret=SQLExec(mcon1,'SELECT F.Titulo,A.nombre,C.diasem,C.horadesde,C.horahasta, ' +;
	'C.duracion,C.Sala,C.fecvigend,C.fecvigenh,E.ESP_descripcion, C.generaagen, ' +;
	'C.Reservados, C.demanda,C.codmed,c.codesp,c.hhmmdes,A.enreldep,a.nroproveedor ' + ;
	'FROM Prestadores AS A, Medpresta AS C, Especialid AS E, TabProfesion AS F ' +;
	'WHERE (fecpasivap = ?mfecnul or fecpasivap > ?mhoy) and  A.Id=C.Codmed AND '+;
	'trim(E.ESP_Codesp)=C.Codesp ' +;
	'AND A.codprof=F.id AND NOT c.diasem is Null '+ mbusqlis + mccpoamb +;
	'GROUP BY c.codmed,c.diasem,c.horadesde,c.horahasta,C.codesp,C.fecvigend,C.fecvigenh ' +;
	'ORDER BY A.Nombre,C.Diasem,C.Horadesde,E.ESP_descripcion,C.fecvigend ','MwkListaMedPresta')

if mret < 0
	messagebox('ERROR EN EL CURSOR DE IMPRESION',64,'Validación')
	mret=0
endif
select MwkListaMedPresta.*,  Estructura,Tiposervicio,tipoturno,Abreviatura ;
	from MwkListaMedPresta,mwkFranjapres;
	where MwkListaMedPresta.diasem = mwkFranjapres.diasem and;
	MwkListaMedPresta.codmed = mwkFranjapres.codmed and;
	MwkListaMedPresta.hhmmdes = mwkFranjapres.hhmmdes and;
	between(MwkListaMedPresta.fecvigend,mwkFranjapres.fecvigend,mwkFranjapres.fecvigenh) and;
	between(MwkListaMedPresta.fecvigenh,mwkFranjapres.fecvigend,mwkFranjapres.fecvigenh) ;
	GROUP BY MwkListaMedPresta.codmed,MwkListaMedPresta.diasem,MwkListaMedPresta.horadesde,;
	MwkListaMedPresta.horahasta,MwkListaMedPresta.codesp,MwkListaMedPresta.fecvigenh;
	into cursor MwkListaMedPrest
