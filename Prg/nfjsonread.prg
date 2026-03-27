**********************************************************************
* Program....: NFJSONREAD.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk 
* Date.......: 13 February 2020, 10:01:49
* Notice.....: Copyright © 2020, Silver Cross America Inc. S.A. 
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: mpistiner, Created 13 February 2020 / 10:01:49
* Purpose....: 
********************************************************************** 
*
Lparameters cjsonstr, revivecollection

Private All
stacklevels = Astackinfo(aerrs)

If m.stacklevels > 1
   calledfrom = ' ( called From ' +  ;
      aerrs(m.stacklevels -  ;
      1, 4) +  ;
      ' line ' +  ;
      TRANSFORM(aerrs(m.stacklevels -  ;
      1, 5)) + ')'
Else
   calledfrom = ''
Endif

Try
   cerror = ''
   If  .Not.  ;
         LEFT(Ltrim(cjsonstr), 1) $  ;
         '{[' .And.  ;
         FILE(m.cjsonstr)
      cjsonstr = Filetostr(m.cjsonstr)
   Endif
   ost = Set('strictdate')
   Set StrictDate To 0
   ojson = nfjsonread2(m.cjsonstr,  ;
      m.revivecollection)
   Set StrictDate To (m.ost)

Catch To oerr1
   cerror = 'nfJson ' +  ;
      m.calledfrom +  ;
      CHR(13) + Chr(10) +  ;
      m.oerr1.Message
Endtry

If  .Not. Empty(m.cerror)
   Error m.cerror
   Return .Null.
Endif

Return Iif(Vartype(m.ojson) = 'O',  ;
   m.ojson, .Null.)
Endfunc

**
Function nfjsonread2
   Lparameters cjsonstr,  ;
      revivecollection
   Try
      x = 1
      cerror = ''
      cjson = Rtrim(Chrtran(m.cjsonstr,  ;
         CHR(13) + Chr(9) +  ;
         CHR(10), ''))
      pchar = Left(Ltrim(m.cjson),  ;
         1)
      nl = Alines(aj, m.cjson, 20,  ;
         '{', '}', '"', ',', ':',  ;
         '[', ']', '\\')
      For xx = 1 To Alen(aj)
         If Left(Ltrim(aj(m.xx)),  ;
               1) $ '{}",:[]' .Or.  ;
               LOWER(Left(Ltrim(m.aj(m.xx)),  ;
               4)) $  ;
               'true/false/null'
            aj(m.xx) =  ;
               LTRIM(aj(m.xx))
         Endif
      Endfor
      ostack = Createobject('stack')
      ojson = Createobject('empty')
      Do Case
         Case aj(1) = '{'
            x = 1
            ostack.pushobject()
            procstring(m.ojson)
         Case aj(1) = '['
            x = 0
            procstring(m.ojson,  ;
               .T.)
         Otherwise
            Error ' expecting [{  got ' +  ;
               m.pchar
      Endcase
      If m.revivecollection
         ojson = revivecollection(m.ojson)
      Endif
   Catch To oerr
      strp = ''
      For Y = 1 To m.x
         strp = m.strp + aj(m.y)
      Endfor
      Do Case
         Case oerr.ErrorNo =  ;
               1098
            cerror = ' Invalid Json: ' +  ;
               m.oerr.Message +  ;
               CHR(13) +  ;
               CHR(10) +  ;
               ' Parsing: ' +  ;
               RIGHT(m.strp,  ;
               80)
         Otherwise
            cerror = ' program error # ' +  ;
               TRANSFORM(m.oerr.ErrorNo) +  ;
               CHR(13) +  ;
               CHR(10) +  ;
               m.oerr.Message +  ;
               ' at line: ' +  ;
               TRANSFORM(oerr.Lineno) +  ;
               CHR(13) +  ;
               CHR(10) +  ;
               ' Parsing: ' +  ;
               RIGHT(m.strp,  ;
               80)
      Endcase
   ENDTRY
   
   If  .Not. Empty(m.cerror)
      Error m.cerror
   Endif
   Return m.ojson

Endfunc

