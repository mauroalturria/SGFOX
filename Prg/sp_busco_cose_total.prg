***
** busco valores de Coseguros
***

mfechapas = Ctod("01/01/2100")
	Do sp_busco_estados With 105 ," and tipo = 5  ","mwkservrossi"  
 
mret = SQLExec(mcon1,"select ID , descripcion,Abreviatura, AbreviaEnt, CodEntAg,PlanCoseg "+;
	" from Planes where FecPasivaPlan = '1900-01-01' "  , "mwkplanto")
Select Val(Alltrim(Abreviatura)) As idplan,* From mwkplanto Into Cursor mwkplanto
mret = SQLExec(mcon1,  "select Cosegurostipoatencion.Descripcion, Coseguros.Coseguro,"+;
	" Coseguros.Plan, Coseguros.TipoAten, Coseguros.Entidad,"+;
	" Entidades.ENT_descrient, "+;
	" Coseguros.Cant_Prestaciones, Coseguros.Fecha "+;
	" from Coseguros,Cosegurostipoatencion "+;
	" ,Entidades  "+;
	" where Coseguros.TipoAten = Cosegurostipoatencion.ID "+;
	" and Coseguros.Entidad = Entidades.ENT_codent "+;
	" and Entidades.ENT_fecpas IS NULL  and Coseguros.FechaHasta >= {fn curdate()} "+;
	"  " ,'MwkCoseimp')
If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL BUSCAR LOS DATOS", 48, "Validacion")
Endif
mret = SQLExec(mcon1,  "select Cosegurostipoatencion.Descripcion, Tabbono.Importe as Coseguro,"+;
	" Coseguros.Plan, Coseguros.TipoAten, Coseguros.Entidad,"+;
	" Entidades.ENT_descrient,  "+;
	" Coseguros.Cant_Prestaciones,  Tabbono.fecvigend as Fecha "+;
	" from Coseguros,tabbono,Cosegurostipoatencion,Entidades  "+;
	" where Coseguros.TipoAten = Cosegurostipoatencion.ID  "+;
	" and Coseguros.Entidad = Entidades.ENT_codent "+;
	" and Coseguros.Bono_Importe = Tabbono.ID and Entidades.ENT_fecpas IS NULL "+;
	" and Coseguros.FechaHasta >= {fn curdate()} and Tabbono.fecvigenh >= {fn curdate()} "+;
	"      " ,'MwkCosbono')
If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL BUSCAR LOS DATOS", 48, "Validacion")
Endif
mret = SQLExec(mcon1,"SELECT Coseprac.Entidad, Coseprac.Fecha, Coseprac.Prestacion,"+;
	"Coseprac.TipoAtenAmb, Prestacions.PRE_descriprest"+;
	" FROM  Coseprac "+;
	" INNER JOIN  Prestacions "+;
	" ON  Coseprac.Prestacion = Prestacions.PRE_codprest "+;
	"  INNER JOIN  Entidades "+;
	"  ON  Coseprac.Entidad = Entidades.ENT_codent"+;
	" WHERE  Entidades.ENT_fecpas IS NULL "+;
	" and Prestacions.PRE_codservicio in ("+ALLTRIM(mwkservrossi.descrip)+')',"mwkcoseprac")

Select MwkCoseimp.*,mwkplanto.AbreviaEnt, mwkplanto.Descripcion As Descriplan ;
	From  MwkCoseimp Left Join mwkplanto On MwkCoseimp.Plan = mwkplanto.Abreviatura;
	Where Entidad Not In ( Select Entidad From MwkCosbono);
	union All Select MwkCosbono.*,mwkplanto.AbreviaEnt, mwkplanto.Descripcion As Descriplan;
	From MwkCosbono Left Join mwkplanto On MwkCosbono.Plan = mwkplanto.Abreviatura;
	into Cursor MwkCostotalsp
SELECT MwkCostotalsp.*,Prestacion,PRE_descriprest FROM MwkCostotalsp;
inner JOIN mwkcoseprac ON (mwkcoseprac.entidad = MwkCostotalsp.entidad;
	 AND mwkcoseprac.TipoAtenAmb = MwkCostotalsp.TipoAten);
	 ORDER BY ENT_descrient, Plan, TipoAten,PRE_descriprest  ;
	 INTO CURSOR MwkCostotal
