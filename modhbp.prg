#include "directry.ch"

MEMVAR nQtd

PROCEDURE Main

   PRIVATE nQtd := 0

   SetMode( 30, 100 )
   CLS
   TestAll( hb_cwd() + "hmg\" )
   TestAll( hb_cwd() + "hmge\" )
   TestAll( hb_cwd() + "hwgui\" )
   TestAll( hb_cwd() + "oohg\" )
   Inkey(0)

   RETURN

FUNCTION TestAll( cPath )

   LOCAL aList, aFile, cFile

   aList := Directory( cPath + "*.*", "D" )
   FOR EACH aFile IN aList
      cFile := Lower( aFile[ F_NAME ] )
      DO CASE
      CASE Right( cFile, 4 ) == ".hbp"
         TestProject( cPath, cFile )
      CASE "D" $ aFile[ F_ATTR ]
         IF ! aFile[ F_NAME ] == "." .AND. ! aFile[ F_NAME ] == ".."
            TestAll( cPath + cFile + "\" )
         ENDIF
      ENDCASE
      IF nQtd > 100
         Inkey(0)
      ENDIF
      Inkey()
   NEXT

   RETURN Nil

FUNCTION TestProject( cPath, cFile )

   LOCAL cTxt, aList, cItem, nPos, aSeek

   Static nErro := 0

   nErro += 1
   cTxt := MemoRead( cPath + cFile )
   aList := hb_RegExSplit( hb_Eol(), cTxt )
   FOR EACH cItem IN aList DESCEND
      IF cFile != "hmg.hbc" .AND. cFile != "hmge.hbc" .AND. cFile != "hwgui.hbc" .AND. cFile != "hwgui.hbc"
         IF hb_AScan( { "-m", "-n", "-w0", "-w2", "-es2", ;
            "-w3 -es2", "-w2 -es2", "-m -n -w2 -es2" ;
             }, cItem, { | e | e == cItem } ) != 0
            //hb_aDel( aList, cItem:__EnumIndex, .T. )
         ENDIF
      ENDIF
   NEXT
   nPos := 0
   aSeek := { "hmg.hbc", "hmge.hbc", "hwgui.hbc", "oohg.hbc" }
   FOR EACH cItem IN aList
      IF ASCan( aSeek, { | e | e $ citem } ) != 0
         nPos := cItem:__EnumIndex
      ENDIF
   NEXT
   IF nPos != 0 .AND. nPos != 1
      //cLib := aList[ nPos ]
      //hb_ADel( aList, nPos, .T. )
      //AAdd( aList, "" )
      //hb_AIns( aList, 1 )
      //aList[ 1 ] := cLib
   ENDIF
   cTxt := ""
   FOR EACH cItem IN aList
      cItem := AllTrim( cItem )
      IF "-o" $ cItem .AND. ".hbp" $ cItem
         cItem := Left( cItem, Len( cItem ) - 4 )
         ? "corrigindo " + cPath + cFile
      ENDIF
      cTxt += cItem + hb_Eol()
   NEXT
   hb_MemoWrit( cPath + cFile, cTxt )
   //RUN ( "q " + cPath + cFile )
   nQtd += 1
   IF nQtd > 20
      //Inkey(0)
      nQtd := 0
   ENDIF
   IF ! "-o" $ cTxt .AND. ! "-hbcontainer" $ cTxt
      ? Str( nErro, 3 ) + " " + cPath + cFile
      cTxt := "-o" + Left( cFile, At( ".", cFile + "." ) -1 ) + hb_Eol() + hb_Eol() + cTxt
      hb_MemoWrit( cPath + cFile, cTxt )
   ENDIF

   RETURN Nil

