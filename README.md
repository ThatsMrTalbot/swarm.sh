# swarm.sh

Some simple scripts to create a development swarm environment. This creates one swarm master and three workers.

## Usage

### Create a swarm

./swarm-start.sh 


### Stop & Delete

./swarm-stop.sh

### Cleanup (Usefull if an issue arises and the containers dont auto delete)

./swarm-clean.sh

### SSH onto a member

./swarm-ssh.sh [swarm-master|swarm-slave1|swarm-slave2|swarm-slave3]
