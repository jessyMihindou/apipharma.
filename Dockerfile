# pull the official base image
FROM python:3.10.11
RUN python --version
# set work directory
WORKDIR /usr/src/app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install system dependencies
RUN apt-get update && apt-get install -y curl

# install Rust and Cargo
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"docker run -d -p  5000:8000 apipharma:0.0.5

# install dependencies
RUN pip install --upgrade pip
COPY ./requirement.txt /usr/src/app
RUN pip install -r requirement.txt

# copy project
COPY . /usr/src/app

EXPOSE 8000

CMD ["python", "/usr/src/app/manage.py", "runserver","0.0.0.0:8000"]