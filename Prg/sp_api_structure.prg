DEFINE CLASS Struct AS Session
*  Author: William GC Steinford
* Purpose: This class simplifies creating structures to pass to Api routines,
*           and retrieving values out of structures changed by Api routines.
*   Usage: Just subclass this class, and override the Init event, calling
*           AddField( 'fieldname', 'type', starting_value )
*           once for each field in the structure.
*   Notes: PCHAR fields are automatically allocated, destroyed, and de-referenced
*            whenever needed.
*          Sub-Structures can be handled by defining them as an "@STRING",
*            creating a second class/object for the substructure,
*            then assigning the sub-structure's ".Structure" property
*            to the parent structure's @STRING field
*
  DIMENSION arrFields[1,5]
  DIMENSION Fld[1]
  && Name, Type, Pos, Len, Data
  FieldCount  = 0
  Structure   = ''
  DataSession = 1 && Default DataSession
  BypassStructureProtection = .F.

  FUNCTION AddField( pcField, pcType, pvValue )
    LOCAL lcEnc
    THIS.FieldCount = THIS.FieldCount + 1
    DIMENSION THIS.arrFields[THIS.FieldCount,5]
    THIS.arrFields[THIS.FieldCount,1] = upper(pcField)
    THIS.arrFields[THIS.FieldCount,2] = pcType
    THIS.arrFields[THIS.FieldCount,3] = LEN(THIS.Structure)+1
    THIS.arrFields[THIS.FieldCount,4] = THIS.TypeLen(pcType,pvValue)
    THIS.arrFields[THIS.FieldCount,5] = iif( pcType='STRUCT', pvValue, .NulL. )
    lcEnc = THIS.ValToType(pvValue,pcType,THIS.arrFields[THIS.FieldCount,4])
    if Vartype(lcEnc)='C'
      THIS.AddToStructure( lcEnc )
    else
      RETURN .F.
    endif
  ENDFUNC
  
  FUNCTION TypeLen( pcType, pvVal )
    DO CASE
      CASE Inlist(upper(pcType),'BYTE')
        RETURN 1

      *v11.01..'INTEGER' was in this list, but is not clear...
      *v11.01..'SHORT' was in this list, but had been taken out. Now it's appropriately back.
      CASE Inlist(upper(pcType),'WORD','HANDLE','SHORT','PASCAL_INTEGER')
        RETURN 2
      CASE Inlist(upper(pcType),'LONG','DWORD')
        RETURN 4
      CASE Inlist(upper(pcType),'@STRING')
        RETURN 4
      CASE Inlist(upper(pcType),'STRING')
        RETURN len(pvVal)
      CASE Inlist(upper(pcType),'PASCAL_STRING')
        RETURN len(pvVal)+1
      CASE Inlist(upper(pcType),'PASCAL_BOolEAN')
        RETURN 1
      CASE Inlist(upper(pcType),'LOGICAL','BOolEAN','BOol')
        RETURN 1
      CASE Inlist(upper(pcType),'DOUBLE','FLOAT64') && Apr 20, 2006
        RETURN 6
      CASE Inlist(upper(pcType),'PASCAL_REAL','FLOAT48')
        RETURN 6
      CASE Inlist(upper(pcType),'FLOAT','FLOAT32','SINGLE')
        RETURN 4
      CASE Inlist(upper(pcType),'STRUCT')
        RETURN len(pvVal.Structure)
      CASE Inlist(upper(pcType),'STRUCT')
        ASSERT Type('pvVal')='O' and type('pvVal.Structure')='C' MESSAGE "Incorrect Type"
        RETURN len(pvVal.Structure)
    ENDCASE
  ENDFUNC

  FUNCTION ValToType( pvVal, pcType, pnLen )
    * Convert a value of the given type to the Struct Encoding
    LOCAL lnRet
    DO CASE
      CASE Inlist(upper(pcType),'BYTE')
        ASSERT Type('pvVal')='N' MESSAGE "Incorrect Type"
        RETURN Chr(MOD(pvVal,256))

      *v11.01..'INTEGER' was in this list, but is not clear...
      *v11.01..'SHORT' was in this list, but had been taken out. Now it's appropriately back.
      CASE Inlist(upper(pcType),'WORD','HANDLE','SHORT','PASCAL_INTEGER')
        ASSERT Type('pvVal')='N' MESSAGE "Incorrect Type"
        RETURN Chr(MOD(pvVal,256)) + CHR(INT(pvVal/256))
      CASE Inlist(upper(pcType),'LONG','DWORD')
        ASSERT Type('pvVal')='N' MESSAGE "Incorrect Type"
        #DEFINE m0_8        256
        #DEFINE m1_16     65536
        #DEFINE m2_24  16777216
        LOCAL b0, b1, b2, b3
        b3 = Int(pvVal/m2_24)
        b2 = Int((pvVal - b3*m2_24)/m1_16)
        b1 = Int((pvVal - b3*m2_24 - b2*m1_16)/m0_8)
        b0 = Mod(pvVal, m0_8)
        RETURN Chr(b0)+Chr(b1)+Chr(b2)+Chr(b3)
      CASE upper(pcType)='STRING'
        ASSERT Type('pvVal')='C' MESSAGE "Incorrect Type"
        RETURN PadR(pvVal,pnLen,chr(0))
      CASE upper(pcType)='PASCAL_STRING'
        * First character is length byte.  Pad to var size with zeros.
        ASSERT Type('pvVal')='C' MESSAGE "Incorrect Type"
        RETURN PadR( chr(len(pvVal))+pvVal, pnLen,chr(0))
      CASE upper(pcType)='@STRING'
        ASSERT inlist(Type('pvVal'),'C','N') MESSAGE "Incorrect Type"
        * Nov 20, 2003: Allow user to pass in a Numeric pointer
        if Type('pvVal')='N' && Passed in a pointer reference.. probably NulL=0
          RETURN THIS.ValToType(pvVal,'LONG')
        endif
