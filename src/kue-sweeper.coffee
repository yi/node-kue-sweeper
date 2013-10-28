##
# kue-job-cleaner
# https://github.com/yi/node-kue-job-cleaner
#
# Copyright (c) 2013 yi
# Licensed under the MIT license.
##

p = require "commander"
redis = require "redis"
_ = require "underscore"
kue = require 'kue'
Job = kue.Job

## 更新外部配置
p.version('0.0.1')
  .option('-p, --port <n>', 'redis service port')
  .option('-h, --host [VALUE]', 'redis service host')
  .parse(process.argv)

kue.redis.createClient = ->

  client = redis.createClient(KUE_PORT, KUE_HOST)

  client.on "error",  (error) ->
    console.error "[kue-sweeper::redis::on error] #{error}"
    return

  client.on "reconnecting", (info) ->
    console.log "[kue-sweeper::redis::on ready] reconnecting to datastore... delay:#{info.delay}, attempt:#{info.attempt}"
    return

  client.on "end", ->
    console.error "[kue-sweeper::redis::on end] redis client end @ #{p.host}:#{p.port}"
    return

  client.on "ready", ->
    console.info "[kue-sweeper::redis::on ready] kue client is ready to monitor redis server @ #{p.host}:#{p.port}"
    return

  return client

# clear job once it completed
kue.createQueue().on 'job complete', (id) ->
  Job.get id, (err, job)->
    if err?
      console.warn "[kue-sweeper::on job completed] fail to get job: #{id}. error:#{err}"
      return

    console.log "[kue-sweeper::removeKueJob] job:#{job}"

    unless job? and _.isFunction(job.remove)
      console.error "[kue-sweeper::removeKueJob] bad argument, #{job}"
      return
    else
      job.remove()
    return

  return

# Prevent master process to exit on uncaught exception
process.on 'uncaughtException', (error) -> console.log "[kue-sweeper::uncaughtException] #{error}, stack:#{error.stack}"

console.info "[kue-sweeper::init] service is up for redis server @ #{p.host}:#{p.port}"


