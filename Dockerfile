FROM debian:buster

RUN apt-get update && apt-get install -y wget \
    curl \
    gnupg \
    apt-transport-https

RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -

RUN echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list

RUN apt-get update && apt-get install elasticsearch

RUN chown -R elasticsearch:elasticsearch /usr/share/elasticsearch

USER elasticsearch

WORKDIR /usr/share/elasticsearch/bin

EXPOSE 9200 9300

ENTRYPOINT [ "./elasticsearch" ]
