* -----------------------------------------------------------------------------------------------------------*
* Auteur  :
*    Francis FAURE        francis.faure@mvps.org
*
* Contributions et Tests :
*    Patrick Gilles      
*    Eric Venanci        
*    Martin Haluza       
*    Fredéric Steczycki
*    Christophe Chenavier
*    Anatole Baudouin
*    Pascal Chambrier
*    Grégory Adam
*    Gilles Lajot Sarthou (test vfp6)
* 
* -----------------------------------------------------------------------------------------------------------*
* Exploitation de WinSock
*    V1.00 : SendMail expédition de Mail
*    V1.01 : Utilisation de MSwinosck dans VCX pour contourner le BUG microsoft winsock en runtime
*            Ajout du fichier de trace
*    V1.02 : ESMTP : authentification SMTP
*            + gestion des retours du serveur
*    V1.03 : Mode Muet (.silence) & pas de doevents, pas de wait pour utilisation en dll COM+
*            Correction problème sur certain server esmtp
*            + Pièces jointes
*    V1.04 : rajout d'une propriété pour envoyer un corps de message en mhtml
*            (but récupérer un enregistrement Internet Explorer, excel, word ou une génération xfrx
*            et envoyer en corps de mail avec les images, cela rend obsoléte la propriété data)
*            gestion des différents cas : entete mhtml, mhtml avec et sans boundary
*            + corps de messages mhtml avec pièces jointes
*    V1.04a : correction bug retour à la connexion au serveur
*    V1.05  : Refonte totale Plus d'appel à Winsock.OCX : 
*             car nécessite qu'il soit installé sur la machine client, enregistré et empéche la génération en DLL pour utilisation en COM
*       Version 1.05 : remplacement de l'appels de MSWINSOCK.OCX pour un appel direct à Winsock2 (WS2_32)
*       Basé sur des posts de  http://fox.wikis.com/wc.dll?Wiki~SendSmtpEmail
*       (William GC Steinford, AnatoliyMogylevets sur fox.wikis.com)
*    V1.05a : correctifs pour prise en charge version vfp 6 (codage base 64)
*    V1.06  : rajouter des défauts : lecture en base de registre : serveur de mail, adresse email, Display Name
*    V1.06a : corrections diverses
*    V1.06b : correction timeout sur le sendData (tests avec Christophe Chenavier)
*    V1.07  : Optimisations temps de traitement (gain 95%)
*             Nouvelle propriété : "Priority" : 1= High ou 5=Low ou (défaut) 3=Normal 
*             Nouvelle propriété : "EML_Dir_Send" : répertoire de stockage des fichiers .eml expédiés (rien si vide)
*    V1.07a : Version avec date en RFC822
*    V1.07b : correction bug, line too long
*    V1.08  : New property: CodePage, default code page is iso-8859-1 (Martin Haluza)
*    V1.09  : Correction message Mhtml Piece + jointes (pas de trombone)
*             Notification : demande de confirmation de lecture
*    V1.09a : bug accusé de reception
*    V1.10  : Changement sur le classe, correction boundary
*             Optimisation : l'expédition ne se fait plus email par email pour chaque destinataires, mail 1 seul mail
*             Possibilité de fixer le nom du fichier eml a générer
*    V1.11  : petits correctifs de structure contre le traitement antispam
*             vfp_ws2_32 : gestion des dll en mémoire avant appel dll (cas objet multiple en mémoire)
*    V1.11a : petits correctifs suite analyse (code inspector) de Christophe 
*    V1.12  : Nouvelle propriété MessageHTML
*             Gestion des multidestinataires TO /TO_NAME et CC_CC_NAME
*             correction calcul GMT dans RFC822
*             probleme antispam de Free.fr : le boundary de forme outlook express ne plait pas à mx1.free.fr ! (galère) j'ai utilisé le format de thunderBird
*    V1.13  : pas de version 13 ^^
*    V1.14  : reprise pour fonctionnement VFP6 !
*             correction d'un probleme lors d'un fichier joint en html (anatole)
*    V1.15  : révision DateTime_to_C822 avec gestion de GetTimeZoneInformation
*    V1.16  : intégration de UDP dans WS32_2
*             rajoute MD5
*             nouvelle classe : "Radius_Access_Request" permettant les requetes "Access-Request" sur un serveur radius
*    V1.17  : recherche du maileur par défaut  "outlook" / "Outlook Express"
*             rajout methode dump()
*    V1.18  : rajout chaine de localization Français / Anglais
*             Correction bugs : Lire_Base_Registre, Alltrim(smtp_host)
*             Modifications pour expédition de gros fichiers joints
*             reprise de la génération des entetes avec boundary pour les pieces jointes 
*              et boundary pour les messages HTM (utilisation de MessageHTML et de Message pour le texte)
*             reprise de la génération du MHTML + piece jointe
*    V1.19  : reprise pour fonctionnement VFP6 !, modification de l'initialisation Winsock de Init a Connect()
*    V1.20  : modification suite analyses des envois via SPAMASSIN / (recherche problème free)
*             modification encodage du sujet en 8859 Quoted Printable
*             conversion .MessageHTML en texte dans .Message si .Message n'est pas précisé
*             Rajout d'une méthode "Reset" pour ré initialiser toutes les propriétés 
*             Création d'un formulaire permttant de générer des examples : vfp_winsock_send_mail_examples.scx
* -----------------------------------------------------------------------------------------------------------*

* option de compilation pour générer la classe OLE public / FOR MTDLL CLASS COMPILATION COM+
#DEFINE COMPIL_AVEC_COM .F.

* défauts /Defaults
#DEFINE VFPWINSOCK_TIMEOUT 60      && timeout d'attente de réponse du serveur / SMTP SERVER TIME OUT IN SECONDS
#define VFPWINSOCK_SMTP_PORT 25    && SMTP SERVER TCP PORT 25 BY DEFAULT

* constantes
#DEFINE CLASSEVERSION "1.20"
#DEFINE CRLF CHR(13)+CHR(10)
#DEFINE c_sckConnected 7

* -----------------------------------------------------------------------------------------------------------*
* Localization
* -----------------------------------------------------------------------------------------------------------*
#DEFINE LANGUAGE "EN"

#IF LANGUAGE == "FR"
  #DEFINE MSG_ERR_UNABLE_INTIALIZE_WS  "ERR00 : Impossile d'initialiser Winsock sur cette machine." && v1.19
  #DEFINE MSG_ERR01_MISSING_SMTP_HOST  "ERR01 : Précisez le serveur SMTP dans la propriété SMTP_HOST."
  #DEFINE MSG_ERR02_MISSING_FROM       "ERR02 : Précisez le mail de l'expéditeur dans la propriété FROM."  
  #DEFINE MSG_ERR03_MISSING_TO         "ERR03 : Précisez le mail du destinataire dans la propriété TO."  
  #DEFINE MSG_ERR04_UNREACHABLE_HOST   "ERR04 : Impossible de se connecter au serveur de mail."
  #DEFINE MSG_ERR05_NOREPLY_HOST       "ERR05 : Pas de réponse du serveur"
  #DEFINE MSG_ERR06_FILE_NOFOUND       "ERR06 : Le fichier à attacher n'existe pas."  
  #DEFINE MSG_ERR07_MHTML_FILE_NOFOUND "ERR07 : Le fichier mhtml servant pour le message n'existe pas."
  #DEFINE MSG_ERR08_MHTML_FILE_WRONG   "ERR08 : Le fichier mhtml indiqué ne semble pas être au format mhtml (archive web). Il ne contient pas de MIME-Version."
  #DEFINE MSG_ERR09_WRONG_RESPONSE     "ERR09 : Le retour attendu était :"
  #DEFINE MSG_ERR10_CONNECT_LOST       "ERR10 : XXX connexion serveur SMTP perdue."
  #DEFINE MSG_ERR14_SENDDATA_RETRY     "ERR14 : Nouvel Essai... Nombre de caractères :"
  #DEFINE MSG_ERR15_SENDDATA_TIMEOUT   "ERR15 : Erreur de Timeout dans l'exécution de SendData."
  
#ELSE
  #DEFINE MSG_ERR_UNABLE_INTIALIZE_WS  "ERR00 : Unable to initialize Winsock on this computer." && v1.19
  #DEFINE MSG_ERR01_MISSING_SMTP_HOST  "ERR01 : Specify the SMTP server in SMTP_HOST property."
  #DEFINE MSG_ERR02_MISSING_FROM       "ERR02 : Specify the mail sender in FROM property."  
  #DEFINE MSG_ERR03_MISSING_TO         "ERR03 : Specify the mail recipient in TO property."  
  #DEFINE MSG_ERR04_UNREACHABLE_HOST   "ERR04 : Mail server unreachable."
  #DEFINE MSG_ERR05_NOREPLY_HOST       "ERR05 : No response from the server"
  #DEFINE MSG_ERR06_FILE_NOFOUND       "ERR06 : attachment file not found."  
  #DEFINE MSG_ERR07_MHTML_FILE_NOFOUND "ERR07 : mhtml attachment file not found."
  #DEFINE MSG_ERR08_MHTML_FILE_WRONG   "ERR08 : The mhtml file does not seem to be in mhtml. It does not contain a MIME-Version."
  #DEFINE MSG_ERR09_WRONG_RESPONSE     "ERR09 : Expected return was :"
  #DEFINE MSG_ERR10_CONNECT_LOST       "ERR10 : XXX connection lost with SMTP server."
  #DEFINE MSG_ERR14_SENDDATA_RETRY     "ERR14 : retry send data... Number of Bytes:"
  #DEFINE MSG_ERR15_SENDDATA_TIMEOUT   "ERR15 : Timeout error in SendData."
  
#ENDIF

* V1.19
#define VFP_VERSION INT(VERSION(5)/100)


* -----------------------------------------------------------------------------------------------------------*
* Texte si lancement du PRG au lien d'appeler la classe
* -----------------------------------------------------------------------------------------------------------*
clear
_screen.fontName = "Courier New"
_screen.fontsize = 8
? 'VfpWinSock                                                             Version :' + CLASSEVERSION
? '-----------------------------------------------------------------------------------------------------------'
? 'Classe VFP_Winsock_Send_Mail'
? '----------------------------'
? ' Propriétés :'
? '    SMTP_HOST        R/W OBLIGATOIRE - Serveur de SMTP ouvert en relais pour la machine'
? '   [SMTP_PORT]       R/W FACULTATIF - Port du Serveur de SMTP si <>25'
? '   [SMTP_TimeOut]    R/W FACULTATIF - Défaut = 1 Minute - temps maximum de connexion au serveur SMTP '
? '    FROM             R/W OBLIGATOIRE - Email de l expéditeur'
? "   [FROM_Name]       R/W FACULTATIF - Nom de l'expéditeur - Défaut = Adresse Email de l'expéditeur"
? '    TO               R/W OBLIGATOIRE - Email du destinataire (multidestinataires : séparer par des "," ou ";")'
? '   [TO_Name]         R/W FACULTATIF - Nom du destinataire - Défaut = Adresse Email du destinataire'
? '    CC               R/W FACULTATIF - Email du contact en copie (multidestinataires : séparer par des "," ou ";")'
? '   [CC_Name]         R/W FACULTATIF - Nom du Contact en Copie - Défaut = Adresse Email du contact copie'
? '    CCI              R/W FACULTATIF - Email du contact en copie invisible (multidestinataires : séparer par des "," ou ";")'
? '   [Subject]         R/W FACULTATIF - Sujet du Mail'
? "   [Message]         R/W FACULTATIF - Texte du Message (la classe rajoute l'entete)"
? "   [MessageHTML]     R/W FACULTATIF - Texte du Message en HTML (la classe rajoute l'entete)"
? '   [Data]            R/W FACULTATIF - Contenu direct du DATA SMTP (pour tests :obsolète), Pour du mhtml utiliser la propriété DATA_MHTML'
? "    Erreur           R              - Contenu du message d'erreur"
? "   [Silence]         R/W FACULTATIF - pas d'affichage : but utilisation en mtdll/com+ (pas de '?', de 'wait')"
? '   [TraceFile]       R/W FACULTATIF - nom du fichier de trace a générer '
? '   [AUTH_LOGIN]      R/W FACULTATIF - login sur le serveur ESMTP'
? '   [AUTH_PASSWORD]   R/W FACULTATIF - password sur le serveur ESMTP'
? '    ATTACHMENT       R/W FACULTATIF - liste des fichiers à joindre (séparés par "," ou ";")'
? '   [DATA_MHTML]      R/W FACULTATIF - Nom du fichier Corps du message en mhtml. Si défini : Prioritaire = remplace message, messageHTML et data, pour le corps en MHTL'
? '   [PRIORITY]        R/W FACULTATIF - Priority : 1=High, 5=Low, (3=Normal)'
? '   [EML_DIR_SEND]    R/W FACULTATIF - Répertoire devant recevoir le fichier .eml contenant les données expédies (fichier eml créé que si répertoire précisé'
? '   [EML_FILE_SEND]   R/W FACTUTATIF - Nom du fichier .eml expédié (par défaut vfpwinsock initialise une fichier SEND_AAAAMMJJ_HHMMSS_NNN.EML)'
? '   [CodePage]        R/W FACULTATIF - par défaut "iso-8859-1"  '
? '   [Content_Transfer_Encoding] R/W FACULTATIF - par défaut "7Bit"'  
? '   [Notification]    R/W FACULTATIF - demande de confirmation de lecture par défaut .F.  '
? ' Méthodes :'
? "   Send()            retour .T. / .F. si le message est expédié (.Erreur Contient la chaine d'erreur)"
? "   Dump([file.txt])  retour file      fichier contenant le dump"
? "   Reset()                            réinitialise toutes les propriétés"
? '-----------------------------------------------------------------------------------------------------------'
? 'exemple :'
? '  SET PROCEDURE TO VFPwinsock'
? '  o=CREATEOBJECT("VFP_Winsock_Send_Mail")'
? '  o.TraceFile = "c:\temp\VFPsendmail.txt'
? '  o.smtp_host = "smtp.monserveur.com'
? '  o.from      = "expediteur@monserveur.com"'
? '  o.to        = "mail@destinataire.com"'
? '  o.Subject   = "Sujet du Message"'
? '  o.Message   = "Hello World"'
? '  if not o.send()'
? '    ? "Erreur : " + o.Erreur'
? '    ? o.dump() : " + o.dump()'
? '  endif'
? '  o=Null'
? '-----------------------------------------------------------------------------------------------------------'

