# Basketball Team Management Web App

## Overview
This web application was developed as part of the CS 340 course to manage basketball team data including players, statistics, teams, and games. It uses Node.js, Express, Handlebars, and MySQL to support full CRUD operations on the database.

## Features
- View and manage players, teams, games, and player statistics
- Add/edit/delete players and teams
- Track player statistics per game
- Responsive layout using Handlebars templates

## Technologies Used
- Node.js
- Express
- MySQL (MariaDB)
- Handlebars (hbs)
- CSS/HTML

## Project Structure
project-folder/
│
├── database/
│ └── db-connector.js # MySQL connection pool
│
├── views/
│ └── layouts/
│ └── main.hbs # Main layout for pages
│ ├── home.hbs # Home page
│ ├── teams.hbs # Teams table view
│ ├── players.hbs # Players table view
│ ├── games.hbs # Games table view
│ ├── teamplayers.hbs # Team-player relation view
│ ├── statistics.hbs # Game statistics view
│ └── playerstatistics.hbs # Player-specific stats view
│
├── public/
│ └── style.css # CSS styles
│
├── app.js # Express server setup and routes
├── package.json # Project dependencies
├── Group109DDL.sql # Database schema
├── Group109DMQ.sql # Data manipulation queries
├── Group109PL.sql # Sample population queries
└── README.md 

## Citations: 
Citation for db connector:
Date: 05/08/2025 
Adapted from Module 6 Exploration - Web App Technology Node.js section
Used base structure to create the db connector 
Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-web-application-technology-2?module_item_id=25352948


Citation for all the CSS:
Date: 04/10/2025
All original work
Source/Modified by: Alejandro Cervantes Flores, Nora Jacobi

Citation for main.hbs: 
Date: 05/08/2025 
Adapted from Module 6 Exploration - Web App Technology Node.js section
Used base structure for Handlebars templating. Added entity page names and other web info. 
Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-web-application-technology-2?module_item_id=25352948

Citation for games.hbs: 
Date: 05/08/2025 
Adapted from Module 6 Exploration - Web App Technology Node.js section
Used base structure for Handlebars templating. Original logic was added for my own entities pages.
Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-web-application-technology-2?module_item_id=25352948

Citation for home.hbs: 
Date: 05/08/2025 
Adapted from Module 6 Exploration - Web App Technology Node.js section
Used base structure for Handlebars templating. Original logic was added for my own entities pages.
Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-web-application-technology-2?module_item_id=25352948

Citation for players.hbs: 
Date: 05/08/2025 
Adapted from Module 6 Exploration - Web App Technology Node.js section
Used base structure for Handlebars templating. Original logic was added for my own entities pages.
Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-web-application-technology-2?module_item_id=25352948

Citation for playersstatistics.hbs: 
Date: 05/08/2025 
Adapted from Module 6 Exploration - Web App Technology Node.js section
Used base structure for Handlebars templating.
Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-web-application-technology-2?module_item_id=25352948

Citation for statistics.hbs: 
Date: 05/08/2025 
Adapted from Module 6 Exploration - Web App Technology Node.js section
Used base structure for Handlebars templating.
Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-web-application-technology-2?module_item_id=25352948

Citation for the following teamplayers.hbs: 
Date: 05/08/2025 
Adapted from Module 6 Exploration - Web App Technology Node.js section
Used base structure for Handlebars templating. Original logic was added for my own entities pages.
Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-web-application-technology-2?module_item_id=25352948

Citation for the teams.hbs:
Date: 05/08/2025 
Adapted from Module 6 Exploration - Web App Technology Node.js section
Used base structure for Handlebars templating.
Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-web-application-technology-2?module_item_id=25352948

Citation for all the route handler and setup code: 
Date: 05/08/2025 
Copied/Adapted from Module 6 Exploration - Web App Technology Node.js section
Used base structure for Express routing, db-connector, listener and Handlebars templating. Original logic was added for my own entities, routes, and CUD operations.
Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-web-application-technology-2?module_item_id=25352948
AI tools like copilot were used for general debugging
Summary of prompts:
Asked how to prevent inserting duplicate (PlayerID, StatisticID, GameID) tuples

Citation for all the CUD operations code: 
Date: 05/17/2025 
Adapted from Module 8 Exploration - Implementing CUD operations in your app
Used base structure for CUD operations.
Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25352968

Citation for the DDL:
Date: 04/28/2025
Adapted/Based on: Exploration - Creating ER Diagram MySQL Workbench
Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-creating-er-diagram-mysql-workbench

Citation for the DMQ:
Date: 05/08/2025
Adapted/Based on: bsg_sample_data_manipulation_queries.sql in Project Step 3 
Source URL: https://canvas.oregonstate.edu/courses/1999601/assignments/10006387?module_item_id=25352952

Citation for the PL:
Date: 05/12/2025
Adapted/Based on: Exploration: PL/SQL part 1, SP, View and Function, Exploration: PL/SQL part 2, Stored Procedures for CUD 
Source URL: 
https://canvas.oregonstate.edu/courses/1999601/pages/exploration-pl-slash-sql-part-1-sp-view-and-function?module_item_id=25352958
https://canvas.oregonstate.edu/courses/1999601/pages/exploration-pl-slash-sql-part-2-stored-procedures-for-cud?module_item_id=25352959