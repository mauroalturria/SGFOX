****
** busco turnos asociados a entidades
****

PARAMETERS mtipotur,mtipopac,mbusco
if type ('mtipotur')#"N"
	mtipotur = 0
ENDIF
if type ('mtipopac')#"C"
	mtipopac = 'AMB'
ENDIF
if type ('mbusco')#"C"
	mbusco = ''
ENDIF
mret = sqlexec(mcon1,"SELECT codent, tipoturno, tpopac,ID, fecvigend, fecvigenh "+;
 	" FROM Entidexclu WHERE  tipoturno = ?mtipotur AND  tpopac = ?mtipopac ","mwkentitur")

mfecnul = ctod("01/01/1900")
mret = sqlexec(mcon1,"select ENT_codent, ENT_descrient,ent_capita " + ;
	" FROM ENTIDADES  where  ENT_descrient is not null "+mbusco+" and  ENT_fecpas IS NULL and ENT_codent not in (select codent from Entidexclu " +;
	" where tipoturno = ?mtipotur AND  tpopac = ?mtipopac and fecPasiva = ?mfecnul ) "+;
	"  group by ENT_codent order by ENT_descrient " , "mwkentST")

if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif
mret = sqlexec(mcon1,"select ENT_codent, ENT_descrient,ent_capita " + ;
	" FROM ENTIDADES  where  ENT_descrient is not null  "+mbusco+" and  ENT_fecpas IS NULL and ENT_codent in (select codent from Entidexclu " +;
	" where tipoturno = ?mtipotur AND  tpopac = ?mtipopac and fecPasiva = ?mfecnul ) "+;
	"  group by ENT_codent order by ENT_descrient  " , "mwkentCT")

if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif
