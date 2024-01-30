#!/bin/bash

set -euo pipefail

K3S_TAG=${K3S_TAG:="v1.27.4-k3s1"} # replace + with -, if needed
IMAGE_REGISTRY=${IMAGE_REGISTRY:="localhost:5050"}
IMAGE_REPOSITORY=${IMAGE_REPOSITORY:="k3d-gpu-support"}
IMAGE_TAG="$K3S_TAG-cuda"
IMAGE=${IMAGE:="$IMAGE_REGISTRY/$IMAGE_REPOSITORY:$IMAGE_TAG"}

echo "IMAGE=$IMAGE"

# due to some unknown reason, copying symlinks fails with buildkit enabled
DOCKER_BUILDKIT=0 docker build \
  --build-arg K3S_TAG=$K3S_TAG \
  -t $IMAGE .
docker push $IMAGE

echo "Done!"
echo "To use this image, run:"
echo " sudo k3d cluster create gpu-cluster --image=$IMAGE --gpus 1 --registry-use k3d-deme-registry:5050 --registry-config local/registries.yml"