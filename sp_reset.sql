
DROP PROCEDURE IF EXISTS ResetPickupDB;
DELIMITER //

CREATE PROCEDURE ResetPickupDB()
BEGIN
    -- Drop existing tables
    DROP TABLE IF EXISTS PlayerStatistics;
    DROP TABLE IF EXISTS TeamPlayers;
    DROP TABLE IF EXISTS Statistics;
    DROP TABLE IF EXISTS Games;
    DROP TABLE IF EXISTS Players;
    DROP TABLE IF EXISTS Teams;

    -- Recreate tables
    CREATE TABLE Players (
        PlayerID INT AUTO_INCREMENT PRIMARY KEY,
        FirstName VARCHAR(50) NOT NULL,
        LastName VARCHAR(50) NOT NULL,
        Position VARCHAR(10) NOT NULL,
        SkillLevel INT NOT NULL CHECK (SkillLevel BETWEEN 1 AND 5)
    );

    CREATE TABLE Teams (
        TeamID INT AUTO_INCREMENT PRIMARY KEY,
        TeamName VARCHAR(100) NOT NULL,
        CoachName VARCHAR(100)
    );

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

    CREATE TABLE Statistics (
        StatisticID INT AUTO_INCREMENT PRIMARY KEY,
        StatisticName VARCHAR(50) NOT NULL,
        Description TEXT
    );

    CREATE TABLE TeamPlayers (
        TeamID INT NOT NULL,
        PlayerID INT NOT NULL,
        JerseyNumber INT,
        PRIMARY KEY (TeamID, PlayerID),
        FOREIGN KEY (TeamID) REFERENCES Teams(TeamID) ON DELETE CASCADE,
        FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID) ON DELETE CASCADE
    );

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

    -- Sample data
    INSERT INTO Players (FirstName, LastName, Position, SkillLevel) VALUES
    ('Marcus', 'Lee', 'PG', 4),
    ('Julia', 'Ramos', 'SG', 3),
    ('Dante', 'Knox', 'C', 5),
    ('Alexis', 'Tran', 'SF', 2);

    INSERT INTO Teams (TeamName, CoachName) VALUES
    ('Wildcats', 'Coach Thompson'),
    ('Highland Hawks', 'Coach Rivera'),
    ('Metro Flyers', NULL);

    INSERT INTO TeamPlayers (TeamID, PlayerID, JerseyNumber) VALUES
    (1, 1, 3),
    (1, 2, 7),
    (2, 3, 15),
    (2, 1, 9),
    (3, 4, 22);

    INSERT INTO Games (Date, Location, TeamAID, TeamBID, ScoreA, ScoreB) VALUES
    ('2025-04-01', 'Court A', 1, 2, 56, 49),
    ('2025-04-08', 'Court B', 2, 3, 71, 58),
    ('2025-04-15', 'Outdoor Court', 1, 3, 64, 64);

    INSERT INTO Statistics (StatisticName, Description) VALUES
    ('Points', 'Total points scored'),
    ('Rebounds', 'Number of rebounds'),
    ('Assists', 'Total assists during a game');

    INSERT INTO PlayerStatistics (PlayerID, StatisticID, GameID, ValueOfStatistic) VALUES
    (1, 1, 1, 14.00),
    (1, 2, 1, 3.00),
    (2, 1, 1, 8.00),
    (3, 1, 2, 20.00),
    (3, 2, 2, 12.00),
    (4, 3, 3, 4.00);

    -- Demonstration of a CUD operation: delete 1 player
    DELETE FROM Players WHERE PlayerID = 1;
END //

DELIMITER ;

