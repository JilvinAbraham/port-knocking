# Port Knocking Setup with Docker

This repository contains a Dockerfile and configuration for setting up a simple web server with port knocking on Ubuntu using `nginx` and `knockd`. Port knocking is a method used to dynamically open ports on a firewall by "knocking" on a predefined sequence of closed ports.

## Prerequisites

- Docker installed on your local machine.

## Setup

### 1. Clone the Repository

```bash
git clone https://github.com/JilvinAbraham/port-knocking.git
cd port-knocking
```

### 2. Build the Docker Image

```bash
docker build -t port-knocking .
```

### 3. Run the Docker Container

```bash
docker run -d --name port-knocking-container -p 7000:7000 -p 8000:8000 -p 9000:9000 -p 8001:8001 port-knocking
```

### 4. Verify the Web Server is Initially Inaccessible

Try accessing the web page at [http://localhost:8001](http://localhost:8001). It should not be accessible initially.

```bash
curl http://localhost:8001
# Should not return the web page content
```

### 5. Perform the Port Knocking Sequence to Open the Port

Execute the following `knock` commands in sequence:

```bash
knock localhost 7000:tcp 8000:tcp 9000:tcp
```

After performing the knock sequence, the port should open and the web page should be accessible.

### 6. Verify the Web Server is Accessible

Try accessing the web page again at [http://localhost:8001](http://localhost:8001).

```bash
curl http://localhost:8001
# Should return the web page content
```

### 7. Perform the Knock Sequence to Close the Port

To close the port, execute the following `knock` command:

```bash
knock localhost 9000:tcp 8000:tcp 7000:tcp
```

After performing this sequence, the port should be closed again.

### 8. Verify the Web Server is Inaccessible

Try accessing the web page once more at [http://localhost:8001](http://localhost:8001). It should not be accessible.

```bash
curl http://localhost:8001
# Should not return the web page content
```

## Configuration Files

### Dockerfile

This Dockerfile sets up an Ubuntu container with `nginx` and `knockd` installed. It also configures `nginx` to serve a simple web page on port 8001 and sets up the `knockd` configuration.

### knockd.conf

The `knockd.conf` file contains the port knocking configuration. It specifies the sequences for opening and closing the port 8001.
