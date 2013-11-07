# kue-sweeper
a simple nodejs service to avoid memory leaking when use kue to process millions of jobs by removing kue job immediately upon its completion

## Why need this module:
[kue](https://npmjs.org/package/kue) is a handy redis-backed job processing module. But when using kue for processing millions of jobs, we have met following circumstances incuring memory leaking.

 * [job related search sets remain in redis after job got removed](https://github.com/learnboost/kue/issues/94)
 * Job handling service crash causes job pilling in redis

So I wrote this little tool to run as a standalone service which will keep watching kue and remove kue job immediately upon its completion

## Install
Install the module with:

```bash
npm install kue-job-cleaner
```

## Usage
```bash
# start kue-sweeper with forever
forever-start-kue-sweep.sh
```

## Configure

 * -p --port <n>, redis service port
 * -h, --host [VALUE], redis service host

## License
Copyright (c) 2013 yi
Licensed under the MIT license.
