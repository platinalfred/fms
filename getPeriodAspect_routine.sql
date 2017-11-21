CREATE DEFINER=`root`@`localhost` FUNCTION `getPeriodAspect`(`period` TINYINT(1)) RETURNS smallint(3) unsigned
    NO SQL
BEGIN
	DECLARE periodAspect SMALLINT(3);
	CASE period
			WHEN 1 THEN SET periodAspect=365;
			WHEN 2 THEN SET periodAspect = 54;
			WHEN 3 THEN SET periodAspect = 12;
	END CASE;
   RETURN periodAspect;
END