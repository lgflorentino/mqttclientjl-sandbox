FROM julia:1.9-bookworm

RUN apt-get -y update && apt-get -y upgrade

RUN apt-get -y install \
        zsh \
        git

COPY . /sandbox

WORKDIR /sandbox/mqttclient.jl/
RUN julia -e "import Pkg; Pkg.activate(\".\"); Pkg.instantiate();"

WORKDIR /sandbox/script
RUN julia -e "import Pkg; Pkg.activate(\".\"); Pkg.instantiate();"

