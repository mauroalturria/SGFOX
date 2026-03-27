*****************************************************************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
******************************************************************************
* Modificado:18/06/2003
**********************************************
* hago un insert del registro de prestaciones 
* al de medico -prestaciones
**********************************************
*do sp_conexion.prg

select Mwkpresta
scan 
	mnagenda =GeneraAgen
	mccodesp =codesp
	mncodmed=codmed
	mncodprest=codprest
   mncodserv=codserv
   mndia= DiaSem
   mtdura= ttoc(duracion,2)
   mcthrdes=ttoc(HoraDesde,2)
   mcthrhas= ttoc(HoraHasta,2)
   mcsala=  sala
   mfecvigend= fecvigend
   mfecvigenh=fecvigenh
   mdfecagen= fechaUltAgenda
   midusu= usuario
   fecaudi= fhgraba
   mncanttur= canturnos
   mdhdesde1=hdesde1
   mdhhasta1 =hhasta1
   mndemanda =demanda
   hhmmD  =hhmmDes
   hhmmH=hhmmHas 

	 mret=sqlexec(mcon1," INSERT INTO medpresta(GeneraAgen, codesp, codmed, codprest,  codserv, "+;
				   " DiaSem, duracion, HoraDesde, HoraHasta, sala, fecvigend,  " +; 
				   " fecvigenh, fechaUltAgenda, usuario, fhgraba, canturnos,   " +;
				   " hdesde1, hhasta1, demanda, hhmmDes, hhmmHas ) values (?mnagenda,?mccodesp,  ?mncodmed,         " +;
				   " ?mncodprest, ?mncodserv, ?mndia, ?mtdura,      " +;
				   " ?mcthrdes, ?mcthrhas, ?mcsala,  ?mfecvigend, ?mfecvigenh,   " +;
				   " ?mdfecagen, ?midusu, ?fecaudi, ?mncanttur, ?mdhdesde1,    " +;
				   " ?mdhhasta1, ?mndemanda, ?hhmmD, ?hhmmH )")

	if mret < 0
		=aerr(eros)
		messagebox(eros(3))
		set step on
	endif	
endscan
