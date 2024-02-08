README

Welcome to the professional website of Maxime Oudin, Ruby On Rails fullstack web developer in Bordeaux, France.

System Dependencies
Before getting started, ensure you have installed the necessary system dependencies, such as PostgreSQL. You can install PostgreSQL using a package manager like apt (for Ubuntu) or Homebrew (for macOS):

# Installing PostgreSQL on Ubuntu
sudo apt-get install postgresql

# Installing PostgreSQL on macOS with Homebrew
brew install postgresql
Ruby Version
To manage Ruby versions, you can use tools like rbenv. Here's how you can install a specific Ruby version and set it as the global version:


# List available Ruby versions
rbenv install --list

# Install a new Ruby version (e.g., 3.2.3)
rbenv install 3.2.3

# Set the new version as the global version
rbenv global 3.2.3
Configuration
Ensure your local configuration is correctly set up, especially for PostgreSQL. Make sure the database connection information is correct in the config/database.yml file.

Database Creation
To create your PostgreSQL database, execute the following commands:


# Create the database
rails db:create

# Run migrations to create tables
rails db:migrate

# (Optional) Populate the database with initial data
rails db:seed
Deployment Instructions
To deploy your application to Heroku, follow these steps:


# Add and commit all necessary files to Git
git add .

# Create a commit with a descriptive message
git commit -m "Add features for production"

# Push your changes to your remote repository (GitHub, GitLab, etc.)
git push origin main

# Log in to Heroku
heroku login

# Create a new Heroku application
heroku create

# Push your code to Heroku
git push heroku main

# Run migrations on Heroku
heroku run rails db:migrate

# (Optional) Populate the database with initial data on Heroku
heroku run rails db:seed


Ensure your application has been properly configured to work with Heroku, including database configuration, secret keys, etc. Refer to Heroku documentation for specific instructions if needed.
