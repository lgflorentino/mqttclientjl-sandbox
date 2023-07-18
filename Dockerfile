FROM julia:1.9-bookworm

RUN apt-get -y update && apt-get -y upgrade

RUN apt-get -y install \
        zsh \
        git

COPY . /app
WORKDIR /app/script

RUN julia -e "import Pkg; Pkg.activate(\".\"); Pkg.instantiate();"
