# Whisper ASR Web Service for Intel ARC / XPU

This repository provides a customized Whisper ASR web service that has been adapted to run on Intel ARC / XPU, enhancing the original [ahmetoner/whisper-asr-webservice](https://github.com/ahmetoner/whisper-asr-webservice). This service is designed to utilize the computational power of Intel's ARC / XPU hardware for improved performance.

## Components Utilized
The service employs several resources:
- It is constructed from Intel's [Dockerfile](https://github.com/intel/intel-extension-for-pytorch/tree/v2.0.110%2Bxpu/docker), it is modified for Intel ARC and Whisper's needs.
- It incorporates a [patched version of OpenAI Whisper](https://github.com/openai/whisper/pull/1362) provided by [@leuc](https://github.com/leuc), enabling it to run on Intel ARC / XPU systems.
- The base [ahmetoner/whisper-asr-webservice](https://github.com/ahmetoner/whisper-asr-webservice) is integrated and patched to be compatible with XPU during the Docker image build.

The Docker image is tested on Ubuntu with kernel version `6.2.0-34-generic #34~22.04.1`.

## Building and Running Using Docker
Ensure you have at least 25 GiB of disk space for the required dependencies. Remember to navigate to the directory containing a checkout of this repository before executing the docker build command.

### Docker Commands
```bash
# Build the Docker image
$ docker build -t arcxpu -f ./Dockerfile.arc-xpu .

# Run the Docker image
# It is crucial to specify the openai_whisper engine
# to activate ARC / XPU acceleration
$ docker run --device /dev/dri:/dev/dri -e ASR_MODEL=large -e ASR_ENGINE=openai_whisper -p 9000:9000 --name arcxpu arcxpu:latest
```

## Using Docker Compose
For convenience, `docker-compose.yml` is provided to simplify the build and run process.

### Docker Compose File
Here's an example of a `docker-compose.yml` for this service. It is crucial to specify the openai_whisper engine to activate ARC / XPU acceleration.

```yaml
version: '3.8'
services:
  arcxpu:
    build:
      context: https://github.com/Sikerdebaard/whisper-asr-webservice-xpu.git
      dockerfile: Dockerfile.arc-xpu
    image: arcxpu:latest
    ports:
      - "9000:9000"
    environment:
      - ASR_MODEL=large
      - ASR_ENGINE=openai_whisper
    devices:
      - "/dev/dri:/dev/dri"
    container_name: arcxpu
```

### Docker Compose Commands
```bash
# Build the image using Docker Compose
docker-compose build

# Run the container in detached mode
docker-compose up -d
```

With Docker Compose, the service will be accessible on port 9000 of the host machine. Remember to navigate to the directory containing your `docker-compose.yml` file before executing the Docker Compose commands.

## Further documentation
For further documentation and details on the original Whisper ASR Web Service, please refer to the official documentation at https://ahmetoner.com/whisper-asr-webservice/.
