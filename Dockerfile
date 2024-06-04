# Choosing Python 3.10 due to PythonAnywhere supporting this version
FROM python:3.10

# Install sqlite3
RUN apt-get update && apt-get install -y sqlite3

# Set the working directory
WORKDIR /workspaces/CS50_SQL/cyberchase

# Copy your project files into the container
COPY . .

# Install any Python dependencies if needed
# RUN pip install -r requirements.txt

# The default command to run when starting the container
CMD ["bash"]



# Old version for Django development
#FROM python:3.10 
#COPY .  /usr/src/app
#WORKDIR /usr/src/app
#RUN pip install -r requirements.txt
#CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]

# Build docker container image: "docker build kontener ."
# Execute container with directory mounted as in docker-compose: "docker run -v ${pwd}:/usr/src/app -p 8000:8000 kontener"Dockerfile copy for django project
