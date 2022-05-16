from ubuntu:20.04

RUN apt-get update
RUN apt-get install -y \
                curl \
                git \
                openssh-client

RUN curl -fsSL https://code-server.dev/install.sh | sh

EXPOSE 8080

RUN mkdir -p /vscode/data

ADD config.yaml /vscode/config.yaml

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /vscode/repos

ENTRYPOINT ["/entrypoint.sh"]
CMD [ "code-server", "--bind-addr", "0.0.0.0:8080", "--config", "/vscode/config.yaml", "--user-data-dir", "/vscode/data"]

# docker build -t coder .
# docker run -it --rm --init -p 8080:8080 -v $(pwd)/docker-data/codeserver:/vscode/data -v $(pwd)/docker-data/repos:/vscode/repos --env-file codeserver.env --name coder coder
# docker-compose up
