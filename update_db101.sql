USE `Paypal`;
CREATE 
     OR REPLACE ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `Paypal_Stats` AS
    SELECT 
        `Paypals`.`Txn_type` AS `Type`,
        `Paypals`.`Payment_Date` AS `Payment_Date`,
        (CASE
            WHEN (`Paypals`.`Txn_type` = 'send_money') THEN 'Real World'
            ELSE `Paypals`.`RegionName`
        END) AS `RegionName`,
        `Paypals`.`Item_name` AS `Item_name`,
        `Paypals`.`Item_number` AS `Item_Number`,
         (CASE
            WHEN (`Paypals`.`Txn_type` = 'send_money') THEN 'none'
            else `Paypals`.`Invoice` 
         end)   AS `Invoice`,
        `Paypals`.`Mc_gross` AS `amount`,
        `Paypals`.`Mc_currency` AS `Currency`,
        (CASE
            WHEN (`Paypals`.`Txn_type` = 'send_money') THEN 'See your accoun transaction'
            ELSE `Paypals`.`AvatarName`
        END) AS `AvatarName`,
        `Paypals`.`Payment_status` AS `payment_status`
    FROM
        `Paypals`
    ORDER BY `Paypals`.`Payment_Date` DESC;
