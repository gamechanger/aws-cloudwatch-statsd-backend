FROM docker.gamechanger.io/nodejs0.10
MAINTAINER Jordan Singleton <jordan@gc.com>

ADD . /gc/aws-cloudwatch-statsd-backend
RUN npm install statsd@0.7.2
RUN npm install /gc/aws-cloudwatch-statsd-backend

ADD cloudwatchStatsDConfig.js /cloudwatchStatsDConfig.js

EXPOSE 8125/udp

CMD node /node_modules/statsd/bin/statsd /cloudwatchStatsDConfig.js
