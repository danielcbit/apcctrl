; winapcctrl.nsi
;
; Adapted by Kern Sibbald for apcctrl from Bacula code
; Further modified by Adam Kropelin
;
; Further modified Wagner Popov dos Santos
;
; Basics
;
Name "ApcCtrl-brazil"
OutFile "winapcctrl-${VERSION}.exe"
SetCompressor lzma
InstallDir "c:\apcctrl"

ShowInstDetails Show
!verbose push
!verbose 10

;			    
; Include files
;
!include "MUI.nsh"
!include "LogicLib.nsh"
!include "StrReplace.nsh"
!include "WinVer.nsh"
!include "FileFunc.nsh"
!include "x64.nsh"

; Global variables
Var ExistingConfig
Var MainInstalled
Var TrayInstalled
Var OrigInstDir

; Paths
!define WINDIR ${TOPDIR}/src/win32

; Icon indexes in shell32.dll
!define START_ICON_INDEX  137
!define STOP_ICON_INDEX   131
!define CONFIG_ICON_INDEX 21
!define HELP_ICON_INDEX   23
!define MANUAL_ICON_INDEX 23

;
; Pull in pages
;
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE ${TOPDIR}/COPYING
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
Page custom EditApcctrlConfEnter EditApcctrlConfExit ""
Page custom InstallServiceEnter InstallServiceExit ""
Page custom ApctrayEnter ApctrayExit ""
!define MUI_FINISHPAGE_SHOWREADME
!define MUI_FINISHPAGE_SHOWREADME_TEXT "View the ReleaseNotes"
!define MUI_FINISHPAGE_SHOWREADME_FUNCTION "ShowReadme"
!define MUI_FINISHPAGE_LINK "Visit ApcCtrl Website"
!define MUI_FINISHPAGE_LINK_LOCATION "http://apcctrl-brazil.sourceforge.net/"
!define MUI_PAGE_CUSTOMFUNCTION_SHOW DisableBackButton
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH
 
!define      MUI_ABORTWARNING

!insertmacro MUI_LANGUAGE "English"

DirText "Setup will install ApcCtrl BRAZIL ${VERSION} to the directory \
         specified below."

; Disable back button
!define FINISH_BUTTON_ID 3
Function DisableBackButton
	GetDlgItem $R1 $HWNDPARENT ${FINISH_BUTTON_ID}
	EnableWindow $R1 0
FunctionEnd

; Post-process apcctrl.conf.in by replacing @FOO@ tokens
; with proper values.
Function PostProcConfig
  FileOpen $0 "$INSTDIR\etc\apcctrl\apcctrl.conf.in" "r"
  FileOpen $1 "$INSTDIR\etc\apcctrl\apcctrl.conf.new" "w"

  ClearErrors
  FileRead $0 $2

  ${DoUntil} ${Errors}
    ${StrReplace} $2 "@VERSION@"    "${VERSION}"           $2
    ${StrReplace} $2 "@sysconfdir@" "$INSTDIR\etc\apcctrl" $2
    ${StrReplace} $2 "@PWRFAILDIR@" "$INSTDIR\etc\apcctrl" $2
    ${StrReplace} $2 "@LOGDIR@"     "$INSTDIR\etc\apcctrl" $2
    ${StrReplace} $2 "@nologdir@"   "$INSTDIR\etc\apcctrl" $2
    FileWrite $1 $2
    FileRead $0 $2
  ${Loop}

  FileClose $0
  FileClose $1

  Delete "$INSTDIR\etc\apcctrl\apcctrl.conf.in"
FunctionEnd

Function ShowReadme
  ExecShell "open" "$INSTDIR\ReleaseNotes.txt"
FunctionEnd

