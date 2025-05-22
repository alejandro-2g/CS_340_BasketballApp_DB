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
