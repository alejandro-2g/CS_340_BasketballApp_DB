// ########################################
// ########## SETUP

// Express
const express = require('express');
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

const PORT = 5330 ;

// Database
const db = require('./database/db-connector');

// Handlebars
const { engine } = require('express-handlebars'); // Import express-handlebars engine
app.engine('.hbs', engine({ extname: '.hbs' })); // Create instance of handlebars
app.set('view engine', '.hbs'); // Use handlebars engine for *.hbs files.

// ########################################
// ########## ROUTE HANDLERS

// READ ROUTES

//for home 
app.get('/', async function (req, res) {
    try {
        res.render('home'); // Make sure you have a views/home.hbs file
    } catch (error) {
        console.error('Error rendering homepage:', error);
        res.status(500).send('Failed to load homepage.');
    }
});
//for players
app.get('/players', async function (req, res) {
    try {
        const query = 'SELECT * FROM Players;';
        const [players] = await db.query(query);
        res.render('players', { players });
    } catch (error) {
        console.error('Error executing query for Players:', error);
        res.status(500).send('Error loading Players page.');
    }
});

//for teams
app.get('/teams', async function (req, res) {
    try {
        const [teams] = await db.query('SELECT * FROM Teams;');
        res.render('teams', { teams });
    } catch (err) {
        res.status(500).send('Error loading Teams page');
    }
});

//for games
app.get('/games', async function (req, res) {
    try {
        const [games] = await db.query('SELECT * FROM Games;');
        res.render('games', { games });
    } catch (err) {
        res.status(500).send('Error loading Games page');
    }
});

//for statistics
app.get('/statistics', async function (req, res) {
    try {
        const [statistics] = await db.query('SELECT * FROM Statistics;');
        res.render('statistics', { statistics });
    } catch (err) {
        res.status(500).send('Error loading Games page');
    }
});

//for playerstatistics
app.get('/playerstatistics', async function (req, res) {
    try {
        const [playerstatistics] = await db.query('SELECT * FROM PlayerStatistics;');
        res.render('playerstatistics', { playerstatistics });
    } catch (err) {
        res.status(500).send('Error loading Games page');
    }
});

//for team players
app.get('/teamplayers', async function (req, res) {
    console.log("GET /teamplayers route hit");  
    try {
        const query = `
            SELECT 
                t.TeamName,
                CONCAT(p.FirstName, ' ', p.LastName) AS PlayerName
            FROM TeamPlayers tp
            JOIN Teams t ON tp.TeamID = t.TeamID
            JOIN Players p ON tp.PlayerID = p.PlayerID
            ORDER BY t.TeamName, PlayerName;
        `;
        const [teamplayers] = await db.query(query);
        res.render('teamplayers', { teamplayers });
    } catch (err) {
        console.error('Error loading TeamPlayers page:', err);
        res.status(500).send('Error loading TeamPlayers page');
    }
});




// ########################################
// ########## LISTENER

app.listen(PORT, function () {
    console.log(
        'Express started on http://localhost:' +
            PORT +
            '; press Ctrl-C to terminate.'
    );
});