Function EditApcctrlConfEnter
  ; Skip this page if config file was preexisting
  ${If} $ExistingConfig == 1
    Abort
  ${EndIf}

  ; Also skip if apcctrl main package was not installed
  ${If} $MainInstalled != 1
    Abort
  ${EndIf}

  ; Configure header text and instantiate the page
  !insertmacro MUI_HEADER_TEXT "Edit Configuration File" "Configure apcctrl for your UPS."
  !insertmacro MUI_INSTALLOPTIONS_INITDIALOG "EditApcctrlConf.ini"
  Pop $R0 ;HWND of dialog

  ; Set contents of text field
  !insertmacro MUI_INSTALLOPTIONS_READ $R0 "EditApcctrlConf.ini" "Field 1" "HWND"
  SendMessage $R0 ${WM_SETTEXT} 0 \
      "All types of connections require editing the client configuration file, \
       apcctrl.conf.$\r$\r\
       Please edit $INSTDIR\etc\apcctrl\apcctrl.conf to fit your installation. \
       When you click the Next button, Wordpad will open to allow you to do this.$\r$\r\
       Be sure to save your changes before closing Wordpad and before continuing \
       with the installation."

  ; Display the page
  !insertmacro MUI_INSTALLOPTIONS_SHOW
FunctionEnd

Function EditApcctrlConfExit
  ; Launch wordpad to edit apcctrl.conf if checkbox is checked
  !insertmacro MUI_INSTALLOPTIONS_READ $R1 "EditApcctrlConf.ini" "Field 2" "State"
  ${If} $R1 == 1
    ExecWait 'notepad "$INSTDIR\etc\apcctrl\apcctrl.conf"'
  ${EndIf}
FunctionEnd

Function InstallServiceEnter
  ; Skip if apcctrl main package was not installed
  ${If} $MainInstalled != 1
    Abort
  ${EndIf}

  ; Configure header text and instantiate the page
  !insertmacro MUI_HEADER_TEXT "Install/Start Service" "Install apcctrl Service and start it."
  !insertmacro MUI_INSTALLOPTIONS_DISPLAY "InstallService.ini"
FunctionEnd

Function InstallServiceExit
  ; Create Start Menu Directory
  CreateDirectory "$SMPROGRAMS\ApcCtrl"
  ; Create start menu link for configuring apcctrl
  CreateShortCut "$SMPROGRAMS\ApcCtrl\Edit Configuration File.lnk" "notepad" "$INSTDIR\etc\apcctrl\apcctrl.conf" "$SYSDIR\shell32.dll" ${CONFIG_ICON_INDEX}

  ; If installed as a service already, remove it
  ReadRegDWORD $R0 HKLM "Software\apcctrl" "InstalledService"
  ${If} $R0 == 1
    ExecWait '"$INSTDIR\bin\apcctrl.exe" /quiet /remove'
    Sleep 1000
  ${EndIf}

  ; Install as service and create start menu shortcuts
  !insertmacro MUI_INSTALLOPTIONS_READ $R1 "InstallService.ini" "Field 2" "State"
  ${If} $R1 == 1
    ; Install service
    ExecWait '"$INSTDIR\bin\apcctrl.exe" /install'
    ${If} ${IsNT}
      ; Installed as a service and we're on NT
      CreateShortCut "$SMPROGRAMS\ApcCtrl\Start apcctrl (run as adm).lnk" "$SYSDIR\net.exe" "start apcctrl" "$SYSDIR\shell32.dll" ${START_ICON_INDEX}
      CreateShortCut "$SMPROGRAMS\ApcCtrl\Stop apcctrl (run as adm).lnk"  "$SYSDIR\net.exe" "stop apcctrl"  "$SYSDIR\shell32.dll" ${STOP_ICON_INDEX}
    ${Else}
      ; Installed as a service, but not on NT
      CreateShortCut "$SMPROGRAMS\ApcCtrl\Start apcctrl (run as adm).lnk" "$INSTDIR\bin\apcctrl.exe" "/service" "$SYSDIR\shell32.dll" ${START_ICON_INDEX}
      CreateShortCut "$SMPROGRAMS\ApcCtrl\Stop apcctrl (run as adm).lnk"  "$INSTDIR\bin\apcctrl.exe" "/kill"    "$SYSDIR\shell32.dll" ${STOP_ICON_INDEX}
    ${EndIf}
  ${Else}
    ; Not installed as a service
    CreateShortCut "$SMPROGRAMS\ApcCtrl\Start apcctrl (run as adm).lnk" "$INSTDIR\bin\apcctrl.exe" ""       "$SYSDIR\shell32.dll" ${START_ICON_INDEX}
    CreateShortCut "$SMPROGRAMS\ApcCtrl\Stop apcctrl (run as adm).lnk"  "$INSTDIR\bin\apcctrl.exe" "/kill"  "$SYSDIR\shell32.dll" ${STOP_ICON_INDEX}
  ${EndIf}

  ; Start apcctrl now, if so requested
  !insertmacro MUI_INSTALLOPTIONS_READ $R2 "InstallService.ini" "Field 4" "State"
  ${If} $R2 == 1
    ExecShell "" "$SMPROGRAMS\ApcCtrl\Start apcctrl.lnk" "" SW_HIDE
  ${Endif}  