**
Procedure procstring
   Lparameters obj, evalue
   Private rowpos, colpos, bidim,  ;
      ncols, arrayname,  ;
      expecting, arraylevel,  ;
      vari
   Private expectingpropertyname,  ;
      expectingvalue,  ;
      objectopen
   expectingpropertyname =  .Not.  ;
      m.evalue
   expectingvalue = m.evalue
   expecting = Iif(expectingpropertyname,  ;
      '"}', '')
   objectopen = .T.
   bidim = .F.
   colpos = 0
   rowpos = 0
   arraylevel = 0
   arrayname = ''
   vari = ''
   ncols = 0
   Do While m.objectopen
      x = m.x + 1
      Do Case
         Case m.x > m.nl
            m.x = m.nl
            If ostack.Count >  ;
                  0
               Error 'expecting ' +  ;
                  m.expecting
            Endif
            Return
         Case aj(m.x) = '}'  ;
               .And. '}' $  ;
               m.expecting
            closeobject()
         Case aj(x) = ']' .And.  ;
               ']' $ m.expecting
            closearray()
         Case m.expecting = ':'
            If aj(m.x) = ':'
               expecting = ''
               Loop
            Else
               Error 'expecting : got ' +  ;
                  aj(m.x)
            Endif
         Case ',' $ m.expecting
            Do Case
               Case aj(x) =  ;
                     ','
                  expecting =  ;
                     IIF('[' $  ;
                     m.expecting,  ;
                     '[',  ;
                     '')
               Case  .Not.  ;
                     aj(m.x) $  ;
                     m.expecting
                  Error 'expecting ' +  ;
                     m.expecting +  ;
                     ' got ' +  ;
                     aj(m.x)
               Otherwise
                  expecting =  ;
                     STRTRAN(m.expecting,  ;
                     ',',  ;
                     '')
            Endcase
         Case m.expectingpropertyname
            If aj(m.x) = '"'
               propertyname(m.obj)
            Else
               Error 'expecting "' +  ;
                  m.expecting +  ;
                  ' got ' +  ;
                  aj(m.x)
            Endif
         Case m.expectingvalue
            If m.expecting ==  ;
                  '[' .And.  ;
                  m.aj(m.x) <>  ;
                  '['
               Error 'expecting [ got ' +  ;
                  aj(m.x)
            Else
               procvalue(m.obj)
            Endif
      Endcase
   Enddo
Endproc

**
Procedure anuevoel
   Lparameters obj, arrayname,  ;
      valasig, bidim,  ;
      colpos, rowpos
   If m.bidim
      colpos = m.colpos + 1
      If colpos > m.ncols
         ncols = m.colpos
      Endif
      Dimension obj.&arrayname(m.rowpos,m.ncols)
      obj.&arrayname(m.rowpos,m.colpos);
         = m.valasig
      If Vartype(m.valasig) = 'O'
         procstring(obj.&arrayname(m.rowpos,m.colpos))
      Endif
   Else
      rowpos = m.rowpos + 1
      Dimension obj.&arrayname(m.rowpos)
      obj.&arrayname(m.rowpos) = m.valasig
      If Vartype(m.valasig) = 'O'
         procstring(obj.&arrayname(m.rowpos))
      Endif
   Endif
Endproc
**

Procedure unescunicode
   Lparameters cstr
   Private All
   ust = ''
   For x = 1 To Alines(xstr, m.cstr,  ;
         18, '\u', '\\u')
      If Right(xstr(m.x), 3) <>  ;
            '\\u' .And.  ;
            RIGHT(xstr(m.x), 2) =  ;
            '\u'
         ust = m.ust +  ;
            RTRIM(xstr(m.x),  ;
            0, '\u')
         dec = Val("0x" +  ;
            LEFT(xstr(m.x +  ;
            1), 4))
         Ansi = Left(Strconv(BinToC(m.dec,  ;
            "R"), 6), 1)
         If m.ansi <> '?'
            ust = m.ust +  ;
               m.Ansi
         Else
            ust = m.ust + '&#' + Transform(m.dec);
               + ';'
         Endif
         xstr(m.x + 1) =  ;
            SUBSTR(xstr(m.x +  ;
            1), 5)
      Else
         ust = m.ust + xstr(m.x)
      Endif
   Endfor
   cstr = m.ust
