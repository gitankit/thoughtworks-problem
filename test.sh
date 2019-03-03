#!/bin/bash

url=$1

#Index test
output=`curl -ksSLD - "$url/index.jsp" | grep HTTP | awk '{print $2}'`
if [ $output -eq "200" ];then
	echo "$(tput setaf 2)Index page working. Returned $output. $(tput sgr0)"
else
	echo "$(tput setaf 1)Index page not working. Returned $output. $(tput sgr0)"
fi

#Read test
output=`curl -ksSLD - "$url/Read.action" | grep HTTP | awk '{print $2}'`
if [ $output -eq "200" ];then
        echo "$(tput setaf 2)Read page working. Returned $output. $(tput sgr0)"
else
        echo "$(tput setaf 1)Read page not working. Returned $output. $(tput sgr0)"
fi

#Post test
output=`curl -ksSLD - "$url/Post.action" | grep HTTP | awk '{print $2}'`
if [ $output -eq "200" ];then
        echo "$(tput setaf 2)Post page working. Returned $output. $(tput sgr0)"
else
        echo "$(tput setaf 1)Post page not working. Returned $output. $(tput sgr0)"
fi