FunctionEnd

Function ApctrayEnter
  ; Skip if apctray package was not installed
  ${If} $TrayInstalled != 1
    Abort
  ${EndIf}

  ; If Apctray is already configured to start automatically, start it now
  ; and skip this page
  ReadRegStr $R0 HKLM "Software\Microsoft\Windows\CurrentVersion\Run" "Apctray"
  ${If} $R0 != ""
    Exec $R0
    Abort
  ${EndIf}

  ; Configure header text and instantiate the page
  !insertmacro MUI_HEADER_TEXT "Configure Tray Icon" "Configure Apctray icon for your preferences."
  !insertmacro MUI_INSTALLOPTIONS_DISPLAY "Apctray.ini"
FunctionEnd

Function ApctrayExit
  ; We get called when checkbox changes or next button is pressed
  ; Figure out which this is.

  !insertmacro MUI_INSTALLOPTIONS_READ $R1 "Apctray.ini" "Settings" "State"
  ${If} $R1 == 2
    ; Return to the page
    Abort
  ${EndIf}

  ; Regular exit due to Next button press...

  ; (Un)Install apctray
  !insertmacro MUI_INSTALLOPTIONS_READ $R1 "Apctray.ini" "Field 2" "State"
  ${If} $R1 == 1
    ; Install and start
    ExecWait '"$INSTDIR\bin\apctray.exe" $R0 /install'
    Exec '"$INSTDIR\bin\apctray.exe" $R0'
  ${EndIf}
FunctionEnd

Section "-Startup"
  SetShellVarContext all

  ; Check for existing config file
  ${If} ${FileExists} "$INSTDIR\etc\apcctrl\apcctrl.conf"
    StrCpy $ExistingConfig 1
  ${Else}
    StrCpy $ExistingConfig 0
  ${EndIf}

  ; Save the new install path in the registry
  WriteRegStr HKLM "Software\apcctrl\" "InstDir" "$INSTDIR"

  ; Create base installation directory
  CreateDirectory "$INSTDIR"

  ; Install common files
  SetOutPath "$INSTDIR"
  File COPYING.txt
  File ChangeLog.txt
  File ReleaseNotes.txt

  ; Clean up old non-txt versions of these files
  Delete /REBOOTOK "$INSTDIR\COPYING"
  Delete /REBOOTOK "$INSTDIR\ChangeLog"
  Delete /REBOOTOK "$INSTDIR\ReleaseNotes"

SectionEnd