DEFINE CLASS VFP_Winsock_Send_Mail as Basique

 Version      = CLASSEVERSION
 * Propriétés
 SMTP_HOST    = ""
 SMTP_PORT    = VFPWINSOCK_SMTP_PORT
 SMTP_TimeOut = VFPWINSOCK_TIMEOUT
 FROM         = ""
 FROM_Name    = ""
 TO           = ""
 TO_Name      = ""
 CC           = ""
 CC_Name      = ""
 CCI          = ""
 Subject      = ""
 Message      = ""
 MessageHTML  = "" && v1.12
 Data         = ""
 Erreur       = ""
 Silence      = .F.
 * 1.01 : si le nom du fichier est renseigné alors la classe trace dans ce fichier
 TraceFile    = ""
 * 1.02 : Authentification sur serveur SMTP
 AUTH_Login   = ""
 AUTH_Password= ""
 * 1.03 pieces jointes
 Attachment   = ""
 * 1.04 remplace message et data pour expédier une fichier mhtml en tant que corps du message
 data_mhtml   = ""
 * 1.07
 Priority = ""  && 1=High  5=Low  3=Normal (défaut)
 EML_Dir_Send = "" && répertoire des fichiers expédié au format .eml
 EML_File_Send= "" && nom du fichier .eml
 * 1.11
 EML_Data = "" && contenu du fichier eml
 * 1.08
 CodePage     = "iso-8859-1" &&v1.07c Martin Haluza, new codePage property
 * 1.09
 Notification = .F.
 * 1.11
 SMTP_HELO    = ""   && c'est le nom/ipexterne a présenter sur le HELO, facultatif, (par défaut : nom du HOST)
 * 1.12
 Content_Transfer_Encoding ="7bit" && Content-Transfer-Encoding: 7bit  quoted-printable

 PROCEDURE init
   DoDefault()
   THIS.NewObject("o_Winsock", "ws2_32")
   * a faire : passer silence a vraie si lancée en dll..
 RETURN
 
 PROCEDURE destroy
   release o_Winsock
   DoDefault()
 return


 FUNCTION Send
   lOCAL v_start, v_to, v_destinataires
   local v_send
   local v_attachment, v_nbre_attachment, v_file, v_contenu, v_i, boundary, v_ext, v_chaine
   local v_tmp, v_f
   LOCAL ARRAY t_attachment[1,2]
   LOCAL v_boundary
   LOCAL v_boundary_html && v1.18
   LOCAL v_data
   local v_data_mhtml
   LOCAL lsData && v1.18 
   LOCAL liI && v1.18
   LOCAL loHTMLconverter && 1.20
   *
   this.Erreur = ""
   * Trace la version de vfp et de vfpwinsock
   this.trace("VFP version : "+_vfp.version)
   this.trace("VFPwinsock version : "+this.version)
   * Test des valeurs Obligatoire
   IF EMPTY(this.SMTP_HOST)
     * V1.06
     this.SMTP_HOST = this.Lire_Base_Registre("SMTP Server")
     if Empty(this.SMTP_HOST)
       this.Erreur = MSG_ERR01_MISSING_SMTP_HOST
       this.Trace(this.erreur)
       RETURN .F.
     endif
   endif
   IF EMPTY(this.FROM)
     * V1.06
     this.FROM = this.Lire_Base_Registre("SMTP Email Address")
     if Empty(this.FROM)
       this.Erreur = MSG_ERR02_MISSING_FROM
       this.Trace(this.erreur)
       RETURN .F.
     else
       * V1.06 si lecture en base de registre de l'adresse : rajouter le Display name
       if Empty(this.FROM_NAME)
         this.FROM_NAME = this.Lire_Base_Registre("SMTP Display Name")
       endif
     endif
   ENDIF
   IF EMPTY(this.TO)
     this.Erreur = MSG_ERR03_MISSING_TO
     this.Trace(this.erreur)
     RETURN .F.
   ENDIF
   * conversion des ; en ,
   this.TO = STRTRAN(this.TO , ";", ",")
   this.CC = STRTRAN(this.CC , ";", ",")
   this.CCI = STRTRAN(this.CCI , ";", ",")
   * Valeurs Par Défaut
   IF EMPTY(this.FROM_Name)
     this.FROM_Name = this.FROM
   ENDIF
   IF EMPTY(this.TO_Name)
     this.TO_Name = this.TO
   ENDIF
   IF EMPTY(this.CC_Name)
     this.CC_Name = this.CC
   endif
   * cas particuliers
   this.FROM_NAME = STRTRAN(this.FROM_NAME , ")", "\)")
   this.FROM_NAME = STRTRAN(this.FROM_NAME , "(", "\(")
   this.TO_NAME = STRTRAN(this.TO_NAME , ")", "\)")
   this.TO_NAME = STRTRAN(this.TO_NAME , "(", "\(")
   this.CC_NAME = STRTRAN(this.CC_NAME , ")", "\)")
   this.CC_NAME = STRTRAN(this.CC_NAME , "(", "\(")  

   * revisé v1.10
   *v_boundary = "----_=NextPart_000" + SYS(2015) + "." + this.Sys3()
   * revisé 1.11
   *v_boundary = "----=_NextPart_000" + SYS(2015) + "." + this.Sys3()
   * revisé 1.12
   *v_boundary = "----=_NextPart_000_0000_" + this.Sys3() + "." + this.Sys3() && boundary de style outlook express rejeté par Free.fr
   *v_boundary = "----=_NextPart_000_00EF_01C781B6.53E3FDB0" && boundary de style outlook express accepté par Free.fr :(
   *v_boundary = "----=_NextPart_000_00EF_45F57802.45F57818" && boundary de style outlook express non accepté par Free.fr :(

   * http://www.faqs.org/rfcs/rfc2045.html
   * le boundary est pour séparer le texte des pieces jointes
   * v1.20
   * v_boundary = REPLICATE("-",10) + this.Sys3() + this.Sys3() + this.Sys3()  && boundary de style thunderBird (qui marche chez free.fr.)
   * v_boundary_html = REPLICATE("-",10) + this.Sys3() + this.Sys3() + this.Sys3()  && v1.18 autre boundary pour la partie html
   v_boundary = REPLICATE("-",12) + this.Sys3() + this.Sys3() + this.Sys3()  && boundary de style thunderBird (qui marche chez free.fr.)
   v_boundary_html = REPLICATE("-",12) + this.Sys3() + this.Sys3() + this.Sys3()  && autre boundary pour la partie html

   v_data_mhtml = ""
   if not Empty(this.data_mhtml)
   
     if File(this.data_mhtml)
       * le fichier existe : le charger
       v_data_mhtml = filetostr(this.data_mhtml)
       * latter l'entete du fichier jusqu'au "MIME-Version:"
       if Upper("MIME-Version:")$Upper(v_data_mhtml)
         v_data_mhtml = Substr(v_data_mhtml, At(Upper("MIME-Version:"), Upper(v_data_mhtml)))        
         * 1.09
         * Suppression la ligne "MIME-Version:" + CRLF + CRLF 
         do while Len(v_data_mhtml)>2
           v_data_mhtml = Substr(v_data_mhtml,2)
           if Asc(Substr(v_data_mhtml,1,1))=13
             exit
           endif
         enddo
         do while Asc(Substr(v_data_mhtml,1,1))=13 or Asc(Substr(v_data_mhtml,1,1))=10
           v_data_mhtml = Substr(v_data_mhtml,2)
         enddo
         * v1.10
         * enlever le CRLF en fin
         do while Asc(Substr(v_data_mhtml,LEN(v_data_mhtml),1))=13 or ;
                  Asc(Substr(v_data_mhtml,LEN(v_data_mhtml),1))=10 or ;
                  Asc(Substr(v_data_mhtml,LEN(v_data_mhtml),1))=32
           v_data_mhtml = LEFT(v_data_mhtml, LEN(v_data_mhtml)-1)
         ENDDO
         * cas particulier mhtml vérification que "--" n'est pas manquant derrière le dernier boundary...
         IF "boundary"$v_data_mhtml
           IF RIGHT(v_data_mhtml,2)<>"--"
             v_data_mhtml = v_data_mhtml + "--"
           endif
         endif
         * data_mhtml ecrase data et message
         this.data = ""
         this.message = ""
       else
         this.erreur = this.erreur + MSG_ERR08_MHTML_FILE_WRONG
         this.Trace(this.erreur)
         return .F.
       endif
     else
       this.erreur = this.erreur + MSG_ERR07_MHTML_FILE_NOFOUND + "("+this.data_mhtml+")"
       this.Trace(this.erreur)
       return .F.
     endif
   endif

   * Composition du Message : Soit DATA direct, soit DATA composé du Message
   IF EMPTY(this.data) 
   
     * v1.20 : si message HTML et pas de message texte => création du message Texte depuis HTML
     IF NOT EMPTY(this.messageHTML)
       IF EMPTY(this.Message)
         loHTMLconverter = CREATEOBJECT("HTMLConverter")
         this.Message = loHTMLconverter.HTMLdecode(this.messageHTML)
         loHTMLconverter = null
       endif
     endif

     * V1.20 date déplacée avant le from
     this.data = this.data + "Date: " + This.DateTime_to_C822() + CRLF

     * From 
     this.data = this.data + 'From: "' + this.FROM_Name + '" <' + this.FROM + '>' + CRLF 

     * To
     * v1.12
     * this.data = this.data + 'To: "' + this.TO_Name + '" <' + this.TO + '>' + CRLF
     this.data = this.data + 'To: ' + this.FormatDataEmail(this.TO, this.TO_name) + CRLF
     
     * CC
     IF NOT EMPTY(this.CC) 
       * v1.12
       *this.data = this.data + 'Cc: "' + this.CC_Name + '" <' + this.CC + '>' + CRLF 
       this.data = this.data + 'Cc: ' + this.FormatDataEmail(this.CC, this.CC_name) + CRLF 
     endif            

     * sujet / subject
     IF NOT EMPTY(this.Subject)
       * v1.20 
       * this.data = this.data + "Subject: "+ this.Subject + CRLF 
       this.data = this.data + "Subject: "+ This.String2Iso8859(this.Subject) + CRLF 
     endif

     * 1.12
     * v1.20 déplacé avant le "from" this.data = this.data + "Date: " + This.DateTime_to_C822() + CRLF

     * 1.03 : traitement avec pièces jointes
     this.Attachment = Alltrim(STRTRAN(this.attachment , ";", ","))
     do while Right(this.Attachment,1)=","
       this.Attachment = Left(this.Attachment, Len(this.Attachment)-1)
     enddo
     if Empty(this.Attachment)       
       v_attachment = ""
     else
       v_attachment = this.attachment + ","
     endif
     v_nbre_attachment = 0
     DO WHILE ","$v_attachment AND NOT EMPTY(v_attachment)
       v_file = ALLTRIM(LEFT(v_attachment, AT(",", v_attachment)-1))
       do while Right(v_file,1)="\" && suppression d'un \ qui se trouverait en fin de fichier
         v_file = Left(v_file, Len(v_file)-1)
       enddo
       * vérification existance du fichier
       if File(v_file)
         this.Trace("Attachment : "+v_file)
         v_nbre_attachment = v_nbre_attachment + 1
         * tableau stockant les fichiers joints
         *  t_attachment[*, 1] = nom du fichier (sans chemin)
         *  t_attachment[*, 2] = contenu du fichier + encodé en base64 + découpé en morceau de 76c
         dimension t_attachment[v_nbre_attachment, 2]         
         t_attachment[v_nbre_attachment, 1] = Substr(v_file, Rat("\", v_file)+1)  && nom du fichier
         * lecture du fichier
         v_contenu = FileToStr(v_file)
         * encodage base64
         v_contenu = This.Encode64(v_contenu)
         * morceaux de 76 c
         * 1.07 ------- optimisation
         if .T.
           v_tmp = GetEnv("Temp")+"\"+this.Sys3()+".txt"
           * v1.14
           * =strtofile(v_contenu, v_tmp, 0)
           =strtofile(v_contenu, v_tmp, .F.) && le troisème paramétre doit être .F. et non 0 en vfp 6
           v_f = Fopen(v_tmp)
           v_chaine = ""
           do while not Feof(v_f)
             v_chaine = v_chaine + Fgets(v_f, 76) + CRLF
           enddo
           =Fclose(v_f)
           erase (v_tmp)
           t_attachment[v_nbre_attachment, 2] = v_chaine
           v_chaine = "" && v1.18
         else
           * avant 1.07 
           t_attachment[v_nbre_attachment, 2] =  ""
           FOR v_i = 1 TO LEN(v_contenu) STEP 76
             t_attachment[v_nbre_attachment, 2] = t_attachment[v_nbre_attachment, 2] + SUBSTR(v_contenu,v_i,76) + CRLF
           next
         endif         
       else
         this.erreur = this.erreur + MSG_ERR06_FILE_NOFOUND + "("+v_file+")"
         this.Trace(this.erreur)
         return .F.
       endif
       v_attachment = SUBSTR(v_attachment, AT(",", v_attachment)+1)
     enddo

     * Entete
     * v1.18 : si Piece joindre : générer un boundary
     if v_nbre_attachment>0
       * Entete avec pièces jointes
       this.data = this.data + "MIME-Version: 1.0" + CRLF
       this.data = this.data + "Content-Type: multipart/mixed;" + CRLF + Chr(9) + 'boundary="' + v_boundary + '"' + CRLF
       This.Data_Header()
       this.data = this.data + CRLF + "This is a multi-part message in MIME format." + CRLF + CRLF 
       this.data = this.data + "--"+ v_boundary+ CRLF
       if Empty(v_data_mhtml)
         IF NOT EMPTY(this.messageHTML)        
           * creer un boundary html pour le message text/html
           this.data = this.data + "Content-Type: multipart/alternative;" + CRLF + Chr(9) + 'boundary="' + v_boundary_html + '"' + CRLF + CRLF
           this.data = this.data + "--"+ v_boundary_html +CRLF
         endif
         this.data = this.data + "Content-Type: text/plain;" + CRLF + SPACE(8) + 'charset="'+this.codePage+'"' + CRLF
         this.data = this.data + "Content-Transfer-Encoding: "+ this.Content_Transfer_Encoding + CRLF
       ENDIF && Empty(v_data_mhtml)
       *
     else
       * pas de pièce jointe : générer l'entete (si ce n'est pas du mhtml)
       if Empty(v_data_mhtml)
         this.data = this.data + "MIME-Version: 1.0" + CRLF
         * v1.12
         IF EMPTY(this.messageHTML)
           this.data = this.data + "Content-Type: text/plain;" + CRLF + SPACE(8) + 'charset="'+this.codePage+'"' + CRLF         
           this.data = this.data + "Content-Transfer-Encoding: "+ this.Content_Transfer_Encoding + CRLF
           This.Data_Header()
         ELSE
           * message Texte + HTML
           this.data = this.data + "Content-Type: multipart/alternative;" + CRLF + Chr(9) + 'boundary="' + v_boundary_html + '"' + CRLF
           This.Data_Header()
           this.data = this.data + CRLF + "This is a multi-part message in MIME format."+ CRLF + CRLF
           this.data = this.data + "--"+ v_boundary_html+ CRLF
           this.data = this.data + "Content-Type: text/plain;" + CRLF + SPACE(8) + 'charset="'+this.codePage+'"' + CRLF         
           this.data = this.data + "Content-Transfer-Encoding: "+ this.Content_Transfer_Encoding + CRLF
         ENDIF         
       else
         this.data = this.data + "MIME-Version: 1.0" + CRLF
         This.Data_Header()
       endif       
     endif

     *  générer le message (si ce n'est pas du mhtml, sinon on prend le source mhtml)
     if Empty(v_data_mhtml)
       * this.data = this.data + CRLF+ This.Message
       * v1.07 (si le message contient un <CRLF>.<CRLF> le transformer en <CRLF>.<NULL><CRLF>)
       this.data = this.data + CRLF+ strtran(This.Message, CRLF + "." + CRLF, CRLF + "." + chr(0) + CRLF)  +CRLF && v1.20 +CRLF
       IF NOT EMPTY(this.messageHTML)
         this.data = this.data + "--"+ v_boundary_html+ CRLF
         this.data = this.data + "Content-Type: text/html;" + CRLF + SPACE(8) + 'charset="'+this.codePage+'"' + CRLF         
         this.data = this.data + "Content-Transfer-Encoding: "+ this. Content_Transfer_Encoding + CRLF
         this.data = this.data + CRLF + '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">' + CRLF
         this.data = this.data + strtran(this.messageHTML, CRLF + "." + CRLF, CRLF + "." + chr(0) + CRLF) +CRLF +CRLF
         this.data = this.data + "--"+ v_boundary_html +"--" +CRLF && v1.18
       ENDIF
     ELSE
       this.data = this.data + v_data_mhtml + CRLF
     endif

     * les pièces jointes
     if v_nbre_attachment>0
       FOR v_i=1 TO v_nbre_attachment
         v_ext = Lower(SUBSTR(t_attachment[v_i, 1],RAT (".",t_attachment[v_i, 1])))
         * 1.09
          this.data = this.data + CRLF + "--" + v_boundary + CRLF
         * content-type MIME en fonction de l'extension de fichier
         DO CASE
           CASE v_ext=".jpg" OR v_ext=".jpeg"
             this.data = this.data + "Content-Type: image/jpeg;" 
           CASE v_ext=".bmp"
             this.data = this.data + "Content-Type: image/bmp;"   && 1.09
           CASE v_ext=".gif"
             this.data = this.data + "Content-Type: image/gif;" 
           CASE v_ext=".wav"
             this.data = this.data + "Content-Type: audio/x-wav;" 
           CASE v_ext=".mht" or v_ext=".mhtm" or v_ext=".htm" or v_ext=".mhtml" or v_ext=".html" 
             this.data = this.data + "Content-Type: text/html;" 
           CASE v_ext=".pdf"
             this.data = this.data + "Content-Type: application/pdf;" && (Fred) 1.11
           OTHERWISE
             this.data = this.data + "Content-Type: application/octet-stream;" 
         endcase
         this.data = this.data + CRLF + SPACE(8) + 'name="' + t_attachment[v_i, 1] + '"' + CRLF
         this.data = this.data + "Content-Transfer-Encoding: base64" + CRLF
         this.data = this.data + "Content-Disposition: attachment;" 
         this.data = this.data + CRLF + SPACE(8) + 'filename="' + t_attachment[v_i, 1] +'"' + CRLF
         * -- v1.18 traiter la concatenantion par bloc d'un 1Mo, pour éviter le "String too long to fit" 
         lsData = this.data + CRLF
         FOR liI=1 TO LEN(t_attachment[v_i, 2]) STEP  1024*1024
           lsData = m.lsData + SUBSTR(t_attachment[v_i, 2], m.liI,  1024*1024)
         next
         this.Data = m.lsData 
         m.lsData = ""
         * this.data = this.data + CRLF + t_attachment[v_i, 2]
         * --          
       next
       this.data = this.data + CRLF + "--" + v_boundary + "--" + CRLF
     endif
   endif && de s'il y a un data déjà défini

   * appel a Winsock
   ** v1.05  With this.o_winsock.object
   With this.o_winsock
   .Close()
   ** .Protocol = 0     && 0=TCP Protocol, 1=UDP
   * Connexion au serveur
   .RemoteHost = This.SMTP_HOST
   .RemotePort = this.SMTP_PORT
   
   .Connect()
   
   ** v1.05
   if .state<> c_sckConnected
     * v1.18
     this.Trace("START : "+ Ttoc(Datetime()))
     this.Trace("Connect() RemoteHost : "+.RemoteHost + " RemoteHostIP :" + .RemoteHostIP)
     this.Trace("Connect() SocketHandle : "+Alltrim(Str(.SocketHandle)))
     if .state == -1 && v1.19 
       This.Erreur = MSG_ERR_UNABLE_INTIALIZE_WS
     else
       This.Erreur = MSG_ERR04_UNREACHABLE_HOST + " " + STR(.state)
     endif
     this.Trace(this.erreur)
     .Close()
     RETURN .F.
   else
     this.Trace("START : "+ Ttoc(Datetime()))
     this.Trace("Connect() RemoteHost : "+.RemoteHost + " RemoteHostIP :" + .RemoteHostIP)
     this.Trace("Connect() SocketHandle : "+Alltrim(Str(.SocketHandle)))
     * this.Trace("Connect() LocalPort : "+Alltrim(Str(.LocalPort)))   
   endif
   * on devrait recupérer un 220 du nom du serveur
   v_send = this.WinSock_GetData("220")

   * Expédition des données 
   * répéter l'expédition pour tous les destinataires, cc et cci
   if Empty(this.AUTH_Login)
     * Message HELO : Le retour devrait être "250"
     * v1.11 rajout de la possibilité de fixer le nom dans le HELO (identity of the sender)
     IF EMPTY(this.SMTP_HELO)
       * v1.17
       this.SMTP_HELO = This.SMTP_HOST
     endif
     v_send = this.WinSock_SendData("HELO " + This.SMTP_HELO + CRLF, "250")
   else
     * cas ESMTP
     * Message EHLO : Le retour devrait être plusieur 250 
     * 
     * v1.11
     IF EMPTY(this.SMTP_HELO)
       * v1.17
       this.SMTP_HELO = This.SMTP_HOST
     endif
     v_send = this.WinSock_SendData("EHLO " + This.SMTP_HELO + CRLF, "250")
     if v_send
       v_send = this.WinSock_SendData("AUTH LOGIN" + CRLF, "334")   && retour 334
     endif
     if v_send
       v_send = this.WinSock_SendData(this.Encode64(this.AUTH_Login) + CRLF, "334")
     endif
     if v_send
       v_send = this.WinSock_SendData(this.Encode64(this.AUTH_Password) + CRLF, "235")
     endif
   endif

   v_destinataires = this.to + "," 
   IF NOT EMPTY(this.cc)
     v_destinataires = v_destinataires + this.cc + ","
   ENDIF
   IF NOT EMPTY(this.cci)
     v_destinataires = v_destinataires + this.cci + ","
   ENDIF
   
   * V1.10 : plus qu'un seul mail
   ** DO WHILE ","$v_destinataires AND NOT EMPTY(v_destinataires)
   **   v_to = ALLTRIM(LEFT(v_destinataires, AT(",", v_destinataires)-1))
   **   IF NOT EMPTY(v_to)
   **     if v_send 
   **       * 1.07 eml multiple
   **       This.EML_File_Send = ""
   **       v_send = this.WinSock_SendMail(v_to)
   **     endif
   **   endif
   **   v_destinataires = SUBSTR(v_destinataires, AT(",", v_destinataires)+1)
   ** enddo
   if v_send 
     v_send = this.WinSock_SendMail(v_destinataires)
     =This.Log_Send_Eml()
   ENDIF
   **

   * Message QUIT
   =this.WinSock_SendData("QUIT" + CRLF, "")
   this.Trace("STOP : "+ Ttoc(Datetime()))
   if this.silence
   else
     WAIT clear
   endif
   .Close()
   endwith
   * vide le data
   this.data=""
 RETURN v_send
 
 * Send MAIL
 * 1.10 : plus qu'en seul mail pour tous les destinataires
 *HIDDEN PROCEDURE WinSock_SendMail(p_to)
 HIDDEN PROCEDURE WinSock_SendMail(p_destinataires)
   local v_send
   local v_data, v_line
   local v_at, v_i, v_j
   local v_step
   LOCAL v_to
   LOCAL v_nblignes
   LOCAL v_chaine
   LOCAL liI && v1.18
   LOCAL lsData && v1.18

   * Message MAIL FROM: retour 250
   v_send = this.WinSock_SendData("MAIL FROM: <" + this.From + ">" + CRLF, "250")

   * Message RCPT TO: 250
   * 1.10
   **   if v_send
   **     v_send = this.WinSock_SendData("RCPT TO: <" + p_to + ">" + CRLF, "250")
   **   endif
   DO WHILE ","$p_destinataires AND NOT EMPTY(p_destinataires)
      v_to = ALLTRIM(LEFT(p_destinataires, AT(",", p_destinataires)-1))
      IF NOT EMPTY(v_to)
       if v_send 
         * Message RCPT TO: 250
         v_send = this.WinSock_SendData("RCPT TO: <" + v_to + ">" + CRLF, "250")
       endif
     endif
     p_destinataires = SUBSTR(p_destinataires, AT(",", p_destinataires)+1)
   enddo
   **

   * Message DATA : 354
   if v_send
     v_send = this.WinSock_SendData("DATA" + CRLF, "354")
   endif
   
   * DATA
   * v1.18
*!*	   if v_send
*!*	     *** RFC 821 chaque ligne fait 512octets maxi avec le crlf 
*!*	     *** la limite du texte est de 1000 caractères avec le crlf
*!*	     * v1.18
*!*	     * This.Data peut contenir un nombre important de lignes (gros fichiers joints par exemple)
*!*	     * a expédier au serveur de mail par chaine terminée par CRLF mais de taille maxi 512 caracteres par ligne
*!*	     * Ne pas passer par un tableau car les version de VFP< 9 ne supporte pas plus 65 0000 Lignes
*!*	     * sur idée de Gregory : passage par un fichier pour eviter le Aline
*!*	     *
*!*	     LOCAL lsFicTmp
*!*	     lsFicTmp = GetEnv("Temp")+"\"+this.Sys3()+".txt"
*!*	     =StrToFile(this.data, m.lsFicTmp, .F.) && le troisème paramétre doit être .F. et non 0 en vfp 6
*!*	     liF = Fopen(m.lsFicTmp)
*!*	     do while not Feof(m.liF)
*!*	       lsDATA = FGETS(m.liF, 8192)
*!*	       IF LEN(m.lsData)<512
*!*	         v_send = this.WinSock_SendData(m.lsData+CRLF, "")
*!*	         This.EML_Data = This.EML_Data + m.lsData + CRLF
*!*	       ELSE
*!*	         for v_j=1 to Len(m.lsData) step 512
*!*	           v_chaine = Substr(m.lsData, v_j, 512)
*!*	           if Len(v_chaine)<512 AND Len(m.lsData)<8192
*!*	             v_send = this.WinSock_SendData(v_chaine + CRLF, "")
*!*	             This.EML_Data = This.EML_Data + v_chaine + CRLF
*!*	           else
*!*	             v_send = this.WinSock_SendData(v_chaine, "")
*!*	             This.EML_Data = This.EML_Data + v_chaine
*!*	           endif
*!*	         next
*!*	       ENDIF
*!*	       IF NOT v_send
*!*	         exit
*!*	       endif
*!*	     enddo
*!*	     =Fclose(m.liF)
*!*	     erase (m.lsFicTmp)
*!*	   endif

   * DATA
   if v_send
     *** RFC 821 chaque ligne commande fait 512octets maxi avec le crlf 
     *** la limite du texte est de 1000 caractères 
     * v1.18 sur idée de Gregory : envoyer directement par chaine de 1000c
     for v_j=1 to Len(this.Data) step 1000
       m.lsData = Substr(this.data, v_j, 1000)
       v_send = this.WinSock_SendData(m.lsData, "")
       This.EML_Data = This.EML_Data + m.lsData
       IF NOT v_send
         exit
       endif
     next
   ENDIF

   * fin du message
   if v_send
     v_send = this.WinSock_SendData(CRLF + "." + CRLF, "250")
   ENDIF
   
   * message RSET : le retour devrait être 250
   ** v1.11 supprimé, car semblerait poser problème pour certains serveur comme laposte.net (?)
   **if v_send
   **  v_send = this.WinSock_SendData("RSET"+CRLF, "250")
   ***endif
 return v_send


 * Send DATA 
 HIDDEN PROCEDURE WinSock_SendData(p_data, p_retour_attendu)
   local v_send
   LOCAL v_Buffer
   local v_start
   * 1.05
   *   with this.o_winsock.object
   v_send = .T.
   with this.o_winsock
     * si la connection est toujours ok
     if .state <> c_sckConnected
       this.Trace(MSG_ERR10_CONNECT_LOST)
       if Empty(this.erreur)
         this.erreur = MSG_ERR10_CONNECT_LOST
       endif
       v_send = .F.
     else
       ** mis en remarque car avec ESMTP avec certains serveur (comme yahoo) cela semble perturber le retour 220
       **       v_Buffer = ""
       **       .GETDATA(@v_Buffer)   && vide le buffer ?
       if Empty(p_retour_attendu)
         * si pas de retour attendu : c'est les data, pas de log
         *** this.Trace(" => SendData : expédition des DATA [..] Nombre de caractères : "+Alltrim(Str(len(p_data))) )
       else
         this.Trace(" => SendData : "+p_data+" Len= "+ALLTRIM(Str(Len(p_data)))+" Bytes")
       endif
       *
       * v1.06b pb Christophe
       * si le send ne s'est pas fait : retenter si pas timeout et pas .state<>7
       *
       * .SendData( p_data )
       v_start = SECONDS()
       DO WHILE not .SendData( p_data )
         this.trace("=> WS2_32.SendDATA : " + MSG_ERR14_SENDDATA_RETRY + Alltrim(Str(len(p_data))) )
         IF (SECONDS() - v_start) > this.SMTP_TimeOut or .state <> c_sckConnected
            This.Erreur = " => WS2_32.SendData : " + MSG_ERR15_SENDDATA_TIMEOUT
            This.Trace(this.erreur)
            v_send = .F.
            * v1.11a
            p_retour_attendu = "" && plus de retour attendu
            exit
         ENDIF
         =this.attente()
       enddo
       *
       if NOT Empty(p_retour_attendu)
         v_send = this.WinSock_GetData(p_retour_attendu)
       endif
     endif
   endwith
 return v_send

 * Winsock_GetDATA 
 HIDDEN function WinSock_GetData(p_retour_attendu)
   LOCAL v_Buffer, v_start
   LOCAL nReturn
   nReturn = .T.
   if Empty(p_retour_attendu)
   else
     =this.attente()
     v_Buffer = ""
     v_start = SECONDS()
     this.o_winsock.GETDATA(@v_Buffer)
     DO WHILE EMPTY(v_Buffer)
       IF (SECONDS() - v_start) > this.SMTP_TimeOut
         This.Erreur = " <= SGetData : "+ MSG_ERR05_NOREPLY_HOST
         This.Trace(this.erreur)
         nReturn = .F.
         exit
       ENDIF
       =this.attente()
       this.o_winsock.GETDATA(@v_Buffer)
     ENDDO
	 IF nReturn
       * un retour : est -il conforme à la valeur attendue 
       v_buffer=STRTRAN(v_buffer, CRLF, "")
       if this.silence
       else
         WAIT windows Left(v_buffer,254) nowait
       endif
       if Left(v_buffer, Len(p_retour_attendu))=p_retour_attendu
         this.Trace(" <= SGetData OK: "+v_buffer)
         nReturn = .T.
       else
         This.Erreur = " <= SGetData ERR : "+v_buffer+" - " + MSG_ERR09_WRONG_RESPONSE + p_retour_attendu
         This.Trace(this.erreur)
         nReturn = .F.
       ENDIF
     endif
   endif
 return nReturn

 * v1-03 : attente doevents / inkey
 * v1.06 sleep ?
 * v1.20 : boucle 
 hidden PROCEDURE Attente()
 local v_i
   v_i = SECONDS()
   DO WHILE (SECONDS()-v_i) < 0.100 && 100 ms
     DOEVENTS
   ENDDO 
 Endproc

 * révisée v1.15
 * DateTime_to_C822 datetime return DateTime() in RFC822 Chap5 format
 * example : "Thu, 20 Mar 2008 10:16:49 +0100
  hidden function DateTime_to_C822()
    LOCAL lcReturn as String
    LOCAL ldDateTime as Datetime
    LOCAL ARRAY t_jours[7]
    t_jours[1] = "Mon"
    t_jours[2] = "Tue"
    t_jours[3] = "Wed"
    t_jours[4] = "Thu"
    t_jours[5] = "Fri"
    t_jours[6] = "Sat"
    t_jours[7] = "Sun"
    LOCAL ARRAY t_mois[12]
    t_mois[01] = "Jan"
    t_mois[02] = "Feb"
    t_mois[03] = "Mar"
    t_mois[04] = "Apr"
    t_mois[05] = "May"
    t_mois[06] = "Jun"
    t_mois[07] = "Jul"
    t_mois[08] = "Aug"
    t_mois[09] = "Sep"
    t_mois[10] = "Oct"
    t_mois[11] = "Nov"
    t_mois[12] = "Dec"

    ldDateTime = Datetime()

    lcReturn = t_jours[DoW(ldDateTime , 2)] + ", "                              && day, 
    lcReturn = lcReturn + Strtran(Str(Day(ldDateTime ),2), " ", "0") + " "      && dd
    lcReturn = lcReturn + t_mois[Month(ldDateTime )] + " "                      && mm
    lcReturn = lcReturn + Str(Year(ldDateTime ),4) + " "                        && yyyy
    lcReturn = lcReturn + Left(time(ldDateTime ),8) + " "                       && HH:MM:SS
    lcReturn = lcReturn + This.GetEcartGMT()                                    && +0100
  return lcReturn 

  *-----------------------------------------------------------------------------------------
  * v1.15
  * 19 Mars 2008 : GetTimeZoneInformation 
  * http://msdn2.microsoft.com/en-us/library/ms724421(VS.85).aspx 
  * Merci Fédéric
  *typedef struct _TIME_ZONE_INFORMATION { // tzi
  *    LONG       Bias;					4
  *    WCHAR      StandardName[ 32 ];		64 (unicode sinon 32)
  *    SYSTEMTIME StandardDate;			SizeOfSystemTime 16
  *    LONG       StandardBias;			4
  *    WCHAR      DaylightName[ 32 ];		64 (unicode sinon 32)
  *    SYSTEMTIME DaylightDate;			SizeOfSystemTime 16
  *    LONG       DaylightBias;			4
  *} TIME_ZONE_INFORMATION

  #DEFINE TIME_ZONE_ID_UNKNOWN 0
  #DEFINE TIME_ZONE_ID_STANDARD 1
  #DEFINE TIME_ZONE_ID_DAYLIGHT 2

  HIDDEN FUNCTION GetEcartGMT
    LOCAL lcReturn as String
    LOCAL liRetCode as Integer, TZInfo  as String, liEcartGMT as Integer
    LOCAL liHours as Integer, liMinutes as Integer
    TZInfo = SPACE(172)
    DECLARE INTEGER GetTimeZoneInformation IN kernel32 STRING @TZInfo
    liRetCode = GetTimeZoneInformation(@TZInfo)
    CLEAR DLLS GetTimeZoneInformation 
    DO case
       CASE m.liRetCode=TIME_ZONE_ID_UNKNOWN OR m.liRetCode=TIME_ZONE_ID_STANDARD
         liEcartGMT = -This.buf2dword(SUBSTR(m.TZInfo, 1, 4))
       CASE m.liRetCode = TIME_ZONE_ID_DAYLIGHT
         liEcartGMT = -(This.buf2dword(SUBSTR(m.TZInfo, 1, 4)) + This.buf2dword(SUBSTR(m.TZInfo, 169, 4))) 
    ENDCASE
    lcReturn = IIF(m.liEcartGMT>=0, "+","-")
    liHours = INT(ABS(m.liEcartGMT)/60)
    liMinutes = ABS(m.liEcartGMT) - 60*m.lihours
    lcReturn = lcReturn + PADL(ALLTRIM(STR(m.liHours)),2,"0") + PADL(ALLTRIM(STR(m.liMinutes)),2,"0")
  RETURN lcReturn

  FUNCTION buf2dword(lcBuffer)
  RETURN Asc(SUBSTR(m.lcBuffer, 1,1)) + ;
        BitLShift(Asc(SUBSTR(m.lcBuffer, 2,1)), 8) +;
        BitLShift(Asc(SUBSTR(m.lcBuffer, 3,1)), 16) +;
        BitLShift(Asc(SUBSTR(m.lcBuffer, 4,1)), 24)

  *-----------------------------------------------------------------------------------------
  * v1.07 révisé 1.09
  * hidden Procedure Data_Priority
  * 1.09
  hidden Procedure Data_Header
    * Priority
    do case
      case This.Priority="1" or Upper(this.Priority)="HIGH"
        this.data = this.data + "X-Priority: 1" + CRLF
        * v1.20
        * this.data = this.data + "X-MSMail-Priority: High" + CRLF
        this.data = this.data + "Importance: High" + CRLF        
      case This.Priority="5" or Upper(this.Priority)="LOW"
        this.data = this.data + "X-Priority: 5" + CRLF
        * v1.20
        * this.data = this.data + "X-MSMail-Priority: low" + CRLF
      OTHERWISE
        * v1.17
        this.Priority="3"
        this.data = this.data + "X-Priority: 3" + CRLF
        * v1.20
        * this.data = this.data + "X-MSMail-Priority: Normal" + CRLF
    ENDCASE
    * 1.09 mailer
    this.data = this.data + "X-Mailer: VFPwinsock " + this.version + CRLF
    * 1.11
    *v1.20 supprimé car provoque un HDR_ORDER_FTSDMCXX_BAT sur spamassain
    * this.data = this.data + "X-MimeOLE: Produced By VFPwinsock v" + this.version + CRLF

    * 1.09      
    if this.Notification
      this.data = this.data + "Disposition-Notification-To: "+this.FROM_Name+"<"+this.FROM+">" + CRLF
    endif
  return

 * v1.07
 hidden Function sys3()
   private v_r_sys3, v_s_sys3
   v_s_sys3 = sys(3)
   v_r_sys3 = sys(3)
   do while v_s_sys3 = v_r_sys3
     v_r_sys3 = sys(3)
   enddo
 return v_r_sys3
 
  * v1.07 : log en fichier.eml (que si le répertoire a été défini)
  * v1.10 : possibilité de donner le nom du fichier eml, sinon affecation du nom par défaut
  * v1.11 : une seule ecriture pour eviter le ralentissement antivirus
  hidden Procedure Log_Send_Eml()
    local v_i
    LOCAL v_fichier_eml, v_safety
    if not Empty(This.EML_Dir_Send) AND NOT EMPTY(This.EML_Data)
      if Empty(This.EML_File_Send) && si le fichier n'est pas précisé
        v_i = 1
        do while .T.
          This.EML_File_Send = "Send_" + Dtos(Date()) + "_" + Strtran(Time(),":","") + "_" + Alltrim(Str(v_i,3,0))+ ".eml"
          if File(Addbs(Alltrim(This.EML_Dir_Send)) + This.EML_File_Send)
            v_i = v_i + 1
          else
            exit
          endif
        ENDDO
      ENDIF
      v_fichier_eml = This.EML_Dir_Send + This.EML_File_Send
      v_safety = SET("safety")
      =StrToFile(This.EML_Data, v_fichier_eml, .F.) && v1.11 fichier ecrasé s'il existe V1.14 : mettre .F. pour vfp6
      SET SAFETY &v_safety
   endif
 RETURN
 
 * 1.12
 FUNCTION FormatDataEmail(p_adresse, p_name)
  LOCAL lcReturn as String
  LOCAL lcTo as String
  LOCAL lcToname as String
  LOCAL liNombreEmail as Integer
  LOCAL liNombreNom as Integer
  LOCAL lii as Integer 
  LOCAL liDebut as Integer 
  LOCAL liLong  as Integer 
  m.lcReturn = ""
  IF NOT EMPTY(p_adresse)
    m.liNombreEmail = OCCURS(",", p_adresse)+1
    m.liNombreNom   = OCCURS(",", p_name)+1
    FOR m.lii= 1 TO m.liNombreEmail
      m.liDebut = IIF(m.lii=1, 1, AT(",",p_adresse,m.lii-1)+1)
      m.liLong  = IIF(m.lii=m.liNombreEmail, LEN(p_adresse) - m.liDebut + 1, AT(",",p_adresse,m.lii)-m.liDebut)
      m.lcTo = LOWER(ALLTRIM(substr(p_adresse, m.liDebut, m.liLong)))
      * recherche du nom 
      IF m.lii<=m.liNombreNom
        m.liDebut = IIF(m.lii=1, 1, AT(",",p_name,m.lii-1)+1)
        m.liLong  = IIF(m.lii=m.liNombreNom, LEN(p_name) - m.liDebut + 1, AT(",",p_name,m.lii)-m.liDebut)
        m.lcToname = LOWER(ALLTRIM(substr(p_name, m.liDebut, m.liLong)))
      ELSE
        * v1.20
        * m.lcToname = m.lcTo
        m.lcToname = ""
      endif
      * v1.20      
      * m.lcReturn  = m.lcReturn  + IIF(EMPTY(m.lcReturn ),"",", ")+ '"'+m.lcToname+'"' + " <"+m.lcTo+">"
      m.lcReturn  = m.lcReturn  + IIF(EMPTY(m.lcReturn ), "", ", ")
      IF EMPTY(m.lcToname) OR (m.lcToname == m.lcTo)
        m.lcReturn  = m.lcReturn  +  "<"+m.lcTo+">"
      else
        m.lcReturn  = m.lcReturn  +  '"'+m.lcToname+'"' + " <"+m.lcTo+">"
      endif
    next
  ENDIF
RETURN m.lcReturn 


 * v1.05a   
 hidden Function EnCode64(p_chaine)
   local v_r
   v_r=""
   if VFP_VERSION >= 7
     v_r = Strconv(p_chaine,13)  && encodage 64 a partir de vfp 7
   else
    * v1-05a
    * Fonction d'encodage Base 64 (pour VFP <7 ne supportant strconv)
    * basée sur la publication de la Class : Base64 des travaux de 
    *     Jeff Bowman <jbowman@jeffbowman.com> Source: http://jeffbowman.com/base64.htm
    * et sur : http://fox.wikis.com/wc.dll?Wiki~VfpBase64
    LOCAL lcStr, i
    FOR i = 1 TO LEN(p_chaine) STEP 3
      lcStr = SUBSTR(p_chaine, i, 3)
      do case
        case Len(lcStr)=1
          v_r = v_r + Left(This.Split4(lcStr),2) + "=="
        case Len(lcStr)=2
          v_r = v_r + Left(This.Split4(lcStr),3) + "="
        otherwise
          v_r = v_r + This.Split4(lcStr)
      endcase
    next
  endif
 return v_r
 
 hidden function Split4(tcBinary)
   local aEncTab, v_i
   aEncTab = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
   LOCAL ARRAY aBase64[64]
*  DIMENSION aBase64[64]
   for v_i = 1 to Len(aEncTab)
     aBase64[v_i]  = Substr(aEncTab, v_i, 1)
   next
   *********************************************************************************
   *  Method:  Split4()
   *  Purpose: Splits a 24-bit binary string into 4 6-bit
   *           strings, converts them into decimal values and
   *           returns them as concatenated Base64 characters
   *******************************************************************************
   LOCAL liOutByte1, liOutByte2, liOutByte3, liOutByte4, liInByte1, liInByte2, liInByte3
   liInByte1 = ASC(SUBSTR(tcBinary, 1, 1))
   liInByte2 = ASC(SUBSTR(tcBinary, 2, 1))
   liInByte3 = ASC(SUBSTR(tcBinary, 3, 1))
   liOutByte1 = BITRSHIFT(liInByte1, 2)
   liOutByte2 = BITLSHIFT(BITAND(liInByte1, 0x03), 4) + BITRSHIFT(BITAND(liInByte2, 0xf0), 4)
   liOutByte3 = BITLSHIFT(BITAND(liInByte2, 0x0f), 2) + BITRSHIFT(BITAND(liInByte3, 0xc0), 6)
   liOutByte4 = BITAND(liInByte3, 0x3f)
   RETURN aBase64[liOutByte1 + 1] + ;
          aBase64[liOutByte2 + 1] + ;
          aBase64[liOutByte3 + 1] + ;
          aBase64[liOutByte4 + 1]
 endfunc

 * v1.17
 * dump : create a file with all properties for trace
 FUNCTION Dump(lsFile)
   * if lsfile, is not specified : Dump in logfile ".TraceFile"
   * if .TraceFile is not specified : dump in the .txt file
   IF TYPE("lsFile")<>"C"
     lsFile = THIS.TraceFile
   ENDIF
   IF EMPTY(lsFile)
     * lsFile = "VFP_Winsock_Send_Mail_"+TTOC(DATETIME())+".txt"
     * v1.19 nom du fichier
     lsFile = "VFP_Winsock_Send_Mail_"+TTOC(DATETIME())+".txt"
     lsFile = STRTRAN(m.lsFile, "/","_")
     lsFile = STRTRAN(m.lsFile, ":","_")
     lsFile = STRTRAN(m.lsFile, " ","_")
   ENDIF
   WITH this
     =STRTOFILE("---------------------------- DUMP ---------------------------- "+CRLF, m.lsFile, .T.)
     =STRTOFILE(TTOC(DATETIME())+CRLF, m.lsFile, .T.) && eb vfp6 le 3eme paramétre de strtofile est boolean
     =STRTOFILE("[.Version]=" + .Version +CRLF, m.lsFile, .T.)
     =STRTOFILE("[.SMTP_HOST]=" + .SMTP_HOST +CRLF, m.lsFile, .T.)
     =STRTOFILE("[.SMTP_PORT]=" + STR(.SMTP_PORT,2,0) +CRLF, m.lsFile, .T.)
     =STRTOFILE("[.SMTP_TimeOut]=" + STR(.SMTP_TimeOut,4,0) +CRLF, m.lsFile, .T.)
     =STRTOFILE("[.SMTP_HELO]=" + .SMTP_HELO +CRLF, m.lsFile, .T.)
     =STRTOFILE("[.CodePage]=" + .CodePage + CRLF, m.lsFile, .T.)
     =STRTOFILE("[.Content_Transfer_Encoding]=" + .Content_Transfer_Encoding+ CRLF, m.lsFile, .T.)
     =STRTOFILE("[.Priority]=" + .Priority + CRLF, m.lsFile, .T.)
     =STRTOFILE("[.Notification]=" + IIF(.Notification, ".T.", ".F.") + CRLF, m.lsFile, .T.)
     =STRTOFILE("[.Silence]=" + IIF(.Silence, ".T.", ".F.") + CRLF, m.lsFile, .T.)
     =STRTOFILE("[.FROM]=" + .FROM + CRLF, m.lsFile, .T.)
     =STRTOFILE("[.FROM_Name]=" + .FROM_Name + CRLF, m.lsFile, .T.)
     =STRTOFILE("[.TO]=" + .TO+ CRLF, m.lsFile, .T.)
     =STRTOFILE("[.TO_Name]=" + .TO_Name+ CRLF, m.lsFile, .T.)
     =STRTOFILE("[.CC]=" + .CC+ CRLF, m.lsFile, .T.)
     =STRTOFILE("[.CC_Name]=" + .CC_Name+ CRLF, m.lsFile, .T.)
     =STRTOFILE("[.CCI]=" + .CCI+ CRLF, m.lsFile, .T.)
     =STRTOFILE("[.AUTH_Login]=" + .AUTH_Login+ CRLF, m.lsFile, .T.)
     =STRTOFILE("[.AUTH_Password]=" + .AUTH_Password+ CRLF, m.lsFile, .T.)
     =STRTOFILE("[.Subject]=" + .Subject+ CRLF, m.lsFile, .T.)
     =STRTOFILE("[.Attachment]=" + .Attachment+ CRLF, m.lsFile, .T.)
     =STRTOFILE("[.Message]=" + .Message+ CRLF, m.lsFile, .T.)
     =STRTOFILE("[.MessageHTML]=" + .MessageHTML+ CRLF, m.lsFile, .T.)
     =STRTOFILE("[.Data]=" + .Data + CRLF, m.lsFile, .T.)
     =STRTOFILE("[.TraceFile]=" + .TraceFile + CRLF, m.lsFile, .T.)
     =STRTOFILE("[.EML_Dir_Send]=" + .EML_Dir_Send + CRLF, m.lsFile, .T.)
     =STRTOFILE("[.EML_File_Send]=" + .EML_File_Send+ CRLF, m.lsFile, .T.)
     =STRTOFILE("[.EML_Data]=" + .EML_Data+ CRLF, m.lsFile, .T.)
     =STRTOFILE("[.data_mhtml]=" + .data_mhtml+ CRLF, m.lsFile, .T.)
     =STRTOFILE("[.Erreur]=" + .Erreur+ CRLF, m.lsFile, .T.)
     =STRTOFILE("-------------------------------------------------------------- "+CRLF, m.lsFile, .T.)
   endwith
   RETURN m.lsFile
 ENDFUNC 

 * v1.20
 * Reset all properties 
 PROCEDURE Reset()
   WITH this
     .Version = CLASSEVERSION
     .SMTP_HOST = ""
     .SMTP_PORT    = VFPWINSOCK_SMTP_PORT
     .SMTP_TimeOut = VFPWINSOCK_TIMEOUT
     .SMTP_HELO = ""
     .CodePage = "iso-8859-1"
     .Content_Transfer_Encoding ="7bit"
     .Priority = ""
     .Notification = .F.
     .Silence = .F.
     .FROM         = ""
     .FROM_Name    = ""
     .TO           = ""
     .TO_Name      = ""
     .CC           = ""
     .CC_Name      = ""
     .CCI          = ""
     .AUTH_Login   = ""
     .AUTH_Password= ""
     .Subject      = ""
     .Attachment   = ""
     .Message      = ""
     .MessageHTML  = ""
     .Data         = ""
     .TraceFile    = ""
     .EML_Dir_Send = "" 
     .EML_File_Send= "" 
     .EML_Data     = "" 
     .data_mhtml   = ""
     .Erreur       = ""     
   endwith
ENDPROC

 *--------------------------------------------------------------------------*
 *---> v1.20 Convertir une chaine en 8859 quoted printable si nécessaire
 hidden function String2Iso8859(cString)
 local cEncode, nI, cChar, nAsc, useIso8859
   store "" to m.cEncode, m.cBuffer
   useIso8859 = .F.
   for nI = 1 to Len(m.cString)
     cChar = Substr(m.cString, m.nI, 1)
     nAsc = Asc(m.cChar)
     do case
       case m.nAsc = 32
         cBuffer = m.cBuffer + "_"
       case m.nAsc < 32 or m.nAsc = 61 or m.nAsc > 126
         cBuffer = m.cBuffer + "=" + Right(Transform(m.nAsc, "@0"), 2)
         useIso8859 = .T.
       otherwise
         cBuffer = m.cBuffer + m.cChar
     endcase
     if Len(m.cBuffer) >= 58
       m.cEncode = m.cEncode + Iif(Empty(m.cEncode), "", CRLF + Chr(9)) + ;
                               "=?iso-8859-1?Q?" +  m.cBuffer + "?="
       m.cBuffer = ""
     endif
   next
   if NOT Empty(m.cBuffer)
     m.cEncode = m.cEncode + Iif(Empty(m.cEncode), "", CRLF + Chr(9)) + ;
                             "=?iso-8859-1?Q?" +  m.cBuffer + "?="
   ENDIF
   IF NOT useIso8859 
     m.cEncode = m.cString
   endif
   return m.cEncode
 endfunc && String2Iso8859
 *--------------------------------------------------------------------------*

enddefine
* -----------------------------------------------------------------------------------------------------------*
* -----------------------------------------------------------------------------------------------------------*
* -----------------------------------------------------------------------------------------------------------*
* -----------------------------------------------------------------------------------------------------------*
* Définition d'une classe olepublic pour utilisation en DLL
* -----------------------------------------------------------------------------------------------------------*
* -----------------------------------------------------------------------------------------------------------*
* -----------------------------------------------------------------------------------------------------------*
#if COMPIL_AVEC_COM
  define class SendMail as VFP_Winsock_Send_Mail olepublic
    procedure init
      *application.AutoYield = .F.  && a voir ?
      DoDefault()
      this.silence=.T.
    return
    procedure destroy
      DoDefault()
      *application.AutoYield = .T.
    return
  enddefine
#endif
* -----------------------------------------------------------------------------------------------------------*
#IF VFP_VERSION>=7
* -----------------------------------------------------------------------------------------------------------*
* Auteur  :
*    Francis FAURE        francis.faure@mvps.org
* -----------------------------------------------------------------------------------------------------------*
* Exploitation de WinSock
*    V1.16 : rajout du client Radius (Radius_Access_Request)
*    objet : écrire un client Radius - Trame Access-Request
*            dans le but de requêter le radius de Vasco avec un token Digipass (Authentification Forte)
* RFC : 2138
* Source : http://www.ietf.org/rfc/rfc2138.txt
* -----------------------------------------------------------------------------------------------------------*
* VFP_RADIUS
* -----------------------------------------------------------------------------------------------------------*
DEFINE CLASS Radius_Access_Request as Custom
  RemoteHost = ""  && Adresse Of Radius server (Dns Name o IP)
  RemotePort = 1812  && standard radius Port
  SharedSecret = "" && Radius Shared Secret 
  Username   =""  && user id in radius
  Password = ""     && password or Digipass 
                        * Digipass = PIN(4) + OTP (6) =10
                        * Digipass = PIN(4) + OTP (6) + newPIN (4) + newPIN(4) = 18
  Request_Authenticator = ""
  PasswordMD5 = "" && Mot de Passe Hashé

  PROCEDURE init
    DoDefault()
    THIS.NewObject("o_Winsock", "ws2_32")
  RETURN
 
  PROCEDURE destroy
    release o_Winsock
    DoDefault()
  return

  * 0 - Radius Server not available 
  * 1 - Error or TimeOut /send & Get
  * 2 - Access-Accept (Ok)
  * 3 - Access-Rejected (Not Ok) bad login / bas pass / bad pin / user locked / ....
  FUNCTION Access_Request
    LOCAL liResult, Lii
    LOCAL lsB1, lsB2
    LOCAL lsSend, lsSend1, lsSend2, lsSend3, lsSend4, lsSend5
    LOCAL lsService_Type, lsNASIdentifier, lsNAS_Port_Type 
    LOCAL liLen, liLen1, liLen2
    LOCAL lsBuffer 
    WITH this.o_Winsock
      .Close()
      .Protocol = 1     && 0=TCP Protocol, 1=UDP
      .RemoteHost = this.RemoteHost
      .RemotePort = this.remoteport
      IF .Connect()
        *
        * User-Name
        *
        this.Username = ALLTRIM(this.Username)
        lsSend1 = CHR(1) + CHR(LEN(this.Username)+2) + this.Username
        *
        * Request_Authenticator (soupe de 16 octets)
        *
        this.Request_Authenticator = LEFT(STR(rand(-1)*10^8,8,0) + STR(SECONDS()*1000,8,0) + SYS(2015) + SPACE(16),16)
        *
        * Calculate MD5 User-Password / RFC2138
        *
        this.Password = ALLTRIM(this.Password)
        lsB1= md5(ALLTRIM(this.SharedSecret) + this.Request_Authenticator) && B1 = MD5(S + RA)
        This.PasswordMD5 = ""
        FOR lii=1 TO 16
          This.PasswordMD5 = This.PasswordMD5 + ;
                             CHR(BITXOR(ASC(SUBSTR(this.Password+REPLICATE(CHR(0),16), m.lii, 1)),;
                             EVALUATE("0x"+SUBSTR(m.lsB1, (m.lii-1)*2+1, 2))))
        NEXT
        * cas ou le mot de passe dépasse 16 octets
        IF LEN(this.Password)>16
          lsB2= md5(ALLTRIM(this.SharedSecret) + this.PasswordMD5 ) && B2 = MD5(S +c(1))
          FOR lii=17 TO 32
            this.PasswordMD5 = this.PasswordMD5 + ;
                               CHR(BITXOR(ASC(SUBSTR(this.Password+REPLICATE(CHR(0),16), m.lii, 1)),;
                               EVALUATE("0x"+SUBSTR(m.lsB2, (lii-17)*2+1, 2))))
          NEXT
        endif
        *
        * User-Password
        *
        lsSend2 = CHR(2) + CHR(LEN(this.PasswordMD5)+2) + this.PasswordMD5
        *
        * Service Type = Login
        *
        lsService_Type = CHR(0) + CHR(0) + CHR(0) + CHR(1) && login
        lsSend3 = CHR(6) + CHR(LEN(m.lsService_Type)+2) + m.lsService_Type 
        *
        * NAS Identifier
        *
        lsNASIdentifier = "Radius Client"
        lsSend4 = CHR(32) + CHR(LEN(m.lsNASIdentifier)+2) + m.lsNASIdentifier
        *
        * NAS port Type = Virtual
        *
        lsNAS_Port_Type = CHR(0)+CHR(0)+CHR(0)+CHR(1) && Virtual
        lsSend5 = CHR(61) + CHR(LEN(m.lsNAS_Port_Type )+2) + m.lsNAS_Port_Type 
        * composition chaine finale a expédier
        lsSend = m.lsSend1 + m.lsSend2 + m.lsSend3 + m.lsSend4 + m.lsSend5
        liLen  = LEN(m.lsSend) + 20
        liLen1 = INT(m.LiLen/255)
        liLen2 = m.LiLen - m.lilen1
        lsSend = CHR(1) + CHR(1) +  CHR(m.liLen1) + CHR(m.liLen2) + this.Request_Authenticator + m.lsSend
        * send UDP
        IF .SendData(m.lsSend)
           lsBuffer = ""
           IF .GETDATA(@m.lsBuffer)
             liResult = ASC(SUBSTR(m.lsBuffer,1,1))
           ELSE
             liResult = 1
           endif
        ELSE
          liResult = 1
        endif 
       .Close()
      else
        liResult = 0
      endif
    ENDWITH
  RETURN m.liResult    
ENDDEFINE
* -----------------------------------------------------------------------------------------------------------*
#ENDIF*-------------------------------------------------------------------------------------*
*-------------------------------------------------------------------------------------*
*-------------------------------------------------------------------------------------*
* 
* Adaptation par Francis Faure des codes source de  William GC Steinford et de AnatoliyMogylevets / fox.wikis.com
* Adapted By Francis Faure, based on source code posted on fox.wikis.com
*
*-------------------------------------------------------------------------------------*
*-------------------------------------------------------------------------------------*
*-------------------------------------------------------------------------------------*
* Révisé le 4/12/2006 (cas appel 2 objet simultanné : gestion DLL en mémoire)
* v1.16 :
*    Révisé le 10/06/2008 pour l'adaptation avec UDP (modified june 10, 2008 for add UDP protocol) 
*-------------------------------------------------------------------------------------*
* VFP_WS2_32.PRG
*-------------------------------------------------------------------------------------*

DEFINE CLASS WS2_32 As custom
  
  * This class was written by William GC Steinford
  * based on code posted by AnatoliyMogylevets on fox.wikis.com
  * This class is designed to mimic the features of the MSWINSCK.WinSock activeX control
  * which are used by SendSmtpEmail
  
  * Public Interface Properties:
  * N - State
  * N - BytesReceived (read only)
  * C - RemoteHost 
  * C - RemoteHostIP (read only)
  * N - RemortPort
  * C - cIn (read/write)
  * N - SocketHandle
  *
  * Public Interface Methods:
  * L - Connect()
  * L - Close()
  * L - SendData( cData )
  * L - GetData( @cDataOut )
  
  * State property Values
  * 0 Default. Closed
  * 1 Open
  * 2 Listening
  * 3 Connection pending
  * 4 Resolving host
  * 5 Host resolved
  * 6 Connecting
  * 7 Connected
  * 8 Peer is closing the connection
  * 9 Error
  State = 0
  BytesReceived = 0
  RemotePort = ""
  RemoteHost = ""
  RemoteHostIP = ""
  *SocketHandle = 0
  SocketHandle = -1 && v1.19
  
  cIn = ''
  WaitForRead = 0
  
  *  LocalPort=0 
  
  * Performance Adjustable Constants:
  #DEFINE READ_SIZE 16384
  #DEFINE READ_FROM_SERVER_TIMEOUT 1000
  
  * v1.14
  Timeout = 30
   
  * API Constants:
  #DEFINE AF_INET 2
  #DEFINE SOCK_STREAM 1
  #DEFINE IPPROTO_TCP 6
  
  * V1.16
  #define IPPROTO_UDP 17
  #define SOCK_DGRAM      2 

  #DEFINE SOCKET_ERROR -1
  #DEFINE FD_READ 1
  #DEFINE HOSTENT_SIZE 16

  * V1.16
  Protocol = 0     && 0=TCP Protocol, 1=UDP    (TCP par défaut)

  * v1.18
  * http://msdn.microsoft.com/en-us/library/ms741394(VS.85).aspx

  *
  * L Connect()
  *
  * v1.12 : modification lconnect en m.lconnect, etc...
  FUNCTION Connect()
    LOCAL cBuffer, cPort, lResult
    LOCAL nHost, cHost
    LOCAL lconnect, nStart
    m.lResult = .F.
    
    if not this.InitiateWinsock() && v1.19
      THIS.State = -1 && rajout d'un etat a State pour indiquer que : "unable to initialize Winsock on this computer"
      return .F.
    endif
        
    * résolution DNS/IP
    this.RemoteHost = ALLTRIM(this.RemoteHost) && v1.18
    THIS.RemoteHostIP = THIS.GetIP(this.RemoteHost)
    IF EMPTY(THIS.RemoteHostIP)
      * THIS.State = 9 && v1.11
      THIS.State = 4 && v1.18
    else
      this.UseDLL("socket")
      * v1.16
      IF this.Protocol = 1 && UDP
        THIS.SocketHandle = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)
      ELSE && TCP
        THIS.SocketHandle = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
      endif
      
      if THIS.SocketHandle = SOCKET_ERROR
        * v1.11
        THIS.State = 9
      else
        THIS.State = 6
        this.UseDLL("htons")
        m.cPort = THIS.num2word(htons(this.RemotePort))
        this.UseDLL("inet_addr")
        m.nHost = inet_addr(THIS.RemoteHostIP)
        m.cHost = THIS.num2dword(m.nHost)
        m.cBuffer = THIS.num2word(AF_INET) + m.cPort + m.cHost + Replicate(Chr(0),8)
        * v 1.11 : rajout d'une boucle de gestion timeout
        m.nstart = SECONDS()
        m.lconnect=0
        * v1.14 
        this.useDLL("ws_connect")
        DO WHILE .T.
          m.lconnect = ws_connect(THIS.SocketHandle, @m.cBuffer, Len(m.cBuffer))
          IF (m.lconnect==0) OR ;
            ((SECONDS() - m.nStart) > this.TimeOut)
            EXIT
          endif
          DOEVENTS
        enddo
        IF m.lconnect==0
          m.lResult=.T.
          THIS.State = 7
        ELSE
          THIS.State = 0
        ENDIF
      ENDIF
    ENDIF
  RETURN m.lResult

  Procedure Close
    if THIS.SocketHandle<>SOCKET_ERROR
      this.UseDLL("closesocket")
      =closesocket(THIS.SocketHandle)
    endif
    THIS.SocketHandle = SOCKET_ERROR
    THIS.State = 0
  EndProc

  *
  * L SENDATA ( @data )
  *
  FUNCTION SendData(cData)
    LOCAL cBuffer, nResult, lreturn
    m.cBuffer = m.cData
    this.useDLL("send")
    nResult = send(THIS.SocketHandle, @m.cBuffer, Len(m.cBuffer), 0)
    lreturn = (m.nResult <> SOCKET_ERROR)
  RETURN m.lreturn

  *
  * L GETDATA( @data )
  *
  FUNCTION GetData(p_Data)
  LOCAL nReturn
    if this.BytesReceived>0
      p_data = THIS.cIn
      THIS.cIn = ''
      nReturn = .T.
    else
      nReturn = .F.
    endif
  return m.nReturn

  PROTECTED FUNCTION BytesReceived_Access
    THIS.Rd()
  RETURN LEN(THIS.cIn)
  
  * v 1.16
  PROTECTED FUNCTION Rd
    LOCAL hEventRead, cRecv, nRecv, nFlags
    LOCAL liWaitForRead
    this.useDLL("WSACreateEvent")
    this.useDLL("WSAEventSelect")
    this.useDLL("WSAWaitForMultipleEvents")
        this.useDLL("WSACloseEvent")
    * creating event, linking it to the socket and wait
    hEventRead = WSACreateEvent()
    =WSAEventSelect(THIS.SocketHandle, m.hEventRead, FD_READ)
    liWaitForRead = WSAWaitForMultipleEvents(1, @m.hEventRead, 0, READ_FROM_SERVER_TIMEOUT, 0)
    =WSACloseEvent(m.hEventRead)
    IF liWaitForRead <> 0 && error or timeout
    ELSE
      cRecv = Repli(Chr(0), READ_SIZE)
      nFlags = 0
      This.useDLL("recv")
      nRecv = recv(THIS.SocketHandle, @m.cRecv, READ_SIZE, m.nFlags)
      THIS.cIn = THIS.cIn + Iif(m.nRecv<=0, "", LEFT(m.cRecv, m.nRecv))
    endif
  ENDFUNC

  hidden function InitiateWinsock && v1.19 The WSAStartup function initiates use of the Winsock DLL by a process.
    * initialisation WS2_32.DLL
    * http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winsock/winsock/wsastartup_2.asp    
    LOCAL nReturn
    This.UseDLL("WSAStartup")
    IF WSAStartup(0x202, Repli(Chr(0),512)) <> 0
      * unable to initialize Winsock on this computer
      nReturn = .F.
    ELSE
      nReturn = .T.
    ENDIF
    RETURN m.nReturn
  ENDfunc
*!*	  PROCEDURE Init()
*!*	    LOCAL nReturn
*!*	    DoDefault()
*!*	    * initialisation WS2_32.DLL
*!*	    * http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winsock/winsock/wsastartup_2.asp    
*!*	    * 04/12/2006
*!*	    *This.DeclareDLL
*!*	    This.UseDLL("WSAStartup")
*!*	    IF WSAStartup(0x202, Repli(Chr(0),512)) <> 0
*!*	      * unable to initialize Winsock on this computer
*!*	      nReturn = .F.
*!*	    ELSE
*!*	      nReturn = .T.    
*!*	    ENDIF
*!*	    RETURN m.nReturn
*!*	  ENDPROC

  PROCEDURE Destroy
    * termine l'utilisation de WS2_32
    * http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winsock/winsock/wsacleanup_2.asp  
    * v1.11 : problème : si 2 objets lancés en même temps (signalé par Christophe Chenavier) : la suppression du 1 objet enleve les DLL et fait planté le deuxieme Objet
    this.useDll("WSACleanup")
    =WSACleanup()
    this.RemoveDLL()
    DoDefault()
  ENDPROC

  * Fonction retournant l'adresse IP d'un nom d'hote (Résolution DNS)  
  * appel gethostbyename
  * http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winsock/winsock/gethostbyname_2.asp

  * http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winsock/winsock/hostent_2.asp
  * typedef struct hostent {
  *   char FAR* h_name;
  *   char FAR  FAR** h_aliases;
  *   short h_addrtype;
  *   short h_length;
  *   char FAR  FAR** h_addr_list;
  * } hostent;
  *
  * attention winsock doit etre initialisée avant avec WSAStartup  
  PROTECTED FUNCTION GetIP(pcHost)
      LOCAL nStruct, cBuffer, cIP
      LOCAL nReturn
      this.UseDll("gethostbyname")
      nStruct = gethostbyname(m.pcHost)
      IF m.nStruct = 0
        nReturn = ""
      else
        cBuffer = Repli(Chr(0), HOSTENT_SIZE)
        cIP = Repli(Chr(0), 4)
        This.UseDLL("CopyMemory")
        =CopyMemory(@m.cBuffer, m.nStruct, HOSTENT_SIZE)
        =CopyMemory(@m.cIP, THIS.buf2dword(SUBS(cBuffer,13,4)),4)
        =CopyMemory(@m.cIP, THIS.buf2dword(m.cIP),4)
        This.UseDLL("inet_ntoa")
        nReturn = inet_ntoa(THIS.buf2dword(m.cIP))
      endif
  RETURN m.nReturn


  FUNCTION buf2dword(lcBuffer)
  RETURN Asc(SUBSTR(m.lcBuffer, 1,1)) + ;
        BitLShift(Asc(SUBSTR(m.lcBuffer, 2,1)), 8) +;
        BitLShift(Asc(SUBSTR(m.lcBuffer, 3,1)), 16) +;
        BitLShift(Asc(SUBSTR(m.lcBuffer, 4,1)), 24)
  
  FUNCTION num2dword(lnValue)
      IF m.lnValue < 0
          m.lnValue = 0x100000000 + m.lnValue
      ENDIF
      LOCAL b0, b1, b2, b3
      m.b3 = Int(m.lnValue/2^24)
      m.b2 = Int((m.lnValue - m.b3*2^24)/2^16)
      m.b1 = Int((m.lnValue - m.b3*2^24 - m.b2*2^16)/2^8)
      m.b0 = Mod(m.lnValue, 2^8)
  RETURN Chr(m.b0)+Chr(m.b1)+Chr(m.b2)+Chr(m.b3)

  
  FUNCTION num2word(lnValue)
  RETURN Chr(MOD(m.lnValue,256)) + CHR(INT(m.lnValue/256))
  
  * 04/12/2006 : rajout d'un paramétre a DeclareDLL
  *              a fonction utilisée (vérifier si la dll est en mémoire sinon la déclarer)
  *              renomer en UseDLL
  hidden procedure UseDLL(p_function)
    LOCAL lsFunction
    lsFunction = ALLTRIM(UPPER(m.p_function))
    IF this.is_DLL_Loaded(m.lsFunction)
    else
	    DO case
	      CASE m.lsFunction = UPPER("WSAStartup")
	        DECLARE INTEGER WSAStartup IN ws2_32 INTEGER wVerRq, STRING lpWSAData
	      CASE m.lsFunction = UPPER("WSACleanup")
		    DECLARE INTEGER WSACleanup IN ws2_32
	      CASE m.lsFunction = UPPER("gethostbyname")
	        DECLARE INTEGER gethostbyname IN ws2_32 STRING host
	      CASE m.lsFunction = UPPER("inet_ntoa") 
	        DECLARE STRING inet_ntoa IN ws2_32 INTEGER in_addr
	      CASE m.lsFunction = UPPER("socket") 
	        DECLARE INTEGER socket IN ws2_32 INTEGER af, INTEGER tp, INTEGER pt
	      CASE m.lsFunction = UPPER("closesocket") 
	        DECLARE INTEGER closesocket IN ws2_32 INTEGER s
	      CASE m.lsFunction = UPPER("WSACreateEvent") 
	        DECLARE INTEGER WSACreateEvent IN ws2_32
	      CASE m.lsFunction = UPPER("WSACloseEvent") 
	        DECLARE INTEGER WSACloseEvent IN ws2_32 INTEGER hEvent
	      CASE m.lsFunction = UPPER("WSAEventSelect")
	        DECLARE INTEGER WSAEventSelect IN ws2_32 INTEGER s, INTEGER hEventObject, INTEGER lNetworkEvents
	      CASE m.lsFunction = UPPER("WSAWaitForMultipleEvents") 
	        DECLARE INTEGER WSAWaitForMultipleEvents IN ws2_32 INTEGER cEvents, INTEGER @lphEvents, INTEGER fWaitAll, INTEGER dwTimeout, INTEGER fAlertable
	      CASE m.lsFunction = UPPER("inet_addr") 
	        DECLARE INTEGER inet_addr IN ws2_32 STRING cp
	      CASE m.lsFunction = UPPER("htons") 
	        DECLARE INTEGER htons IN ws2_32 INTEGER hostshort
	      CASE m.lsFunction = UPPER("connect")  OR  m.lsFunction = UPPER("ws_connect") 
	        DECLARE INTEGER connect IN ws2_32 AS ws_connect INTEGER s, STRING @sname, INTEGER namelen
	      CASE m.lsFunction = UPPER("send") 
	        DECLARE INTEGER send IN ws2_32 INTEGER s, STRING @buf, INTEGER buflen, INTEGER flags
	      CASE m.lsFunction = UPPER("recv") 
	        DECLARE INTEGER recv IN ws2_32 INTEGER s, STRING @buf, INTEGER buflen, INTEGER flags
	      CASE m.lsFunction = UPPER("RtlMoveMemory")  OR  m.lsFunction = UPPER("CopyMemory")
	        DECLARE RtlMoveMemory IN kernel32 As CopyMemory STRING @Dest, INTEGER Src, INTEGER nLength
	    ENDCASE
      * DECLARE GetSystemTime IN kernel32 STRING @lpSystemTime
    endif
  return    

  hidden FUNCTION is_DLL_Loaded(p_function)
    LOCAL ARRAY laTab[1,3]
    LOCAL lii
    LOCAL nReturn
    nReturn = .F.
    * v1.14
    if VFP_VERSION >= 7 && en VFP6 la fonction ADLLs n'existe pas : on charge toujours la DLL
*!*	      FOR lii=1 TO ADLLS(laTab)
*!*	        IF ALLTRIM(UPPER(laTab[m.lii,1])) = m.p_function OR ;
*!*	           ALLTRIM(UPPER(laTab[m.lii,2])) = m.p_function
*!*	          nReturn = .T.
*!*	          exit
*!*	        endif
*!*	      NEXT
    endif
  RETURN m.nReturn

  hidden Procedure RemoveDLL
    clear dlls gethostbyname
    clear dlls inet_ntoa
    clear dlls socket
    clear dlls closesocket
    clear dlls WSACreateEvent
    clear dlls WSACloseEvent
*   clear dlls GetSystemTime
    clear dlls inet_addr
    clear dlls htons
    clear dlls WSAStartup 
    clear dlls WSACleanup
    clear dlls ws_connect
    clear dlls send
    clear dlls recv
    clear dlls WSAEventSelect
    clear dlls WSAWaitForMultipleEvents
    clear dlls CopyMemory
  return
   
ENDDEFINE
*-------------------------------------------------------------------------------------*
*-------------------------------------------------------------------------------------*
*-------------------------------------------------------------------------------------*
* -----------------------------------------------------------------------------------------------------------*
* Classe Basique
* -----------------------------------------------------------------------------------------------------------*
* vfp_base.prg
*-------------------------------------------------------------------------------------*

DEFINE CLASS Basique as Custom
 * 1.01 : si le nom du fichier est renseigné alors la classe trace dans ce fichier
 * 1.17 : rajoute de recherhce outlook/outlook express
 TraceFile = ""
 
 * -----------------------------------------------------------------------------------------------------------*
 * -----------------------------------------------------------------------------------------------------------*
 * -----------------------------------------------------------------------------------------------------------*
 * Pemet de générer le fichier de log
 Procedure Trace(p_texte)
   local v_f
   if not empty(this.TraceFile)
     if File(this.TraceFile)
       v_f=Fopen(this.TraceFile,2)
       =Fseek(v_f, 0, 2)
     else
       v_f=Fcreate(this.TraceFile)
     endif
     =Fputs(v_f, TTOC(Datetime())+" "+ Strtran(m.p_texte, CRLF, "<CR+LF>"))
     =Fclose(v_f)
   endif
 endproc
 
 * -----------------------------------------------------------------------------------------------------------*
 * -----------------------------------------------------------------------------------------------------------*
 * -----------------------------------------------------------------------------------------------------------*
 * 1.06 : lecture base de registre
 * source Design Or Decline
 function Lire_Base_Registre(p_quoi)
 local v_handle, v_account, v_retour
   v_retour = "" && v1.18 oubli d'initialiser cette variable
   * v1.17 : rajout test outlook / outlook express
   LOCAL lsMailer
   lsMailer=""
   v_handle = this.KeyOpen("SOFTWARE\Clients\Mail","MACHINE")
   if v_handle<>0
     lsMailer = ALLTRIM(this.KeyGetValue(v_handle, [])) && OutlookExpress / Microsoft Outlook
     =this.KeyClose(v_handle)
   ENDIF
   DO case
     CASE lsMailer == "Microsoft Outlook"
       v_handle = this.KeyOpen("Software\Microsoft\Office\Outlook\OMI Account Manager")
       if v_handle<>0
         v_account = this.KeyGetValue(v_handle, "Default Mail Account")
         =this.KeyClose(v_handle)
         if not Empty(v_account)
           v_handle = this.KeyOpen("Software\Microsoft\Office\Outlook\OMI Account Manager\Accounts\"+v_account)
           if v_handle<>0
             v_retour = this.KeyGetValue(v_handle, m.p_quoi)
             =this.KeyClose(v_handle)
           endif
         endif
       endif
       this.Trace(lsMailer+" Reading registry : ["+m.p_quoi+"] response = " + m.v_retour)
     *CASE lsMailer == "Outlook Express"
     otherwise
       v_handle = this.KeyOpen("Software\Microsoft\Internet Account Manager")
       if v_handle<>0
         v_account = this.KeyGetValue(v_handle, "Default Mail Account")
         =this.KeyClose(v_handle)
         if not Empty(v_account)
           v_handle = this.KeyOpen("Software\Microsoft\Internet Account Manager\Accounts\"+v_account)
           if v_handle<>0
             v_retour = this.KeyGetValue(v_handle, m.p_quoi)
             =this.KeyClose(v_handle)
           endif
         endif
       endif
       this.Trace(lsMailer+" Reading registry : ["+m.p_quoi+"] response = "+m.v_retour)
   endcase
   return m.v_retour
 endfunc
 
 *--------------------------------------------------------------------------*
 #define HKEY_LOCAL_MACHINE        0x80000002
 #define HKEY_CURRENT_USER         0x80000001
 #define REG_OPTION_NON_VOLATILE    0
 #define REG_SZ                    1    && Unicode nul terminated string
 #define REG_BINARY                3    && Free form binary
 #define KEY_QUERY_VALUE         (0x0001)
 #define KEY_SET_VALUE           (0x0002)
 #define KEY_CREATE_SUB_KEY      (0x0004)
 #define KEY_ENUMERATE_SUB_KEYS  (0x0008)
 #define KEY_NOTIFY              (0x0010)
 #define KEY_CREATE_LINK         (0x0020)
 #define SYNCHRONIZE                (0x00100000)
 #define STANDARD_RIGHTS_ALL        (0x001F0000)

 hidden procedure KeyOpen(p_key, p_user_machine)
 private v_handle
 private KEY_ALL_ACCESS
 LOCAL nError
    * v1.17
   IF TYPE("p_user_machine")<>"C"
     p_user_machine="USER"
   endif

   KEY_ALL_ACCESS = BitAnd(STANDARD_RIGHTS_ALL + ;
                           KEY_QUERY_VALUE + ;
                           KEY_SET_VALUE + ;
                           KEY_CREATE_SUB_KEY + ;
                           KEY_ENUMERATE_SUB_KEYS + ;
                           KEY_NOTIFY + ;
                           KEY_CREATE_LINK, BitNot(SYNCHRONIZE))
   declare integer RegOpenKeyEx in advapi32 ;
           integer hKey, ;                && handle of open key
           string  @lpSubKey, ;            && address of name of subkey to open
           integer ulOptions, ;            && reserved
           integer samDesired, ;            && security access mask
           integer @phkResult             && address of handle of open key
   v_handle = 0
   * v1.17
   IF (p_user_machine=="MACHINE")
     nError = RegOpenKeyEx(HKEY_LOCAL_MACHINE, p_key, 0, KEY_ALL_ACCESS, @v_handle)
   else
     nError = RegOpenKeyEx(HKEY_CURRENT_USER, p_key, 0, KEY_ALL_ACCESS, @v_handle)
   endif
   return v_handle
 endproc
 *--------------------------------------------------------------------------*
 hidden procedure KeyGetValue(p_handle, p_value_name)
 private v_reserved, v_type, v_data, v_data_size
 LOCAL nError
   declare integer RegQueryValueEx in advapi32 ;
           integer hKey, ;                && handle of key to query
           string  lpValueName, ;        && address of name of value to query
           integer lpReserved, ;            && reserved
           integer @lpType, ;            && address of buffer for value type
           string  @lpData, ;            && address of data buffer
           integer @lpcbData             && address of data buffer size
   v_reserved = 0
   v_type = 0
   v_data = Space(256)
   v_data_size = 255
   nError = RegQueryValueEx(p_handle, ;
                             p_value_name, ;
                             v_reserved, ;
                             @v_type, ;
                             @v_data, ;
                             @v_data_size)
   return Left(v_data, v_data_size - 1)
 endproc
 *--------------------------------------------------------------------------*
 hidden procedure KeyClose(p_handle)
  declare integer RegCloseKey in advapi32 ;
          integer hKey                    && handle of key to close
   =RegCloseKey(m.p_handle)
 endproc
 * -----------------------------------------------------------------------------------------------------------*
 * -----------------------------------------------------------------------------------------------------------*
 * -----------------------------------------------------------------------------------------------------------*

 
ENDDEFINE

* -----------------------------------------------------------------------------------------------------------*
* VFP_MD5.PRG
* -----------------------------------------------------------------------------------------------------------*

#IF VFP_VERSION>=7
* -----------------------------------------------------------------------------------------------------------*
*
* MD5 Function => return MD5
* Based on class written by Patrick Gilles on www.atoutfox.org
*
* -----------------------------------------------------------------------------------------------------------*
* C MD5(String)
Function MD5
PARAMETERS lsString
  LOCAL oMD5
  LOCAL lsReturn
  oMD5 = CREATEOBJECT("MD5")
  oMD5.tohash = m.lsSTring
  lsReturn = oMD5.Compute()
  oMD5=.null.
RETURN lsReturn


DEFINE CLASS MD5 AS Custom 
**********************************************************************************************************************
* Written in VFP by GILLES Patrick (C) IKOONET SARL www.ikoonet.com
* Une implémention en Visual Foxpro de l'algorithme MD5 message digest tel que definis dans le RFC 1321 par R. RIVEST
* de la sociét?RSA DATA SECURTY & MIT Laboratory for Computer Science
* A VFP implementation of the RSA Data Security, Inc. MD5 Message Digest Algorithm, as defined in RFC 1321.
**********************************************************************************************************************
* Usage (sample)
* SET PROCEDURE TO mdigest5
* MD5=CREATEOBJECT("MD5")
* MD5.tohash="abc"
* ? MD5.compute()
*******************************
tohash=""
DIMENSION SinusArray(64)
#DEFINE MAX_UINT 4294967296
#DEFINE NUMBEROFBIT 8 && UNICODE 16 (unicode not tested)


PROCEDURE init
  LOCAL I
  FOR I = 1 TO 64
    this.SinusArray(I)=TRANSFORM(MAX_UINT*ABS(SIN(I)),"@0")
    this.SinusArray(I)=BITAND(EVALUATE(this.SinusArray(I)),0xFFFFFFFF) &&CAST
  ENDFOR
RETURN .T.

PROCEDURE bourre
  LOCAL NBR_BIT_BOURRE, BOURRAGE
  Bourrage = CHR(128)+REPLICATE(CHR(0),63)
  NBR_BIT_BOURRE=(448-(LEN(THIS.TOHASH)*NUMBEROFBIT)%512)/NUMBEROFBIT
  IF (LEN(THIS.TOHASH)*NUMBEROFBIT)%512>=448
    NBR_BIT_BOURRE=(448+((512-LEN(THIS.TOHASH)*NUMBEROFBIT)%512))/NUMBEROFBIT
  ENDIF

RETURN LEFT(bourrage,NBR_BIT_BOURRE)


PROCEDURE acompleter
  LOCAL retour,decalage
  decalage=TRANSFORM(LEN(this.tohash)* NUMBEROFBIT,"@0")
  retour=""
  retour=retour+CHR(EVALUATE("0x"+SUBSTR(decalage,9,2)))
  retour=retour+CHR(EVALUATE("0x"+SUBSTR(decalage,7,2)))
  retour=retour+CHR(EVALUATE("0x"+SUBSTR(decalage,5,2)))
  retour=retour+CHR(EVALUATE("0x"+SUBSTR(decalage,3,2)))
  retour=retour+REPLICATE(CHR(0),4)
RETURN RETOUR


PROCEDURE MD5_F
LPARAMETERS x,y,z
RETURN BITOR(BITAND(X,Y),BITAND(BITNOT(X),Z))

PROCEDURE MD5_G
LPARAMETERS x,y,z
RETURN BITOR(BITAND(X,Z),BITAND(Y,BITNOT(Z)))

PROCEDURE MD5_H
LPARAMETERS x,y,z
RETURN BITXOR(X,Y,Z)

PROCEDURE MD5_I
LPARAMETERS x,y,z
RETURN BITXOR(Y,BITOR(X,BITNOT(Z)))

PROCEDURE ROTATE_LEFT
LPARAMETERS pivot, npivot
RETURN BITOR(BITLSHIFT(pivot,npivot),BITRSHIFT(pivot,32-Npivot))

procedure ronde1
LPARAMETERS PA,PB,PC,PD,PE,PF,PG
RETURN PB+this.ROTATE_LEFT(PA+this.MD5_F(PB,PC,PD)+PE+PG,PF)

procedure ronde2
LPARAMETERS PA,PB,PC,PD,PE,PF,PG
RETURN PB+this.ROTATE_LEFT(PA+this.MD5_G(PB,PC,PD)+PE+PG,PF)

PROCEDURE ronde3
LPARAMETERS PA,PB,PC,PD,PE,PF,PG
RETURN PB+this.ROTATE_LEFT(PA+this.MD5_H(PB,PC,PD)+PE+PG,PF)

PROCEDURE ronde4
LPARAMETERS PA,PB,PC,PD,PE,PF,PG
RETURN PB+this.ROTATE_LEFT(PA+this.MD5_I(PB,PC,PD)+PE+PG,PF)

PROCEDURE compute
  LOCAL tocompute,CPT_I,CPT_J,CPT_L,TMP_STRING,AA,BB,CC,DD,a,b,c,d,aa,bb,cc,dd
  A=BITAND(0x67452301,0xFFFFFFFF)
  B=BITAND(0xEFCDAB89,0xFFFFFFFF)
  C=BITAND(0x98BADCFE,0xFFFFFFFF)
  D=BITAND(0x10325476,0xFFFFFFFF)

  DIMENSION T_X(16)
  tocompute=this.tohash+this.bourre()+this.acompleter()
  lentocompute=LEN(tocompute)/64

  OldA=A
  OldB=B
  OldC=C
  OldD=D
  FOR CPT_I=0 TO lentocompute-1
    FOR CPT_J=0 TO 15
      T_X(CPT_J+1)=""
      T_X(CPT_J+1)=T_X(CPT_J+1)+RIGHT(TRANSFORM(ASC(SUBSTR(tocompute,(CPT_I*64)+(CPT_J*4)+4,1)),"@0"),2)
      T_X(CPT_J+1)=T_X(CPT_J+1)+RIGHT(TRANSFORM(ASC(SUBSTR(tocompute,(CPT_I*64)+(CPT_J*4)+3,1)),"@0"),2)
      T_X(CPT_J+1)=T_X(CPT_J+1)+RIGHT(TRANSFORM(ASC(SUBSTR(tocompute,(CPT_I*64)+(CPT_J*4)+2,1)),"@0"),2)
      T_X(CPT_J+1)=T_X(CPT_J+1)+RIGHT(TRANSFORM(ASC(SUBSTR(tocompute,(CPT_I*64)+(CPT_J*4)+1,1)),"@0"),2)

      T_X(CPT_J+1)=BITAND(EVALUATE("0x"+T_X(CPT_J+1)),0xFFFFFFFF) && CAST
      *? TRANSFORM(T_X(CPT_J+1),"@0")
      *?
    ENDFOR

    OldA=A
    OldB=B
    OldC=C
    OldD=D

    && Ronde1
    a=this.ronde1(a,b,c,d,T_X( 1), 7,this.sinusarray( 1))
    d=this.ronde1(d,a,b,c,T_X( 2),12,this.sinusarray( 2))
    c=this.ronde1(c,d,a,b,T_X( 3),17,this.sinusarray( 3))
    b=this.ronde1(b,c,d,a,T_X( 4),22,this.sinusarray( 4))

    a=this.ronde1(a,b,c,d,T_X( 5), 7,this.sinusarray( 5))
    d=this.ronde1(d,a,b,c,T_X( 6),12,this.sinusarray( 6))
    c=this.ronde1(c,d,a,b,T_X( 7),17,this.sinusarray( 7))
    b=this.ronde1(b,c,d,a,T_X( 8),22,this.sinusarray( 8))

    a=this.ronde1(a,b,c,d,T_X( 9), 7,this.sinusarray( 9))
    d=this.ronde1(d,a,b,c,T_X(10),12,this.sinusarray(10))
    c=this.ronde1(c,d,a,b,T_X(11),17,this.sinusarray(11))
    b=this.ronde1(b,c,d,a,T_X(12),22,this.sinusarray(12))

    a=this.ronde1(a,b,c,d,T_X(13), 7,this.sinusarray(13))
    d=this.ronde1(d,a,b,c,T_X(14),12,this.sinusarray(14))
    c=this.ronde1(c,d,a,b,T_X(15),17,this.sinusarray(15))
    b=this.ronde1(b,c,d,a,T_X(16),22,this.sinusarray(16))
    && ronde 2
    a=this.ronde2(a,b,c,d,T_X( 2), 5,this.sinusarray(17))
    d=this.ronde2(d,a,b,c,T_X( 7), 9,this.sinusarray(18))
    c=this.ronde2(c,d,a,b,T_X(12),14,this.sinusarray(19))
    b=this.ronde2(b,c,d,a,T_X( 1),20,this.sinusarray(20))

    a=this.ronde2(a,b,c,d,T_X( 6), 5,this.sinusarray(21))
    d=this.ronde2(d,a,b,c,T_X(11), 9,this.sinusarray(22))
    c=this.ronde2(c,d,a,b,T_X(16),14,this.sinusarray(23))
    b=this.ronde2(b,c,d,a,T_X( 5),20,this.sinusarray(24))

    a=this.ronde2(a,b,c,d,T_X(10), 5,this.sinusarray(25))
    d=this.ronde2(d,a,b,c,T_X(15), 9,this.sinusarray(26))
    c=this.ronde2(c,d,a,b,T_X( 4),14,this.sinusarray(27))
    b=this.ronde2(b,c,d,a,T_X( 9),20,this.sinusarray(28))

    a=this.ronde2(a,b,c,d,T_X(14), 5,this.sinusarray(29))
    d=this.ronde2(d,a,b,c,T_X( 3), 9,this.sinusarray(30))
    c=this.ronde2(c,d,a,b,T_X( 8),14,this.sinusarray(31))
    b=this.ronde2(b,c,d,a,T_X(13),20,this.sinusarray(32))

    && ronde 3
    a=this.ronde3(a,b,c,d,T_X( 6), 4,this.sinusarray(33))
    d=this.ronde3(d,a,b,c,T_X( 9),11,this.sinusarray(34))
    c=this.ronde3(c,d,a,b,T_X(12),16,this.sinusarray(35))
    b=this.ronde3(b,c,d,a,T_X(15),23,this.sinusarray(36))

    a=this.ronde3(a,b,c,d,T_X( 2), 4,this.sinusarray(37))
    d=this.ronde3(d,a,b,c,T_X( 5),11,this.sinusarray(38))
    c=this.ronde3(c,d,a,b,T_X( 8),16,this.sinusarray(39))
    b=this.ronde3(b,c,d,a,T_X(11),23,this.sinusarray(40))

    a=this.ronde3(a,b,c,d,T_X(14), 4,this.sinusarray(41))
    d=this.ronde3(d,a,b,c,T_X( 1),11,this.sinusarray(42))
    c=this.ronde3(c,d,a,b,T_X( 4),16,this.sinusarray(43))
    b=this.ronde3(b,c,d,a,T_X( 7),23,this.sinusarray(44))

    a=this.ronde3(a,b,c,d,T_X(10), 4,this.sinusarray(45))
    d=this.ronde3(d,a,b,c,T_X(13),11,this.sinusarray(46))
    c=this.ronde3(c,d,a,b,T_X(16),16,this.sinusarray(47))
    b=this.ronde3(b,c,d,a,T_X( 3),23,this.sinusarray(48))

    && ronde 4
    a=this.ronde4(a,b,c,d,T_X( 1), 6,this.sinusarray(49))
    d=this.ronde4(d,a,b,c,T_X( 8),10,this.sinusarray(50))
    c=this.ronde4(c,d,a,b,T_X(15),15,this.sinusarray(51))
    b=this.ronde4(b,c,d,a,T_X( 6),21,this.sinusarray(52))

    a=this.ronde4(a,b,c,d,T_X(13), 6,this.sinusarray(53))
    d=this.ronde4(d,a,b,c,T_X( 4),10,this.sinusarray(54))
    c=this.ronde4(c,d,a,b,T_X(11),15,this.sinusarray(55))
    b=this.ronde4(b,c,d,a,T_X( 2),21,this.sinusarray(56))

    a=this.ronde4(a,b,c,d,T_X( 9), 6,this.sinusarray(57))
    d=this.ronde4(d,a,b,c,T_X(16),10,this.sinusarray(58))
    c=this.ronde4(c,d,a,b,T_X( 7),15,this.sinusarray(59))
    b=this.ronde4(b,c,d,a,T_X(14),21,this.sinusarray(60))

    a=this.ronde4(a,b,c,d,T_X( 5), 6,this.sinusarray(61))
    d=this.ronde4(d,a,b,c,T_X(12),10,this.sinusarray(62))
    c=this.ronde4(c,d,a,b,T_X( 3),15,this.sinusarray(63))
    b=this.ronde4(b,c,d,a,T_X(10),21,this.sinusarray(64))

    a=a+olda
    b=b+oldb
    c=c+oldC
    d=d+oldd
  ENDFOR
  a=TRANSFORM(BITAND(a,0xFFFFFFFF),"@0") && cast
  b=TRANSFORM(BITAND(b,0xFFFFFFFF),"@0") && cast
  c=TRANSFORM(BITAND(c,0xFFFFFFFF),"@0") && cast
  d=TRANSFORM(BITAND(d,0xFFFFFFFF),"@0") && cast
  a=SUBSTR(a,9,2)+SUBSTR(a,7,2)+SUBSTR(a,5,2)+SUBSTR(a,3,2)
  b=SUBSTR(b,9,2)+SUBSTR(b,7,2)+SUBSTR(b,5,2)+SUBSTR(b,3,2)
  c=SUBSTR(c,9,2)+SUBSTR(c,7,2)+SUBSTR(c,5,2)+SUBSTR(c,3,2)
  d=SUBSTR(d,9,2)+SUBSTR(d,7,2)+SUBSTR(d,5,2)+SUBSTR(d,3,2)

RETURN a+b+c+d

PROCEDURE testsuite
&& return true if all the reference value are true
  LOCAL test
  test=.T.
  this.tohash=""
  IF LOWER(this.compute())#"d41d8cd98f00b204e9800998ecf8427e"
    RETURN this.tohash
  ENDIF
  this.tohash="a"
  IF LOWER(this.compute())#"0cc175b9c0f1b6a831c399e269772661"
    RETURN this.tohash
  ENDIF
  this.tohash="abc"
  IF LOWER(this.compute())#"900150983cd24fb0d6963f7d28e17f72"
    RETURN this.tohash
  ENDIF
  this.tohash="message digest"
  IF LOWER(this.compute())#"f96b697d7cb7938d525a2f31aaf161d0"
    RETURN this.tohash
  ENDIF
  this.tohash="abcdefghijklmnopqrstuvwxyz"
  IF LOWER(this.compute())#"c3fcd3d76192e4007dfb496cca67e13b"
    RETURN this.tohash
  ENDIF
  this.tohash="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
  IF LOWER(this.compute())#"d174ab98d277d9f5a5611c2c9f419d9f"
    RETURN this.tohash
  ENDIF
  this.tohash="12345678901234567890123456789012345678901234567890123456789012345678901234567890"
  IF LOWER(this.compute())#"57edf4a22be3c955ac49da2e2107b67a"
    RETURN this.tohash
  ENDIF
  RETURN test

ENDDEFINE
* -----------------------------------------------------------------------------------------------------------*
#ENDIF
* ---------------------------------------------------------------
* Francis FAURE 2008
* HTMLdecode -> HTML to TXT
* HTMLencode -> TXT to HTML
* VFP_HTMLconverter v1.0
* ----------------------------------------------------------------
#define CRLF CHR(13)+CHR(10)

DEFINE CLASS HTMLConverter as Custom
  llInBalise =.F.
  llInBody = .F.
  llInText = .T.
  lsBalise = ""
  ls_text = ""
  liNbHtmlChar =0
  DIMENSION HtmlCar[255,3] && array 1= char, 2=iso, 3=html
  HtmlCar = "" && store "" to HtmlCar 
  DEBUG = .F. && debug mode

  PROCEDURE init
    DODEFAULT()
    WITH this
      .HtmlCharStore(CHR(32), "nbsp")
      .HtmlCharStore(CHR(34), "quot")
      .HtmlCharStore(CHR(38), "amp") && voir le probleme en encodant
      .HtmlCharStore(CHR(39), "")
      .HtmlCharStore("€", "euro")&& 128
      .HtmlCharStore("<", "lt")
      .HtmlCharStore(">", "gt")
      .HtmlCharStore("œ", "oelig")
      .HtmlCharStore("À", "Agrave")
      .HtmlCharStore("Ç", "Ccedil")
      .HtmlCharStore("È", "Egrave")
      .HtmlCharStore("É", "Eacute")
      .HtmlCharStore("Ê", "Ecirc")
      .HtmlCharStore("à", "agrave")
      .HtmlCharStore("á", "aacute")
      .HtmlCharStore("â", "acirc")
      .HtmlCharStore("ç", "ccedil")
      .HtmlCharStore("è", "egrave")
      .HtmlCharStore("é", "eacute")
      .HtmlCharStore("ê", "ecirc")
      .HtmlCharStore("ë", "euml")
      .HtmlCharStore("î", "icirc")
      .HtmlCharStore("ô", "ocirc")
      .HtmlCharStore("ù", "ugrave")
      .HtmlCharStore("û", "ucirc")
      
      .HtmlCharStore("»", "raquo")
      * ... A compléter

    endwith
  RETURN

  HIDDEN PROCEDURE HtmlCharStore(lsChr, lsHTML)
    WITH this
      .liNbHtmlChar = .liNbHtmlChar + 1                                       && incrémenter le nombre de caractères spéciaux stockés dans le tableau
      .HtmlCar[.liNbHtmlChar,1] = m.lsChr                                     && caractère
      .HtmlCar[.liNbHtmlChar,2] = "&#" + ALLTRIM(STR(ASC(m.lsChr),3,0)) + ";" && code iso
      IF TYPE("m.lsHTML")="C"
        .HtmlCar[.liNbHtmlChar,3] = "&" + m.lsHTML + ";"                      && code html
      endif
    endwith
  return
  
  * String : Return Text String from HTML String 
  FUNCTION HTMLdecode(lsHTML)
    LOCAL liI
    LOCAL lsCur
    LOCAL lsLastCur
    lsCur = ""
    lsLastCur = CHR(32)
    lsHTML=STRTRAN(m.lsHTML, CHR(13),"")
    lsHTML=STRTRAN(m.lsHTML, CHR(10),"")
    WITH this
      FOR liI = 1 TO LEN(m.lsHTML)
        lsCur = SUBSTR(m.lsHTML, m.liI, 1)
        DO case
          CASE m.lsCur == CHR(32) AND m.lsLastCur == CHR(32) && ignore double space
          CASE m.lsCur == "<" AND NOT .llInBalise    && début de balise
            .llInBalise=.T.
          CASE m.lsCur == ">" AND .llInBalise        && fin de balise : si balise connues : traiter et remplacer
            .llInBalise=.F.
            .lsBalise = UPPER(ALLTRIM(.lsBalise))
            DO case
              CASE LEFT(.lsBalise,4)="BODY"
                .llInBody = .T.
              CASE LEFT(.lsBalise,5)="/BODY"
                .llInBody = .F.
              CASE LEFT(.lsBalise,6)="SCRIPT"
                .llInText = .F.
              CASE LEFT(.lsBalise,7)="/SCRIPT"
                .llInText = .T.
              CASE LEFT(.lsBalise,5)="STYLE"
                .llInText = .F.
              CASE LEFT(.lsBalise,6)="/STYLE"
                .llInText = .T.
              CASE LEFT(.lsBalise,6)="SELECT"
                .llInText = .F.
              CASE LEFT(.lsBalise,7)="/SELECT"
                .llInText = .T.
              CASE LEFT(.lsBalise,3)="/TD" OR ;
                   LEFT(.lsBalise,3)="/TH"
                .Add_Text(CHR(9)) && TAB
              CASE LEFT(.lsBalise,2)="BR" OR ;
                   LEFT(.lsBalise,2)="/P" OR ;
                   LEFT(.lsBalise,3)="/H1" OR ;
                   LEFT(.lsBalise,3)="/H2" OR ;
                   LEFT(.lsBalise,3)="/H3" OR ;
                   LEFT(.lsBalise,3)="/TR" OR ;
                   LEFT(.lsBalise,5)="/DIV" OR ;
                   LEFT(.lsBalise,6)="/TABLE" OR ;
                   LEFT(.lsBalise,5)="/FORM"
                .Add_Text(CRLF)
              CASE LEFT(.lsBalise,2)="HR"
                .Add_Text(CRLF + REPLICATE("-", 80) + CRLF)
              CASE LEFT(.lsBalise,2)="LI"
                .Add_Text(CRLF + "*")
              CASE LEFT(.lsBalise,5)="TITLE" OR LEFT(.lsBalise,6)="/TITLE" OR ;
                   LEFT(.lsBalise,5)="TABLE" OR ;
                   LEFT(.lsBalise,4)="FORM" OR ;
                   LEFT(.lsBalise,4)="NOBR" OR LEFT(.lsBalise,5)="/NOBR" OR ;
                   LEFT(.lsBalise,2)="OL" OR LEFT(.lsBalise,3)="/OL" OR;
                   LEFT(.lsBalise,2)="H1" OR ;
                   LEFT(.lsBalise,2)="H2" OR ;
                   LEFT(.lsBalise,2)="H3" OR ;
                   LEFT(.lsBalise,2)="TR" OR ;
                   LEFT(.lsBalise,2)="TD" OR ;
                   LEFT(.lsBalise,2)="TH" OR ;
                   LEFT(.lsBalise,5)="TBODY" OR LEFT(.lsBalise,6)="/TBODY" OR ;
                   LEFT(.lsBalise,2)="UL" OR LEFT(.lsBalise,3)="/UL" OR ;
                   LEFT(.lsBalise,3)="/LI" OR ;
                   LEFT(.lsBalise,5)="INPUT" OR LEFT(.lsBalise,6)="/INPUT" OR ;
                   LEFT(.lsBalise,5)="LABEL" OR LEFT(.lsBalise,6)="/LABEL" OR ;
                   LEFT(.lsBalise,8)= "TEXTAREA" OR LEFT(.lsBalise,9)= "/TEXTAREA" OR ; 
                   LEFT(.lsBalise,4)="FONT" OR LEFT(.lsBalise,5)="/FONT" OR ;
                   LEFT(.lsBalise,5)="SMALL" OR LEFT(.lsBalise,6)="/SMALL" OR ;
                   LEFT(.lsBalise,4)="SPAN" OR LEFT(.lsBalise,5)="/SPAN" OR ;
                   LEFT(.lsBalise,2)="A " OR LEFT(.lsBalise,2)="/A" OR ;
                   LEFT(.lsBalise,3)="IMG" OR ;
                   .lsBalise=="P" OR LEFT(.lsBalise,2)="P " OR ;
                   .lsBalise=="I" OR .lsBalise=="/I" OR LEFT(.lsBalise,2)="I " OR ;
                   .lsBalise=="B" OR .lsBalise=="/B" OR LEFT(.lsBalise,2)="B " OR ;
                   .lsBalise=="U" OR .lsBalise=="/U" OR LEFT(.lsBalise,2)="U " OR ;
                   .lsBalise=="STRONG" OR .lsBalise=="/STRONG" or;
                   .lsBalise=="EM" OR .lsBalise=="/EM" or;
                   .lsBalise=="CITE" OR .lsBalise=="/CITE" or;
                   LEFT(.lsBalise,3)="DIV" or;
                   LEFT(.lsBalise,7)="CENTER" OR LEFT(.lsBalise,7)="/CENTER" OR ;
                   LEFT(.lsBalise,8)="NOSCRIPT" or LEFT(.lsBalise,9)="/NOSCRIPT"
                * rien
              OTHERWISE 
                IF .DEBUG
                  .Add_Text("<"+.lsBalise+">"+ CRLF)
                ENDIF
            endcase
            .lsBalise = ""
          OTHERWISE
            IF .llInBalise
              .lsBalise = .lsBalise + m.lsCur
            ELSE
              .Add_Text(m.lsCur)
            endif
        ENDCASE
        lsLastCur = m.lsCur
      NEXT
      FOR liI=1 TO .liNbHtmlChar
        .ls_text = STRTRAN(.ls_text, .HtmlCar[m.liI,3], .HtmlCar[m.liI,1], -1, -1, 0) && html
        .ls_text = STRTRAN(.ls_text, .HtmlCar[m.liI,2], .HtmlCar[m.liI,1], -1, -1, 0) && iso
      NEXT
      IF .debug
        SET SAFETY off
        STRTOFILE(.ls_text, "c:\temp\html2txt_debug.txt")
        SET SAFETY on
      endif
    endwith
    RETURN this.ls_Text
  endfunc  

  HIDDEN PROCEDURE Add_Text(lsText)
    IF this.llInBody AND this.llInText
      this.ls_text = this.ls_text + m.lsText
    endif          
  endproc

enddefine
* ---------------------------------------------------------------
