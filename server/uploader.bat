@echo off

set uploaddir=golang

( 
    echo ===============================================================
    echo  GoAgent����˲������, ��ʼ�ϴ�%uploaddir%�����
    echo  �����Ҫ�ϴ�python�����, ���޸ı��ļ���uploaddir��ֵΪpython
    echo ===============================================================
    echo.
    echo ����������appid, ���appid����^|�Ÿ���
) && (
    @cd /d "%~dp0" 
) && (
    set PYTHONSCRIPT=uploader.py
) && (
    "..\local\proxy.exe"
) || (
    pause
)
  
  
@echo off