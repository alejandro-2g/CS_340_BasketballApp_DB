//# Citation for all the route handler and setup code: 
//# Date: 05/08/2025 
//# Copied/Adapted from Module 6 Exploration - Web App Technology Node.js section
//# Used base structure for Express routing, db-connector, listener and Handlebars templating. Original logic was added for my own entities, routes, and CUD operations.
//# Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-web-application-technology-2?module_item_id=25352948
//# AI tools like copilot were used for general debugging
//# Summary of prompts:
//# Asked how to prevent inserting duplicate (PlayerID, StatisticID, GameID) tuples


// ########################################
// ########## SETUP########################

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
app.set('view engine', '.hbs'); 

// ########################################
// ########## ROUTE HANDLERS ##############


//for home 
app.get('/', async function (req, res) {
    try {
        res.render('home'); 
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

//for games — display all games and team names
app.get('/games', async (req, res) => {
  try {
    const [games] = await db.query(`
      SELECT GameID, Location, TeamAID, t1.TeamName AS TeamAName,
             TeamBID, t2.TeamName AS TeamBName, ScoreA, ScoreB,
             DATE_FORMAT(Date, '%Y-%m-%d') AS Date
      FROM Games
      JOIN Teams AS t1 ON TeamAID = t1.TeamID
      JOIN Teams AS t2 ON TeamBID = t2.TeamID;
    `);
    const [teams] = await db.query('SELECT * FROM Teams;');
    res.render('games', { games, teams });
  } catch (err) {
    console.error('Error loading /games route:', err);
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

// for playerstatistics — display all stats with player/game context
app.get('/playerstatistics', async (req, res) => {
  try {
    const [playerstatistics] = await db.query(`
      SELECT ps.PlayerID, ps.StatisticID, ps.GameID,
             CONCAT(p.FirstName, ' ', p.LastName) AS PlayerName,
             s.StatisticName AS StatName,
             CONCAT(DATE_FORMAT(g.Date, '%Y-%m-%d'), ' ', t1.TeamName, ' vs. ', t2.TeamName) AS GameInfo,
             ps.ValueOfStatistic
      FROM PlayerStatistics ps
      JOIN Players p ON ps.PlayerID = p.PlayerID
      JOIN Statistics s ON ps.StatisticID = s.StatisticID
      JOIN Games g ON ps.GameID = g.GameID
      JOIN Teams t1 ON g.TeamAID = t1.TeamID
      JOIN Teams t2 ON g.TeamBID = t2.TeamID;
    `);

    const [players] = await db.query(`
      SELECT PlayerID, CONCAT(FirstName, ' ', LastName) AS PlayerName FROM Players;
    `);

    const [statistics] = await db.query(`
      SELECT StatisticID, StatisticName FROM Statistics;
    `);

    const [games] = await db.query(`
      SELECT GameID, CONCAT(DATE_FORMAT(Date, '%Y-%m-%d'), ' ', t1.TeamName, ' vs. ', t2.TeamName) AS GameInfo
      FROM Games
      JOIN Teams t1 ON TeamAID = t1.TeamID
      JOIN Teams t2 ON TeamBID = t2.TeamID;
    `);

    res.render('playerstatistics', { playerstatistics, players, statistics, games });
  } catch (err) {
    console.error('ERROR in /playerstatistics route:', err);
    res.status(500).send('Error loading Player Statistics page');
  }
});


//for team players
app.get('/teamplayers', async function (req, res) {
    console.log("GET /teamplayers route hit");  
    try {
        const intersectQuery = `
            SELECT 
                t.TeamName,
                CONCAT(p.FirstName, ' ', p.LastName) AS PlayerName,
				tp.JerseyNumber,
				t.TeamID,
				p.PlayerID
            FROM TeamPlayers tp
            JOIN Teams t ON tp.TeamID = t.TeamID
            JOIN Players p ON tp.PlayerID = p.PlayerID
            ORDER BY t.TeamName, PlayerName;
        `;
        const [teamplayers] = await db.query(intersectQuery);

		const teamsOnlyQuery = `
			SELECT
				TeamID,
				TeamName
			FROM Teams;
		`
        const [teams] = await db.query(teamsOnlyQuery);

		const playersOnlyQuery = `
			SELECT PlayerID, CONCAT(FirstName, ' ', LastName) AS PlayerName FROM Players;`
        const [players] = await db.query(playersOnlyQuery);

        res.render('teamplayers', { teamplayers, teams, players });
    } catch (err) {
        console.error('Error loading TeamPlayers page:', err);
        res.status(500).send('Error loading TeamPlayers page');
    }
});

// for reset button
app.get('/reset', async function (req, res) {
  try {
    await db.query('CALL ResetPickupDB()');
    res.redirect('/'); // goes to home page
  } catch (err) {
    console.error('Error running ResetPickupDB:', err);
    res.status(500).send('Error resetting database');
  }
});


//# Citation for all the CUD operations code: 
//# Date: 05/17/2025 
//# Adapted from Module 8 Exploration - Implementing CUD operations in your app
//# Used base structure for CUD operations.
//# Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25352968


// ##################################################
// ################# Player CUD ######################

// for the add player form in players table
app.post('/players/add', async (req, res) => {
  try {
    const { FirstName, LastName, Position, SkillLevel } = req.body;

    // Use a session variable to capture the OUT param
    await db.query('SET @newPlayerID = 0');

    await db.query(
      'CALL sp_CreatePlayer(?, ?, ?, ?, @newPlayerID)',
      [FirstName, LastName, Position, SkillLevel]
    );
    res.redirect('/players');
  } catch (err) {
    console.error("Error adding player:", err);
    res.status(500).send("Error adding player");
  }
});

// for the delete player form
app.post('/players/delete', async (req, res) => {
    try {
        const { PlayerID } = req.body;
        await db.query('CALL sp_DeletePlayer(?)', [PlayerID]);
        res.redirect('/players');
    } catch (err) {
        console.error('Error deleting player:', err);
        res.status(500).send('Error deleting player');
    }
});

//update player form
app.post('/players/update', async function (req, res) {
    const { PlayerID, FirstName, LastName, Position, SkillLevel } = req.body;
    try {
        await db.query(
            'UPDATE Players SET FirstName=?, LastName=?, Position=?, SkillLevel=? WHERE PlayerID=?',
            [FirstName, LastName, Position, SkillLevel, PlayerID]
        );
        res.redirect('/players');
    } catch (error) {
        console.error('Error updating player:', error);
        res.status(500).send('Error updating player');
    }
});

// ##################################################
// ################# Team CUD ######################

// Create a team
app.post('/teams/add', async (req, res) => {
  try {
    const { TeamName, CoachName } = req.body;
    await db.query('INSERT INTO Teams (TeamName, CoachName) VALUES (?, ?)', [TeamName, CoachName]);
    res.redirect('/teams');
  } catch (err) {
    console.error("Error adding team:", err);
    res.status(500).send("Error adding team");
  }
});

// Update a team
app.post('/teams/update', async (req, res) => {
  try {
    const { TeamID, TeamName, CoachName } = req.body;
    await db.query('UPDATE Teams SET TeamName=?, CoachName=? WHERE TeamID=?', [TeamName, CoachName, TeamID]);
    res.redirect('/teams');
  } catch (err) {
    console.error("Error updating team:", err);
    res.status(500).send("Error updating team");
  }
});

// Delete a team
app.post('/teams/delete', async (req, res) => {
  try {
    const { TeamID } = req.body;
    await db.query('DELETE FROM Teams WHERE TeamID=?', [TeamID]);
    res.redirect('/teams');
  } catch (err) {
    console.error("Error deleting team:", err);
    res.status(500).send("Error deleting team");
  }
});
// ##################################################
// ################# Games CUD ######################

// Create a game
app.post('/games/add', async (req, res) => {
  try {
    const { Date, Location, TeamAID, TeamBID, ScoreA, ScoreB } = req.body;
    await db.query('INSERT INTO Games (Date, Location, TeamAID, TeamBID, ScoreA, ScoreB) VALUES (?, ?, ?, ?, ?, ?)', [Date, Location, TeamAID, TeamBID, ScoreA, ScoreB]);
    res.redirect('/games');
  } catch (err) {
    console.error("Error adding game:", err);
    res.status(500).send("Error adding game");
  }
});

// Update a game
app.post('/games/update', async (req, res) => {
  try {
    const { GameID, Date, Location, TeamAID, TeamBID, ScoreA, ScoreB } = req.body;
    await db.query('UPDATE Games SET Date=?, Location=?, TeamAID=?, TeamBID=?, ScoreA=?, ScoreB=? WHERE GameID=?', [Date, Location, TeamAID, TeamBID, ScoreA, ScoreB, GameID]);
    res.redirect('/games');
  } catch (err) {
    console.error("Error updating game:", err);
    res.status(500).send("Error updating game");
  }
});

// Delete a game
app.post('/games/delete', async (req, res) => {
  try {
    const { GameID } = req.body;
    await db.query('DELETE FROM Games WHERE GameID=?', [GameID]);
    res.redirect('/games');
  } catch (err) {
    console.error("Error deleting game:", err);
    res.status(500).send("Error deleting game");
  }
});

// ##################################################
// ################# Statistics CUD ######################

// Create a statistic
app.post('/statistics/add', async (req, res) => {
  try {
    const { StatisticName, Description } = req.body;
    await db.query('INSERT INTO Statistics (StatisticName, Description) VALUES (?, ?)', [StatisticName, Description]);
    res.redirect('/statistics');
  } catch (err) {
    console.error("Error adding statistic:", err);
    res.status(500).send("Error adding statistic");
  }
});

// Update a statistic
app.post('/statistics/update', async (req, res) => {
  try {
    const { StatisticID, StatisticName, Description } = req.body;
    await db.query('UPDATE Statistics SET StatisticName=?, Description=? WHERE StatisticID=?', [StatisticName, Description, StatisticID]);
    res.redirect('/statistics');
  } catch (err) {
    console.error("Error updating statistic:", err);
    res.status(500).send("Error updating statistic");
  }
});

// Delete a statistic
app.post('/statistics/delete', async (req, res) => {
  try {
    const { StatisticID } = req.body;
    await db.query('DELETE FROM Statistics WHERE StatisticID=?', [StatisticID]);
    res.redirect('/statistics');
  } catch (err) {
    console.error("Error deleting statistic:", err);
    res.status(500).send("Error deleting statistic");
  }
});

// ##################################################
// ########## Player Statistics CUD #################


// add player statistic
app.post('/playerstatistics/add', async (req, res) => {
  const { PlayerID, StatisticID, GameID, ValueOfStatistic } = req.body;

  try {
    // Insert into PlayerStatistics
    await db.query(
      'INSERT INTO PlayerStatistics (PlayerID, StatisticID, GameID, ValueOfStatistic) VALUES (?, ?, ?, ?)',
      [PlayerID, StatisticID, GameID, ValueOfStatistic]
    );

    res.redirect('/playerstatistics');
  } catch (err) {
    console.error("Error adding player statistic:", err);
    res.status(500).send("Error adding player statistic");
  }
});


app.post('/playerstatistics/update', async (req, res) => {
	const { PlayerStatisticsID, ValueOfStatistic } = req.body;

	try {
		const parts = PlayerStatisticsID.split(' ');
		const PlayerID = parts[0] || '';
		const StatisticID = parts[1] || '';
		const GameID = parts[2] || '';

		// Update PlayerStatistics entry
		await db.query(
			'UPDATE PlayerStatistics SET ValueOfStatistic = ? WHERE PlayerID = ? AND StatisticID = ? AND GameID = ?',
			[ValueOfStatistic, PlayerID, StatisticID, GameID]
		);

		res.redirect('/playerstatistics');
	} catch (err) {
		console.error("Error updating player statistic:", err);
		res.status(500).send("Error updating player statistic");
	}
});


// Delete a player statistic entry
app.post('/playerstatistics/delete', async (req, res) => {
  try {
    const { PlayerID, StatisticID, GameID } = req.body;
    await db.query('DELETE FROM PlayerStatistics WHERE PlayerID=? AND StatisticID=? AND GameID=?', [PlayerID, StatisticID, GameID]);
    res.redirect('/playerstatistics');
  } catch (err) {
    console.error("Error deleting player statistic:", err);
    res.status(500).send("Error deleting player statistic");
  }
});


// ##################################################
// ########## Team Player CUD #######################

// Add a player to a team
app.post('/teamplayers/add', async (req, res) => {
  try {
    const { TeamID, PlayerID, JerseyNumber } = req.body;
    // Insert into TeamPlayers
    await db.query('INSERT INTO TeamPlayers (TeamID, PlayerID, JerseyNumber) VALUES (?, ?, ?)', [TeamID, PlayerID, JerseyNumber]);

    res.redirect('/teamplayers');
  } catch (err) {
    console.error('Error adding player to team:', err);
    res.status(500).send('Error adding player to team');
  }
});


app.post('/teamplayers/update', async (req, res) => {
  const { TeamPlayerID, JerseyNumber } = req.body;

  const parts = TeamPlayerID.split(' ');
  const TeamID = parts[0] || '';
  const PlayerID = parts[1] || '';

  try {
    await db.query('UPDATE TeamPlayers SET JerseyNumber=? WHERE TeamID=? and PlayerID=?', [JerseyNumber, TeamID, PlayerID]);
    res.redirect('/teamplayers');
  } catch (err) {
      console.error('Error deleting team player:', err);
      return res.sendStatus(500);
  }
});

app.post('/teamplayers/update-names', async (req, res) => {
  const { CurrentTeamName, NewTeamName, CurrentPlayerName, NewPlayerName } = req.body;

  try {
    // Update the team name
    await db.query('UPDATE Teams SET TeamName = ? WHERE TeamName = ?', [NewTeamName, CurrentTeamName]);

    // Split new player name into first and last name (assuming names are separated by a space)
    const newPlayerNameParts = NewPlayerName.split(' ');
    const newFirstName = newPlayerNameParts[0] || '';
    const newLastName = newPlayerNameParts[1] || '';

    const currentPlayerNameParts = CurrentPlayerName.split(' ');
    const currentFirstName = currentPlayerNameParts[0] || '';
    const currentLastName = currentPlayerNameParts[1] || '';

    // Update the player name
    await db.query(
      'UPDATE Players SET FirstName = ?, LastName = ? WHERE FirstName = ? AND LastName = ?',
      [newFirstName, newLastName, currentFirstName, currentLastName]
    );

    res.redirect('/teamplayers');
  } catch (err) {
    console.error('Error updating names:', err);
    res.status(500).send('Error updating team or player names');
  }
});


// Delete a team player 
app.post('/teamplayers/delete', async (req, res) => {
  const { TeamPlayerID } = req.body;

  const parts = TeamPlayerID.split(' ');
  const TeamID = parts[0] || '';
  const PlayerID = parts[1] || '';

  try {
    await db.query('DELETE FROM TeamPlayers WHERE TeamID = ? and PlayerID = ?', [TeamID, PlayerID]);
    res.redirect('/teamplayers');
  } catch (err) {
      console.error('Error deleting team player:', err);
      return res.sendStatus(500);
  }
});


// ########################################
// ########## LISTENER#####################
app.listen(PORT, function () {
    console.log(
        'Express started on http://localhost:' +
            PORT +
            '; press Ctrl-C to terminate.'
    );
});
