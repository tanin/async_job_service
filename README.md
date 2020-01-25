async_job_service - provides json API for processing async jobs

# PREREQUISITES
  * `brew cask install virtualbox`
  * `brew install docker docker-machine`
  * `docker-machine create --driver virtualbox default`
  * export the Docker environment variables to your shell:
    `eval "$(docker-machine env default)"
  * `brew install docker-compose

# INSTALL AND RUN:
  * git clone git@github.com:tanin/async_job_service.git
  * cd async_job_service
  * 

# API:
  * GET: '/:queue_name' (http://domain/email/:EMAIL_ID/status?status=recived)

  - controller:
    queues


