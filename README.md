# Docker

1. Run 3 containers using images that does not automatically exit such
as nginx in detached mood. Stop one of them and leave 2
running. Submitting the output for docker ps -a is enough to prove
this exercise has been done.

```console
$ docker run -d nginx
$ docker run -d tomcat
$ docker run -d mongo
$ docker ps
```

![](/screenshots/docker-ps-3.png)

```console
$ docker stop a56797c85c18
$ docker ps -a
```

![](/screenshots/docker-ps-a-3.png)

2. Containers and images that we have running right now won’t be used
anymore and they are consuming resources. Clean the docker daemon from
all images and containers. Submit the output for docker ps -a and
docker images.

```console
$ docker stop $(docker ps -aq)
$ docker rm $(docker ps -aq)
```

![](/screenshots/docker-ps-a-0.png)

```console
$ docker rmi $(docker images -aq)
```

![](/screenshots/docker-images.png)

3 Now that we’ve warmed up it’s time to get inside a container while
it’s running! Start container with image
devopsdockeruh/exec_bash_exercise, it will start with clock-like
features and create a log. Go inside the container and use tail -f
./logs.txt to follow the logs. Every 15 seconds the clock will send
you a “secret message”. Submit the secret message and command(s) given
as your answer.

```console
$ docker run -d devopsdockeruh/exec_bash_exercise
$ docker ps
```

![](/screenshots/docker-ps-1.png)

```console
$ docker exec -it 439edc1329cd bash
```

![](/screenshots/secret-message.png)

4. Create a Dockerfile that starts with FROM
devopsdockeruh/overwrite_cmd_exercise. Add a CMD line to the
Dockerfile.  The developer has poorly documented how the application
works. Nevertheless once you will execute an application (run a
container from an image) you will have some clues on how it
works. Your task is to run an application so that it will simulate a
number sequence.  When you build an image tag it as “docker-sequence”
so that docker run docker-sequence starts the application.

```console
$ docker run --rm -it devopsdockeruh/overwrite_cmd_exercise /bin/bash
```

![](/screenshots/docker-cmd.png)

Dockerfile
```dockerfile
FROM devopsdockeruh/overwrite_cmd_exercise
CMD ["-c"]
```

```console
$ docker build -t docker-sequence .
$ docker run docker-sequence
```

![](/screenshots/docker-sequence.png)

5. In this exercise we won’t create a new Dockerfile. Image
devopsdockeruh/first_volume_exercise has instructions to create a log
into /usr/app/logs.txt. Start the container with bind mount so that
the logs are created into your filesystem.  Submit your used commands
for this exercise.

```console
$ touch logs.txt
$ docker run --rm -v $(pwd)/logs.txt:/usr/app/logs.txt \
devopsdockeruh/first_volume_exercise
```

6. In this exercise we won’t create a new Dockerfile. Image
devopsdockeruh/ports_exercise will start a web service in port 80. Use
-p flag to access the contents with your browser.  Submit your used
commands for this exercise.

```console
$ docker run --rm -p 5000:80 devopsdockeruh/ports_exercise
```

![](/screenshots/docker-ports.png)

7. You've already created your own flask app, let's containerize
it. Create a Dockerfile and run it localy. Tips to get started: use
python:_tag_ as a base image. Add all the required packages, but the
ones already present in python, to requirements.txt file and install
them using RUN command. Also make sure you copied all the required
files inside the container.  Run a container with 5000 port exposed
and published so when you start the container and navigate to
https://localhost:5000 you will see if you ran it successfully.  Feel
free to make any code changes you want if you want to simplify
it. Submit a github repository with code and commands in README that
you used to run it.

```dockerfile
FROM python:3.10
WORKDIR /usr
RUN git clone https://github.com/akapinos/flask_oauth /usr/app
WORKDIR /usr/app
RUN pip install -r requirements.txt
COPY .env /usr/app/.env
RUN flask
EXPOSE 5000
ENTRYPOINT ["python3"]
CMD ["app.py"]
```

```console
$ docker build -t flask_oauth .
$ docker run -d -p 5000:5000 flask_oauth
```

Open browser at https://127.0.0.1:5000

![](/screenshots/docker-flask.png)

# Kubernetes

1. Create you account in docker hub and push your image here.

```console
$ docker login
$ docker tag flask_oauth artharakiri/flask_oauth
$ docker push artharakiri/flask_oauth
```

2. Create a secret with GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET, so
they will be imported in your .env file.

```console
$ kubectl create secret generic google-id-secret \
--from-file=GOOGLE_CLIENT_ID=.env \
--from-file=GOOGLE_CLIENT_SECRET=.env
```

or use ``secret.yaml``

```console
$ kubectl apply -f secret.yaml
```

3. Create a deployment, using the image you pushed to the docker
hub. You may skip all the probes, but make sure to import environment
values from secret and don’t forget to specify a port for container.

4. Deploy your secret and deployment in k8s.

```console
$ kubectl apply -f deployment.yaml
```

5. Check whether you app is available inside the cluster: run
port-forwarding on your computer and open localhost:_port_(depending
on with port you’re exposing an application) in your browser.

For example:

```console
$ kubectl get po
NAME                               READY   STATUS    RESTARTS   AGE
flask-deployment-d667765f9-xm9ds   1/1     Running   0          13m
$ kubectl port-forward flask-deployment-d667765f9-xm9ds 5000:5000
```

![](/screenshots/port-forward.png)

Open https://localhost:5000

![](/screenshots/k8s-flask.png)