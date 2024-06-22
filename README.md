# MyApp Setup Guide
Welcome to my WeatherApp! Follow the instructions below to set up and run the application.
# Prerequisites
Ensure you have the following installed:
* Ruby
* Rails
* Bundler

# Setup Instructions
_**1. Install Dependencies**_

- Open your terminal and navigate to the project directory. Run the following command to install all the required gems:
```sh
bundle install
```

**_2.Migrate the Database_**

- Once the dependencies are installed, set up the database by running:

```sh
rake db:migrate
```
- After this command completes, you should see a message indicating that the database migrations were successful.

**_3. Start the Rails Server_**

- Finally, start the Rails server with the following command:

```sh
rails server -b 127.0.0.1 -p 3001 -e development
```
This will start the server on localhost at port 3001 in development mode.

# Stopping the Application
- To stop the server, go back to the terminal where the server is running and press:
```sh
Ctrl + C
```