# couchdb


## docker 2.1.1 stuff

https://github.com/apache/couchdb-docker/blob/master/2.1.1/Dockerfile

build: 

`docker build -t 3dwardsharp/emergency-db .`

run (locally) with persistant data (./data/ directory):

`docker run -p 5984:5984 -v $(pwd)/data:/opt/couchdb/data --name emergency-db 3dwardsharp/emergency-db`


misc:

`-e COUCHDB_USER=admin -e COUCHDB_PASSWORD=password`