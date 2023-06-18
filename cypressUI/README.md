Step 1: Prerequisites
Make sure you have Node.js installed on your machine. Cypress requires Node.js version 14 or above. You can check your Node.js version by running the command node -v in your terminal.

Step 2: Create a new project
Create a new directory for your project and navigate to it in your terminal.

Step 3: Initialize a new Node.js project
Run the following command to initialize a new Node.js project:
npm init -y

This command will create a package.json file in your project directory.

Step 4: Install Cypress
Run the following command to install Cypress as a dev dependency in your project:
npm install cypress --save-dev

This command will download and install Cypress and its dependencies into your project's node_modules folder.
tep 5: Open Cypress
Once the installation is complete, you can open Cypress by running the following command:
npx cypress open

This command will open the Cypress Test Runner. Cypress will create a default test directory structure and configuration files.

Step 6: Run sample tests
npx cypress run --browser chrome --headed
