*
* Actualizacion RTS
*
Use in select("mwkfichas")
mret = sqlexec(mcon1,"select * from TabFichaTraumatologica ","mwkfichas")
If mret < 0
	=aerror(merror)
	Messagebox(merror(3),16,"ERROR")
	Return
Endif
&& Frecuencia respiratoria
Use in select("mwkbase1")
mret = sqlexec(mcon1,"select * from TabFichaTrauVal where FTV_agrupa=1","mwkbase1")
If mret < 0
	=aerror(merror)
	Messagebox(merror(3),16,"ERROR")
	Return
Endif
&& Tension sistolica
Use in select("mwkbase2")
mret = sqlexec(mcon1,"select * from TabFichaTrauVal where FTV_agrupa=2","mwkbase2")
If mret < 0
	=aerror(merror)
	Messagebox(merror(3),16,"ERROR")
	Return
Endif
Select mwkfichas
Scan all
	mlidfic = mwkfichas.id
	mlidfre = mwkfichas.FT_frecResp && Frecuencia respiratoria
	mlidtas	= mwkfichas.FT_tas      && Tension sistolica
	Use in select("mwkval1")
	Use in select("mwkval2")
	Select FTV_valor from mwkbase1 where mwkbase1.id = mlidfre into cursor mwkval1
	Select FTV_valor from mwkbase2 where mwkbase2.id = mlidtas into cursor mwkval2
	mvglasg = 0
	Do case
	Case BETWEEN(mwkfichas.FT_glasgow,13,15)
		mvglasg = 4
	Case BETWEEN(mwkfichas.FT_glasgow,9,12)
		mvglasg = 3
	Case BETWEEN(mwkfichas.FT_glasgow,6,8)
		mvglasg = 2
	Case BETWEEN(mwkfichas.FT_glasgow,4,5)
		mvglasg = 1
	otherwise
		mvglasg = 0
	Endcase
	mrts = mwkval1.FTV_valor + mwkval2.FTV_valor + mvglasg
	mret = sqlexec(mcon1,"update TabFichaTraumatologica"+;
		" set FT_indRts = ?mrts where id = ?mlidfic")
	If mret < 0
		=aerror(merror)
		Messagebox(merror(3),16,"ERROR")
		Exit
	Endif
	Select mwkfichas
Endscan
Use in select("mwkfichas")
Use in select("mwkbase1")
Use in select("mwkbase2")
Use in select("mwkval1")
Use in select("mwkval2")
Messagebox("Finalizada",48,"Actualización")
Return
