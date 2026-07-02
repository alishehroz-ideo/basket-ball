@echo off
setlocal enabledelayedexpansion
set BUILDDIR=C:\Users\Ali Shehroz\Downloads\COUPRA_GAMES\WebGL_Coupra_BasketBall URL\build
set API=https://api-gamebull.hyperfunded.pro
set TENANT=ideo-test
set GAMEID=BASKET_BALL
set GAMEURL=https://alishehroz-ideo.github.io/basket-ball/
set RETURNURL=https://example.com/done
set WAIT=150
cd /d "%BUILDDIR%"
echo === [1/4] Pushing build to GitHub ===
git add .
git commit -m "auto build %date% %time%"
git push
echo.
echo === [2/4] Waiting %WAIT%s for GitHub Pages ===
timeout /t %WAIT% /nobreak
echo.
echo === [3/4] Minting token ===
curl -s -c c.txt -X POST "%API%/tenants/%TENANT%/guests" -H "Content-Type: application/json" -d "{\"deviceFp\":\"batch-%RANDOM%%RANDOM%\"}" >nul
curl -s -b c.txt -X POST "%API%/play/sessions" -H "Content-Type: application/json" -d "{\"gameId\":\"%GAMEID%\"}" > session.json
for /f "usebackq delims=" %%T in (`powershell -NoProfile -Command "(Get-Content session.json -Raw ^| ConvertFrom-Json).sessionToken"`) do set TOKEN=%%T
for /f "usebackq delims=" %%S in (`powershell -NoProfile -Command "(Get-Content session.json -Raw ^| ConvertFrom-Json).seed"`) do set SEED=%%S
echo Seed=!SEED!
echo.
echo === [4/4] Opening game in incognito Chrome ===
start chrome --incognito "%GAMEURL%?tenantSlug=%TENANT%&gameId=%GAMEID%&seed=!SEED!&returnUrl=%RETURNURL%&sessionToken=!TOKEN!"
del session.json
echo Done.
endlocal
