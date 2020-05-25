FROM centos

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

