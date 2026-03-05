@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
echo ========================================
echo    PaperCat Serial 自动打包脚本
echo ========================================
echo.

:: 获取当前时间
set timestamp=%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set timestamp=%timestamp: =0%

:: 目标EXE路径（打包后将覆盖到此位置）
set "target_exe=D:\项目资料\rt\dist\PaperCat_Serial.exe"

:: 1. 备份旧版本
echo [1/5] 正在备份旧版本...
if exist "dist\PaperCat_Serial.exe" (
    if not exist "backup" mkdir backup
    copy /Y "dist\PaperCat_Serial.exe" "backup\PaperCat_Serial_backup_%timestamp%.exe" >nul
    echo      ✓ 旧版本已备份至: backup\PaperCat_Serial_backup_%timestamp%.exe
) else (
    echo      ⚠ 未找到旧版本exe文件，跳过备份
)
echo.

:: 2. 清理旧的构建文件
echo [2/5] 正在清理构建缓存...
if exist "build" rmdir /S /Q build
if exist "dist" rmdir /S /Q dist
echo      ✓ 构建缓存已清理
echo.

:: 3. 执行打包
echo [3/5] 正在打包exe文件...
echo      (这可能需要1-2分钟，请耐心等待)
echo.
set "pyinstaller_exe=.venv\Scripts\pyinstaller.exe"
if not exist "%pyinstaller_exe%" (
    echo.
    echo ❌ 未找到 %pyinstaller_exe%
    echo 请先在该虚拟环境中安装 PyInstaller: .\.venv\Scripts\python.exe -m pip install pyinstaller
    pause
    exit /b 1
)
"%pyinstaller_exe%" tst.spec --clean
if %errorlevel% neq 0 (
    echo.
    echo ❌ 打包失败！请检查错误信息
    pause
    exit /b 1
)
echo.
echo      ✓ 打包完成
echo.

:: 4. 复制资源文件
echo [4/5] 正在复制资源文件...
if exist "1.jpg" (
    copy /Y "1.jpg" "dist\" >nul
    echo      ✓ 背景图片已复制
)
if exist "eco.png" (
    copy /Y "eco.png" "dist\" >nul
    echo      ✓ 吉祥物图片已复制
)
echo.

:: 5. 更新目标EXE
echo [5/5] 正在更新目标EXE...
if exist "dist\PaperCat_Serial.exe" (
    for %%I in ("dist\PaperCat_Serial.exe") do set "source_exe=%%~fI"
    for %%I in ("%target_exe%") do set "target_exe_abs=%%~fI"
    if /I "!source_exe!"=="!target_exe_abs!" (
        echo      ✓ 目标EXE与构建输出相同，已是最新
    ) else (
        for %%I in ("%target_exe%") do set "target_dir=%%~dpI"
        if not exist "!target_dir!" mkdir "!target_dir!"
        copy /Y "dist\PaperCat_Serial.exe" "!target_exe!" >nul
        echo      ✓ 已更新目标EXE: !target_exe!
    )
) else (
    echo      ❌ 未找到构建输出，无法更新目标EXE
)
echo.

:: 6. 显示结果
echo ========================================
echo    打包成功！
echo ========================================
echo.
echo 📦 新版本位置: dist\PaperCat_Serial.exe
dir /B dist\PaperCat_Serial.exe 2>nul && for %%A in (dist\PaperCat_Serial.exe) do echo 📏 文件大小: %%~zA 字节
echo.

:: 7. 询问是否运行
set /p run="是否立即运行新版本？(Y/N): "
if /i "%run%"=="Y" (
    echo.
    echo 正在启动 PaperCat Serial...
    start "" "dist\PaperCat_Serial.exe"
)

echo.
echo 按任意键退出...
pause >nul
