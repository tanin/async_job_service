# SUMMARY
  async_job_service - provides json API for processing async jobs
  - Deockerized development environment:
    - Rails 6.0.1
    - Redis
    - Sidekiq
    - Postgres

  Utilizes DDD/CQRS/Event Source patterns

  - Flow:
    * Controller receves the request (GET to meet the requirements, should be POST actually)
    * Controller calls run job command (Commands::RunJob)
    * Command validates parameters
    * Command handler (CommandHandlers::RunJob) initializes aggregate root (RunJob)
    * Command handler executes action method from the aggregate root instance
    * Aggregate root (Domain::RunJob) object applying the corresponding event
      (Events::EmailReceived)
    * Aggregate root fails if appropriate worker does not exist on the queue
    * Command publishes event (enqueues message) and stores aggregate root

    *********************

    * ActiveJob asynchronous dispatcher reads message (event) and dispatches it to subscribers
    * Subscribers or/and Denormalizers in our case, are processing the event and
      storing record in DB

    * if failed fires an event and changes aggregate root state

# PREREQUISITES
  * `brew cask install virtualbox`
  * `brew cask install docker`
  * `brew install docker-machine docker`
  * `docker-machine create --driver virtualbox default`
  * export the Docker environment variables to your shell:
    `eval "$(docker-machine env default)"`
  * `brew install docker-compose`

# INSTALL AND RUN:
  * `git clone git@github.com:tanin/async_job_service.git`
  * `cd async_job_service`
  * `docker-compose run web env`
  * `docker-compose build`
  * `docker-compose run web rake db:create db:setup`
  * `docker-compose run web rake` # run spec
  * `docker-compose up`

# API:
  - Console:

      when docker is up: (check `docker ps`)

      `docker exec -it $( docker ps | grep async_job_service_web | awk "{print \$1}" | head -n 1 ) rails c`

      ```ruby```
      include Commands::Execute
      uid = Digest::MD5.hexdigest('123')
      cmd = Commands::RunJob.new(uid: uid, queue_name: 'email', state: 'status', data: { status: 'received', id: 125 })
      execute(cmd)
      ```

  - post/(get - disscuss): '/:queue_name/:id/status' (http://domain/email/:EMAIL_ID/status?status=received)

