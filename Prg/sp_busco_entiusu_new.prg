
Parameters mopcion,mcodent ,mnroreg,midusu

mfecnul = Ctod("01/01/1900")
mbusco= ''
Do Case
Case mopcion = 0
	mret = SQLExec(mcon1," select nomape,email,IET_protocolo,IET_nroregis,IET_avisoxmail"+;
		",IET_fechadesde, IET_fechahasta,IET_perfil,IET_usuarioid,IET_fecpasiva,Tabusuario.id "+;
		" from Tabusuario  "+;
		" left join ZabInvET on IET_usuarioid = Tabusuario.id   "+;
		" where Tabusuario.fecpasiva = '1900-01-01' and {fn LEFT(nomape,1)} <>'*' order by nomape  ","mwkEntiUsu" )
Case mopcion = 1
	mret = SQLExec(mcon1," select nomape,email,IET_protocolo,IET_nroregis,IET_avisoxmail"+;
		",IET_fechadesde, IET_fechahasta,IET_perfil,IET_usuarioid,IET_fecpasiva,Tabusuario.id "+;
		" from Tabusuario "+;
		" left join ZabInvET on IET_usuarioid = Tabusuario.id   "+;
		" where Tabusuario.fecpasiva = '1900-01-01' and {fn LEFT(nomape,1)} <>'*' order by nomape  ","mwkEntiUsup" )

Case mopcion = 3
	mret = SQLExec(mcon1," select IET_protocolo,IET_nroregis"+;
		",IET_fechadesde, IET_fechahasta,IET_perfil,IET_usuarioid "+;
		" from  ZabInvET   "+;
		" where  IET_usuarioid = ?midusu and IET_fecpasiva = ?mfecnul  ","mwkEntiUsu" )
CASE mopcion = 4
	mret = SQLExec(mcon1," select ID,IET_nroregis"+;
		",IET_fechadesde, IET_fechahasta,IET_perfil,IET_usuarioid "+;
		" from  ZabInvET   "+;
		" where  IET_nroregis = ?mnroreg and IET_fecpasiva = ?mfecnul and IET_avisoxmail = 1 ","mwkEntiUsu" )	
Endcase
If mret < 0
	=Aerr(eros)
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	mret=0
	SELECT * FROM mwkusuario WHERE 1=2 INTO CURSOR mwkEntiUsu
Endif

