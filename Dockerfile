# Choosing Python 3.10 due to PythonAnywhere supporting this version
FROM python:3.10

# Install sqlite3 and bash (bash should be available by default, but just in case)
RUN apt-get update && apt-get install -y sqlite3 bash && apt-get install -y mariadb-client


# Set the working directory
WORKDIR /workspaces/CS50_SQL/

# Copy your project files into the container
COPY . .

# Install any Python dependencies if needed
# RUN pip install -r requirements.txt

# The default command to run when starting the container
CMD ["bash"]
