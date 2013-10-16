USE wfrmls
DROP TABLE IF EXISTS par;
DROP TABLE IF EXISTS changes;
CREATE TABLE changes(					
	listno 		INT NOT NULL,
	taxid 		VARCHAR(255) NOT NULL,
	office		MEDIUMINT UNSIGNED,
	changedt	DATE,
	changedby	VARCHAR(255),
	field		VARCHAR(255),
	oldvalue	VARCHAR(255),
	newvalue	VARCHAR(255)
);

CREATE TABLE par (
	taxid 	VARCHAR(255) NOT NULL,
	par	CHAR(0) NULL
);

