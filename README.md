# certificates-uberspace
an easy way to add your ssl certificates from startssl to uberspace.de

If you want to have ssl for your [uberspace](https://uberspace.de)-websites this is an tool, that will save a lot of time.

You have to be registered  at <http://www.startssl.com/>

* `$> ./cert.sh`
* Paste the CSR into StartSSL's Webinterface and generate a Certificate
* Paste the finished CERT back to the running `cert.sh`
* Wait until uberspace accepts your certificate

then follow this <https://wiki.uberspace.de/webserver:https> tutorial to only enable ssl, ... and other features
