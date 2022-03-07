# AllTrails Lunchtime Backend

The abstraction on top of Google Maps you never knew you needed!

## Local Development

### First Time Setup
Depedencies:
- Docker for Mac
- Docker Compose (should be installed automatically, but ensure it is present with `which docker-compose`)

Clone the repository locally, then run `cp .env.dist .env`. In the `.env` file, set the Google Maps API Key
env var. Then run `make workspace`. This will build and then drop you into a bash
session within the workspace container.

Next, **from within the workspace container**, run `bin/rails db:schema:load`. This will create a SQLite3
database with the latest state of the db, rather than iterating through migrations.

Run the command `exit` to stop the workspace container.

Now, **from outside the workspace**, run `make dev` to boot the web app. Next, run `make open` - you should a
Hello, World page in the browser confirming your app is running!

Finally, we need to create a User so that an API Key exists for authentication.

```bash
make workspace

# wait to be dropped in
rails console

# Wait for the REPL to open
User.create! email: "test", password: "test"
User.first.api_key.token # Copy this value
exit!

# Wait for the repl to close
exit
```

You now can begin interacting with the API! Open up Postman, and import from the `postman` directory in this repo
the `AllTrails Lunchtime.postman_collection.json` file. In the variables tab, replace the `auth` variable
with the API Key you copied above.

### General development

- `make dev`: starts the local web server in a detached state
- `make workspace`: opens a bash session in a separate, but identical container that is not running the web server
- `make logs`: a proxy command to `docker-compose logs -f`
- `make stop`: a proxy command to `docker-compose down`
- `make open`: opens the Chrome browser to the hello, world page

Any changes you make to files on your local machine, within the workspace, or within the running web app
will be synced across all three machines. When running rails, ruby or bundle commands, it is advised
that you do so from within the container to ensure the greatest environmental parity.

### Tests

There are unit tests for a good deal of the functionality in here. To run them, enter the workspace with
`make workspace` then simply run `rspec`.