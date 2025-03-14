README

Welcome to the professional website of Maxime Oudin, Ruby On Rails fullstack web developer in Bordeaux, France.

System Dependencies
Before getting started, ensure you have installed the necessary system dependencies, such as PostgreSQL. You can install PostgreSQL using a package manager like apt (for Ubuntu) or Homebrew (for macOS):

# Installing PostgreSQL
# Install Ruby rbenv
# Check and Install Gem Dependencies
After ensuring the correct Ruby version is set, you should check and install the gem dependencies for your project. This is done using Bundler, which reads the Gemfile and installs the specified gems. Run the following command in the root directory of your project:

bundle install
This command will install all the gems listed in your Gemfile along with their dependencies.

Configuration
Ensure your local configuration is correctly set up, especially for PostgreSQL. Make sure the database connection information is correct in the config/database.yml file.

Database Creation
To create your PostgreSQL database, execute the following commands:

# Create the database
rails db:create

# Run migrations to create tables
rails db:migrate


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

## TO LAUNCH sitemap from heroku console
heroku run rake sitemap:refresh
