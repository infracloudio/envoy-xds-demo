## Setup

### Start Control Plane

do just this:

```bash
$ go run src/main.go 

INFO[0000] Starting control plane                       
INFO[0000] management server listening                   port=18000
```

### Run sample_servers
Here I am using dummy json-server a nodejs module. To install `json-server`, you can follow the steps here [https://www.npmjs.com/package/json-server#getting-started].

```bash
IP=`ip -f inet addr show wlp0s20f3 | grep -Po 'inet \K[\d.]+'`
json-server --watch sample_servers/profiles.json --host ${IP} --port 10002
```

This command will start a server on port 10002, and the requests to this server will be proxied through envoy

### Run Envoy

To run envoy, just download a local envoy

```bash
docker cp `docker create envoyproxy/envoy:v1.16-latest`:/usr/local/bin/envoy .
```

Then invoke

```bash
./envoy -c dynamic-configuration.yaml -l debug
```

### Access proxy

```bash
curl  -H "Host: router.mahendrabagul.io" \
   --resolve  router.mahendrabagul.io:10000:127.0.0.1 \
   --cacert certs/envoy-intermediate-and-envoy-root-ca-chain.crt https://router.mahendrabagul.io:10000/profiles
```

### Check dynamic configuration is being applied to envoy or not.
1. You will need to start a server(you can use the `json-server` command on the posts.json in sample_servers folder). Once you fire below command,
```bash
json-server --watch sample_servers/posts.json --host ${IP} --port 10003
```
update the ip and port in domains.csv present in root of the project like below.

```
"192.168.1.14","10003","/posts"
```
When you will do this, the next iteration will pick up this change and push it to envoy. You will be able to access /posts api from envoy's ip and port.

```bash
curl  -H "Host: router.mahendrabagul.io" \
   --resolve  router.mahendrabagul.io:10000:127.0.0.1 \
   --cacert certs/envoy-intermediate-and-envoy-root-ca-chain.crt https://router.mahendrabagul.io:10000/posts
```
