FROM predictionio/pio:0.13.0
# Enviroment Vars
ENV BASIC_REC_HOME /templates/basic-recommender
# Default ENV vars for BasicRecommender
ENV BASIC_REC_WARM_UP_DELAY 30
ENV BASIC_REC_DEFAULT_ACCESSKEY 8a99c64d820a742083712f3b58b09c2d1fce3a4c3e333c42c8100c4b351d2e9b
ENV BASIC_REC_TRAIN_DEPLOY_STEPS_SKIPPED 2
ENV BASIC_REC_SPARK_MASTER spark://localhost:7077
ENV BASIC_REC_DRIVER_MEM 4G
ENV BASIC_REC_EXECUTOR_MEM 4G

# Install 
USER root
# Install Python pip
RUN apt-get update && apt-get install -y \
    python-pip
RUN pip install predictionio

# Install mysql conncetor, if we ue mysql:
ENV MYSQL_JAR_FILE=$PIO_HOME/lib/mysql-connector-java-$MYSQL_VERSION.jar
RUN curl -o $MYSQL_JAR_FILE http://central.maven.org/maven2/mysql/mysql-connector-java/$MYSQL_VERSION/mysql-connector-java-$MYSQL_VERSION.jar

# Add cron, for cases, when a cronjob should be run
RUN apt-get update && apt-get -y install cron

WORKDIR /
ADD /basic-recommender /templates/basic-recommender
WORKDIR ${BASIC_REC_HOME}

# Build the engine, so its faster when run via docker
RUN pio build

ADD bin/entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod 0777 /usr/bin/entrypoint.sh

RUN chmod 0777 /usr/bin/pio_run

ADD /crontab /etc/cron.d/custom-cron
RUN chmod 0644 /etc/cron.d/custom-cron
RUN crontab /etc/cron.d/custom-cron

ADD bin/training_and_deploy.sh /usr/bin/training_and_deploy.sh
RUN chmod 0777 /usr/bin/training_and_deploy.sh

CMD ["sh", "/usr/bin/entrypoint.sh"]
ENTRYPOINT ["sh", "/usr/bin/entrypoint.sh"]