Section "apcctrl Service" SecService
  ; We're installing the main package
  StrCpy $MainInstalled 1

  ; Shutdown any apcctrl or apctray that might be running
  ExecWait '"$OrigInstDir\bin\apctray.exe" /kill'
  ExecWait '"$OrigInstDir\bin\apcctrl.exe" /kill'
  DetailPrint "Waiting for apcctrl and apctray to exit..."
  Sleep 3000

  ; Create installation directories
  CreateDirectory "$INSTDIR\bin"
  CreateDirectory "$INSTDIR\driver"
  CreateDirectory "$INSTDIR\etc"
  CreateDirectory "$INSTDIR\etc\apcctrl"
  CreateDirectory "c:\tmp"

  ;
  ; NOTE: If you add new files here, be sure to remove them
  ;       in the uninstaller!
  ;

  SetOutPath "$INSTDIR\bin"
  File ${CROSSTOOLS}\mingw32\mingw32\bin\mingwm10.dll
  File ${DEPKGS}\libroot\lib\pthreadGCE.dll
  File ${TOPDIR}\src\apcctrl.exe
  File ${TOPDIR}\src\smtp.exe
  File ${TOPDIR}\src\apcaccess.exe
  File ${TOPDIR}\src\apctest.exe
  File ${WINDIR}\popup.exe 
  File ${WINDIR}\shutdown.exe
  File ${WINDIR}\email.exe
  File ${WINDIR}\background.exe

  SetOutPath "$INSTDIR\driver"
  File ${TOPDIR}\platforms\mingw\winusb\apccdc.inf
  File ${TOPDIR}\platforms\mingw\winusb\apccdc.cat
  File ${TOPDIR}\platforms\mingw\winusb\ftdiport.cat  
  File ${TOPDIR}\platforms\mingw\winusb\ftd2xx.h
  File ${TOPDIR}\platforms\mingw\winusb\ftdibus.inf
  File ${TOPDIR}\platforms\mingw\winusb\ftdibus.cat
  File ${TOPDIR}\platforms\mingw\winusb\ftdiport.inf
  SetOutPath "$INSTDIR\driver\amd64"
  File ${TOPDIR}\platforms\mingw\winusb\amd64\ftdibus.sys
  File ${TOPDIR}\platforms\mingw\winusb\amd64\ftbusui.dll
  File ${TOPDIR}\platforms\mingw\winusb\amd64\ftser2k.sys
  File ${TOPDIR}\platforms\mingw\winusb\amd64\ftcserco.dll
  File ${TOPDIR}\platforms\mingw\winusb\amd64\ftd2xx.lib
  File ${TOPDIR}\platforms\mingw\winusb\amd64\ftserui2.dll
  File ${TOPDIR}\platforms\mingw\winusb\amd64\ftlang.dll
  File ${TOPDIR}\platforms\mingw\winusb\amd64\ftd2xx64.dll
  SetOutPath "$INSTDIR\driver\Static"
  SetOutPath "$INSTDIR\driver\Static\amd64"
  File ${TOPDIR}\platforms\mingw\winusb\Static\amd64\ftd2xx.lib
  SetOutPath "$INSTDIR\driver\Static\i386"
  File ${TOPDIR}\platforms\mingw\winusb\Static\i386\ftd2xx.lib
  SetOutPath "$INSTDIR\driver\i386"
  File ${TOPDIR}\platforms\mingw\winusb\i386\ftdibus.sys
  File ${TOPDIR}\platforms\mingw\winusb\i386\ftbusui.dll
  File ${TOPDIR}\platforms\mingw\winusb\i386\ftd2xx.dll
  File ${TOPDIR}\platforms\mingw\winusb\i386\ftser2k.sys
  File ${TOPDIR}\platforms\mingw\winusb\i386\ftcserco.dll
  File ${TOPDIR}\platforms\mingw\winusb\i386\ftd2xx.lib
  File ${TOPDIR}\platforms\mingw\winusb\i386\ftserui2.dll
  File ${TOPDIR}\platforms\mingw\winusb\i386\ftlang.dll  
  
  SetOutPath "$INSTDIR\etc\apcctrl"
  File ${TOPDIR}\platforms\mingw\apccontrol.bat
  File ${TOPDIR}\platforms\mingw\apcctrl.conf.in
  File /oname=onbattery.vbs.example ${TOPDIR}\platforms\mingw\onbattery.vbs
  File /oname=offbattery.vbs.example ${TOPDIR}\platforms\mingw\offbattery.vbs
  File /oname=commfailure.vbs.example ${TOPDIR}\platforms\mingw\commfailure.vbs

  ; Post-process apcctrl.conf.in into apcctrl.conf.new
  Call PostProcConfig

  ; Rename apcctrl.conf.new to apcctrl.conf if it does not already exist
  ${Unless} ${FileExists} "$INSTDIR\etc\apcctrl\apcctrl.conf"
    Rename apcctrl.conf.new apcctrl.conf
  ${EndUnless}
SectionEnd

