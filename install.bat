@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"

net session >nul 2>&1
if errorlevel 1 (
    set "IS_ADMIN=false"
) else (
    set "IS_ADMIN=true"
)

set SCRIPT_NAME=lockpdf.py
set EXE_NAME=lockpdf.exe
set APP_NAME=LockPDF
set INSTALL_DIR=%LOCALAPPDATA%\Programs\%APP_NAME%

if exist "%INSTALL_DIR%\%EXE_NAME%" (
    echo ✅ LockPDF is already installed at %INSTALL_DIR%\%EXE_NAME%
    echo 🚀 Skipping build process...
    goto registry_setup
)

echo 🔧 LockPDF not found, proceeding with build and installation...

if not exist "%SCRIPT_NAME%" (
    echo ❌ Error: %SCRIPT_NAME% not found in current directory.
    pause
    exit /b 1
)

where python >nul 2>nul
if errorlevel 1 (
    echo ⚠️ Python not found. Downloading...
    curl -L -o python-installer.exe https://www.python.org/ftp/python/3.12.3/python-3.12.3-amd64.exe
    if not exist python-installer.exe (
        echo ❌ Failed to download Python installer.
        pause
        exit /b 1
    )
    python-installer.exe /quiet InstallAllUsers=0 PrependPath=1
    timeout /t 8 >nul
)

where python >nul 2>nul
if errorlevel 1 (
    echo ❌ Python installation failed.
    pause
    exit /b 1
)

echo 🐍 Creating Python virtual environment...
if exist "venv" (
    echo ⚠️ Virtual environment already exists, removing it...
    rmdir /s /q venv
)

python -m venv venv
if errorlevel 1 (
    echo ❌ Failed to create virtual environment
    pause
    exit /b 1
)

echo 🔧 Activating virtual environment...
call venv\Scripts\activate.bat

echo 🔄 Upgrading pip to latest version...
python -m pip install --upgrade pip >nul 2>nul

if exist requirements.txt (
    echo 📦 Installing dependencies from requirements.txt...
    python -m pip install -r requirements.txt
)

echo 📦 Installing PyInstaller and Pillow in virtual environment...
python -m pip install pyinstaller pillow
if errorlevel 1 (
    echo ❌ Failed to install PyInstaller or Pillow
    pause
    exit /b 1
)

echo 🔍 Environment information:
python --version
python -c "import sys; print('Python path:', sys.executable)"
python -c "import PyInstaller; print('PyInstaller version:', PyInstaller.__version__)"

echo 🛠 Building EXE in virtual environment...

if exist "build" rmdir /s /q build >nul 2>nul
if exist "dist" rmdir /s /q dist >nul 2>nul
if exist "*.spec" del *.spec >nul 2>nul

set PYINSTALLER_ARGS=--onefile --noconsole --windowed --name=%APP_NAME% --clean --collect-all tkinter
set PYINSTALLER_ARGS=%PYINSTALLER_ARGS% --exclude-module _tkinter --exclude-module tkinter.dnd --exclude-module tkinter.scrolledtext
set PYINSTALLER_ARGS=%PYINSTALLER_ARGS% --exclude-module win32api --exclude-module win32con --exclude-module win32gui
set PYINSTALLER_ARGS=%PYINSTALLER_ARGS% --exclude-module pywintypes --exclude-module pythoncom
if exist "lock_icon.ico" set PYINSTALLER_ARGS=%PYINSTALLER_ARGS% --icon=lock_icon.ico

echo 🔧 PyInstaller arguments: %PYINSTALLER_ARGS%
pyinstaller %PYINSTALLER_ARGS% "%SCRIPT_NAME%"
if errorlevel 1 (
    echo 🔧 Trying python -m PyInstaller...
    python -m PyInstaller %PYINSTALLER_ARGS% "%SCRIPT_NAME%"
    if errorlevel 1 (
        echo ⚠️ Icon conversion failed, trying without icon and with minimal exclusions...
        set PYINSTALLER_ARGS_NO_ICON=--onefile --noconsole --windowed --name=%APP_NAME% --clean --collect-all tkinter
        set PYINSTALLER_ARGS_NO_ICON=!PYINSTALLER_ARGS_NO_ICON! --exclude-module win32api --exclude-module win32con
        python -m PyInstaller !PYINSTALLER_ARGS_NO_ICON! "%SCRIPT_NAME%"
        if errorlevel 1 (
            echo ⚠️ Trying basic build with clean flag...
            set PYINSTALLER_ARGS_BASIC=--onefile --windowed --name=%APP_NAME% --clean
            python -m PyInstaller !PYINSTALLER_ARGS_BASIC! "%SCRIPT_NAME%"
            if errorlevel 1 (
                echo ❌ PyInstaller failed completely. Please check the error above.
                pause
                exit /b 1
            )
        )
    )
)

echo 🔍 Checking what was built...
if exist "dist" (
    echo 📁 Contents of dist folder:
    dir /b dist
) else (
    echo ❌ No dist folder found
)

