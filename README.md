# DockerUtility

## Introduction
This project consists of a menu based setup which can be used to launch a fully loaded Jupyter python environment for any genre of development in python, and comes packed with some major heavy ML/DL based libraries such as numpy, pandas, keras, tensorflow, seaborne, scipy, scikit-learn, opencv-contrib, pillow, h5py etc. and to launch a fully functional wordpress setup with persistent, easy to migrate storage(using mysql DBMS) which comes with some basic and power-full commonly used plugins such as watu, Contact-Form7, WooCommerce, Akismet and WordfenceSecurity, all using the power of containerization using docker.

The setup is created with  the aim to give developer, access to his work and enable him to jump into development at any time and any where. He could be carrying the whole setup in a pen-drive and start working anywhere using some pre-configured setup

Also, one might start developing, deploying and managing his/her website from any where, anytime with a portable and lightweight easy to use setup. 

## Features:
* Ease of usage as the whole setup can be configured and run from just selecting options in a menu
* The setup is very portable and versatile, the persistent storage can be copied over to other machines and used on the go
* The setup is very fast and lightweight due to usage of Containerization

## Getting started
### Requirements:
* Redhat Linux preferably though any Linux system would work
* Docker
* Docker-compose
* Web Browser

## Setting up the environment:
__Docker installation on Linux:__ 

    sudo apt-get update
    sudo apt-get remove docker docker-en
    gine docker.io'''

    sudo apt install docker.io

__Docker Installation on RedHat/Centos:__

* You need to configure yum by adding docker.repo inside /etc/yum.repos.d for local installation using: https://download.docker.com/linux/centos/docker-ce.repo  

* After setting up the repo, use the following command to install docker:

      yum install docker-ce --nobest
      Starting Docker:
      systemctl start docker

* Now install Docker Compose:-

       curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
      chmod +x /usr/local/bin/docker-compose

* After installing, run the following to start docker service:

      systemctl start docker
      systemctl enable docker

* Now, we need to install some docker images to proceed with our setup:

*You can find all the docker images here : https://hub.docker.com/

    docker pull wordpress:5.1.1-php7.3-apache
    docker pull mysql:5.7
    docker pull centos

## Next, we will start by creating the required Dockerfiles, first one for python Jupyter setup and the second one for the Wordpress-MySQL setup
* Create a directory in /root, in my case, /root/jupy and move inside this directory

      mkdir /root/jupy
      cd /root/jupy

* now, create a file named Dockerfile in this directory

      gedit Dockerfile
* write the following code into this file

```FROM centos


RUN yum install epel-release -y


RUN yum update -y


RUN yum install python36 -y


RUN python3.6 -m venv ml-env


RUN source ml-env/bin/activate && pip install --upgrade pip


RUN source ml-env/bin/activate install --upgrade setuptool


RUN source ml-env/bin/activate && pip install jupyter


RUN source ml-env/bin/activate && pip install numpy scipy scikit-learn pillow h5py pandas opencv-contrib-python seaborn 


RUN source ml-env/bin/activate && pip --no-cache-dir install tensorflow 


RUN source ml-env/bin/activate && pip install keras


RUN mkdir workspace/ 


CMD source ml-env/bin/activate && jupyter notebook --allow-root --no-browser --ip=0.0.0.0 --port=1234
```

__Now, we have to create a docker-compose file for running a container with the image we created in the above step with just one command__
* In the same directory, create a file called docker-compose.yml and write the following code

```version: '3'


services:
  pythlab:
    image: jupyter:v2
    restart: always
    ports:
          - 2222:1234
    volumes:
          - jupyter_storage:/workspace


volumes:
        jupyter_storage:
```

__In this file, we have mentioned the volumes that should be created for persistent storage and also given a mount point for the outside volume to connect to an inside the container directory called workspace.__

__Now, we will create the Wordpress-MySQL setup, start-off by creating a directory in /root in my case /root/wp__

```mkdir /root/wp
cd /root/wp
```

* copy all the plugins u want to add to your wordpress image in this directory

![wpplugin](https://github.com/aelit31134/DockerUtility/blob/master/images/wp_plugins.PNG)

__In my case, I have downloaded and copied akismet, watu, wordfence, contact-form-7 and woocommerce plugins__

* now, create a file named Dockerfile in this directory

      gedit Dockerfile
 
 * write the following code into this file

```FROM wordpress:5.1.1-php7.3-apache


COPY .  /var/www/html/wp-content/plugins/


EXPOSE 80
```


### Now, we have to create a docker-compose file for running a container with the image we created in the above step with just one command

* In the same directory, create a file called docker-compose.yml and write the following code

```version: '3'


services:
        dbos:
                image: mysql:5.7
                restart: always
                environment:
                        MYSQL_ROOT_PASSWORD: root1425
                        MYSQL_USER: aayush
                        MYSQL_PASSWORD: DBpass13
                        MYSQL_DATABASE: mydb
                volumes:
                        - mysql_storage:/var/lib/mysql
        wpos:
                image: wpenhance:v1
                restart: always
                environment:
                        WORDPRESS_DB_HOST: dbos
                        WORDPRESS_DB_USER: aayush
                        WORDPRESS_DB_PASSWORD: DBpass13
                        WORDPRESS_DB_NAME: mydb
                depends_on:
                        - dbos
                ports:
                        - 1234:80
                volumes:
                        - wp_storage:/var/www/html


volumes:
        mysql_storage:
        wp_storage:
```


__In this file, we have mentioned the volumes that should be created for persistent storage and also given a mount point for the outside volume to connect to an inside the container directory called workspace.__

__Through this docker compose file, we will be able to run wordpress and mysql together along with their volume binds with just a single command and again and again.__

### Next, we will create a shell script to have our menu ready:
* Create a file as <filename>.sh, in my case utildock.sh and write the following code:

```#!/bin/sh
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
           if [ ch=="j" ]
	   then
 		cd /root/jupy
                docker-compose down
           else
		cd /root/wp
		docke-compose down 
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
```

* We need to give this file, execute permissions to run it as a shell script
      
      chmod 777 <path to utildock.sh>/utildock.sh
* We can now run this script using

      ./utildock.sh

After running this command, we will be presented with a menu as follows:

![script](https://github.com/aelit31134/DockerUtility/blob/master/images/script-comm.PNG)

![script-run](https://github.com/aelit31134/DockerUtility/blob/master/images/script-run.PNG)

* Use the 5th option to build the the image for python jupyter setup using the Dockerfile we created earlier

__Here, we are using the centos image as base image to create a custom image that will already contain some important python libraries in a pre-created environment with jupyter installed, and as soon as this container is run, it will run jupyter notebook.__

* the build might take some time and requires active internet connection
* after the build is complete, a docker image with the name jupyter:v2 will be created, which we can see using
docker image ls
 * Use the 6th option now to build the image for Wordpress with preinstalled plugins using the Dockerfile we created easrlier
 
 __Here, we are using the wordpress:5.1.1-php7.3-apache image as base image to create a custom image that will already contain some important wordpress plugins in a pre-created environment.__

* We can use these options again in the future if we export our project to some other machine

## We can now start running our environments using the menu:
### Running the python-jupyter environment:

* use the option number 1 to run the docker-compose file for the python-jupyter setup which will run a container using the jupyter:v2 image we created and start the jupyter notebook

![option1](https://github.com/aelit31134/DockerUtility/blob/master/images/option1.PNG)

![option1-1](https://github.com/aelit31134/DockerUtility/blob/master/images/option1_1.PNG)

* copy-paste the above highlighted URL in a browser, and replace the port number as 2222 (eg. http://127.0.0.1:2222), to access the jupyter notebook
* Use the worskpace folder already present in the the container to store all your work and it will be saved in the persistent storage we created
* U can copy the data in the volume and export the project to any system and start working with ease

### Running the Wordpress-MySQL environment:

* Use the option 2 to run the docker-compose file we created earlier and within an instant, complete setup of wordpress with mysql databse will be ready for use an deployment with some widely used preinstalled plugins

![option2](https://github.com/aelit31134/DockerUtility/blob/master/images/option2.PNG)

![option2-1](https://github.com/aelit31134/DockerUtility/blob/master/images/option2_1.PNG)

* Now, we can access wordpress using: localhost:1234 as URL 
* If localhost does not work use the command given below to check your default hostname or domain
hostname
_(Using hostname rather than IP is beneficial as otherwise, wordpress will register the first IP u access it with as the default IP for access and after sometime, if your IP changes, u won't we able to access your admin page as it will keep redirecting u to the previous IP)_

* The data or wordpress and mysql is stored in the mounted volume mentioned in the docker-compose file and can be easily coppied and transfered for easy migration

## Having a look at the other options left in the menu:
The options numbered as 3 and 4 can be used for stopping and removing the running containers and stopping the containers and removing the containers, personal network and volumes created(complete removal) respectively.

* Use the third option if u wish to stop the services for some instance and remove the containers to begin a fresh set of containers. U can begin the service again by using the option 1 or 2.

![option3](https://github.com/aelit31134/DockerUtility/blob/master/images/option3.PNG)

* Use the 4th option if u wish to stop and remove the containers, the network created and the associated volumes created in case u want to begin a fresh setup and don't require the previous data

![option4](https://github.com/aelit31134/DockerUtility/blob/master/images/jupy-remove.PNG)
With this, we come to the end of the explanation and the setup of our project.

__One can easily make changes in the script and the files to have the desired output to solve a custom test-case.__

## References:
* https://docs.docker.com/engine/reference/builder/
* https://docs.docker.com/compose/
* https://www.shellscript.sh/
