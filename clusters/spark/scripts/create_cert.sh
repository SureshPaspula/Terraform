cat > csr_details.txt <<-EOF
[req]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn  ]
C=US
ST=Illinois
L=Chicago
O=Gray Matter Analytics
OU=Coretechs
emailAddress=coretechsadmin@graymatteranalytics.com
CN = *.ec2.internal

[ req_ext  ]
subjectAltName = @alt_names

[ alt_names  ]
DNS.1 = *.us-east-2.compute.internal
DNS.2 = *.us-west-1.compute.internal
DNS.3 = *.us-west-2.compute.internal
EOF

# Let’s call openssl now by piping the newly created file in
# openssl req -new -sha256 -nodes -out \*.your-new-domain.com.csr -newkey rsa:2048 -keyout \*.your-new-domain.com.key -config <( cat csr_details.txt  )

openssl req -x509 -newkey rsa:1024 -keyout privateKey.pem -out certificateChain.pem -days 3650 -nodes -config <( cat csr_details.txt )
cp certificateChain.pem trustedCertificates.pem
zip -r -X coretechs-emr-certs.zip certificateChain.pem privateKey.pem trustedCertificates.pem
