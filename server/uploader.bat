@echo off

set uploaddir=python

(
    echo ===============================================================
    echo  GoAgent����˲������, ��ʼ�ϴ�%uploaddir%�����
    echo ===============================================================
    echo.
    echo ����������appid, ���appid����^|�Ÿ���
) && (
    @cd /d "%~dp0"
) && (
    if exist ".appcfg_cookies" (@del /f /q .appcfg_cookies)
) && (
    "..\local\python27.exe" -c "import sys;sys.path.insert(0, 'uploader.zip');import appcfg;appcfg.main()"
) && (
    echo.
    echo �ϴ��ɹ����벻Ҫ���Ǳ༭proxy.ini�����appid���ȥ��лл����������˳�����
)

@pause>NUL

@echo off
