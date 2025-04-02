push2hdfs:
	docker cp ./data_crawl namenode:data_crawl
	docker exec namenode sh -c 'hdfs dfs -test -d /user/root || (echo "Creating /user/root in HDFS..." && hdfs dfs -mkdir -p /user/root)'
	docker exec namenode hdfs dfs -put data_crawl /user/root/

.jupyter-work:
	docker exec -u 0 -it pyspark-notebook chown -R jovyan work
jupyter: .jupyter-work
	docker exec -it pyspark-notebook jupyter server list

compose-up:
	docker-compose up -d
compose-down:
	docker-compose down