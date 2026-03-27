* Todas las Conexiones e inicializaciones de Obj. y Variables
* Que necesito para el sistema y todos los seteos

public mcon1,mcon3,mret
*Nombre de los Procedures
public GuardoDatosSQL,EjecutoSql,ActualizoGrid 
*Nombre de Variables
public  midpers, mape, mid, mob, mdt, maten, mForm,;
		 midSocio,mpac
public mfrmmesa2cmdprint, mfrmmesa2cmdsave
		 
set ansi on
set bell off
set cent on
set compatible off
set conf on 
set date to french
set decimal to 2
set dele on
set exact on
set exclu off
set fdow to 1   
set hours to 24
set near on
set notify off
set path to Scx, Lib, Mnu, Prg, Exe, Bmp, Rep
set library to librerias_mesa_ent.prg 
set optimize on
set point to ","
set safety off
set separator to "."
set status off
set status bar off
set talk off
set sysmenu off		 
_screen.keypreview = .t.

mresplog = 0

modify windows screen;
	title "Mesa de Admision";
	FILL FILE "\qepd1a1\solo_marca.jpg"
	
*!*		do form frmmesalog WITH 'MESAADMISION'
*!*		
*!*		if mresplog = 0
		create cursor Mwkusuario (idusuario c(10))
		insert into Mwkusuario values ('DIRECCION')
		
		do sp_busco_server_namespaces
		on error =aerr(eros)
		mfile = justpath(SYS(16,0))+"\inicio\ini.txt"
		mcadcon = filetostr(mfile)
		on error
		if type('mcadcon') = "C"
			mDatabase 	= mline(mcadcon,3)
			mDatabase 	=alltrim(substr(mDatabase,at("=",mDatabase)+1))
			if !empty('mDatabase')
				select mwktabcfg
				replace olespaces with mDatabase 	
			endif	
		endif	
		 mfrmmesa2cmdprint =.t.	
		 mfrmmesa2cmdsave  =.f.
	If !Used("mwkserver1")
		Do sp_conexion
	EndIf 
		 mcon3=mcon1
		 DO FORM frmMesa4.scx
		 
*!*			do mnme.mpr
*!*			read events
*!*		endif	
	
	
	
*!*		   DO EjecutoSql with 0
*!*	   		if messagebox("Esta Ud. Recibiendo a las Persona?",4+32,"Comienzo de Sesion")= 6
*!*	      		DO sp_conexion
*!*	 			DO EjecutoSql with 0
*!*				 DO FORM frmMesa1.scx
*!*	   		else
*!*	   			DO sp_conexion
*!*	 			DO EjecutoSql with 0
*!*	   	  		DO FORM frmMesa2.scx   
*!*	   		endif	  
   	
*!*	*!*			 
*!*	endif


