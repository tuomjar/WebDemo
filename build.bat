@echo off
setlocal

REM Luo virtuaaliympäristö, jos ei ole
if not exist venv (
    python -m venv venv
)

REM Aktivoi venv
call venv\Scripts\activate

REM Asenna riippuvuudet
pip install --upgrade pip
pip install -r requirements.txt

REM Käynnistä palvelin taustalle
start "" /B python demoapp\server.py

REM Odota hetki että palvelin ehtii käynnistyä
timeout /t 5 > nul

REM Aja testit
robot login_tests

REM Sammuta taustalla oleva palvelin
for /f "tokens=2" %%a in ('tasklist ^| findstr "python.exe"') do (
    taskkill /PID %%a /F > nul
)

exit /B 0
