
-- CS 340 Group 109 Project - Basketball Team Management & Game Match Organizer Database
-- Author: Alejandro Cervantes Flores & Nora Jacobi
-- Description: SQL queries and Example Data for Basketball Club Management


SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;

-- Drop tables if they exist
DROP TABLE IF EXISTS PlayerStatistics;
DROP TABLE IF EXISTS TeamPlayers;
DROP TABLE IF EXISTS Games;
DROP TABLE IF EXISTS Statistics;
DROP TABLE IF EXISTS Teams;
DROP TABLE IF EXISTS Players;

-- Create Players Table
CREATE TABLE Players (
    PlayerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Position VARCHAR(10) NOT NULL CHECK (Position IN ('PG', 'SG', 'SF', 'PF', 'C')),
    SkillLevel INT NOT NULL CHECK (SkillLevel BETWEEN 1 AND 5)
);

-- Create Teams Table
CREATE TABLE Teams (
    TeamID INT AUTO_INCREMENT PRIMARY KEY,
    TeamName VARCHAR(100) NOT NULL,
    CoachName VARCHAR(100)
);

-- Create Games Table
CREATE TABLE Games (
    GameID INT AUTO_INCREMENT PRIMARY KEY,
    Date DATE NOT NULL,
    Location VARCHAR(100) NOT NULL,
    TeamAID INT NOT NULL,
    TeamBID INT NOT NULL,
    ScoreA INT,
    ScoreB INT,
    FOREIGN KEY (TeamAID) REFERENCES Teams(TeamID) ON DELETE CASCADE,
    FOREIGN KEY (TeamBID) REFERENCES Teams(TeamID) ON DELETE CASCADE
);

-- Create Statistics Table
CREATE TABLE Statistics (
    StatisticID INT AUTO_INCREMENT PRIMARY KEY,
    StatisticName VARCHAR(50) NOT NULL,
    Description TEXT
);

-- Create TeamPlayers Table
CREATE TABLE TeamPlayers (
    TeamID INT NOT NULL,
    PlayerID INT NOT NULL,
    JerseyNumber INT,
    PRIMARY KEY (TeamID, PlayerID),
    FOREIGN KEY (TeamID) REFERENCES Teams(TeamID) ON DELETE CASCADE,
    FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID) ON DELETE CASCADE
);

-- Create PlayerStatistics Table
CREATE TABLE PlayerStatistics (
    PlayerID INT NOT NULL,
    StatisticID INT NOT NULL,
    GameID INT NOT NULL,
    ValueOfStatistic DECIMAL(7,2) NOT NULL,
    PRIMARY KEY (PlayerID, StatisticID, GameID),
    FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID) ON DELETE CASCADE,
    FOREIGN KEY (StatisticID) REFERENCES Statistics(StatisticID) ON DELETE CASCADE,
    FOREIGN KEY (GameID) REFERENCES Games(GameID) ON DELETE CASCADE
);

-- -------------------------------------------------------
-- Example Data
-- -------------------------------------------------------

-- Insert into Players
INSERT INTO Players (FirstName, LastName, Position, SkillLevel) VALUES
('Marcus', 'Lee', 'PG', 4),
('Julia', 'Ramos', 'SG', 3),
('Dante', 'Knox', 'C', 5),
('Alexis', 'Tran', 'SF', 2);

-- Insert into Teams
INSERT INTO Teams (TeamName, CoachName) VALUES
('Wildcats', 'Coach Thompson'),
('Highland Hawks', 'Coach Rivera'),
('Metro Flyers', NULL);

-- Insert into TeamPlayers
INSERT INTO TeamPlayers (TeamID, PlayerID, JerseyNumber) VALUES
(1, 1, 3),
(1, 2, 7),
(2, 3, 15),
(2, 1, 9),
(3, 4, 22);

-- Insert into Games
INSERT INTO Games (Date, Location, TeamAID, TeamBID, ScoreA, ScoreB) VALUES
('2025-04-01', 'Court A', 1, 2, 56, 49),
('2025-04-08', 'Court B', 2, 3, 71, 58),
('2025-04-15', 'Outdoor Court', 1, 3, 64, 64);

-- Insert into Statistics
INSERT INTO Statistics (StatisticName, Description) VALUES
('Points', 'Total points scored'),
('Rebounds', 'Number of rebounds'),
('Assists', 'Total assists during a game');

-- Insert into PlayerStatistics
INSERT INTO PlayerStatistics (PlayerID, StatisticID, GameID, ValueOfStatistic) VALUES
(1, 1, 1, 14.00),
(1, 2, 1, 3.00),
(2, 1, 1, 8.00),
(3, 1, 2, 20.00),
(3, 2, 2, 12.00),
(4, 3, 3, 4.00);

SET FOREIGN_KEY_CHECKS=1;
COMMIT;
