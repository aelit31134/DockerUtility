#!/bin/sh
clear
while(true)
do
echo "-------------------------------------------"
echo "-------------------------------------------"

echo "            Welcome to Docker-Utility.v1.0"
echo
echo "                             By Aayush Goel"

echo "-------------------------------------------"
echo "-------------------------------------------"

echo

	echo "Choose any of the options given below: "
        echo
	echo "1. To run jupyter-notebook docker container environment"
	echo "2. To run wordpress docker environment with databse"
	echo "3. To stop the setup and remove containers(volumes are not deleted)"        
	echo "4. To stop the setup and remove storage"
        echo "(Note:This option while wipe all your data!)"

	echo "5. To build the Jupyter image from Dockerfile"
        echo "6. To build the wordpress image from Dockerfile"
        echo
        echo "(use Ctrl+c to stop a running setup)"
	echo
	echo "Press 0 to exit"

  	read inp
   
        case $inp in
          
        1)
           cd /root/jupy
           docker-compose up
           ;;
        2)
           cd /root/wp
           docker-compose up
           ;;
        3)
           echo "Which setup do you wish to remove"
           echo "(j for jupyter/w wordpress)"
           read ch
           if [ $ch == "j" ]
	   then
 		        cd /root/jupy
                docker-compose down
           else
		      cd /root/wp
		      docker-compose down 
	   fi
           ;;
	
        4)
           echo "Which setup do you wish to remove"
           echo "(j for jupyter/w for wordpress)"
           read ch
           if [ $ch == "j" ]
	   then
 		cd /root/jupy
                docker-compose down -v
           else
		cd /root/wp
		docker-compose down -v
	   fi
           ;;
	5)
	   cd /root/jupy
	   docker build -t jupyter:v2 .
	   ;;
	6)
	   cd /root/wp
	   docker build -t wpenhance:v1 .
	   ;;
        0)
           exit
       esac
done
           
           





