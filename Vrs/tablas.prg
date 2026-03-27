/// Accesos ARM/VC/NUT
Class User.TabIntAVN Extends %Persistent
{

// datos de ARM/VC/NUT del paciente

Index idevolIX On idevol [ Type = bitmap ];

Index fechaHIX On fechaH [ Type = bitmap ];

Index tipoIX On tipo [ Type = bitmap ];

Index usuarioIX On usuario [ Type = bitmap ];

Property idevol As %Library.Integer [ SqlFieldName = AVN_idevol ];

Property fechaH As %TimeStamp [ SqlFieldName = AVN_fechaH ];

Property fechaini As %Date [ SqlFieldName = AVN_fechaini ];

Property fechafin As %Date [ SqlFieldName = AVN_fechafin ];

Property complica As %SmallInt [ SqlFieldName = AVN_complica ];

Property motivo As %SmallInt [ SqlFieldName = AVN_motivo ];

Property modo As %SmallInt [ SqlFieldName = AVN_modo ];

Property peep As %SmallInt [ SqlFieldName = AVN_peep ];

Property vt As %SmallInt [ SqlFieldName = AVN_vt ];

/// 1 - ARM 
/// 2 - Via central
/// 3 - Nutricion
/// 4 - Traqueostomia
/// 5 - Dialisis
Property tipo As %SmallInt [ SqlFieldName = AVN_tipo ];

Property usuario As TabUsuario [ SqlFieldName = AVN_usuario ];

}
/// datos del balance hidrico
/// 
Class User.TabIntBalH Extends %Persistent
{

Index idevolIX On idevol [ Type = bitmap ];

Index fechaHIX On fechaH [ Type = bitmap ];

Index usuarioIX On usuario [ Type = bitmap ];

Property idevol As %Library.Integer [ SqlFieldName = BHI_idevol ];

Property fechaH As %TimeStamp [ SqlFieldName = BHI_fechaH ];

Property hora As %Numeric(MAXVAL = 2400, MINVAL = 0) [ SqlFieldName = BHI_hora ];

Property tipo As %Numeric [ SqlFieldName = BHI_tipo ];

Property entsal As %SmallInt [ SqlFieldName = BHI_entsal ];

Property volumen As %Numeric [ SqlFieldName = BHI_volumen ];

Property observa As %String(MAXLEN = 250) [ SqlFieldName = BHI_observa ];

Property usuario As TabUsuario [ SqlFieldName = BHI_usuario ];

}
/// Evolucion de signos vitales
Class User.TabIntCSV Extends %Persistent
{

Index idevolIX On idevol [ Type = bitmap ];

Index fechaHIX On fechaH [ Type = bitmap ];

Index usuarioIX On usuario [ Type = bitmap ];

Property idevol As %Library.Integer [ SqlFieldName = ESV_idevol ];

Property fechaH As %TimeStamp [ SqlFieldName = ESV_fechaH ];

Property hora As %Numeric(MAXVAL = 2400, MINVAL = 0) [ SqlFieldName = ESV_hora ];

Property parFreCard As %Integer(FORMAT = "+") [ SqlFieldName = ESV_parFreCard ];

Property parFreResp As %Integer(FORMAT = "+") [ SqlFieldName = ESV_parFreResp ];

Property parGluc As %Integer(FORMAT = "+") [ SqlFieldName = ESV_parGluc ];

Property parPeso As %Float [ SqlFieldName = ESV_parPeso ];

Property parSatur As %Integer(FORMAT = "+") [ SqlFieldName = ESV_parSatur ];

Property parTemAxl As %Float [ SqlFieldName = ESV_parTemAxl ];

Property parTemBuc As %Float [ SqlFieldName = ESV_parTemBuc ];

Property parTemRct As %Float [ SqlFieldName = ESV_parTemRct ];

Property parTensDia As %Integer(FORMAT = "+") [ SqlFieldName = ESV_parTensDia ];

Property parTensSis As %Integer(FORMAT = "+") [ SqlFieldName = ESV_parTensSis ];

Property parTensAM As %Integer(FORMAT = "+") [ SqlFieldName = ESV_parTensAM ];

Property parPIC As %Integer(FORMAT = "+") [ SqlFieldName = ESV_parpic ];

Property usuario As TabUsuario [ SqlFieldName = ESV_usuario ];

}
/// Evoluciones de Pacientes Internados
Class User.TabIntEvol Extends %Persistent
{

Index FechaIX On fechaHora [ Type = bitmap ];

Index secuenciaIX On secuencia [ Type = bitmap ];

Index admisionIX On admision [ Type = bitmap ];

Property admision As %String(MAXLEN = 11, TRUNCATE = 1) [ SqlFieldName = EI_admision ];

Property codCIE As %Library.Integer [ SqlFieldName = EI_codcie ];

Property codmed As %Library.Integer(FORMAT = "+", MAXVAL = "") [ SqlFieldName = EI_codmed ];

Property codmedcie As %Library.Integer(FORMAT = "+", MAXVAL = "") [ SqlFieldName = EI_codmedcie ];

Property codestado As %Library.Integer(FORMAT = "+", MAXVAL = "") [ SqlFieldName = EI_codestado ];

Property secuencia As %Library.Integer [ SqlFieldName = EI_secuencia ];

Property fechaHora As %TimeStamp [ SqlFieldName = EI_fechaHora ];

Property horaCierre As %TimeStamp [ SqlFieldName = EI_horaCierre ];

/// ananmnesis piel y faneras
Property anpiel As %GlobalCharacterStream [ SqlFieldName = EI_anpiel ];

/// ananmnesis Cabeza y Cuello
Property ancyc As %GlobalCharacterStream [ SqlFieldName = EI_ancyc ];

/// ananmnesis Respiratorio
Property anresp As %GlobalCharacterStream [ SqlFieldName = EI_anresp ];

/// ananmnesis Cardiovascular
Property ancard As %GlobalCharacterStream [ SqlFieldName = EI_ancard ];

/// ananmnesis Abdomen - Genito Urinario
Property anabd As %GlobalCharacterStream [ SqlFieldName = EI_anabd ];

/// ananmnesis Locomotor
Property anloc As %GlobalCharacterStream [ SqlFieldName = EI_anloc ];

/// ananmnesis Neurológico
Property anneur As %GlobalCharacterStream [ SqlFieldName = EI_anneur ];

/// ananmnesis Impresión Diagnóstica
Property animpDiag As %GlobalCharacterStream [ SqlFieldName = EI_animpDiag ];

/// ananmnesis Plan Terapeútico - Estudios Solicitados
Property anplanT As %GlobalCharacterStream [ SqlFieldName = EI_anplanT ];
Property evolnurse As %GlobalCharacterStream [ SqlFieldName = EI_evolnurse ];

Property indicNurse As %GlobalCharacterStream [ SqlFieldName = EI_indicNurse ];

Property motIngreso As %SmallInt [ SqlFieldName = EI_motIngreso ];

Property procedencia As %SmallInt [ SqlFieldName = EI_procedencia ];

Property scrapacheii As %SmallInt [ SqlFieldName = EI_scrapacheii ];

Property scrsofa As %SmallInt [ SqlFieldName = EI_scrsofa ];

Property scrranson As %SmallInt [ SqlFieldName = EI_scrranson ];

Property scrhyh As %SmallInt [ SqlFieldName = EI_scrhyh ];

Property scrfisher As %SmallInt [ SqlFieldName = EI_scrfisher ];

Property sector As %SmallInt [ SqlFieldName = EI_sector ];

Property usuario As TabUsuario [ SqlFieldName = EI_usuario ];

}
/// Evoluciones por medico
Class User.TabIntEvolMed Extends %Persistent
{

Index FechahoraIX On fechaH [ Type = bitmap ];

Index idevolIX On idevol [ Type = bitmap ];

Property codmed As %Library.Integer(FORMAT = "+", MAXVAL = "") [ SqlFieldName = EIM_codmed ];

Property evol As %GlobalCharacterStream [ SqlFieldName = EIM_evol ];

Property fechaH As %TimeStamp [ SqlFieldName = EIM_fechaH ];

Property idevol As %Library.Integer [ SqlFieldName = EIM_idevol ];

}
/// Evoluciones de enfermeria
Class User.TabIntEvolNurse Extends %Persistent
{

Index fechaHIX On fechaH [ Type = bitmap ];

Index usuarioIX On usuario [ Type = bitmap ];

Index idevolIX On idevol [ Type = bitmap ];

Property codCIENanda As TabCieNanda [ SqlFieldName = EIN_codCIENanda ];

Property evolNurse As %GlobalCharacterStream [ SqlFieldName = EIN_evolNurse ];

Property fechaH As %TimeStamp [ SqlFieldName = EIN_fechaH ];

Property parAdmF As %String(TRUNCATE = 1) [ SqlFieldName = EIN_parAdmF ];

Property parAlerg As %Integer(FORMAT = "+") [ SqlFieldName = EIN_parAlerg ];

Property parAlergQue As %String(MAXLEN = 250, TRUNCATE = 1) [ SqlFieldName = EIN_parAlergQue ];

Property parOtros As %String(TRUNCATE = 1) [ SqlFieldName = EIN_parOtros ];

Property idevol As %Library.Integer [ SqlFieldName = EIN_idevol ];

Property usuario As TabUsuario [ SqlFieldName = EIN_usuario ];

}


