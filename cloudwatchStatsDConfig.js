{
    backends: [ "aws-cloudwatch-statsd-backend" ],
    cloudwatch:
    {
        accessKeyId: process.env.AWS_ACCESS_KEY,
        secretAccessKey: process.env.AWS_SECRET_KEY,
        region: 'us-east-1',
        whitelist: ['ASGMetrics.ThreadUtilization'],
        processKeyForNamespace: true
    }
}
