openssl genrsa -passout pass:1111 -out envoy-root-ca.key 4096
openssl req -new -x509 -days 365 -key envoy-root-ca.key -subj "/C=IN/ST=MH/L=SC/O=InfraCloud/OU=IC/CN=IC Root CA" -out envoy-root-ca.crt -passin pass:1111 -set_serial 0 -extensions v3_ca -config openssl.cnf

openssl req -nodes -new -keyout envoy-intermediate-ca.key -out envoy-intermediate-ca.csr -subj "/C=IN/ST=MH/L=SC/O=InfraCloud/OU=ICServices/CN=IC Intermediate CA" -config openssl.cnf -passout pass:1111

openssl x509 -days 365 -req -in envoy-intermediate-ca.csr -CAcreateserial -CA envoy-root-ca.crt -CAkey envoy-root-ca.key -out envoy-intermediate-ca.crt -extfile openssl.cnf -extensions v3_intermediate_ca -passin pass:1111

openssl req -nodes -new -keyout envoy-proxy-server.key -out envoy-proxy-server.csr -subj "/C=IN/ST=MH/L=SC/O=InfraCloud/OU=envoy-proxy-server/CN=router.mahendrabagul.io" -config openssl.cnf -passout pass:1111

openssl x509 -days 365 -req -in envoy-proxy-server.csr -CAcreateserial -CA envoy-intermediate-ca.crt -CAkey envoy-intermediate-ca.key -out envoy-proxy-server.crt -extfile openssl.cnf -extensions server_cert -passin pass:1111

openssl req -nodes -new -keyout envoy-proxy-client.key -out envoy-proxy-client.csr -subj "/C=IN/ST=MH/L=SC/O=InfraCloud/OU=IC/CN=client-svc@domain.com" -config openssl.cnf -passout pass:1111
openssl x509 -days 365 -req -in envoy-proxy-client.csr -CAcreateserial -CA envoy-intermediate-ca.crt -CAkey envoy-intermediate-ca.key -out envoy-proxy-client.crt -extfile openssl.cnf -extensions usr_cert -passin pass:1111


cat envoy-root-ca.crt envoy-intermediate-ca.crt > envoy-intermediate-and-envoy-root-ca-chain.crt
