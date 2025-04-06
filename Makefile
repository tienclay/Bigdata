CURRENT_DIR := $(shell pwd)
NOTEBOOK_DIR := $(shell pwd)/notebook

all: up .jupyter-permission

push2hdfs:
	docker cp ./data_crawl namenode:data_crawl
	docker exec namenode sh -c 'hdfs dfsadmin -safemode leave || echo "Not in safe mode"'
	docker exec namenode sh -c 'hdfs dfs -test -d /user/root || (echo "Creating /user/root in HDFS..." && hdfs dfs -mkdir -p /user/root)'
	docker exec namenode hdfs dfs -put data_crawl /user/root/

.update-env:
	@echo "Updating .env file..."
	@echo "CURRENT_NOTEBOOK_DIR=$(NOTEBOOK_DIR)" > .env

.jupyter-permission:
	@echo "Setting up Permissions for Jupyter Notebook..."
	docker exec -u 0 -it pyspark-notebook chown -R jovyan work

jupyter-token:
	docker exec -it pyspark-notebook jupyter server list

up: .update-env 
	@echo "Starting Docker Compose..."
	CURRENT_NOTEBOOK_DIR=$(NOTEBOOK_DIR) docker compose up -d
	
down:
	@echo "Stopping Docker Compose..."
	docker compose down -v