# README for Docker-based Big Data Project

This project is designed to manage a big data environment using Docker, Hadoop, Apache Spark, and Jupyter Notebook. The Makefile provided automates several tasks such as starting and stopping Docker containers, updating environment variables, and interacting with HDFS.

## Table of Contents

1. [Requirements](#requirements)
2. [Makefile Targets](#makefile-targets)
3. [Architecture](#architecture)
4. [How to Setup](#how-to-setup)
5. [Check Services Status](#check-services-status)
5. [Connect Apache Hive to PowerBI in Windows](#connect-apache-hive-to-powerbi-in-windows)

## Requirements

- Docker and Docker Compose installed
- Apache Spark, Jupyter Notebook, and Hadoop containers setup
- Docker-based environment for running Spark jobs and Jupyter Notebooks
- A directory containing data to be processed (`./data_crawl`)
- Power BI on Windows for visualization

## Makefile Targets

### 1. `all`
Runs the `up` target and sets up Jupyter permissions. This is the default target when running `make`.

### 2. `push2hdfs`
Uploads the `data_crawl` directory to HDFS. It performs the following tasks:
- Copies `data_crawl` to the `namenode` container.
- Creates a `/user/root` directory in HDFS if it does not exist.
- Uploads `data_crawl` to `/user/root/` in HDFS.

### 3. `.update-env`
Updates the `.env` file with the current notebook directory path. The path to the Jupyter notebook directory (`NOTEBOOK_DIR`) is stored in the `.env` file.

### 4. `.jupyter-permission`
Sets the correct file permissions for the Jupyter Notebook workspace in the `pyspark-notebook` container. It ensures that the `jovyan` user has ownership of the `work` directory, allowing proper file access and modification.

### 5. `jupyter-token`
Retrieves the Jupyter Notebook server token. This is useful for accessing the Jupyter Notebook interface running inside the container.

### 6. `up`
- Updates the `.env` file using the `.update-env` target.
- Starts Docker Compose, which brings up the required containers (such as Spark and Jupyter Notebook).

### 7. `down`
Stops and removes the running Docker containers associated with the project.

## Architecture

   ![architecture](images/architecture.png) 

## How to Setup

1. **Start the environment:**
   To start the Docker containers, use the following command:
   ```bash
   make 
   ```
2. **Crawl data and Push data to HDFS:** 

   Dataset: https://www.kaggle.com/datasets/anukaggle81/top-100-crypto-currency-historical-dataset?fbclid=IwY2xjawJcrcRleHRuA2FlbQIxMAABHaxqeuSMh9T42Brh7yH5fESgCZ6IQvQX53OOrCtBYux2vNMRsjOf-YgHyg_aem_H6-qacApzr12dDKNW-2QvQ

   After the environment is up, download data from kaggle then save to data_crawl folder then upload the data_crawl directory to HDFS by running:
   ```bash
   make push2hdfs
   ```
3. **Access Jupyter Notebook:**
   To retrieve the Jupyter Notebook server token and access the interface, run:
   ```bash 
   make jupyter-token
   ```
4. **Stop the environment:**
   To stop all running Docker containers and services, use the following command:
   ```bash
   make down
   ```

## Check Services Status
   You can check the status of each running service in your Docker environment to ensure all components are up and running. This is important for troubleshooting or ensuring that all services are correctly started. The following steps outline how to check the status of the individual services.
1. **Check Docker Containers:** 
   Run the following command to check the status of all the containers:
   ```bash
   docker ps
   ```
   This will show a list of all running containers along with their status, ports, and names.
2. **Service-Specific Checks:** 
   To check the status of a specific service, use the following command:
- **Hadoop Namenode:**  
   To ensure the Hadoop namenode is running, check for the Namenode UI at: 
   [http://localhost:9870](http://localhost:9870). when the page loads, the namenode service is running.
   ![namenode](images/namenode.png) 

- **Hadoop Datanodes:**  
   To check the status of the Hadoop datanodes, you can visit the Hadoop Web UI at:  
   [http://localhost:9870/dfshealth.html#tab-datanode](http://localhost:9870/dfshealth.html#tab-datanode) to see the status of the datanodes.
   ![datanodes](images/datanodes.png) 

- **Hadoop ResourceManager:**  
   To verify the ResourceManager service and nodemanager services, visit:  
   [http://localhost:8088/](http://localhost:8088/) in your browser. This will show the ResourceManager's status.
   ![resourcemanager](images/resourcemanager.png) 

- **Spark Master:**  
   You can check the Spark master status by going to:  
   [http://localhost:8080/](http://localhost:8080/). If it’s running, you’ll see the Spark Web UI.
   ![spark](images/spark.png) 

- **Hive Server:**  
   You can also check by connecting directly to the hive-server container and use the beeline command to interact with Hive:   
   ```bash
   docker exec -it hive-server /bin/bash
   beeline -u jdbc:hive2://localhost:10000
   ```
   ![hive](images/hive.png) 


- **Jupyter Notebook:**  
   To verify the Jupyter Notebook service, visit:
   [http://localhost:8888/](http://localhost:8888/). If it’s running, you’ll see the Jupyter Notebook Web UI.
   ![jupyter](images/jupyter.png) 

## Connect Apache Hive to PowerBI in Windows

Source: https://medium.com/emorphis-technologies/how-to-connect-microsoft-power-bi-with-hive-a778a1fdd234

1. **Download Hive OBDC Driver:**
   From this link: https://www.microsoft.com/en-us/download/details.aspx?id=40886
2. **Config ODBC:**
   
   Go to the Configure: 

   ![odbc-dsn](images/odbc-dsn.png) 

   Setup config:

   ![odbc-config](images/odbc-config.png) 

   Test:

   ![odbc-sucess](images/odbc-success.png) 

   Then Click to OK -> OK
3. **Connect to PowerBI:**
   
   PowerBI Home -> Get Data -> More -> Other -> ODBC -> Sample Microsoft Hive DSN -> OK

   ![powerbi-connected](images/powerbi-connected.png) 