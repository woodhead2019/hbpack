@echo off

:Main

   call :update harbour_32    harbour_32     https://github.com/harbour/core
   call :update harbour_34    harbour_34     https://github.com/vszakats/hb
   call :update hbdeleted     hbdeleted
   call :update hmg           hmg
   call :update hmge          hmge
   call :update oohg_core     oohg           https://github.com/oohg/core
   call :update oohg_distros  oohg_distros   https://github.com/oohg/distros
   call :update oohg_doc      oohg_doc       https://github.com/oohg/doc
   call :update oohg_fmt      oohg_fmt       https://github.com/oohg/fmt
   call :update oohg_ide      oohg_ide       https://github.com/oohg/ide
   call :update oohg_samples  oohg_samples   https://github.com/oohg/samples
   call :update hwgui         hwgui
   call :update hbsefazclass  hbsefazclass

:hwgui_sourceforge

   echo create/Update hwgui from sourceforge
   cd \github\hwgui
   git svn init https://svn.code.sf.net/p/hwgui/code/trunk/hwgui
   git svn fetch
   git push

   goto :exit

:update

   echo create %2
   git clone https://github.com/JoseQuintas/%1 \github\%2 --depth 100
   echo updating %2 from %3
   cd \github\%2
   if not "%3" == "" git pull %3
   git push

:exit

