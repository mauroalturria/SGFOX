lparameters Pmid,mcursor
if vartype(mcursor)#"C"
	mcursor = "mwkprevobs"
endif
if vartype(Pmid)= "N"
	mbusco = "Where IdAutPrevias = ?Pmid "
else
	mbusco = "Where IdAutPrevias in "+Pmid
endif

mRet = sqlexec(mcon1,"select Tabautobs.*,Tabusuariofirma.*,tabusuario.idusuario,tabusuario.nomape,tabestados.descrip"+;
	" from  Tabautobs " + ;
	"left join tabusuario on Tabautobs.usuario = tabusuario.idusuario " + ;
	"left join Tabusuariofirma on tabusuario.codigovax = TUF_codigovax " + ;
	"left join tabestados on (Tabautobs.estado = tabestados.subestado and tabestados.propietario = 28) " + ;
	mbusco+" and TUF_tipo = 4 order by Tabautobs.id desc  ",mcursor)
