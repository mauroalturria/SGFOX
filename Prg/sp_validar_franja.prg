PARAMETERS mhoraDesde,mhorahHasta,mfechaDesde,mfechaHasta
	     IF USED('MwkFranjaDia')  
				select * from MwkFranjaDia where ;
					between(mhoraDesde,ttoc(horadesde,2),ttoc(horahasta,2));
					and between(mfechaDesde,fecvigend,fecvigenh);
					and not mhoraDesde =ttoc(horahasta,2);
					union;
					select * from MwkFranjaDia where ;
					between(mhoraDesde,ttoc(horadesde,2),ttoc(horahasta,2));
					and between(mfechaHasta,fecvigend,fecvigenh);
					and not mhoraDesde =ttoc(horahasta,2);
					union;
					select * from MwkFranjaDia where ;
					between(mhoraDesde,ttoc(horadesde,2),ttoc(horahasta,2));
					and (mfechaDesde < fecvigend and mfechaHasta > fecvigenh) ;
					and not mhoraDesde =ttoc(horahasta,2);
					union;
					select * from MwkFranjaDia where ;
					between(mhorahHasta,ttoc(horadesde,2),ttoc(horahasta,2));
					and between(mfechaDesde,fecvigend,fecvigenh);
					and not mhorahHasta =ttoc(horadesde,2);
					union;
					select * from MwkFranjaDia where ;
					between(mhorahHasta,ttoc(horadesde,2),ttoc(horahasta,2));
					and between(mfechaHasta,fecvigend,fecvigenh);
					and not (mhorahHasta =ttoc(horadesde,2));
					union;
					select * from MwkFranjaDia where ;
					between(mhorahHasta,ttoc(horadesde,2),ttoc(horahasta,2));
					and (mfechaDesde < fecvigend and mfechaHasta > fecvigenh) ;
					and not mhorahHasta =ttoc(horadesde,2);
					union;
					select * from MwkFranjaDia where mhoraDesde < ttoc(horadesde,2);
					and mhorahHasta > ttoc(horahasta,2);
					and between(mfechaDesde,fecvigend,fecvigenh);
					union;
					select * from MwkFranjaDia where mhoraDesde < ttoc(horadesde,2);
					and mhorahHasta > ttoc(horahasta,2);
					and between(mfechaHasta,fecvigend,fecvigenh);
					union;
					select * from MwkFranjaDia where mhoraDesde < ttoc(horadesde,2);
					and mhorahHasta > ttoc(horahasta,2);
					and (mfechaDesde < fecvigend and mfechaHasta > fecvigenh) ;
					into cursor MwkfranjaDiaExiste
	    ELSE
	                MESSAGEBOX("NO EXITE FRANJA HORARIA",16,"VALIDACION")
	    ENDIF  
				