--Group 109: Alejandro Cervantes Flores, Nora Jacobi
-- Citation for the PL
-- Date: 05/12/2025
-- Adapted/Based on: Exploration: PL/SQL part 1, SP, View and Function, Exploration: PL/SQL part 2, Stored Procedures for CUD 
-- Source URL: 
-- https://canvas.oregonstate.edu/courses/1999601/pages/exploration-pl-slash-sql-part-1-sp-view-and-function?module_item_id=25352958
-- https://canvas.oregonstate.edu/courses/1999601/pages/exploration-pl-slash-sql-part-2-stored-procedures-for-cud?module_item_id=25352959

-- Create player
DROP PROCEDURE IF EXISTS sp_CreatePlayer;

DELIMITER //
CREATE PROCEDURE sp_CreatePlayer(
    IN p_FirstName VARCHAR(100),
    IN p_LastName VARCHAR(100),
    IN p_Position VARCHAR(10),
    IN p_SkillLevel INT,
    OUT p_PlayerID INT
)
BEGIN
    INSERT INTO Players (FirstName, LastName, Position, SkillLevel)
    VALUES (p_FirstName, p_LastName, p_Position, p_SkillLevel);

    SELECT LAST_INSERT_ID() INTO p_PlayerID;
    SELECT LAST_INSERT_ID() AS 'New Player ID';
END //
DELIMITER ;


-- Delete Player
DROP PROCEDURE IF EXISTS sp_DeletePlayer;

DELIMITER //
CREATE PROCEDURE sp_DeletePlayer(IN p_PlayerID INT)
BEGIN
    DECLARE error_message VARCHAR(255);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

        -- can add cascading deletes if TeamPlayers or PlayerStatistics exist
        DELETE FROM TeamPlayers WHERE PlayerID = p_PlayerID;
        DELETE FROM PlayerStatistics WHERE PlayerID = p_PlayerID;
        DELETE FROM Players WHERE PlayerID = p_PlayerID;

        IF ROW_COUNT() = 0 THEN
            SET error_message = CONCAT('No matching player with ID: ', p_PlayerID);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;
END //
DELIMITER ;


-- Update player
DROP PROCEDURE IF EXISTS sp_UpdatePlayer;
DELIMITER //
CREATE PROCEDURE sp_UpdatePlayer(
    IN p_PlayerID INT,
    IN p_FirstName VARCHAR(50),
    IN p_LastName VARCHAR(50),
    IN p_Position VARCHAR(10),
    IN p_SkillLevel INT
)
BEGIN
    UPDATE Players
    SET FirstName = p_FirstName,
        LastName = p_LastName,
        Position = p_Position,
        SkillLevel = p_SkillLevel
    WHERE PlayerID = p_PlayerID;
END //
DELIMITER ;
