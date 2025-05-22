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