*!*            * If the string is just CHR(0), then it's a NulL pointer
*!*            if len(pvVal)=1 and asc(pvVal)=0 && NulL pointer
*!*              RETURN THIS.ValToType(0,'LONG')
*!*            endif

        * If it's an empty string, then it's a NulL pointer
        if len(pvVal)=0 && NulL pointer
          RETURN THIS.ValToType(0,'LONG')
        endif
        Declare LONG GlobalAlloc IN "kernel32" LONG wFlags, LONG dwBytes
        lnRet = GlobalAlloc(0,len(pvVal))
        Declare LONG RtlMoveMemory IN "kernel32" ;
          LONG ptrIntoHere, STRING @ cFromHere, LONG cb
        RtlMoveMemory(lnRet,@pvVal,len(pvVal))
        RETURN THIS.ValToType(lnRet,'LONG')
      CASE Inlist(upper(pcType),'LOGICAL','BOolEAN','BOol')
        ASSERT Type('pvVal')='L' MESSAGE "Incorrect Type"
        RETURN iif( pvVal, Chr(0), chr(1) ) && fixed pcType->pvVal 10/14/2003
      CASE Inlist(upper(pcType),'PASCAL_BOolEAN')
        ASSERT Type('pvVal')='L' MESSAGE "Incorrect Type"
        RETURN iif( pvVal, Chr(1), chr(0) ) && fixed pcType->pvVal 10/14/2003
      CASE Inlist(upper(pcType),'PASCAL_REAL','FLOAT48')
        ASSERT Type('pvVal')='N' MESSAGE "Incorrect Type"
        RETURN space(6) && TODO: How to convert a number into a binary 'real'
      CASE INLIST(UPPER(pcType),'DOUBLE','FLOAT64') && Apr 20, 2006 wgcs
        *FUNCTION NumToFloat64
        *LPARAMETERS NUMB AS NUMBER
        LOCAL Float64 AS STRING, ;
              SIGN AS INTEGER, ;
              Bias AS INTEGER, ;
              Exponent AS INTEGER, ;
              I AS INTEGER, ;
              Y AS INTEGER, ;
              x AS STRING, ;
              Mantissa AS NUMBER, ;
              oldFixed AS STRING, ;
              m.byte,m.bit, ;
              fraction AS NUMBER

        numb = pvVal
        oldFixed=SET("Fixed")
        SET FIXED OFF       
           Mantissa=0
           SIGN=0
          Bias=1023
        Exponent=0

        Float64=REPLICATE(CHR(0),8)

        *set sing
        Float64=STUFF(Float64,1,1,IIF(NUMB<0,CHR(128),CHR(0)))
        NUMB=ABS(NUMB)
        I=-1023
        DO WHILE I<=1023
          IF NUMB<2^I
            EXIT
          ENDIF
          I=I+1
        ENDDO
        Exponent=1023+I-1
        FOR I=0 TO 11
          IF BITTEST(Exponent,I)
            m.byte=INT(((12-I)-1)/8)+1
            m.bit=7-MOD(((12-I)-1),8)
            Float64=STUFF(Float64,m.byte,1,CHR(BITSET(ASC(SUBSTR(Float64,m.byte,1)),m.bit)))
          ENDIF
        NEXT
        Mantissa=NUMB/(2^(Exponent-1023))-1
        FOR I=1 TO 52
          IF Mantissa>=1/(2^I)
            m.byte=INT(((I+12)-1)/8)+1
            m.bit=7-MOD(((I+12)-1),8)
            Float64=STUFF(Float64,m.byte,1,CHR(BITSET(ASC(SUBSTR(Float64,m.byte,1)),m.bit)))
            Mantissa=Mantissa-1/(2^I)
          ENDIF
          IF Mantissa=0
            EXIT
          endif
        NEXT

        SET FIXED &oldFixed
        RETURN Float64
      CASE Inlist(upper(pcType),'FLOAT','FLOAT32','SINGLE')
        ASSERT Type('pvVal')='N' MESSAGE "Incorrect Type"
        * Thanks to Anatoliy Mogylevets at http://fox.wikis.com/wc.dll?Wiki~VFPFloatingPointDataType~VFP
        #DEFINE REAL_BIAS 127
        #DEFINE REAL_MANTISSA_SIZE 23
        #DEFINE REAL_NEGATIVE 0x80000000
        #DEFINE EXPONENT_MASK 0x7F800000
        #DEFINE MANTISSA_MASK 0x007FFFFF

        LOCAL num, sgn, exponent, mantissa, lcHex, lcBin
        num = pvVal

        DO CASE
          CASE num < 0
            sgn = REAL_NEGATIVE
            num = -num
          CASE num > 0
            sgn = 0
          OTHERWISE
            RETURN 0
        ENDCASE

        exponent = FLOOR(LOG(num)/LOG(2))
        mantissa = (num - 2^exponent)* 2^(REAL_MANTISSA_SIZE-exponent)
        exponent = BITLSHIFT(exponent+REAL_BIAS, REAL_MANTISSA_SIZE)

        num = BITOR(sgn, exponent, mantissa)
        lcHex = TRANSFORM(num,'@0')

        * 1234567890
        * 0x47F12000 = 123456
        lcBin =  THIS.ValToType(SUBSTR(lcHex,3,2),'HEX') ;
                +THIS.ValToType(SUBSTR(lcHex,5,2),'HEX') ;
                +THIS.ValToType(SUBSTR(lcHex,7,2),'HEX') ;
                +THIS.ValToType(SUBSTR(lcHex,9,2),'HEX')
        RETURN lcBin
      CASE INLIST(UPPER(pcType),'HEX')
        ASSERT Type('pvVal')='C' MESSAGE "Incorrect Type"
        LOCAL lnI, lcChr, lnVal
        lnVal = 0
        for lnI = 1 to len( pvVal )
          lcChr = substr( pvVal, len(pvVal)-lnI+1, 1 )
          do case
            case InList( lcChr, '0','1','2','3','4','5','6','7','8','9' )
              lnVal = lnVal + val(lcChr) * 2^((lnI-1)*4)
            case InList( lcChr, 'A','B','C','D','E','F' )
              lnVal = lnVal + (asc(lcChr)-asc('A')+10) * 2^((lnI-1)*4)
          endcase
        endfor
        RETURN CHR( lnVal%256 )
      CASE Inlist(upper(pcType),'STRUCT')
        ASSERT Type('pvVal')='O' MESSAGE "Incorrect Type"
        RETURN pvVal.Structure
    ENDCASE
  ENDFUNC
  FUNCTION TypeToVal( pcVal, pcType, pnFld )
    * Convert a struct encoded Type back to it's original value
    * pnFld is the index of this field in the structure:
    *   this is useful for getting any attached data
    *   (primarily the Struct Object for a sub-structure)
    LOCAL lnPtr, lcRet
    DO CASE
      CASE Inlist(upper(pcType),'BYTE')
        RETURN Asc(SUBSTR(pcVal, 1,1))

      *v11.01..'INTEGER' was in this list, but is not clear... there are different size integers.
      *v11.01..'SHORT' was in this list, but had been taken out. Now it's appropriately back.
      CASE Inlist(upper(pcType),'SHORT','WORD','HANDLE','PASCAL_INTEGER')
        RETURN Asc(SUBSTR(pcVal, 1,1)) + ;
               Asc(SUBSTR(pcVal, 2,1)) * 256
      CASE Inlist(upper(pcType),'LONG','DWORD') && Apr 20, 2006..removed inappropriate "DOUBLE"
        RETURN Asc(SUBSTR(pcVal, 1,1)) + ;
               Asc(SUBSTR(pcVal, 2,1)) * 256 +;
               Asc(SUBSTR(pcVal, 3,1)) * 65536 +;
               Asc(SUBSTR(pcVal, 4,1)) * 16777216
      CASE upper(pcType)='STRING'
        RETURN pcVal
      CASE upper(pcType)='PASCAL_STRING'
        * First character is length byte.  Trim string to actual size.
        RETURN SUBSTR(pcVal,2,asc(pcVal))
      CASE upper(pcType)='@STRING'
        lnPtr = THIS.TypeToVal( pcVal, 'LONG' )
        Declare LONG GlobalSize IN "Kernel32" LONG HGLOBAL_hMem
        lnLen = GlobalSize(lnPtr)
        ASSERT lnLen>0 MESSAGE "Could not determine length of string."
        lcRet = SPACE(lnLen)
        Declare LONG RtlMoveMemory IN "kernel32" ;
          STRING @ cIntoHere, LONG ptrFromHere, LONG cb
        RtlMoveMemory(@lcRet,lnPtr,lnLen)
        RETURN lcRet
      CASE Inlist(upper(pcType),'LOGICAL','BOolEAN','BOol')
        RETURN ASC( SUBSTR(pcVal,1) ) = 0
      CASE Inlist(upper(pcType),'PASCAL_BOolEAN')
        RETURN ASC( SUBSTR(pcVal,1) ) <> 0
      CASE Inlist(upper(pcType),'DOUBLE','FLOAT64') && Apr 20, 2006..added section
        * From: http://www.tek-tips.com/faqs.cfm?fid=1932
        *FUNCTION  Float64ToNum
        *LPARAMETERS Float64 AS STRING

        *!*        S XXXXXXX XXXX MMMM MMMMMMMM MMMMMMMM MMMMMMMM MMMMMMMM MMMMMMMM MMMMMMMM
        *!*        0 0000000 0000 0000 00000000 00000000 00000000 00000000 00000000 00000000
        *!*        1 2345678 9012 3456 78901234
        *!*            1         2         3
        LOCAL SIGN AS INTEGER, ;
              Bias AS INTEGER, ;
              Exponent AS INTEGER, ;
              I AS INTEGER, ;
              x AS STRING, ;
              Mantissa AS NUMBER, ;
              OldDecimals AS INTEGER, ;
              oldFixed AS STRING

        Float64 = pcVal
        IF LEN(Float64)<8
          RETURN 0
        ENDIF

        *OldDecimals=SET("Decimals")
        *SET DECIMALS TO 20
        oldFixed=SET("Fixed")
        SET FIXED OFF
        Mantissa=1
        SIGN=0
        Bias=1023
        Exponent=0
        Float64  =LEFT(Float64,8)
        SIGN=IIF(BITTEST(ASC(LEFT(Float64,1)),7),-1,1)
        FOR I=12 TO 2 STEP -1
          Exponent = Exponent + IIF(BITTEST(ASC(SUBSTR(Float64,INT((I-1)/8)+1,1)),;
                                          7-MOD((I-1),8)),1,0)*(2^(12-I))
        NEXT
        Exponent = Exponent-1023
        FOR I=13 TO 64
          AA=INT((I-1)/8)+1
          BB=7-MOD((I-1),8)
          B=IIF(BITTEST(ASC(SUBSTR(Float64,INT((I-1)/8)+1,1)),7-MOD((I-1),8)),1,0)
          Mantissa = Mantissa + IIF(BITTEST(ASC(SUBSTR(Float64,INT((I-1)/8)+1,1)),;
                                          7-MOD((I-1),8)),1,0)*(1/(2^(I-12)))
        NEXT
        SET FIXED &oldFixed
        RETURN SIGN*(Mantissa)*(2^Exponent)

      CASE Inlist(upper(pcType),'PASCAL_REAL','FLOAT48')

        * info from: http://docs.sun.com/db/doc/801-5055/6hvhckkeh?a=view
        *            http://info.borland.com/techpubs/delphi/delphi5/oplg/memory.html
        *            http://www.tek-tips.com/faqs.cfm?spid=184&sfid=1932
        *            http://www.tek-tips.com/faqs.cfm?fid=1932
        *              faq184-1932
        * A 6-byte (48-bit) Real48 number is divided into three fields:
        *   1 bit: Sign
        *  39 bits: f (mantissa)
        *   8 bits: e (exponent)
        *  If 0 < e <= 255, the value v of the number is given by
        *     v = (-1)^s * 2^(e-129) * (1.f )
        *  If e = 0, then v = 0.

        * Pascal Real:
        ***  S MMMMMMM MMMMMMMM MMMMMMMM MMMMMMMM MMMMMMMM EEEEEEEE
        *    1 2345678 90123456 78901234 56789012 34567890 12345678
        *               1          2          3          4

        * 64 bit float:
        *!*        S XXXXXXX XXXX MMMM MMMMMMMM MMMMMMMM MMMMMMMM MMMMMMMM MMMMMMMM MMMMMMMM
        *!*        0 0000000 0000 0000 00000000 00000000 00000000 00000000 00000000 00000000
        *!*        1 2345678 9012 3456 78901234
        *!*                   1           2         3

        LOCAL Float48, SIGN, Bias, Exponent, I, x, Mantissa, oldFixed
        Float48 = pcVal

        IF LEN(Float48) < 6
          RETURN 0
        ENDIF
        oldFixed=SET("Fixed")
        SET FIXED OFF
        Mantissa = 1
        SIGN     = 0
        Bias     = 129 && 64bit bias: 1023
        Exponent = 0
        Float48  = LEFT(Float48,6)

        SIGN=IIF( BITTEST(ASC(Float48),7), -1, 1)

        FOR I=48 TO 41 STEP -1
        *FOR I=12 TO 2 STEP -1
          AA = INT((I-1)/8)+1  && Find the appropriate Byte to look in
          BB = 7-MOD((I-1),8)  && Find the appropriate bit in that byte
          B = BITTEST(ASC(SUBSTR(Float48,AA,1)),BB)      && Find out if that bit is set

          Exponent = Exponent + IIF( B, 2^(48-I), 0)

        *  Exponent = Exponent + IIF(BITTEST(ASC(SUBSTR(Float64,INT((I-1)/8)+1,1)),;
        *                                  7-MOD((I-1),8)),1,0)*(2^(12-I))
        NEXT
        Exponent = Exponent-bias

        FOR I=2 TO 40
        *FOR I=13 TO 64
          AA = INT((I-1)/8)+1  && Find the appropriate Byte to look in
          BB = 7-MOD((I-1),8)  && Find the appropriate bit in that byte
          B = BITTEST(ASC(SUBSTR(Float48,AA,1)),BB)      && Find out if that bit is set
          Mantissa = Mantissa + IIF( B, 1/(2^(I-1)), 0 ) && If set, add to the total Mantissa

        *  Mantissa = Mantissa + IIF(BITTEST(ASC(SUBSTR(Float64,INT((I-1)/8)+1,1)),;
        *                                  7-MOD((I-1),8)),1,0)*(1/(2^(I-12)))
        NEXT
        SET FIXED &oldFixed
        RETURN SIGN*(Mantissa)*(2^Exponent)
      CASE Inlist(upper(pcType),'FLOAT','FLOAT32','SINGLE')
        * Thanks to AnatoliyMogylevets at http://fox.wikis.com/wc.dll?Wiki~VFPFloatingPointDataType~VFP
        LOCAL num, lcHex, sgn, exponent, mantissa
        lcHex = RIGHT(TRANSFORM(ASC(SUBSTR(pcVal,1,1)),'@0'),2) ;
              + RIGHT(TRANSFORM(ASC(SUBSTR(pcVal,2,1)),'@0'),2) ;
              + RIGHT(TRANSFORM(ASC(SUBSTR(pcVal,3,1)),'@0'),2) ;
              + RIGHT(TRANSFORM(ASC(SUBSTR(pcVal,4,1)),'@0'),2)
        num = EVALUATE('0x'+lcHex)
        sgn = IIF(BITTEST(num,31), -1,1)
        exponent = BITRSHIFT(BITAND(num, EXPONENT_MASK), REAL_MANTISSA_SIZE) - REAL_BIAS
        mantissa = BITAND(num, MANTISSA_MASK) / 2^(REAL_MANTISSA_SIZE-m.exponent)
        RETURN (2^m.exponent + m.mantissa) * m.sgn
      CASE Inlist(upper(pcType),'STRUCT')
        * return the associated structure object
        ASSERT VARTYPE(THIS.arrFields[pnFld,5])='O' MESSAGE "STRUCT Object Data Item Not Found"
        THIS.arrFields[pnFld,5].Structure = pcVal
        RETURN THIS.arrFields[pnFld,5]
    ENDCASE
  ENDFUNC

  FUNCTION Fld_Access( pncIdx )
    LOCAL lnIdx, lcVal, lvRes, lnOEx, lcIdx, lcSubFld
    lcSubFld = ''
    DO case
      CASE type('pncIdx')='N'
        lnIdx = pncIdx
      CASE type('pncIdx')='C'
        ASSERT type('pncIdx')='C' MESSAGE "Must provide numeric or character Index!"
        lnOEx = SET('EXACT')
        lcIdx = pncIdx
        SET EXACT ON
        if '.' $ lcIdx && this is a sub-structure field reference
          lcSubFld = SUBSTR(lcIdx,AT('.',lcIdx)+1)
          lcIdx    = LEFT(lcIdx,AT('.',lcIdx)-1)
        endif
        lnIdx = ASCAN(THIS.arrFields,upper(lcIdx))
        SET EXACT &lnOEx
        ASSERT lnIdx>0 MESSAGE "Field not found"
        if lnIdx=0
          RETURN .NulL.
        endif
        lnIdx = ASUBSCRIPT(THIS.arrFields,lnIdx,1)
      OTHERWISE && Bad index value.
        RETURN .NulL.
    ENDCASE
    lcVal = SUBSTR(THIS.Structure,THIS.arrFields[lnIdx,3],THIS.arrFields[lnIdx,4])
    lvRes = THIS.TypeToVal(lcVal,THIS.arrFields[lnIdx,2],lnIdx)
    if not empty(lcSubFld)
      ASSERT VARTYPE(lvRes)='O' MESSAGE "SubField requires STRUCT Object"
      * Retrieving value from sub-field... Refresh sub-structures whole structure value:
      && Oct 23, 2003: Make sure the sub-structure is current
      THIS.arrFields[lnIdx,5].Structure = SUBSTR(THIS.Structure,THIS.arrFields[lnIdx,3],THIS.arrFields[lnIdx,4])
      lvRes = lvRes.fld[(lcSubFld)] && Oct 20, 2003: Pass by reference to avoid strange VFP6 behavior of skipping the _ACCESS method
    endif
    RETURN lvRes
  ENDFUNC
  *
  FUNCTION Fld_Assign( pvNewVal, pncIdx )
    LOCAL lcBuf, lnIdx, lnVal, lvNewVal, lnPtr, lnOEx, lcIdx, lcSubFld
    lcSubFld = ''
    if type('pncIdx')='N'
      lnIdx = pncIdx
    else
      ASSERT type('pncIdx')='C' MESSAGE "Must provide numeric or character Index!"
      lnOEx = SET('EXACT')
      lcIdx = pncIdx
      SET EXACT ON
      if '.' $ lcIdx && this is a sub-structure field reference
        lcSubFld = SUBSTR(lcIdx,AT('.',lcIdx)+1)
        lcIdx    = LEFT(lcIdx,AT('.',lcIdx)-1)
      endif
      lnIdx = ASCAN(THIS.arrFields,upper(lcIdx))
      SET EXACT &lnOEx
      ASSERT lnIdx>0 MESSAGE "Field not found"
      if lnIdx=0
        RETURN .NulL.
      endif
      lnIdx = ASUBSCRIPT(THIS.arrFields,lnIdx,1)
    endif
    IF THIS.arrFields[lnIdx,2]='@STRING'
      * Free the stored string (ValToType will re-allocate memory)
        Declare LONG GlobalFree IN "kernel32" LONG hmem
        THIS.arrFields[lnIdx,2] = 'LONG'  && Not going to be a pointer much longer.
        lnPtr = THIS.fld[lnIdx]           && get it as a LONG pointer
        THIS.arrFields[lnIdx,2] = '@STRING'
        if lnPtr>0
          GlobalFree(lnPtr)
        endif
    ENDIF

    * If we were handed a structure object (primarily to assign a structure into an @STRING)
    *    take the String version of the structure.
    if type('pvNewVal.Structure')='C' && substructure... take string version
      lvNewVal = pvNewVal.Structure
    else
      lvNewVal = pvNewVal
    endif

    DO CASE && This CASE is to properly get the new encoded-value into lcBuf
      CASE THIS.arrFields[lnIdx,2]='STRUCT'
        if not empty(lcSubFld)
          * Assigning value into sub-field... Refresh sub-structures whole structure value:
          && Oct 21, 2003: Make sure the sub-structure is current
          THIS.arrFields[lnIdx,5].Structure = SUBSTR(THIS.Structure,THIS.arrFields[lnIdx,3],THIS.arrFields[lnIdx,4])
          * Assign new sub-field's value
          THIS.arrFields[lnIdx,5].Fld[(lcSubFld)] = lvNewVal  && Oct 21, 2003: Pass by reference to avoid strange VFP6 behavior of skipping the _ACCESS method
          * Retrieve the sub-structure's string to be stuffed back into this structure's string.
          * Make sure that the sub-structure's encoded string is the right length:
          lcBuf = PADR(THIS.arrFields[lnIdx,5].Structure,THIS.arrFields[lnIdx,4],chr(0))
        else
          * Assigning entire encoded-structure-string to replace this sub-structure

          * Make sure that the sub-structure's encoded string is the right length:
          lcBuf = PADR(lvNewVal,THIS.arrFields[lnIdx,4],chr(0))
          * Set the new encoded-structure-string into the sub-structure object
          THIS.arrFields[lnIdx,5].Structure = lcBuf
        endif
      OTHERWISE
        lcBuf = THIS.ValToType(lvNewVal,THIS.arrFields[lnIdx,2],THIS.arrFields[lnIdx,4])
    ENDCASE
    * Stuff the encoded string into THIS.structure
    * Arr Col 3:start idx in .structure, 4:length of data item
    THIS.Structure = STUFF( THIS.Structure, THIS.arrFields[lnIdx,3], THIS.arrFields[lnIdx,4], lcBuf )
  ENDFUNC
  *
  FUNCTION StructureToPtr
    LOCAL lnOut
    lnOut = THIS.TypeToVal( THIS.ValToType( THIS.Structure, '@STRING' ), 'LONG' )  && return a numeric
    RETURN lnOut
  ENDFUNC
  FUNCTION PtrToStructure( pnPtr )
    LOCAL lcStr
    * Convert the number to a string/Long
    * Then Retrieve the memory that String/Long points to.
    lcStr = THIS.TypeToVal( THIS.ValToType( pnPtr, 'LONG' ), '@STRING' )
    THIS.Structure = lcStr
  ENDFUNC
  FUNCTION FreePtr(hMem)
    Declare LONG GlobalFree IN "kernel32" LONG hmem
    GlobalFree(hmem)
  ENDFUNC
  FUNCTION Structure_Assign( pvNewVal )
    * Ensure that the type of Structure stays Character, and that it stays the same length!
    if Vartype(pvNewVal)='C'
      if THIS.BypassStructureProtection
        THIS.Structure = pvNewVal
      else
        THIS.Structure = PADR(pvNewVal,len(THIS.Structure),chr(0))
      endif
    endif
  ENDFUNC
  FUNCTION AddToStructure( pcNewFld )
    * Ensure that the type of Structure stays Character, and that it stays the same length!
    THIS.BypassStructureProtection = .T.
    THIS.Structure = THIS.Structure + pcNewFld
    THIS.BypassStructureProtection = .F.
  ENDFUNC

  FUNCTION Destroy
    LOCAL lnI, lnPtr
    Declare LONG GlobalFree IN "kernel32" LONG hmem
    for lnI = 1 to THIS.FieldCount
      do case
        case THIS.arrFields[lnI,2]='@STRING'
          THIS.arrFields[lnI,2] = 'LONG' && Not going to be a pointer much longer.
          lnPtr = THIS.fld[lnI]          && get it as a LONG pointer
          GlobalFree(lnPtr)              && Now, it really is no longer a pointer
        case THIS.arrFields[lnI,2]='STRUCT'
          loObj = THIS.arrFields[lnI,5]   && save contained object.
          THIS.arrFields[lnI,5] = .NulL.  && remove reference in array
          RELEASE loObj                   && Explicitly release it
          loObj = .NulL.
      endcase
    endfor
  ENDFUNC
  *
  FUNCTION DebugShowStruct
    * This should build a multi-line string displaying the structure and it's contents.
    LOCAL lnI, lnJ, lcOut, lnFldLen, lnTypLen, lnValLen, lvVal, lcSub, lcRaw
    lnFldLen = 15
    lnTypLen = 10
    lnValLen = 20
    lcOut = 'Structure Class '+THIS.Class + _CRLF
    for lnJ = 1 to LEN(THIS.Structure)
      lcOut = lcOut + str( asc(substr(THIS.Structure,lnJ)), 4 )
    endfor
    lcOut = lcOut + _CRLF

    for lnI = 1 to THIS.FieldCount
      lnFldLen = MAX(lnFldLen,len(THIS.arrFields[lnI,1]))
      lnTypLen = MAX(lnTypLen,len(THIS.arrFields[lnI,2]))
      lcSub = SUBSTR(THIS.Structure,THIS.arrFields[lnI,3],THIS.arrFields[lnI,4])
      lcRaw = ''
      for lnJ = 1 to LEN(lcSub)
        lcRaw = lcRaw + str( asc(substr(lcSub,lnJ)), 4 )
      endfor

      lvVal = THIS.fld(lnI)
      do case
        case type('lvVal')='O' and type('lvVal.structure')='C'
          lvVal = '(struct '+lvVal.Class+')'
        case type('lvVal')='O'
          lvVal = '(object '+lvVal.Class+')'
        otherwise
          lvVal = tran(lvVal)
      endcase
      lnValLen = MAX(lnValLen,len(lvVal))
      lcOut = lcOut+'  '+padR(THIS.arrFields[lnI,1],lnFldLen);
                   +'  '+padR(THIS.arrFields[lnI,2],lnTypLen);
                   +'  '+PadR(lvVal,lnValLen)+ ':'+ lcRaw + _CRLF
      if lvVal='(struct '
        lvVal = THIS.fld(lnI)
        lvVal = lvVal.DebugShowStruct()
        lvVal = '  '+trim(strtran(lvVal,_CRLF,_CRLF+'  '))
        lcOut = lcOut + lvVal
      endif
    endfor
    RETURN lcOut
  ENDFUNC
ENDDEFINE