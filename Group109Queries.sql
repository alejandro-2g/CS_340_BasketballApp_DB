
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

-- Insert into TeamPlayers using subqueries
INSERT INTO TeamPlayers (TeamID, PlayerID, JerseyNumber) VALUES
((SELECT TeamID FROM Teams WHERE TeamName = 'Wildcats'), (SELECT PlayerID FROM Players WHERE FirstName = 'Marcus' AND LastName = 'Lee'), 3),
((SELECT TeamID FROM Teams WHERE TeamName = 'Wildcats'), (SELECT PlayerID FROM Players WHERE FirstName = 'Julia' AND LastName = 'Ramos'), 7),
((SELECT TeamID FROM Teams WHERE TeamName = 'Highland Hawks'), (SELECT PlayerID FROM Players WHERE FirstName = 'Dante' AND LastName = 'Knox'), 15),
((SELECT TeamID FROM Teams WHERE TeamName = 'Highland Hawks'), (SELECT PlayerID FROM Players WHERE FirstName = 'Marcus' AND LastName = 'Lee'), 9),
((SELECT TeamID FROM Teams WHERE TeamName = 'Metro Flyers'), (SELECT PlayerID FROM Players WHERE FirstName = 'Alexis' AND LastName = 'Tran'), 22);

-- Insert into Games using subqueries
INSERT INTO Games (Date, Location, TeamAID, TeamBID, ScoreA, ScoreB) VALUES
('2025-04-01', 'Court A',
 (SELECT TeamID FROM Teams WHERE TeamName = 'Wildcats'),
 (SELECT TeamID FROM Teams WHERE TeamName = 'Highland Hawks'), 56, 49),

('2025-04-08', 'Court B',
 (SELECT TeamID FROM Teams WHERE TeamName = 'Highland Hawks'),
 (SELECT TeamID FROM Teams WHERE TeamName = 'Metro Flyers'), 71, 58),

('2025-04-15', 'Outdoor Court',
 (SELECT TeamID FROM Teams WHERE TeamName = 'Wildcats'),
 (SELECT TeamID FROM Teams WHERE TeamName = 'Metro Flyers'), 64, 64);

-- Insert into Statistics
INSERT INTO Statistics (StatisticName, Description) VALUES
('Points', 'Total points scored'),
('Rebounds', 'Number of rebounds'),
('Assists', 'Total assists during a game');

-- Insert into PlayerStatistics using subqueries
INSERT INTO PlayerStatistics (PlayerID, StatisticID, GameID, ValueOfStatistic) VALUES
((SELECT PlayerID FROM Players WHERE FirstName = 'Marcus' AND LastName = 'Lee'),
 (SELECT StatisticID FROM Statistics WHERE StatisticName = 'Points'),
 (SELECT GameID FROM Games WHERE Date = '2025-04-01'), 14.00),

((SELECT PlayerID FROM Players WHERE FirstName = 'Marcus' AND LastName = 'Lee'),
 (SELECT StatisticID FROM Statistics WHERE StatisticName = 'Rebounds'),
 (SELECT GameID FROM Games WHERE Date = '2025-04-01'), 3.00),

((SELECT PlayerID FROM Players WHERE FirstName = 'Julia' AND LastName = 'Ramos'),
 (SELECT StatisticID FROM Statistics WHERE StatisticName = 'Points'),
 (SELECT GameID FROM Games WHERE Date = '2025-04-01'), 8.00),

((SELECT PlayerID FROM Players WHERE FirstName = 'Dante' AND LastName = 'Knox'),
 (SELECT StatisticID FROM Statistics WHERE StatisticName = 'Points'),
 (SELECT GameID FROM Games WHERE Date = '2025-04-08'), 20.00),

((SELECT PlayerID FROM Players WHERE FirstName = 'Dante' AND LastName = 'Knox'),
 (SELECT StatisticID FROM Statistics WHERE StatisticName = 'Rebounds'),
 (SELECT GameID FROM Games WHERE Date = '2025-04-08'), 12.00),

((SELECT PlayerID FROM Players WHERE FirstName = 'Alexis' AND LastName = 'Tran'),
 (SELECT StatisticID FROM Statistics WHERE StatisticName = 'Assists'),
 (SELECT GameID FROM Games WHERE Date = '2025-04-15'), 4.00);

SET FOREIGN_KEY_CHECKS=1;
COMMIT;