if exist "dist\%APP_NAME%.exe" (
    echo ✅ Found %APP_NAME%.exe (single file)
    set "BUILT_EXE=dist\%APP_NAME%.exe"
    goto exe_found
) 
if exist "dist\%EXE_NAME%" (
    echo ✅ Found %EXE_NAME% (single file)
    set "BUILT_EXE=dist\%EXE_NAME%"
    goto exe_found
) 
if exist "dist\lockpdf\lockpdf.exe" (
    echo ✅ Found lockpdf.exe in folder structure
    set "BUILT_EXE=dist\lockpdf\lockpdf.exe"
    goto exe_found
) 
if exist "dist\%APP_NAME%\%APP_NAME%.exe" (
    echo ✅ Found %APP_NAME%.exe in folder structure
    set "BUILT_EXE=dist\%APP_NAME%\%APP_NAME%.exe"
    goto exe_found
)

echo ❌ No EXE found in expected locations
echo 🔍 Searching for any .exe files in dist:
dir /s /b dist\*.exe
pause
exit /b 1

:exe_found
echo 📍 Selected EXE: %BUILT_EXE%

echo 🧪 Testing EXE functionality...
echo This will test if the EXE can start without errors...
timeout /t 2 >nul
"%BUILT_EXE%" --help >nul 2>nul
if errorlevel 1 (
    echo ⚠️ Warning: EXE may have runtime issues, but proceeding with installation...
) else (
    echo ✅ EXE appears to be working correctly
)

echo 🚚 Installing to %INSTALL_DIR%
if not exist "%INSTALL_DIR%" (
    echo 📁 Creating installation directory...
    mkdir "%INSTALL_DIR%"
)

echo 📂 Moving %BUILT_EXE% to %INSTALL_DIR%\%EXE_NAME%
echo Source: %BUILT_EXE%
echo Destination: %INSTALL_DIR%\%EXE_NAME%

copy /Y "%BUILT_EXE%" "%INSTALL_DIR%\%EXE_NAME%" >nul
if errorlevel 1 (
    echo ❌ Failed to copy EXE to install directory
    echo Trying alternative method...
    xcopy /Y "%BUILT_EXE%" "%INSTALL_DIR%\" >nul
    if errorlevel 1 (
        echo ❌ All copy methods failed
        pause
        exit /b 1
    )
    :: Rename if needed
    if not exist "%INSTALL_DIR%\%EXE_NAME%" (
        ren "%INSTALL_DIR%\%APP_NAME%.exe" "%EXE_NAME%" >nul 2>nul
    )
)

if not exist "%INSTALL_DIR%\%EXE_NAME%" (
    echo ❌ Failed to install EXE to directory
    echo Directory contents:
    dir "%INSTALL_DIR%" /b
    pause
    exit /b 1
)

echo ✅ EXE successfully installed to %INSTALL_DIR%\%EXE_NAME%
echo 📝 Verifying installation:
dir "%INSTALL_DIR%\%EXE_NAME%" | findstr "%EXE_NAME%"

echo 🧹 Cleaning up virtual environment...
deactivate
echo 🗑️ Removing virtual environment folder...
rmdir /s /q venv >nul 2>nul

:registry_setup
if "%IS_ADMIN%"=="false" (
    echo.
    echo ❌ Administrator privileges required for registry modification!
    echo 🔐 Please run this script as Administrator to enable right-click context menu.
    echo.
    echo 📝 To run as Administrator:
    echo    1. Right-click on install.bat
    echo    2. Select "Run as administrator"
    echo.
    pause
    exit /b 1
)

echo 🧩 Adding registry entry for right-click menu...

set EXE_PATH=%INSTALL_DIR%\%EXE_NAME%
set EXE_PATH_ESC=!EXE_PATH:\=\\!

set REG_FILE=%TEMP%\lockpdf.reg
> "!REG_FILE!" echo Windows Registry Editor Version 5.00
>>"!REG_FILE!" echo.
>>"!REG_FILE!" echo [HKEY_CLASSES_ROOT\SystemFileAssociations\.pdf\shell\LockWithPassword]
>>"!REG_FILE!" echo @="Lock PDF with Password"
>>"!REG_FILE!" echo "Icon"="shell32.dll,48"
>>"!REG_FILE!" echo.
>>"!REG_FILE!" echo [HKEY_CLASSES_ROOT\SystemFileAssociations\.pdf\shell\LockWithPassword\command]
>>"!REG_FILE!" echo @="\"!EXE_PATH_ESC!\" \"%%1\""

regedit /s "!REG_FILE!" 2>nul
if errorlevel 1 (
    echo ❌ Registry update failed.
    echo 📄 Registry file created at: !REG_FILE!
    echo 💡 You can manually import it by double-clicking the file
) else (
    echo ✅ Registry entry added successfully!
    echo 🖱️ Right-click context menu enabled for PDF files
)
del "!REG_FILE!" >nul 2>nul

echo.
echo ✅ LockPDF setup completed successfully!
echo 🚀 EXE Location: %INSTALL_DIR%\%EXE_NAME%
echo 🖱️ Right-click context menu has been enabled for PDF files
pause
