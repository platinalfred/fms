BEGIN
	DECLARE installs INT DEFAULT 0;
    DECLARE tempDate, dueDate DATE;
	WHILE (installs <= installments) DO
		SET installs = installs+1;
		
		CASE time_unit
		WHEN 1 THEN SET tempDate = DATE_ADD(disbursementDate, INTERVAL installs*repaymentFreq DAY);
		WHEN 2 THEN SET tempDate = DATE_ADD(disbursementDate, INTERVAL installs*repaymentFreq WEEK);
		WHEN 3 THEN SET tempDate = DATE_ADD(disbursementDate, INTERVAL installs*repaymentFreq MONTH);
		END CASE;
		IF (tempDate BETWEEN start_date AND end_date) THEN
			SET dueDate = tempDate;
			RETURN dueDate;
		END IF;
	END WHILE;
	
	RETURN dueDate;
END

BEGIN
	DECLARE installs INT DEFAULT 0;
    DECLARE tempDate, dueDate DATE;
	WHILE (installs <= installments) DO
		SET installs = installs+1;
		
		CASE time_unit
		WHEN 1 THEN SET tempDate = DATE_ADD(disbursementDate, INTERVAL installs*repaymentFreq DAY);
		WHEN 2 THEN SET tempDate = DATE_ADD(disbursementDate, INTERVAL installs*repaymentFreq WEEK);
		WHEN 3 THEN SET tempDate = DATE_ADD(disbursementDate, INTERVAL installs*repaymentFreq MONTH);
		END CASE;
		IF (tempDate < end_date) THEN
			SET dueDate = tempDate;
		END IF;
	END WHILE;
	
	RETURN dueDate;
END