# certificates-uberspace
an easy way to add your ssl certificates from startssl to uberspace.de

If you want to have ssl for your uberspace.de-websites this is an tool, that will save a lot of time.

you have to be registered and authored at <http://www.startssl.com/>

before doing anything at the startssl-website start this script:

`sh cert-create.sh`

this will ask you some questions:

```
Private Key and Certificate Signing Request Generator
the CAcert Certificate Authority. www.Startssl.com

Domain (with ending) : your-domain.de
Subdomain (ie. mail, www): test
Running OpenSSL...
Generating a 4096 bit RSA private key
...
writing new private key to './test.your-domain.de/test_privatekey.pem'
-----
Copy the following Certificate Request and paste into Startssl website to obtain a Certificate.
When you receive your certificate, you 'should' enter it in the ./test.your-domain.de/test_startssl.pem

-----BEGIN CERTIFICATE REQUEST-----
MIIEYzCCAksCAQAwHjEcMBoGA1UEAxMTYXNkZnN0dW5reW1vbmtleS5kZTCCAiIw
DQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAK4nXNKlTPng2JPEFi91Ny/CDhIy
cXQoCN51dtYjYrDIicxUZ+zxUvoCfSviaI0QMymZ2Fr49finT17+fQujwVuCVR9J
jlhzEgzoZkh522T3RDYPSe9mZIhsC5shI2jqvu/ypjTd82Lhk4uQqVv2hpKzm9aV
sBFOhEejVBmOSS2/weVdk/NM4uHR8ZLGMX9KF2qgn33j3+iZ4CfAV4dO/YVuu56z
IfpbTYmAvFsLL1w1l8AxdU1KuX05ba0qcdqixITn5WdqvH4E1MW78m7MClrG1SzH
SLtdGArOt6VzvSUmof4tnJbWIt1Il6ScjMJ9F2yHibTpbSQBeROGoU4zxd6nnzmo
/ZETHxUJ+J24vUgZnDB6PXdypFfS1iUPJHD2KHIGrpF8R96O+AQCb+fEiuRKyJey
bx5ZLe6fhM/5C2WrRZGSQtomLystlMJPU8s7vmKj0UIAZPe0tMlIpPcU+4+HChQW
iRaZA0hiSDo+4NhKq353tMWJv8iSSbW+31Sdh3iW+OQJLvQvwdiAQvRXsQtqN1PI
O8k8WJ83xjo5W3HFPkR8eVu0MMeW9fMx3rtMeLjaM1DjOc//iljHcUd6kFQu8D33
seOsdhvnRbL95+NHNSk71kNZKTt19iCFzufIbJiY/voaavVNLiDJX9SsRX/sefF1
d/zLfPTQGaZsYQR7AgMBAAGgADANBgkqhkiG9w0BAQsFAAOCAgEATIHPdtmOasOF
mkTyos7Pkasm9tULNjzoz3nRcyiKO3sYg55AjfQETJIjD5I008EI7Ge4t7UFHOPs
FySPqXnbR9xd2EYAK9pN6HZKKUdPX3O/+GmPHSBt0d4CRftghTv/2tJx6y/R6BgO
XZLKi3ZHn060SQGQgnphxQvwjAxOhdP6h/mqOc6d0PAe/vxXE7nDiQCSYodKcy2w
LFXM8bk7h6JPmmX2GKiftOnO1fBjyASEQf22mYgkqtd41SgtkaWAk6NMenpQim9t
Wmr68eWDyM1u73BKq9hwF+nTkbu7vX1Ienimw0uJOfDbXP0s5YdMsix/kjlVH8Df
axjyJY+nk78F8oA5wH3dBdimsOppE60Xdl9RiBlZ8EmCygjAfYi344S44x1n4AIY
KzFH1USxYC/mcdvfs2jilnUtlOVCH6tpHiYMOJh5KEVeUNh15U0YMoFtLNCv6UTX
3wqCuObq4eL3oYuyPI/83ll6qFruiktQvhKJpL5XKpirNZGS/2S0iUcqsD17WsLK
4vD5/vsFJnaghBx0/9y1Jwmq55G+w4C0Ev2qAqumvnNCQhB4WBuqDOELPbuIBEWq
4oqKFMCRM6yEnJONCyes5aDjITF+pUJ4UZRUeUW7/vbxuEM74gt8ljyZuO8L1Co3
jZhAxOPODmcgZPD1gPmQEHPC+RU6Gs4=
-----END CERTIFICATE REQUEST-----

The Certificate request is also available in ./test.your-domain.de/test_csr.pem
The Private Key is stored in ./test.your-domain.de/test_privatekey.pem
```

this will generate your private key. (this is only an example)

when startssl gives you your certificate you have to enter it into your ./test.your-domain.de/test_startssl.pem

`nano ./test.your-domain.de/test_startssl.pem`

enter here your certificate and then run:

`sh cert-add-to-uber.sh`

they will ask you again your information:
```
sh cert-add-to-uber.sh 
Domain (with ending) : your-domain.de
Subdomain (ie. mail, www): test
True

Let's check the files...
Key is okay...
Certificate is okay...
Certificate matches key...
All good!

Feel free to mail to hallo@uberspace.de, please include the following information:

Host: menkar.uberspace.de
uberspace-import-ssl-cert -u testuser -c /home/testuser/.tls-certs/testuser.test.your-domain.de.combined.pem
Mail was send to hallo@uberspace.de

```

after this you have to wait for a few hours until uberspace.de will accept your certificates.

then follow this <https://wiki.uberspace.de/webserver:https> tutorial to only enable ssl, ... and other features