-- Backup generado automaticamente por scripts/backup_db.py
-- Fecha: 2026-03-11 08:23:40
SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS `assignments`;
CREATE TABLE `assignments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `judge_id` int NOT NULL,
  `project_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_assignment_judge_project` (`judge_id`,`project_id`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `assignments_ibfk_1` FOREIGN KEY (`judge_id`) REFERENCES `judges` (`id`),
  CONSTRAINT `assignments_ibfk_2` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `assignments` (`id`, `judge_id`, `project_id`) VALUES (1, 1, 1);
INSERT INTO `assignments` (`id`, `judge_id`, `project_id`) VALUES (2, 1, 2);

DROP TABLE IF EXISTS `evaluations`;
CREATE TABLE `evaluations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `judge_id` int NOT NULL,
  `project_id` int NOT NULL,
  `evaluation_type` enum('escrito','exposicion') COLLATE utf8mb4_unicode_ci NOT NULL,
  `criteria_1` int NOT NULL,
  `criteria_2` int NOT NULL,
  `criteria_3` int NOT NULL,
  `criteria_4` int NOT NULL,
  `comments` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_eval_type_per_judge_project` (`judge_id`,`project_id`,`evaluation_type`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `evaluations_ibfk_1` FOREIGN KEY (`judge_id`) REFERENCES `judges` (`id`),
  CONSTRAINT `evaluations_ibfk_2` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `evaluations` (`id`, `judge_id`, `project_id`, `evaluation_type`, `criteria_1`, `criteria_2`, `criteria_3`, `criteria_4`, `comments`, `created_at`) VALUES (1, 1, 1, 'exposicion', 25, 25, 25, 25, '', '2026-03-10 17:44:22');
INSERT INTO `evaluations` (`id`, `judge_id`, `project_id`, `evaluation_type`, `criteria_1`, `criteria_2`, `criteria_3`, `criteria_4`, `comments`, `created_at`) VALUES (2, 1, 1, 'escrito', 12, 12, 12, 12, '', '2026-03-10 17:44:36');
INSERT INTO `evaluations` (`id`, `judge_id`, `project_id`, `evaluation_type`, `criteria_1`, `criteria_2`, `criteria_3`, `criteria_4`, `comments`, `created_at`) VALUES (3, 1, 2, 'escrito', 12, 23, 25, 1, 'vale', '2026-03-11 13:18:40');
INSERT INTO `evaluations` (`id`, `judge_id`, `project_id`, `evaluation_type`, `criteria_1`, `criteria_2`, `criteria_3`, `criteria_4`, `comments`, `created_at`) VALUES (4, 1, 2, 'exposicion', 25, 25, 25, 25, '', '2026-03-11 13:19:02');

DROP TABLE IF EXISTS `judges`;
CREATE TABLE `judges` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active_user` tinyint(1) NOT NULL,
  `is_admin` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `judges` (`id`, `full_name`, `email`, `password_hash`, `is_active_user`, `is_admin`) VALUES (1, 'Juez Demo', 'juez1@expotecnica.local', 'scrypt:32768:8:1$xGfpP0SO0jsZVoKz$53ba77facb3be623d7342fac698a082643eaddee65a40de65075be8b21e9527805044f404637b78954731d0303443cc9b868adc5c2ac8e3f47c973e1611f0b7b', 1, 0);
INSERT INTO `judges` (`id`, `full_name`, `email`, `password_hash`, `is_active_user`, `is_admin`) VALUES (2, 'Administrador', 'admin@expotecnica.local', 'scrypt:32768:8:1$JUkS3sFx3Q0ZCjcV$c46a595165dd7f745c524df71235ae2ff8af334e842358a206858da91ab286b5f5cbc7d8c5fc30c393951e9b75889a023d9e1d1ccf61c054ad1c3486cf513cf8', 1, 1);

DROP TABLE IF EXISTS `project_members`;
CREATE TABLE `project_members` (
  `id` int NOT NULL AUTO_INCREMENT,
  `project_id` int NOT NULL,
  `full_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `photo_url` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_project_members_project_id` (`project_id`),
  CONSTRAINT `project_members_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `project_members` (`id`, `project_id`, `full_name`, `role`, `photo_url`, `created_at`) VALUES (5, 5, 'Caleb', 'The Boss', 'uploads/members/93b8e475d6dd4166a5c87c3c3812901b.png', '2026-03-11 14:17:52');
INSERT INTO `project_members` (`id`, `project_id`, `full_name`, `role`, `photo_url`, `created_at`) VALUES (6, 5, 'Cruz', 'El Segundon al mando', 'uploads/members/20173cc40e59459998b6868fe52babbc.png', '2026-03-11 14:17:52');

DROP TABLE IF EXISTS `projects`;
CREATE TABLE `projects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `team_name` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `representative_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `representative_email` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` enum('steam','emprendimiento') COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `projects` (`id`, `title`, `team_name`, `representative_name`, `representative_email`, `category`, `description`, `created_at`) VALUES (1, 'FiveSolutions', '10-3', 'Erick Sevilla', 'vegabryan@gmail.com', 'emprendimiento', 'No entiendo como no gano', '2026-03-10 17:26:23');
INSERT INTO `projects` (`id`, `title`, `team_name`, `representative_name`, `representative_email`, `category`, `description`, `created_at`) VALUES (2, 'Alohomora', '9-5', 'Sebastian Navarro', 'vegabryan@hotmail.com', 'steam', 'Este si gano', '2026-03-11 13:17:21');
INSERT INTO `projects` (`id`, `title`, `team_name`, `representative_name`, `representative_email`, `category`, `description`, `created_at`) VALUES (5, 'InnovaMind', '11-3', 'Caleb Mesén', 'caleb@gmail.com', 'emprendimiento', 'Este casi gana', '2026-03-11 14:17:52');

SET FOREIGN_KEY_CHECKS=1;
