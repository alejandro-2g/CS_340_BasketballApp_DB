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
