*
* Selecciono legajos activos
*
Lparameters ntodos, mLegajo

Local mFechaHoy
Local mWhere

mFechaHoy = Sp_Busco_Fecha_Serv("DD")

mFechaHoy = Dtot(mFechaHoy)

mLegajo = Iif(Vartype(mLegajo) = "N", Alltrim(Str(mLegajo)), "")

mWhere = Iif(Empty(mLegajo), "", " where SF_Legajo = '" + mLegajo + "' ")

mret  = SQLExec(mcon1,"select SF_Apellido as leg_apellido,SF_Nombre as leg_Nombre,SF_Legajo as Leg_id"+;
	",1 as LEG_TIPODOC,SF_CUIL as LEG_NRODOC, SF_sector ,SF_NroMatricula,sf_tipomatricula "+;
	" from ZabSF " + mWhere,"MwkLegajo")
If mret<=0
	Messagebox("ERROR EN LA LECTURA DE LEGAJOS",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

ccharmalos = "ÁÉÍÓÚÀÈÌÒÙ$ðÐ^/\'$:ñ¥·ÿŸº?¿!¡%&()=¨;.ª|¬[]{}-"

Select Alltrim(prg_saca_char(Upper(leg_apellido),ccharmalos)) + "," + Alltrim(prg_saca_char(Upper(leg_Nombre),ccharmalos)) As leg_Nombre;
	,Int(Val(Leg_id)) As Leg_id,LEG_NRODOC,Ctod("  /  /  ") As LEG_fechaegr;
	,'' As leg_path, 0 As leg_tipodoc,'' As LEG_TELEFONO,SF_sector,Val(Transform(SF_NroMatricula)) As SF_NroMatricula;
	,Left(sf_tipomatricula,1) As Tipomat  ;
	from MwkLegajo Order By Leg_id;
	INTO Cursor MwkLegajo

Return .T.
