# Constants
image=paper/dreyeve
volume=/home/javier/DREYEVE_MAFT

# Args
action=$1

# Argument handling
if [ -z "$1" ]
  then
    printf "
Usage: ./environment-manager.sh action\n
Action must be one of the following: build, run, stop, clean.\n
"
    exit 1
fi

# Functions
case $action in
  build)
    sudo docker build \
      -t ${image} \
      --build-arg USER_NAME=$(whoami) \
      --build-arg USER_ID=$(id -u) \
      --build-arg GROUP_NAME=$(getent group $(id -g) | cut -d: -f1) \
      --build-arg GROUP_ID=$(id -g) \
      .
    ;;
  run)
    # Run service with nvidia-docker (--gpus all)
    # Only mount data and code folders (avoid docker to install as user in shared .pip)
    # Mount credential files to enable 'sudo pip3.6 install ...'
    sudo docker run -it --gpus all \
      -v ${volume}:${volume} \
      -v /etc/passwd:/etc/passwd:ro \
      -v /etc/group:/etc/group:ro \
      -v /etc/shadow:/etc/shadow:ro \
      ${image}
    ;;
  stop)
    sudo docker ps -a | awk '{ print $1,$2 }' | grep ${image} | awk '{ print $1 }' | xargs -I {} sudo docker stop {}
    ;;
  clean)
    sudo docker ps -a | awk '{ print $1,$2 }' | grep ${image} | awk '{ print $1 }' | xargs -I {} sudo docker rm {}
    ;;
  *)
    printf "\nUnknown action argument.\n\n"
    ;;
esac