Section "Tray Applet" SecApctray
  ; We're installing the apctray package
  StrCpy $TrayInstalled 1

  ; Shut down any running copy
  ${If} $MainInstalled != 1
    ExecWait '"$OrigInstDir\bin\apctray.exe" /kill'
    DetailPrint "Waiting for apctray to exit..."
    Sleep 2000
  ${EndIf}

  ; Install files
  CreateDirectory "$INSTDIR"
  CreateDirectory "$INSTDIR\bin"
  SetOutPath "$INSTDIR\bin"
  File ${WINDIR}\apctray.exe

  ; Create start menu link for apctray
  CreateDirectory "$SMPROGRAMS\ApcCtrl"
  CreateShortCut "$SMPROGRAMS\ApcCtrl\Apctray.lnk" "$INSTDIR\bin\apctray.exe"
SectionEnd

Section "Multimon CGI programs" SecMultimon
  CreateDirectory "$INSTDIR"
  CreateDirectory "$INSTDIR\cgi"
  CreateDirectory "$INSTDIR\etc"
  CreateDirectory "$INSTDIR\etc\apcctrl"

  SetOutPath "$INSTDIR\cgi"
  File ${TOPDIR}\src\cgi\multimon.cgi
  File ${TOPDIR}\src\cgi\upsstats.cgi
  File ${TOPDIR}\src\cgi\upsfstats.cgi
  File ${TOPDIR}\src\cgi\upsimage.cgi
  File ${CROSSTOOLS}\mingw32\mingw32\bin\mingwm10.dll

  SetOutPath "$INSTDIR\etc\apcctrl"
  File ${TOPDIR}\src\cgi\apcctrl.css
  File /oname=hosts.conf.new ${TOPDIR}\platforms\etc\hosts.conf

  ; Rename hosts.conf.new to hosts.conf if it does not already exist
  ${Unless} ${FileExists} "$INSTDIR\etc\apcctrl\hosts.conf"
    Rename hosts.conf.new hosts.conf
  ${EndUnless}
SectionEnd

Section "USB Driver" SecUsbDrv

  ${DisableX64FSRedirection}
  
  ClearErrors   
  ExecWait '"$SYSDIR\PnPutil.exe" -i -a "$INSTDIR\driver\apccdc.inf"' $0
  ${If} ${Errors} 
    MessageBox MB_OK|MB_ICONEXCLAMATION  \
      "Ocorreu algum erro ao instalar os drivers USB APC Brasil. Voce pode \
       ignorar esse erro ou tentar instalar manualmente (driver esta no caminho $INSTDIR\driver). O erro ocorreu ao instalar o \
       arquivo apccdc.inf"
  ${Else}
    DetailPrint "Instalacao do driver apccdc.inf: OK"
  ${EndIF}   
  
  ExecWait '"$SYSDIR\PnPutil.exe" -i -a "$INSTDIR\driver\ftdiport.inf"' $0
  ${If} ${Errors} 
    MessageBox MB_OK|MB_ICONEXCLAMATION  \
      "Ocorreu algum erro ao instalar os drivers USB APC Brasil. Voce pode \
       ignorar esse erro ou tentar instalar manualmente (driver esta no caminho $INSTDIR\driver). O erro ocorreu ao instalar o \
       arquivo ftdiport.inf"
  ${Else}
    DetailPrint "Instalacao do driver ftdiport.inf: OK"
  ${EndIF}   
    
  ${EnableX64FSRedirection}
  
SectionEnd

