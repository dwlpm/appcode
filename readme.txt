Usage:

# build app docker image
docker build . -f Dockerfile -t dwlpm/appcode

# run docker image
docker run --name app --rm -d -p80:80 -v $(PWD):/appcode dwlpm/appcode 

# check app is up
browse http://localhost/index.php

# run unit test
docker exec app - ./vendor/bin/phpunit ./tests 

# run system integration test
python sit.py localhost:80/index.php
