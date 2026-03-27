PARAMETERS mid, madmisionRN , medadmat , mgesta , mcesarea , mabortos , mgrupoyfactor , mpci , mgammagarh , membarazoctrl ,;
 mfechavdrl , mvdrl , mhiv , mfechahiv , migg , mfechaigg , migm , mfechaigm , mhepb , mfechahepb , megb , mprofilaxis , mtoxoplasma , mchagas ,;
 midevol , mfechasys , musuario

if mid = 0

	TEXT To lcsql Textmerge Noshow Pretext 7
		Insert into ZabNeoAntecMaterno
		( NAM_admisionRN , NAM_edadmat , NAM_gesta , NAM_cesarea , NAM_abortos , NAM_grupoyfactor , NAM_pci , NAM_gammagarh , NAM_embarazoctrl , NAM_fechavdrl , NAM_vdrl , NAM_hiv , NAM_fechahiv , NAM_igg , NAM_fechaigg , NAM_igm , NAM_fechaigm , NAM_hepb , NAM_fechahepb , NAM_egb , NAM_profilaxis , NAM_toxoplasmosis , NAM_chagas , NAM_idevol , NAM_fechahora , NAM_usuario) 
		 Values 
		( ?madmisionRN , ?medadmat , ?mgesta , ?mcesarea , ?mabortos , ?mgrupoyfactor , ?mpci , ?mgammagarh , ?membarazoctrl , ?mfechavdrl , ?mvdrl , ?mhiv , ?mfechahiv , ?migg , ?mfechaigg , ?migm , ?mfechaigm , ?mhepb , ?mfechahepb , ?megb , ?mprofilaxis ,?mtoxoplasma, ?mchagas , ?midevol , ?mfechasys , ?musuario) 
	ENDTEXT

else

	TEXT To lcsql Textmerge Noshow Pretext 7
		Update ZabNeoAntecMaterno 
		Set NAM_admisionRN  = ?madmisionRN , 
		NAM_edadmat  = ?medadmat , 
		NAM_gesta  = ?mgesta , 
		NAM_cesarea  = ?mcesarea , 
		NAM_abortos  = ?mabortos , 
		NAM_grupoyfactor  = ?mgrupoyfactor , 
		NAM_pci  = ?mpci , 
		NAM_gammagarh  = ?mgammagarh , 
		NAM_embarazoctrl  = ?membarazoctrl , 
		NAM_fechavdrl  = ?mfechavdrl , 
		NAM_vdrl  = ?mvdrl , 
		NAM_hiv  = ?mhiv , 
		NAM_fechahiv  = ?mfechahiv , 
		NAM_igg  = ?migg , 
		NAM_fechaigg  = ?mfechaigg , 
		NAM_igm  = ?migm , 
		NAM_fechaigm  = ?mfechaigm , 
		NAM_hepb  = ?mhepb , 
		NAM_fechahepb  = ?mfechahepb , 
		NAM_egb  = ?megb , 
		NAM_profilaxis  = ?mprofilaxis ,
		NAM_toxoplasmosis = ?mtoxoplasma ,
		NAM_chagas = ?mchagas ,
		NAM_idevol = ?midevol ,
		NAM_fechahora = ?fechasys ,
		NAM_usuario = ?musuario
		where ID = ?mid 
	ENDTEXT

endif

If !Prg_EjecutoSql(lcSql,"mwk")
	Messagebox("ERROR AL GUARDAR",16,"ERROR")
	Return .f.
ENDIF