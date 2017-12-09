# couchdb


## docker stuff

build: 

`docker build -t 3dwardsharp/emergency-db .`

run (locally) with persistant data (./data/ directory):

`docker run -p 5984:5984 -v $(pwd)/data:/usr/local/var/lib/couchdb --name emergency-db 3dwardsharp/emergency-db`


misc:

`-e COUCHDB_USER=admin -e COUCHDB_PASSWORD=password`