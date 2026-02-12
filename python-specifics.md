# PYTHON SPECIFICS

### \*args and \*\*kwargs

[reference](https://www.geeksforgeeks.org/args-kwargs-python/)

#### args

```python
def myFun(*argv):
    for arg in argv:
        print(arg)


myFun('Hello', 'Welcome', 'to', 'GeeksforGeeks')
```

```bash
Hello
Welcome
to
GeeksforGeeks
```

#### kwargs

They are basically named args in dict

```python

def myFun(**kwargs):
    for key, value in kwargs.items():
        print("%s == %s" % (key, value))


# Driver code
myFun(first='Geeks', mid='for', last='Geeks')
```

```
first == Geeks
mid == for
last == Geeks
```


## Issues with pip certificates

```bash
pip install evo
Defaulting to user installation because normal site-packages is not writeable
Collecting evo
  WARNING: Certificate did not match expected hostname: files.pythonhosted.org. Certificate: {'subject': ((('countryName', 'US'),), (('stateOrProvinceName', 'California'),), (('localityName', 'San Francisco'),), (('organizationName', 'Fastly, Inc.'),), (('commonName', 'default.ssl.fastly.net'),)), 'issuer': ((('countryName', 'BE'),), (('organizationName', 'GlobalSign nv-sa'),), (('commonName', 'GlobalSign RSA OV SSL CA 2018'),)), 'version': 3, 'serialNumber': '774F44BD70CC390C7F8E2FE4', 'notBefore': 'May  1 16:26:08 2025 GMT', 'notAfter': 'Jun  2 16:26:07 2026 GMT', 'subjectAltName': (('DNS', 'default.ssl.fastly.net'), ('DNS', '*.hosts.fastly.net'), ('DNS', '*.fastly.com')), 'OCSP': ('http://ocsp.globalsign.com/gsrsaovsslca2018',), 'caIssuers': ('http://secure.globalsign.com/cacert/gsrsaovsslca2018.crt',), 'crlDistributionPoints': ('http://crl.globalsign.com/gsrsaovsslca2018.crl',)}
  WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'SSLError(CertificateError("hostname 'files.pythonhosted.org' doesn't match either of 'default.ssl.fastly.net', '*.hosts.fastly.net', '*.fastly.com'"))': /packages/7e/dc/e3cde9c4b1a09c8759555c58bc881965f9d82032014cf2e0fd4cad3d21bb/evo-1.33.0-py3-none-any.whl
```

fix:
```bash
sudo mkdir -p /etc/pip
sudo vim /etc/pip/pip.conf
```

Enter inside: 

```txt
[global]
trusted-host = 
    pypi.org
    pypi.python.org
    files.pythonhosted.org
```
