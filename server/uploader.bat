@echo off

set uploaddir=golang

( 
    echo ===============================================================
    echo ��ʼ�ϴ�GoAgent %uploaddir% Server
    echo �����Ҫ�ϴ�python server, ���޸ı��ļ���uploaddir��ֵΪpython
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