# -*- mode: python ; coding: utf-8 -*-


a = Analysis(
    ['tst.py'],
    pathex=[],
    binaries=[],
    datas=[('1.jpg', '.')],  # 包含背景图片（eco.png 可选）
    hiddenimports=[
        'serial',
        'serial.tools',
        'serial.tools.list_ports',
        'PySide6',
        'PySide6.QtWidgets',
        'PySide6.QtGui',
        'PySide6.QtCore',
        'pyqtgraph',
        'numpy',
        'psutil',
    ],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[
        'torch', 'torchvision', 'torchaudio',
        'tensorflow', 'tensorflow_core', 'keras',
        'sklearn', 'scikit-learn',
        'cv2', 'opencv',
        'scipy', 'sympy', 'matplotlib',
        'PIL', 'Pillow', 'lxml', 'h5py',
        'cryptography', 'grpc', 'pandas',
        'IPython', 'jupyter', 'notebook',
        'pytest', 'unittest', 'nose',
    ],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='PaperCat_Serial',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
