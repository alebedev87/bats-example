# Setup Job base images

## Helm
Installs or upgrades a single Helm chart.

### Input
Arguments can be passed as environment variables, see [entrypoint comment](https://rndwww.nce.amadeus.net/git/projects/ACSPB/repos/setupjob-base-images/browse/bin/helm/helm-entrypoint.sh#4).

### Usage
You can see the examples of how to use the Helm base image [here](https://rndwww.nce.amadeus.net/git/projects/ACS51/repos/helm-subscription-operator/browse/setupjob/Dockerfile.setupjob) or [there](https://rndwww.nce.amadeus.net/git/projects/ACSPB/repos/gcr-seed/browse/image/Dockerfile).

### Image
Repository: `dockerhub.rnd.amadeus.net:5000`    
Image name: `acs_sre/setupjob-base-images`      
Image version: see the build number on the master branch
