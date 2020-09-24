build:
	docker build -t tadayosi/artemis:latest .

run:
	docker run --rm -d -p 8161:8161 -p 8778:8778 -p 61616:61616 --name artemis tadayosi/artemis:latest

push:
	docker push tadayosi/artemis:latest

deploy-openshift:
	-oc delete dc/artemis
	oc run artemis --image=tadayosi/artemis:latest --image-pull-policy='Always'
	oc patch dc artemis -p '{"spec":{"template":{"spec":{"containers":[{"name":"artemis","ports":[{"containerPort":8161,"name":"console-jolokia","protocol":"TCP"},{"containerPort":8778,"name":"jolokia","protocol":"TCP"},{"containerPort":61616,"name":"artemis","protocol":"TCP"}]}]}}}}'
