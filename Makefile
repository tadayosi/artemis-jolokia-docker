build:
	docker build -t tadayosi/artemis:latest .

run:
	docker run --rm -d -p 8161:8161 -p 8778:8778 -p 61616:61616 --name artemis tadayosi/artemis:latest

push:
	docker push tadayosi/artemis:latest
