FROM elasticsearch:5
RUN apt-get update && apt-get -y install cron
# Add crontab file in the cron directory
ADD crontab /etc/cron.d/simple-cron

# Add shell script and grant execution rights
ADD deleteoldindicies.sh /deleteoldindicies.sh
RUN chmod +x /deleteoldindicies.sh

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/simple-cron

ENV ES_JAVA_OPTS="-Des.path.conf=/etc/elasticsearch"

CMD ["-E", "network.host=0.0.0.0", "-E", "discovery.zen.minimum_master_nodes=1"]
