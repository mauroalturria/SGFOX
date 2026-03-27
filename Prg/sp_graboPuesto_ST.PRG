parameter mPuesto,mObser,mUbic,mid,mabm,mMaquina,mrack,mppuesto,mpachera,midSector,mimagen,mnombre,mModelo,mnroserie,mImagen
dimension cf(100)
store '' to cf

mfechatope = sp_busco_fecha_serv('DD')

DO CASE 
   CASE mabm = 1
        IF USED('mwkValidPuesto')
           SELECT mwkValidPuesto
           use
        ENDIF 
		mret =	sqlexec(mcon1,"select puesto from tabStPuesto where puesto = ?mPuesto or Maquina =?mMaquina","mwkValidPuesto")
		        IF RECCOUNT('mwkValidPuesto') > 0
		            MESSAGEBOX("PUESTO EXISTENTE",16,"VALIDACION")
		            valor = .f.
		            RETURN
		        ENDIF
        IF USED('mwkValidPuesto2')
           SELECT mwkValidPuesto2
           use
        ENDIF 
        

        
        
*!*			mret =	sqlexec(mcon1,"select puesto from tabStPuesto where "+;
*!*			                      " rack = ?mrack AND ppuesto = ?mppuesto AND  pachera  = ?mpachera","mwkValidPuesto2")
*!*			        IF RECCOUNT('mwkValidPuesto2') > 0
*!*			            MESSAGEBOX("RACK,PACHERA,PUESTO EXISTENTE",16,"VALIDACION")
*!*			            valor = .f.
*!*			            RETURN
*!*			        ENDIF
		mret =	sqlexec(mcon1,"insert into tabStPuesto (Puesto,Observaciones,Ubicacion,Maquina,rack,ppuesto,pachera,idSector,imagen2,nombre,idModelo,NroSerie )" +;
			                  " values(?mPuesto,?mObser,?mUbic,?mMaquina,?mrack,?mppuesto,?mpachera,?midSector,?mimagen,?mnombre,?mModelo,?mNroSerie )")

   CASE mabm = 2
        IF USED('mwkValidPuesto')
           SELECT mwkValidPuesto
           use
        ENDIF 
		mret =	sqlexec(mcon1,"select puesto from tabStPuesto where puesto = ?mPuesto or Maquina =?mMaquina","mwkValidPuesto")
		        IF RECCOUNT('mwkValidPuesto') > 1
		            MESSAGEBOX("PUESTO EXISTENTE",16,"VALIDACION")
		            valor = .f.
		            RETURN .F.
		        ENDIF
        IF USED('mwkValidPuesto2')
           SELECT mwkValidPuesto2
           use
        ENDIF 
*!*			mret =	sqlexec(mcon1,"select puesto from tabStPuesto where "+;
*!*			                      " rack = ?mrack AND  ppuesto = ?mppuesto AND  pachera  = ?mpachera","mwkValidPuesto2")
*!*			        IF RECCOUNT('mwkValidPuesto2') > 1
*!*			            MESSAGEBOX("RACK,PACHERA,PUESTO EXISTENTE",16,"VALIDACION")
*!*			            valor = .f.
*!*			            RETURN
*!*			        ENDIF
		mret =	sqlexec(mcon1,"update tabStPuesto set Puesto = ?mPuesto,Observaciones = ?mObser,Ubicacion = ?mUbic,"+;
							  " Maquina = ?mMaquina, rack = ?mrack,ppuesto = ?mppuesto,pachera  = ?mpachera,nombre = ?mnombre, "+;
							  " idSector = ?midSector,imagen2 = ?mimagen,idModelo = ?mModelo,NroSerie =?mNroSerie"+;
							  "  where id = ?mid ")
   CASE mabm = 3
        IF USED('mwkValidDetPuesto')
           SELECT mwkValidDetPuesto
           use
        ENDIF 
        mret =	sqlexec(mcon1,"select * from tabStDetPuesto where idPuesto = ?mid ","mwkValidDetPuesto")
		        IF RECCOUNT('mwkValidDetPuesto') > 0
		            MESSAGEBOX("HAY COMPONENTES ASOCIADOS AL PUESTO DE TRABAJO",16,"VALIDACION")
		            RETURN
		            valor = .f.
		        ENDIF
		mret =	sqlexec(mcon1,"delete from tabStPuesto  where id = ?mid ")
ENDCASE 
   

if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif
