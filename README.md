## Setup

### Start Control Plane

do just this:

```bash
$ go run src/main.go 

INFO[0000] Starting control plane                       
INFO[0000] management server listening                   port=18000
```

### Run Envoy

To run envoy, just download a local envoy

``` 
   docker cp `docker create envoyproxy/envoy:v1.16-latest`:/usr/local/bin/envoy .
```

Then invoke

```
./envoy -c dynamic-configuration.yaml -l debug
```

### Access proxy

```bash
curl  -H "Host: router.mahendrabagul.io" \
   --resolve  router.mahendrabagul.io:10000:127.0.0.1 \
   --cacert certs/envoy-intermediate-and-envoy-root-ca-chain.crt https://router.mahendrabagul.io:10000/
```