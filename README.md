## SUMMARY
  async_job_service - provides json API for processing async jobs
  - Deockerized development environment:
    - Rails 6.0.1
    - Redis
    - Sidekiq
    - Postgres

  Utilizes DDD/CQRS/Event Source patterns

  - Flow:
    * Controller receives the request (GET to meet the requirements, should be POST actually)
    * Controller calls run job command (`Commands::RunJob`)
    * Command validates parameters
    * Command handler (`CommandHandlers::RunJob`) initializes aggregate root (`Domain::RunJob`)
    * Command handler executes action method from the aggregate root instance
    * Aggregate root (`Domain::RunJob`) object applying the corresponding event
      (`Events::EmailReceived`)
    * Aggregate root fails if corresponding worker does not exist on the queue
      (event does not exist)
    * Command publishes event (enqueues message) and stores aggregate root

    *********************

    * ActiveJob asynchronous dispatcher reads message (event) and dispatches it to subscribers
    * Subscribers or/and Denormalizers in our case, are processing the event and
      storing record in DB

    * if failed - fires `JobFailed` event
    * `Services::JobFail` service calls fail job command (`Commands::FailJob`)
    * Commad handler updates aggregate root state to error

## PREREQUISITES
  * `brew cask install virtualbox`
  * `brew cask install docker`
  * `brew install docker-machine docker`
  * `docker-machine create --driver virtualbox default`
  * export the Docker environment variables to your shell:
    `eval "$(docker-machine env default)"`
  * `brew install docker-compose`

## INSTALL AND RUN:
  * `git clone git@github.com:tanin/async_job_service.git`
  * `cd async_job_service`
  * `docker-compose run web env`
  * `docker-compose build`
  * `docker-compose run web rake db:create db:setup`
  * `docker-compose run web rake` # run spec
  * `docker-compose up`

## API:

### Console:
  When docker is up: (check `docker ps`)

  `docker exec -it $( docker ps | grep async_job_service_web | awk "{print \$1}" | head -n 1 ) rails c`

  ```ruby
  include Commands::Execute
  uid = Digest::MD5.hexdigest('123')

  cmd = Commands::RunJob.new(
    uid: uid,
    queue_name: 'email',
    state: 'status',
    data: { status: 'received', id: 123 }
  )

  execute(cmd)
  ```

### Web
  `curl http://localhost:3000/email/700/status?status=received`

  `docker exec -it $( docker ps | grep async_job_service_web | awk "{print \$1}" | head -n 1 ) rails c`
  ```ruby
    Email.all
  ```
### Sidekiq
  http://localhost:3000/sidekiq

## NEW WORKER ADDITION
  - add new event in `app/lib/events.rb` (`EmailSent`, `PostCreated`, `UrlCrawled` etc)
  - add new denormalizer for storing data or service for more complicated processing
    * `app/lib/denormalizers/`
    * `app/lib/services/`
  - subscribe to event in `config/initializers/rails_event_store.rb`

## NOTES:
  - This is a development evironment, passwords for sidekiq and postgres not set
  - .env file committed for simplicity and does not contains any sensitive data

  - TODO:
    * extract Jobs namespace to allow more domains to be added
    * add custom logger
    * change current GET request to POST
    * refactor parameters handling for POST request

