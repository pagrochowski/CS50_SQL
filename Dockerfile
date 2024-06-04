# Choosing Python 3.10 due to PythonAnywhere supporting this version
FROM python:3.10 
COPY .  /usr/src/app
WORKDIR /usr/src/app
RUN pip install -r requirements.txt
CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]

# Build docker container image: "docker build kontener ."
# Execute container with directory mounted as in docker-compose: "docker run -v ${pwd}:/usr/src/app -p 8000:8000 kontener"Dockerfile copy for django project