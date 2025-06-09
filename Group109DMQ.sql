
-- CS 340 Group 109: Alejandro Cervantes Flores, Nora Jacobi

-- Citation for the DMQ 
-- Date: 05/08/2025
-- Adapted/Based on: bsg_sample_data_manipulation_queries.sql in Project Step 3 
-- Source URL: https://canvas.oregonstate.edu/courses/1999601/assignments/10006387?module_item_id=25352952

-- ========= PLAYERS =========
-- Insert a new player into the Players table
INSERT INTO Players (FirstName, LastName, Position, SkillLevel)
VALUES (@FirstNameInput, @LastNameInput, @PositionInput, @SkillLevelInput);

-- Update player information based on PlayerID
UPDATE Players
SET FirstName = @NewFirstName, LastName = @NewLastName, Position = @NewPosition, SkillLevel = @NewSkillLevel
WHERE PlayerID = @PlayerIDToUpdate;

-- Remove a player from the Players table using PlayerID
DELETE FROM Players
WHERE PlayerID = @PlayerIDToDelete;

-- Retrieve all players
SELECT * FROM Players;

-- ========= TEAMS =========

-- Add a new team with a name and optional coach
INSERT INTO Teams (TeamName, CoachName)
VALUES (@TeamNameInput, @CoachNameInput);

-- Update team details using TeamID
UPDATE Teams
SET TeamName = @NewTeamName, CoachName = @NewCoachName
WHERE TeamID = @TeamIDToUpdate;

-- Delete a team using its TeamID
DELETE FROM Teams
WHERE TeamID = @TeamIDToDelete;

-- Retrieve all teams
SELECT * FROM Teams;

-- ========= GAMES =========

-- Insert a new game with participating teams and scores
INSERT INTO Games (Date, Location, TeamAID, TeamBID, ScoreA, ScoreB)
VALUES (@GameDate, @LocationInput, @TeamAIDInput, @TeamBIDInput, @ScoreAInput, @ScoreBInput);

-- Update game details using GameID
UPDATE Games
SET Date = @NewDate, Location = @NewLocation, TeamAID = @NewTeamAID, TeamBID = @NewTeamBID, ScoreA = @NewScoreA, ScoreB = @NewScoreB
WHERE GameID = @GameIDToUpdate;

-- Delete a game from the schedule by GameID
DELETE FROM Games
WHERE GameID = @GameIDToDelete;

-- Retrieve all scheduled games
SELECT * FROM Games;

-- ========= STATISTICS =========

-- Insert a new statistic type (e.g., Points, Rebounds)
INSERT INTO Statistics (StatisticName, Description)
VALUES (@StatisticNameInput, @DescriptionInput);

-- Update a statistic's name or description
UPDATE Statistics
SET StatisticName = @NewStatisticName, Description = @NewDescription
WHERE StatisticID = @StatisticIDToUpdate;

-- Remove a statistic from the system
DELETE FROM Statistics
WHERE StatisticID = @StatisticIDToDelete;

-- Retrieve all statistic types
SELECT * FROM Statistics;

-- ========= PLAYER STATISTICS =========

-- Insert a new stat entry for a player in a specific game
INSERT INTO PlayerStatistics (PlayerID, StatisticID, GameID, ValueOfStatistic)
VALUES (@PlayerIDInput, @StatisticIDInput, @GameIDInput, @ValueInput);

-- Update the recorded value of a stat for a player in a game
UPDATE PlayerStatistics
SET ValueOfStatistic = @NewValue
WHERE PlayerID = @PlayerID AND StatisticID = @StatisticID AND GameID = @GameID;

-- Delete a player's stat record for a game
DELETE FROM PlayerStatistics
WHERE PlayerID = @PlayerIDToDelete AND StatisticID = @StatisticIDToDelete AND GameID = @GameIDToDelete;

-- Retrieve all player statistics
SELECT * FROM PlayerStatistics;
