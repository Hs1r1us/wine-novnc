build:
	docker build -t wine-novnc .

run: build
	docker run --rm -p 18080:8080 wine-novnc

shell: build
	docker run --rm -ti -p 18080:8080 wine-novnc bash