Section "Documentation" SecDoc
  SetOutPath "$INSTDIR\doc"
  CreateDirectory "$INSTDIR\doc"
  File ${TOPDIR}\doc\manual\manual.html
  File ${TOPDIR}\doc\manual\*.png
  File *.man.txt

  ; Create Start Menu entry
  CreateDirectory "$SMPROGRAMS\ApcCtrl\Documentation"
  CreateShortCut "$SMPROGRAMS\ApcCtrl\Documentation\ApcCtrl User Manual.lnk"     "$INSTDIR\doc\manual.html"          "" "$SYSDIR\shell32.dll" ${MANUAL_ICON_INDEX}
  CreateShortCut "$SMPROGRAMS\ApcCtrl\Documentation\apcCtrl Reference.lnk"       "$INSTDIR\doc\apcctrl.man.txt"      "" "$SYSDIR\shell32.dll" ${HELP_ICON_INDEX}
  CreateShortCut "$SMPROGRAMS\ApcCtrl\Documentation\apcaccess Reference.lnk"     "$INSTDIR\doc\apcaccess.man.txt"    "" "$SYSDIR\shell32.dll" ${HELP_ICON_INDEX}
  CreateShortCut "$SMPROGRAMS\ApcCtrl\Documentation\apctest Reference.lnk"       "$INSTDIR\doc\apctest.man.txt"      "" "$SYSDIR\shell32.dll" ${HELP_ICON_INDEX}
  CreateShortCut "$SMPROGRAMS\ApcCtrl\Documentation\apccontrol Reference.lnk"    "$INSTDIR\doc\apccontrol.man.txt"   "" "$SYSDIR\shell32.dll" ${HELP_ICON_INDEX}
  CreateShortCut "$SMPROGRAMS\ApcCtrl\Documentation\Configuration Reference.lnk" "$INSTDIR\doc\apcctrl.conf.man.txt" "" "$SYSDIR\shell32.dll" ${HELP_ICON_INDEX}
SectionEnd

!define UNINSTREG "Software\Microsoft\Windows\CurrentVersion\Uninstall\apcctrl"

Section "-Finish"
  ; Write the uninstall keys for Windows & create Start Menu entry
  SetShellVarContext all

  WriteRegStr   HKLM "${UNINSTREG}" "DisplayName"     "ApcCtrl"
  WriteRegStr   HKLM "${UNINSTREG}" "UninstallString" "$INSTDIR\uninstall.exe"
  WriteRegStr   HKLM "${UNINSTREG}" "DisplayVersion"  "${VERSION}"
  WriteRegStr   HKLM "${UNINSTREG}" "Version"         "${VERSION}"
  WriteRegStr   HKLM "${UNINSTREG}" "Publisher"       "http://apcctrl-brazil.sourceforge.net/"
  WriteRegStr   HKLM "${UNINSTREG}" "URLInfoAbout"    "http://apcctrl-brazil.sourceforge.net/"
  WriteRegDWord HKLM "${UNINSTREG}" "NoRepair"        1
  WriteRegDWord HKLM "${UNINSTREG}" "NoModify"        1

  ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
  IntFmt $0 "0x%08X" $0
  WriteRegDWORD HKLM "${UNINSTREG}" "EstimatedSize" "$0"

  WriteUninstaller "$INSTDIR\Uninstall.exe"
  CreateShortCut "$SMPROGRAMS\ApcCtrl\Uninstall apcctrl (run as adm).lnk" "$INSTDIR\Uninstall.exe"
SectionEnd

;
; Initialization Callback
;
Function .onInit

  ; If there is an existing installation, default INSTDIR to location of that
  ; install. Otherwise, if user did not specify INSTDIR on cmdline (using /D), 
  ; default it to %SystemDrive%\apcctrl.
  ReadRegStr $0 HKLM "Software\apcctrl" "InstDir"
  ${If} $0 != ''
    StrCpy $INSTDIR $0
  ${ElseIf} "$INSTDIR" == ''
    ReadEnvStr $0 SystemDrive
    ${If} $0 == ''
      StrCpy $0 'c:'
    ${EndIf}
    StrCpy $INSTDIR $0\apcctrl
  ${EndIf}

  ; Preserve a copy of original install dir string before user possibly
  ; changes it. This will be used to run existing apcctrl and apctray exes
  ; with /kill switch to shut down running instances.
  StrCpy $OrigInstDir $INSTDIR

  ; Extract custom pages. Automatically deleted when installer exits.
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT "EditApcctrlConf.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT "InstallService.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT "Apctray.ini"

  ; Nothing installed yet
  StrCpy $MainInstalled 0
  StrCpy $TrayInstalled 0
  
FunctionEnd


;
; Extra Page descriptions
;

