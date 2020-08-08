#!/bin/sh

set -e;

# https://docs.docker.com/engine/swarm/configs/#advanced-example-use-configs-with-a-nginx-service
# https://wiki.hackzine.org/sysadmin/openssl-commands.html
# https://www.sslshopper.com/article-most-common-openssl-commands.html
# https://www.openssl.org/docs/man1.0.2/man1/x509.html
# https://www.digitalocean.com/community/tutorials/openssl-essentials-working-with-ssl-certificates-private-keys-and-csrs

certs_path="../nginx/certs/"

mkdir -p ${certs_path}

ca_serial="${certs_path}/ca-serial.srl"
dhparam="${certs_path}/dhparam.pem"

root_ca_key="${certs_path}/root-ca.key"
root_ca_crt="${certs_path}/root-ca.crt"
root_ca_csr="${certs_path}/root-ca.csr"
root_ca_cnf="./certificate-root-ca.cnf"

site_key="${certs_path}/site.key"
site_crt="${certs_path}/site.crt"
site_csr="${certs_path}/site.csr"
site_cnf="./certificate-site.cnf"

printf '\e[7;31m%-6s\e[m\n\n' "General OpenSSL certificate 🔐"
sleep .5

printf '\e[1;32m%-6s\e[m\n' "Checking CA-serial number file: 🗂"
echo "########################################"
sleep .5

if test -f ${ca_serial}; then
    echo "=> File $ca_serial exists. ✅";
else
    echo "=> File $ca_serial does not exists. ❌";
fi

sleep .5

if test ! -f ${ca_serial}; then
    echo "\nGenerate new certificate! ⚙️"
    echo "########################################"

    echo "=> Generate a root key. ✅"
    openssl genrsa -out ${root_ca_key} 4096 &>/dev/null

    echo "=> Generate a CSR using the root key. ✅";
    openssl req \
        -new \
        -key ${root_ca_key} \
        -out ${root_ca_csr} \
        -sha256 \
        -subj '/C=RU/ST=Moscow/L=Moscow/O=Example/CN=localhost Example CA/emailAddress=develop@soprun.com' &>/dev/null

    echo "=> Sign the certificate. ✅";
    openssl x509 \
        -req \
        -days 15 \
        -in ${root_ca_csr} \
        -signkey ${root_ca_key} \
        -sha256 \
        -out ${root_ca_crt} \
        -extfile ${root_ca_cnf} \
        -extensions \
        root_ca &>/dev/null

    echo "=> Generate the site key. ✅";
    openssl genrsa -out ${site_key} 4096 &>/dev/null

    echo "=> Generate the site certificate and sign it with the site key. ✅";
    openssl req \
        -new \
        -key ${site_key} \
        -out ${site_csr} \
        -sha256 \
        -subj '/C=RU/ST=Moscow/L=Moscow/O=Example/CN=localhost/emailAddress=develop@soprun.com' &>/dev/null

    echo "=> Sign the site certificate. ✅";
    openssl x509 \
        -req \
        -days 10 \
        -in ${site_csr} \
        -sha256 \
        -CA ${root_ca_crt} \
        -CAkey ${root_ca_key} \
        -CAcreateserial \
        -CAserial ${ca_serial} \
        -out ${site_crt} \
        -extfile ${site_cnf} \
        -extensions server &>/dev/null

    # You’ll also need PKSC12 certificate bundles to import in browsers:

    #openssl pkcs12 -export \
    #    -in client-s.crt -inkey client-s.key \
    #    -certfile ca.crt \
    #    -name "Certificate for client X" \
    #    -out client-s.p12
fi

echo "=> CA-serial: $(cat ${ca_serial}) 📍";

printf '\e[1;32m%-6s\e[m\n' "Checking DH file: 🗄"
echo "########################################"
sleep .5

if test -f ${dhparam}; then
    echo "=> File ${dhparam} exists. ✅";
    exit 0;
else
    echo "=> File ${dhparam} does not exists. ❌";

    sleep 1
    echo ""
    echo "Generate new DH file! ✅"

    sleep 1
    echo "=> Generate a DH Diffie-Hellman key exchange. ✅"
    openssl dhparam -out ${dhparam} 256 &>/dev/null
fi
