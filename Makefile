docker-build:
	docker-compose build

docker-run-tests:
	rm -rf results
	mkdir -p results
	docker-compose run --rm -p 50000:50000 e2etests $(SH)

docker-run-tests-it:
	make docker-run-tests SH=sh

help: help-docker-build help-docker-run-tests help-docker-run-tests-it

help-docker-build:
	@echo "\n\033[0;34mmake docker-build\033[0m\n"
	@echo "Will build a docker image base on content described into docker-compose.yml"
	@echo "This image will be used by script 'docker-run-tests' and 'docker-run-tests-it'\n"

help-docker-run-tests:
	@echo "\033[0;34mmake docker-run-tests\033[0m\n"
	@echo "Will run built image by 'docker-build' in order to run test\n"
	@echo "It uses var env provided into .env file (same file that has been used by your local e2etests framework) and .env.docker.local\n"

help-docker-run-tests-it:
	@echo "\033[0;34mmake docker-run-testsit\033[0m\n"
	@echo "It run script 'docker-run-tests' in interactive mode with a shell\n"