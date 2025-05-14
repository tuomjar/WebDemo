@echo off
echo Activating virtual environment...
call venv\Scripts\activate

echo Installing dependencies...
pip install -r requirements.txt

echo Starting demo server...
start /B python demoapp\server.py

timeout /t 5

echo Running tests...
robot login_tests

echo Killing demo server...
for /f "tokens=2 delims=," %%a in ('powershell -Command "Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -like '*demoapp\\server.py*' } | ForEach-Object { $_.ProcessId }"') do (
    echo Terminating process ID %%a
    taskkill /PID %%a /F
)

echo Done!
