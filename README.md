# symfony4-docker-kickstarter
A Symfony 4 fresh installed project with a fully operational **docker-compose** / **docker-sync** environnement and its `Makefile` to make life easier.

## prerequisites : 
 * Install docker : https://docs.docker.com/compose/install/#install-compose 
 * Install docker-sync `gem install docker-sync`
 * Clone this repo
 * Copy `.env.dist` to `.env`
 * Change `COMPOSE_PROJECT_NAME` in `.env` project to fit yours.
 * Run `make install` in project's root
 * Add a rule in your hosts file to reach the `{COMPOSE_PROJECT_NAME}.docker` domain. For example `myapp.docker     127.0.0.1` 
 
 

 