LangString DESC_SecService ${LANG_ENGLISH} "Install apcctrl on this system."
LangString DESC_SecApctray ${LANG_ENGLISH} "Install Apctray. Shows status icon in the system tray."
LangString DESC_SecUsbDrv ${LANG_ENGLISH} "Install USB driver. Required if you have a USB UPS."
LangString DESC_SecDoc ${LANG_ENGLISH} "Install Documentation on this system."
LangString DESC_SecMultimon ${LANG_ENGLISH} "Install MULTIMON cgi scripts for web-based monitoring."

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecService} $(DESC_SecService)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecApctray} $(DESC_SecApctray)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecMultimon} $(DESC_SecMultimon)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecUsbDrv} $(DESC_SecUsbDrv)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecDoc} $(DESC_SecDoc)
!insertmacro MUI_FUNCTION_DESCRIPTION_END



; Uninstall section

UninstallText "This will uninstall apcctrl. Hit next to continue."

Section "Uninstall"

  ; Shutdown any apcctrl & apctray that might be running
  ExecWait '"$INSTDIR\bin\apctray.exe" /kill'
  ExecWait '"$INSTDIR\bin\apcctrl.exe" /kill'
  DetailPrint "Waiting for apcctrl and apctray to exit..."
  Sleep 3000

  ; Remove apcuspd service, if needed
  ReadRegDWORD $R0 HKLM "Software\apcctrl" "InstalledService"
  ${If} $R0 == 1
    ExecWait '"$INSTDIR\bin\apcctrl.exe" /quiet /remove'
  ${EndIf}

  ; Remove apctray autorun, if needed
  ReadRegStr $R0 HKLM "Software\Microsoft\Windows\CurrentVersion\Run" "Apctray"
  ${If} $R0 != ""
    ExecWait '"$INSTDIR\bin\apctray.exe" /quiet /remove'
  ${EndIf}

  ; remove registry keys
  DeleteRegKey HKLM "${UNINSTREG}"
  DeleteRegKey HKLM "Software\apcctrl"
  DeleteRegValue HKLM "Software\Microsoft\Windows\CurrentVersion\Run" "Apctray"

  ; remove start menu items
  SetShellVarContext all
  RMDir /r /REBOOTOK "$SMPROGRAMS\ApcCtrl"

  ; remove files and uninstaller (preserving config for now)
  Delete /REBOOTOK "$INSTDIR\bin\mingwm10.dll"
  Delete /REBOOTOK "$INSTDIR\bin\pthreadGCE.dll"
  Delete /REBOOTOK "$INSTDIR\bin\apcctrl.exe"
  Delete /REBOOTOK "$INSTDIR\bin\smtp.exe"
  Delete /REBOOTOK "$INSTDIR\bin\apcaccess.exe"
  Delete /REBOOTOK "$INSTDIR\bin\apctest.exe"
  Delete /REBOOTOK "$INSTDIR\bin\popup.exe"
  Delete /REBOOTOK "$INSTDIR\bin\shutdown.exe"
  Delete /REBOOTOK "$INSTDIR\bin\email.exe"
  Delete /REBOOTOK "$INSTDIR\bin\background.exe"
  Delete /REBOOTOK "$INSTDIR\bin\apctray.exe"
  
  Delete /REBOOTOK "$INSTDIR\driver\apccdc.inf"
  Delete /REBOOTOK "$INSTDIR\driver\amd64\ftdibus.sys"
  Delete /REBOOTOK "$INSTDIR\driver\amd64\ftbusui.dll"
  Delete /REBOOTOK "$INSTDIR\driver\amd64\ftser2k.sys"
  Delete /REBOOTOK "$INSTDIR\driver\amd64\ftcserco.dll"
  Delete /REBOOTOK "$INSTDIR\driver\amd64\ftd2xx.lib"
  Delete /REBOOTOK "$INSTDIR\driver\amd64\ftserui2.dll"
  Delete /REBOOTOK "$INSTDIR\driver\amd64\ftlang.dll"
  Delete /REBOOTOK "$INSTDIR\driver\amd64\ftd2xx64.dll"
  Delete /REBOOTOK "$INSTDIR\driver\Static\amd64\ftd2xx.lib"
  Delete /REBOOTOK "$INSTDIR\driver\Static\i386\ftd2xx.lib"
  Delete /REBOOTOK "$INSTDIR\driver\ftd2xx.h"
  Delete /REBOOTOK "$INSTDIR\driver\ftdibus.inf"
  Delete /REBOOTOK "$INSTDIR\driver\ftdibus.cat"
  Delete /REBOOTOK "$INSTDIR\driver\ftdiport.inf"
  Delete /REBOOTOK "$INSTDIR\driver\i386\ftdibus.sys"
  Delete /REBOOTOK "$INSTDIR\driver\i386\ftbusui.dll"
  Delete /REBOOTOK "$INSTDIR\driver\i386\ftd2xx.dll"
  Delete /REBOOTOK "$INSTDIR\driver\i386\ftser2k.sys"
  Delete /REBOOTOK "$INSTDIR\driver\i386\ftcserco.dll"
  Delete /REBOOTOK "$INSTDIR\driver\i386\ftd2xx.lib"
  Delete /REBOOTOK "$INSTDIR\driver\i386\ftserui2.dll"
  Delete /REBOOTOK "$INSTDIR\driver\i386\ftlang.dll"
  Delete /REBOOTOK "$INSTDIR\driver\apccdc.cat"
  Delete /REBOOTOK "$INSTDIR\driver\ftdiport.cat"
  
  Delete /REBOOTOK "$INSTDIR\README*"
  Delete /REBOOTOK "$INSTDIR\COPYING*"
  Delete /REBOOTOK "$INSTDIR\ChangeLog*"
  Delete /REBOOTOK "$INSTDIR\ReleaseNotes*"
  Delete /REBOOTOK "$INSTDIR\Uninstall.exe"
  Delete /REBOOTOK "$INSTDIR\etc\apcctrl\apccontrol.bat"
  Delete /REBOOTOK "$INSTDIR\etc\apcctrl\apcctrl.conf.new"
  Delete /REBOOTOK "$INSTDIR\etc\apcctrl\hosts.conf.new"
  Delete /REBOOTOK "$INSTDIR\etc\apcctrl\onbattery.vbs.example"
  Delete /REBOOTOK "$INSTDIR\etc\apcctrl\offbattery.vbs.example"
  Delete /REBOOTOK "$INSTDIR\etc\apcctrl\commfailure.vbs.example"
  Delete /REBOOTOK "$INSTDIR\doc\*"
  Delete /REBOOTOK "$INSTDIR\cgi\multimon.cgi"
  Delete /REBOOTOK "$INSTDIR\cgi\upsstats.cgi"
  Delete /REBOOTOK "$INSTDIR\cgi\upsfstats.cgi"
  Delete /REBOOTOK "$INSTDIR\cgi\upsimage.cgi"
  Delete /REBOOTOK "$INSTDIR\cgi\mingwm10.dll"
  Delete /REBOOTOK "$INSTDIR\etc\apcctrl\apcctrl.css"

  ; Delete conf if user approves
  ${If} ${FileExists} "$INSTDIR\etc\apcctrl\apcctrl.conf"
  ${OrIf} ${FileExists} "$INSTDIR\etc\apcctrl\apcctrl.events"
    ${If} ${Cmd} 'MessageBox MB_YESNO|MB_ICONQUESTION "Would you like to delete the current configuration and events files?" /SD IDYES IDYES'
      Delete /REBOOTOK "$INSTDIR\etc\apcctrl\apcctrl.conf"
      Delete /REBOOTOK "$INSTDIR\etc\apcctrl\apcctrl.events"
      Delete /REBOOTOK "$INSTDIR\etc\apcctrl\hosts.conf"
    ${EndIf}
  ${EndIf}

  ; remove directories used
  RMDir "$INSTDIR\bin"
  RMDir "$INSTDIR\cgi"
  RMDir "$INSTDIR\driver\amd64"
  RMDir "$INSTDIR\driver\i386"
  RMDir "$INSTDIR\driver\Static\amd64"
  RMDir "$INSTDIR\driver\Static\i386"
  RMDir "$INSTDIR\driver\Static"
  RMDir "$INSTDIR\driver"
  RMDir "$INSTDIR\etc\apcctrl"
  RMDir "$INSTDIR\etc"
  RMDir "$INSTDIR\doc"
  RMDir "$INSTDIR\examples"
  RMDir "$INSTDIR"
  RMDir "C:\tmp"
  
SectionEnd

; eof
