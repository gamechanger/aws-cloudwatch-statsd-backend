# StatsD backend for AWS CloudWatch

## Overview

[StatsD](https://github.com/etsy/statsd) is a smart Node.js package that collects and aggregates statistics from differents apps sent over the UDP protocol. At a set time interval it forwards the aggregated data to a configured backend. It is pluggable with several backends available, the most popular being [Graphite](https://github.com/graphite-project/graphite-web), a python/django monitoring tool.

With **aws-cloudwatch-statsd-backend** you can replace Graphite in favour of [AWS Cloudwatch](http://aws.amazon.com/cloudwatch/) for your monitoring purposes, appropriate for sites on the Amazon EC2 cloud.

Counters, timers, gauges and sets are all supported.

## Installation

You need node.js installed on your system aswell as StatsD. Follow the instructions on their sites or see this [blog post/tutorial](http://blog.simpletask.se/post/aggregating-monitoring-statistics-for-aws-cloudwatch) on how to install these components on a Windows system.

The CloudWatch backend is an npm package that can be installed with the npm command which comes with your installation of node.js. Go to the [npm site](https://npmjs.org/) for more information.

    npm install aws-cloudwatch-statsd-backend

The package has two depdencies that should be installed automatically, [awssum](https://npmjs.org/package/awssum) and [fmt](https://npmjs.org/package/fmt). Awssum is a node.js package encapsulating the AWS API.

## Configuration

The StatsD and its backends are configured in a json object placed in a file supplied to StatsD at the command line. For example, start StatsD with the following.

    node ./stats.js ./myConfig.js

The following demonstrates the minimum config for the CloudWatch backend.

    {
        backends: [ "aws-cloudwatch-statsd-backend" ],
        cloudwatch:
        {
            accessKeyId: 'YOUR_ACCESS_KEY_ID',
            secretAccessKey:'YOUR_SECRET_ACCESS_KEY',
            region:"YOUR_REGION"
        }
    }

The access keys can be you personal credentials to AWS but it is highly recommended to create an ad hoc user via Amazon's IAM service and use those credentials.

The region is for example eu-west-1 or us-east-1.

The above will create a metric with the default namespace, AwsCloudWatchStatsdBackend, and send an http request to CloudWatch via awssum.

See the CloudWatch [documentation](http://docs.amazonwebservices.com/AmazonCloudWatch/latest/DeveloperGuide/cloudwatch_concepts.html) for more information on these concepts.

The metric name, unit and value depends on what you send StatsD with your UDP request. For example, given

    gorets:1|c

the Unit will be Counter, the metric name gorets. The value will be the aggregated count as calculated by StatsD.

*ms* corresponds the unit *Milliseconds*. *s and *g* to *None*.

**Warning** Indescriminate use of CloudWatch metrics can quickly become costly. Amazon charges 50 cents for each combination of namepace, metric name and dimension per month. However, the 10 first per month are free.

## Additional configuration options

The cloudwatch backend provides ways to override the name and namespace by cofiguration. It can also capture these components from the bucket name.

The following overrides the default and any provided namespace or metric name with the specified.

    {
        backends: [ "aws-cloudwatch-statsd-backend" ],
        cloudwatch:
        {
            accessKeyId: 'YOUR_ACCESS_KEY_ID',
            secretAccessKey: 'YOUR_SECRET_ACCESS_KEY',
            region: 'YOUR_REGION',
            namespace: 'App/Controller/Action',
            metricName: 'Request'
        }
    }

Using the option *processKeyForNamespace* (default is false) you can parse the bucket name for namespace, as well as add dimensions for your metric.
Namespace and metric name are split using `.`, and are split from the section for dimensions
with the sequence `_._`.  Dimensions are split using `.`, with dimension names preceding their values.

    {
        backends: [ "aws-cloudwatch-statsd-backend" ],
        cloudwatch:
        {
            accessKeyId: 'YOUR_ACCESS_KEY_ID',
            secretAccessKey: 'YOUR_SECRET_ACCESS_KEY',
            region: 'YOUR_REGION',
            processKeyForNamespace:true
        }
    }

For example, sending StatsD the following

    App-Controller-Action.Request_._AutoScalingGroupName.web:1|c

Will produce:
 * namespace `App-Controller-Action`
 * metric name `Request`
 * dimensions `[{Name: 'AutoScalingGroupName', Value: 'web'}]

## Whitelisting Metrics

Using cloudwatch will incur a cost for each metric sent. In order to control your costs, you can optionally whitelist (by full metric name) those metrics sent to cloudwatch. For example:

    {
        backends: [ "aws-cloudwatch-statsd-backend" ],
        cloudwatch:
        {
            accessKeyId: 'YOUR_ACCESS_KEY_ID',
            secretAccessKey: 'YOUR_SECRET_ACCESS_KEY',
            region: 'YOUR_REGION',
            whitelist: ['YOUR_FULL_METRIC_NAME']
        }
    }

The above configuration would only sent the metric named 'YOUR_FULL_METRIC_NAME' to cloudwatch. As this is an array, you can specify multiple metrics. This is useful if you are using multiple backends e.g. mysql backend and want to send some metrics cloudwatch (due to the associated cost) and all the metrics together to another backend. It is also useful if you want to limit the metrics you use in cloudwatch to those that raise alarms as part of your wider AWS hosted system.

## Tutorial

This project was launched with a following [blog post/tutorial](http://blog.simpletask.se/post/aggregating-monitoring-statistics-for-aws-cloudwatch) describing the implementation chain from log4net to Cloudwatch on a Windows system.

Also in the series:

[Improving the CloudWatch Appender](http://blog.simpletask.se/post/improving-cloudwatch-appender)

[A CloudWatch Appender for log4net](http://blog.simpletask.se/post/awscloudwatch-log4net-appender)

[![endorse](http://api.coderwall.com/camitz/endorsecount.png)](http://coderwall.com/camitz)
