@"%~dp0..\local\python27.exe" -x "%~dpnx0" && exit /b 0 || (pause && exit /b -1)

import sys
import os
import re
import getpass
import socket

try:
    socket.create_connection(('127.0.0.1', 8087), timeout=1).close()
    os.environ['HTTP_PROXY'] = 'http://127.0.0.1:8087'
    os.environ['HTTPS_PROXY'] = 'http://127.0.0.1:8087'
except socket.error:
    pass

sys.path += ['google_appengine.zip', 'google_appengine.zip/google/appengine/_internal']

import httplib
import fancy_urllib

def fancy_urllib_create_fancy_connection(*args, **kwargs):
    return httplib.HTTPSConnection

fancy_urllib.create_fancy_connection = fancy_urllib_create_fancy_connection

_realgetpass = getpass.getpass
def getpass_getpass(prompt='Password:', stream=None):
    try:
        import msvcrt
        password = ''
        sys.stdout.write(prompt)
        while 1:
            ch = msvcrt.getch()
            if ch == '\b':
                if password:
                    password = password[:-1]
                    sys.stdout.write('\b \b')
                else:
                    continue
            elif ch == '\r':
                sys.stdout.write(os.linesep)
                return password
            else:
                password += ch
                sys.stdout.write('*')
    except Exception:
        return _realgetpass(prompt, stream)
getpass.getpass = getpass_getpass


def upload(dirname, appid):
    import google.appengine.tools.appengine_rpc
    import google.appengine.tools.appcfg
    assert isinstance(dirname, basestring) and isinstance(appid, basestring)
    filename = os.path.join(dirname, 'app.yaml')
    assert os.path.isfile(filename), u'%s not exists!' % filename
    with open(filename, 'rb') as fp:
        yaml = fp.read()
    yaml = re.sub(r'application:\s*\S+', 'application: '+appid, yaml)
    with open(filename, 'wb') as fp:
        fp.write(yaml)
    if sys.modules.has_key('google'):
        del sys.modules['google']
    google.appengine.tools.appengine_rpc.HttpRpcServer.DEFAULT_COOKIE_FILE_PATH = './.appcfg_cookies'
    google.appengine.tools.appcfg.main(['appcfg', 'rollback', dirname])
    google.appengine.tools.appcfg.main(['appcfg', 'update', dirname])


def main():
    appids = raw_input('APPID:')
    if not re.match(r'[0-9a-zA-Z\-|]+', appids):
        sys.stderr.write('appid Wrong Format, please login http://appengine.google.com to view the correct appid!\n')
        sys.exit(-1)
    if any(x in appids.lower() for x in ('ios', 'android')):
        sys.stderr.write('appid cannot contians ios/android\n')
        sys.exit(-1)
    for appid in appids.split('|'):
        upload('gae', appid)


if __name__ == '__main__':
    sys.stdout.write('''\
===============================================================
 GoAgent����˲������, ��ʼ�ϴ� gae Ӧ���ļ���
 Linux/Mac �û�, ��ʹ�� python -x uploader.bat ���ϴ�Ӧ��
===============================================================

����������appid, ���appid����|�Ÿ���
ע�⣺appid ������� android/ios ������������ܱ�ĳЩ��վʶ����ƶ��豸��
        '''.decode('gbk').strip().encode(sys.getfilesystemencoding(), 'replace')+'\n')
    main()
    sys.stdout.write(u'''
�ϴ��ɹ����벻Ҫ���Ǳ༭proxy.ini�����appid���ȥ��лл�����س����˳�����'''
        .decode('gbk').encode(sys.getfilesystemencoding(), 'replace'))
    raw_input()
