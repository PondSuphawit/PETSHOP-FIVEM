
CREATE TABLE IF NOT EXISTS `pets` (
  `owner` varchar(50) DEFAULT NULL,
  `pet` varchar(50) DEFAULT NULL,
  `hunger` int(11) DEFAULT NULL,
  `health` int(11) DEFAULT NULL,
  `customize` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`customize`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;