Endproc
**
Procedure unescapecontrolc
   Lparameters Value
   If At('\', m.value) = 0
      Return
   Endif
   Private aa, elem, unesc
   Dimension aa(1)
   = Alines(m.aa, m.value, 18, '\\',  ;
      '\b', '\f', '\n', '\r', '\t',  ;
      '\"', '\/')
   unesc = ''
   For Each elem In m.aa
      If  .Not. m.elem == '\\'  ;
            .And. Left(Right(m.elem,  ;
            2), 1) = '\'
         elem = Left(m.elem,  ;
            LEN(m.elem) - 2) +  ;
            CHRTRAN(Right(m.elem,  ;
            1), 'bnrt/"',  ;
            CHR(127) +  ;
            CHR(10) +  ;
            CHR(13) + Chr(9) +  ;
            CHR(47) +  ;
            CHR(34))
      Endif
      unesc = m.unesc + m.elem
   Endfor
   Value = m.unesc
Endproc
**
Procedure propertyname
   Lparameters obj
   x = m.x + 1
   vari = aj(m.x)
   Do While Right(aj(m.x), 1)<>'"'  ;
         .And. m.x<Alen(m.aj)
      x = m.x + 1
      vari = m.vari + aj(m.x)
   Enddo
   If Right(m.aj(m.x), 1) <> '"'
      Error ' expecting "  got  ' +  ;
         m.aj(m.x)
   Endif
   vari = Rtrim(m.vari, 1, '"')
   vari = Iif(Isalpha(m.vari), '',  ;
      '_') + m.vari
   vari = Chrtran(vari, Chrtran(vari,  ;
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890_',  ;
      ''),  ;
      '_______________________________________________________________')
   If vari == 'tabindex'
      vari = '_tabindex'
   Endif
   expecting = ':'
   expectingvalue = .T.
   expectingpropertyname = .F.
Endproc
**
Procedure procvalue
   Lparameters obj
   Do Case
      Case aj(m.x) = '{'
         ostack.pushobject()
         If m.arraylevel = 0
            AddProperty(obj,  ;
               m.vari,  ;
               CREATEOBJECT('empty'))
            procstring(m.obj.&vari)
            expectingpropertyname =  ;
               .T.
            expecting = ',}'
            expectingvalue = .F.
         Else
            anuevoel(m.obj,  ;
               m.arrayname,  ;
               CREATEOBJECT('empty'),  ;
               m.bidim,  ;
               @m.colpos,  ;
               @m.rowpos)
            expectingpropertyname =  ;
               .F.
            expecting = ',]'
            expectingvalue = .T.
         Endif
      Case aj(x) = '['
         ostack.pusharray()
         Do Case
            Case m.arraylevel =  ;
                  0
               arrayname = Evl(m.vari,  ;
                  'array')
               rowpos = 0
               colpos = 0
               bidim = .F.
               Try
                  AddProperty(obj,  ;
                     (m.arrayname +  ;
                     '(1)'),  ;
                     .Null.)
               Catch
                  m.arrayname =  ;
                     m.arrayname +  ;
                     '_vfpSafe_'
                  AddProperty(obj,  ;
                     (m.arrayname +  ;
                     '(1)'),  ;
                     .Null.)
               Endtry
            Case m.arraylevel =  ;
                  1 .And.   ;
                  .Not.  ;
                  m.bidim
               rowpos = 1
               colpos = 0
               ncols = 1
               Dime obj.&arrayname(1,2)
               bidim = .T.
         Endcase
         arraylevel = m.arraylevel +  ;
            1
         vari = ''
         expecting = Iif( .Not.  ;
            m.bidim,  ;
            '[]{',  ;
            ']')
         expectingvalue = .T.
         expectingpropertyname =  ;
            .F.
      Otherwise
         isstring = aj(m.x) =  ;
            '"'
         x = m.x +  ;
            IIF(m.isstring, 1,  ;
            0)
         Value = ''
         Do While m.x<= ;
               ALEN(m.aj)
            Value = m.value +  ;
               aj(m.x)
            If ((m.isstring  ;
                  .And.  ;
                  RIGHT(aj(m.x),  ;
                  1) = '"') .Or.  ;
                  ( .Not.  ;
                  m.isstring  ;
                  .And.  ;
                  RIGHT(aj(m.x),  ;
                  1) $ '}],'))  ;
                  .And.  ;
                  LEFT(Right(aj(m.x),  ;
                  2), 1) <> '\'
               Exit
            Endif
            x = m.x + 1
         Enddo
         closechar = Right(aj(m.x),  ;
            1)
         Value = Left(m.value,  ;
            LEN(m.value) -  ;
            1)
         Do Case
            Case Empty(m.value)  ;
                  .And.  .Not.  ;
                  (m.isstring  ;
                  .And.  ;
                  m.closechar =  ;
                  '"')
               Error 'Expecting value got ' +  ;
                  m.closechar
            Case m.isstring
               If m.closechar <>  ;
                     '"'
                  Error 'expecting " got ' +  ;
                     m.closechar
               Endif
            Case ostack.isobject()  ;
                  .And.  .Not.  ;
                  m.closechar $  ;
                  ',}'
               Error 'expecting ,} got ' +  ;
                  m.closechar
            Case ostack.isarray()  ;
                  .And.  .Not.  ;
                  m.closechar $  ;
                  ',]'
               Error 'expecting ,] got ' +  ;
                  m.closechar
         Endcase
         If m.isstring
            unescunicode(@m.value)
            unescapecontrolc(@m.value)
            Value = Strtran(m.value,  ;
               '\\',  ;
               '\')
            If isjsondt(m.value)
               Value = jsondatetodt(m.value)
            Endif
         Else
            Value = Alltrim(m.value)
            Do Case
               Case Lower(m.value) ==  ;
                     'null'
                  Value = .Null.
               Case Lower(m.value) ==  ;
                     'true'  ;
                     .Or.  ;
                     LOWER(m.value) ==  ;
                     'false'
                  Value = m.value =  ;
                     'true'
               Case Empty(Chrtran(m.value,  ;
                     '-1234567890.Ee',  ;
                     ''))
                  Try
                     Local  ;
                        tvaln,  ;
                        im
                     im =  ;
                        'tvaln = ' +  ;
                        m.Value
                     &im
                     Value =  ;
                        m.tvaln
                     badnumber =  ;
                        .F.
                  Catch
                     badnumber =  ;
                        .T.
                  Endtry
                  If badnumber
                     Error  ;
                        'bad number format:  got ' +  ;
                        aj(m.x)
                  Endif
               Otherwise
                  Error 'expecting "|number|null|true|false|  got ' +  ;
                     aj(m.x)
            Endcase
         Endif
         If m.arraylevel = 0
            AddProperty(obj,  ;
               m.vari,  ;
               m.Value)
            expecting = '}'
            expectingvalue = .F.
            expectingpropertyname =  ;
               .T.
         Else
            anuevoel(obj,  ;
               m.arrayname,  ;
               m.Value,  ;
               m.bidim,  ;
               @m.colpos,  ;
               @m.rowpos)
            expecting = ']'
            expectingvalue = .T.
            expectingpropertyname =  ;
               .F.
         Endif
         expecting = Iif(m.isstring,  ;
            ',', '') +  ;
            m.expecting
         Do Case
            Case m.closechar =  ;
                  ']'
               closearray()
            Case m.closechar =  ;
                  '}'
               closeobject()
         Endcase
   Endcase
Endproc
**
Procedure closearray
   If ostack.Pop() <> 'A'
      Error 'unexpected ] '
   Endif
   If m.arraylevel = 0
      Error 'unexpected ] '
   Endif
   arraylevel = m.arraylevel - 1
   If m.arraylevel = 0
      arrayname = ''
      rowpos = 0
      colpos = 0
      expecting = Iif(ostack.isobject(),  ;
         ',}', '')
      expectingpropertyname = .T.
      expectingvalue = .F.
   Else
      If m.bidim
         rowpos = m.rowpos + 1
         colpos = 0
         expecting = ',]['
      Else
         expecting = ',]'
      Endif
      expectingvalue = .T.
      expectingpropertyname = .F.
   Endif
Endproc
**
Procedure closeobject
   If ostack.Pop() <> 'O'
      Error 'unexpected }'
   Endif
   If m.arraylevel = 0
      expecting = ',}'
      expectingvalue = .F.
      expectingpropertyname = .T.
      objectopen = .F.
   Else
      expecting = ',]'
      expectingvalue = .T.
      expectingpropertyname = .F.
   Endif
Endproc
**
Function revivecollection
   Lparameters o
   Private All
   oconv = Createobject('empty')
   nprop = Amembers(elem, m.o, 0,  ;
      'U')
   For x = 1 To m.nprop
      estavar = m.elem(x)
      esarray = .F.
      escoleccion = Type('m.o.' +  ;
         m.estavar) =  ;
         'O' .And.  ;
         RIGHT(m.estavar,  ;
         14) $  ;
         '_KV_COLLECTION,_KL_COLLECTION'  ;
         .And.  ;
         TYPE('m.o.' +  ;
         m.estavar +  ;
         '.collectionitems',  ;
         1) = 'A'
      Do Case
         Case m.escoleccion
            estaprop = Createobject('collection')
            tv = m.o.&estavar
            m.keyvalcoll = Right(m.estavar,  ;
               14) =  ;
               '_KV_COLLECTION'
            If  .Not.  ;
                  (Alen(m.tv.collectionitems) =  ;
                  1 .And.  ;
                  ISNULL(m.tv.collectionitems))
               For T = 1 To  ;
                     ALEN(m.tv.collectionitems)
                  If m.keyvalcoll
                     esteval =  ;
                        m.tv.collectionitems(m.t).Value
                  Else
                     esteval =  ;
                        m.tv.collectionitems(m.t)
                  Endif
                  If Vartype(m.esteval) =  ;
                        'O'  ;
                        .Or.  ;
                        TYPE('esteVal',  ;
                        1) =  ;
                        'A'
                     esteval =  ;
                        revivecollection(m.esteval)
                  Endif
                  If m.keyvalcoll
                     estaprop.Add(esteval,  ;
                        m.tv.collectionitems(m.t).Key)
                  Else
                     estaprop.Add(m.esteval)
                  Endif
               Endfor
            Endif
         Case Type('m.o.' +  ;
               m.estavar, 1) =  ;
               'A'
            esarray = .T.
            For T = 1 To Alen(m.o.&estavar)
               Dimension &estavar(m.t)
               If Type('m.o.&estaVar(m.T)');
                     = 'O'
                  &estavar(m.t);
                     = revivecollection(m.o.&estavar(m.t))
               Else
                  &estavar(m.t);
                     = m.o.&estavar(m.t)
               Endif
            Endfor
         Case Type('m.o.' +  ;
               estavar) = 'O'
            estaprop = revivecollection(m.o.&estavar)
         Otherwise
            estaprop = m.o.&estavar
      Endcase
      estavar = Strtran(m.estavar,  ;
         '_KV_COLLECTION',  ;
         '')
      estavar = Strtran(m.estavar,  ;
         '_KL_COLLECTION',  ;
         '')
      Do Case
         Case m.escoleccion
            AddProperty(m.oconv,  ;
               m.estavar,  ;
               m.estaprop)
         Case m.esarray
            AddProperty(m.oconv,  ;
               m.estavar +  ;
               '(1)')
            Acopy(&estavar,m.oconv.&estavar)
         Otherwise
            AddProperty(m.oconv,  ;
               m.estavar,  ;
               m.estaprop)
      Endcase
   Endfor
   Try
      retcollection = m.oconv.Collection.BaseClass =  ;
         'Collection'
   Catch
      retcollection = .F.
   Endtry
   If m.retcollection
      Return m.oconv.Collection
   Else
      Return m.oconv
   Endif
Endfunc
**
Function isjsondt
   Lparameters cstr
   cstr = Rtrim(m.cstr, 1, 'Z')
   Return Iif(Len(m.cstr) = 19 .And.  ;
      LEN(Chrtran(m.cstr,  ;
      '01234567890:T-', '')) = 0  ;
      .And. Substr(m.cstr, 5, 1) =  ;
      '-' .And. Substr(m.cstr, 8,  ;
      1) = '-' .And.  ;
      SUBSTR(m.cstr, 11, 1) =  ;
      'T' .And. Substr(m.cstr,  ;
      14, 1) = ':' .And.  ;
      SUBSTR(m.cstr, 17, 1) =  ;
      ':' .And. Occurs('T',  ;
      m.cstr) = 1 .And. Occurs( ;
      '-', m.cstr) = 2 .And.  ;
      OCCURS(':', m.cstr) = 2,  ;
      .T., .F.)
Endfunc
**
Function jsondatetodt
   Lparameters cjsondate
   cjsondate = Rtrim(m.cjsondate, 1,  ;
      'Z')
   If m.cjsondate =  ;
         '0000-00-00T00:00:00'
      Return {}
   Else
      cret = Evaluate('{^' +  ;
         RTRIM(m.cjsondate, 1,  ;
         "T00:00:00") + '}')
      If  .Not. Empty(m.cret)
         Return m.cret
      Else
         Error 'Invalid date ' +  ;
            cjsondate
      Endif
   Endif
Endfunc
**
Define Class Stack As Collection
   **
   Procedure pushobject
      This.Add('O')
   Endproc
   **
   Procedure pusharray
      This.Add('A')
   Endproc
   **
   Function isobject
      Return This.Count > 0 .And.  ;
         this.Item(This.Count) =  ;
         'O'
   Endfunc
   **
   Function isarray
      Return This.Count > 0 .And.  ;
         this.Item(This.Count) =  ;
         'A'
   Endfunc
   **
   Function Pop
      cret = This.Item(This.Count)
      This.Remove(This.Count)
      Return m.cret
   Endfunc
   **
Enddefine


