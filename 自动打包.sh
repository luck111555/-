#!/bin/bash

# Ensure relative paths resolve from the script directory.
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$script_dir"
# PaperCat Serial 自动打包脚本 (Linux/Mac版本)

echo "========================================"
echo "   PaperCat Serial 自动打包脚本"
echo "========================================"
echo ""

timestamp=$(date +"%Y%m%d_%H%M%S")

# 1. 备份旧版本
echo "[1/4] 正在备份旧版本..."
if [ -f "dist/PaperCat_Serial.exe" ]; then
    mkdir -p backup
    cp "dist/PaperCat_Serial.exe" "backup/PaperCat_Serial_backup_${timestamp}.exe"
    echo "     ✓ 旧版本已备份至: backup/PaperCat_Serial_backup_${timestamp}.exe"
else
    echo "     ⚠ 未找到旧版本exe文件，跳过备份"
fi
echo ""

# 2. 清理旧的构建文件
echo "[2/4] 正在清理构建缓存..."
rm -rf build dist
echo "     ✓ 构建缓存已清理"
echo ""

# 3. 执行打包
echo "[3/4] 正在打包exe文件..."
echo "     (这可能需要1-2分钟，请耐心等待)"
echo ""

run_pyinstaller() {
    # Prefer Windows PyInstaller when running in WSL to produce a Windows exe.
    if uname -r 2>/dev/null | grep -qi microsoft; then
        local win_ps="/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"
        if [ -x "$win_ps" ] && [ -f ".venv/Scripts/pyinstaller.exe" ] && command -v wslpath >/dev/null 2>&1; then
            local win_project_dir
            win_project_dir=$(wslpath -w "$PWD")
            local win_pyinstaller="${win_project_dir}\\.venv\\Scripts\\pyinstaller.exe"
            local win_spec="${win_project_dir}\\tst.spec"
            "$win_ps" -NoProfile -Command "& '$win_pyinstaller' '$win_spec' --clean"
            return $?
        fi
    fi

    pyinstaller tst.spec --clean
}

run_pyinstaller
if [ $? -ne 0 ]; then
    echo ""
    echo "❌ 打包失败！请检查错误信息"
    exit 1
fi
echo ""
echo "     ✓ 打包完成"
echo ""

# 4. 复制资源文件
echo "[4/4] 正在复制资源文件..."
if [ -f "1.jpg" ]; then
    cp "1.jpg" "dist/"
    echo "     ✓ 背景图片已复制"
fi
if [ -f "eco.png" ]; then
    cp "eco.png" "dist/"
    echo "     ✓ 吉祥物图片已复制"
fi
echo ""

# 5. 显示结果
echo "========================================"
echo "   打包成功！"
echo "========================================"
echo ""
echo "📦 新版本位置: dist/PaperCat_Serial.exe"
if [ -f "dist/PaperCat_Serial.exe" ]; then
    size=$(ls -lh "dist/PaperCat_Serial.exe" | awk '{print $5}')
    echo "📏 文件大小: ${size}"
fi
echo ""
echo "打包完成！"
