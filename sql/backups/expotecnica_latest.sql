-- Backup generado automaticamente por scripts/backup_db.py
-- Fecha: 2026-03-16 16:41:05
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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `assignments` (`id`, `judge_id`, `project_id`) VALUES (9, 1, 5);
INSERT INTO `assignments` (`id`, `judge_id`, `project_id`) VALUES (8, 1, 14);
INSERT INTO `assignments` (`id`, `judge_id`, `project_id`) VALUES (11, 11, 5);
INSERT INTO `assignments` (`id`, `judge_id`, `project_id`) VALUES (10, 11, 14);

DROP TABLE IF EXISTS `campaigns`;
CREATE TABLE `campaigns` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `ix_campaigns_is_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `campaigns` (`id`, `name`, `start_date`, `end_date`, `is_active`, `notes`, `created_at`) VALUES (2, 'Campaña pública 2026', '2026-03-10', '2026-03-18', 1, 'Prueba automatizada', '2026-03-11 22:26:12');

DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `sort_order` int NOT NULL,
  `rubric_1_evaluation_type_id` int DEFAULT NULL,
  `rubric_2_evaluation_type_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_categories_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `categories` (`id`, `code`, `name`, `is_active`, `sort_order`, `rubric_1_evaluation_type_id`, `rubric_2_evaluation_type_id`) VALUES (1, 'steam', 'STEAM', 1, 1, 4, 6);
INSERT INTO `categories` (`id`, `code`, `name`, `is_active`, `sort_order`, `rubric_1_evaluation_type_id`, `rubric_2_evaluation_type_id`) VALUES (2, 'emprendimiento', 'Emprendimiento', 1, 2, 5, 7);

DROP TABLE IF EXISTS `evaluation_scores`;
CREATE TABLE `evaluation_scores` (
  `id` int NOT NULL AUTO_INCREMENT,
  `evaluation_id` int NOT NULL,
  `rubric_criterion_id` int NOT NULL,
  `score` int NOT NULL,
  `observation` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_evaluation_score_criterion` (`evaluation_id`,`rubric_criterion_id`),
  KEY `ix_evaluation_scores_rubric_criterion_id` (`rubric_criterion_id`),
  KEY `ix_evaluation_scores_evaluation_id` (`evaluation_id`),
  CONSTRAINT `evaluation_scores_ibfk_1` FOREIGN KEY (`evaluation_id`) REFERENCES `evaluations` (`id`),
  CONSTRAINT `evaluation_scores_ibfk_2` FOREIGN KEY (`rubric_criterion_id`) REFERENCES `rubric_criteria` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=253 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (1, 6, 10, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (2, 6, 11, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (3, 6, 12, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (4, 6, 13, 1, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (5, 6, 14, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (6, 6, 15, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (7, 6, 16, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (8, 6, 17, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (9, 6, 18, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (10, 6, 19, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (11, 6, 20, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (12, 6, 21, 1, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (13, 6, 22, 1, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (14, 6, 23, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (15, 6, 24, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (16, 6, 25, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (17, 6, 26, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (18, 6, 27, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (19, 6, 28, 1, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (20, 6, 29, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (21, 6, 30, 1, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (22, 6, 31, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (23, 6, 32, 1, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (24, 6, 33, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (25, 6, 34, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (26, 6, 35, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (27, 6, 36, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (28, 6, 37, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (29, 6, 38, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (30, 6, 39, 1, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (31, 6, 40, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (32, 6, 41, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (33, 6, 42, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (34, 6, 43, 1, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (35, 6, 44, 2, 'no esta bien ordenada');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (36, 6, 45, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (37, 6, 46, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (38, 7, 47, 0, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (39, 7, 48, 1, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (40, 7, 49, 1, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (41, 7, 50, 1, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (42, 7, 51, 1, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (43, 7, 52, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (44, 7, 53, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (45, 7, 54, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (46, 7, 55, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (47, 7, 56, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (48, 7, 57, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (49, 7, 58, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (50, 7, 59, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (51, 7, 60, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (52, 7, 61, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (53, 7, 62, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (54, 7, 63, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (55, 7, 64, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (56, 8, 100, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (57, 8, 101, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (58, 8, 102, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (59, 8, 103, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (60, 8, 104, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (61, 8, 105, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (62, 8, 106, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (63, 8, 107, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (64, 8, 108, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (65, 8, 109, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (66, 8, 110, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (67, 8, 111, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (68, 8, 112, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (69, 8, 113, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (70, 8, 114, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (71, 8, 115, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (72, 8, 116, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (73, 8, 117, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (74, 8, 118, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (75, 8, 119, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (76, 8, 120, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (77, 8, 121, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (78, 8, 122, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (79, 8, 123, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (80, 9, 65, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (81, 9, 66, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (82, 9, 67, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (83, 9, 68, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (84, 9, 69, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (85, 9, 70, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (86, 9, 71, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (87, 9, 72, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (88, 9, 73, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (89, 9, 74, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (90, 9, 75, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (91, 9, 76, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (92, 9, 77, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (93, 9, 78, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (94, 9, 79, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (95, 9, 80, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (96, 9, 81, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (97, 9, 82, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (98, 9, 83, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (99, 9, 84, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (100, 9, 85, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (101, 9, 86, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (102, 9, 87, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (103, 9, 88, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (104, 9, 89, 1, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (105, 9, 90, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (106, 9, 91, 1, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (107, 9, 92, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (108, 9, 93, 1, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (109, 9, 94, 1, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (110, 9, 95, 1, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (111, 9, 96, 1, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (112, 9, 97, 1, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (113, 9, 98, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (114, 9, 99, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (123, 11, 10, 3, 'teriuan');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (124, 11, 11, 3, 'fwfwf');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (125, 11, 12, 2, 'sazzz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (126, 11, 13, 1, 'zzz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (127, 11, 14, 0, 'zzzz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (128, 11, 15, 0, 'fwfwf');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (129, 11, 16, 1, 'wfwf');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (130, 11, 17, 2, 'f');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (131, 11, 18, 3, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (132, 11, 19, 2, 'zzzz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (133, 11, 20, 0, 'zzzz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (134, 11, 21, 0, 'zzz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (135, 11, 22, 0, 'ZZZZ');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (136, 11, 23, 0, 'ZZZZZZZZ');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (137, 11, 24, 0, 'ZZZZZZZZZZ');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (138, 11, 25, 0, 'zzzzzzzzzzzzzzzzzzzzzzzzzzzzz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (139, 11, 26, 0, 'zzz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (140, 11, 27, 0, 'zzzz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (141, 11, 28, 0, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (142, 11, 29, 0, 'ZZZZ');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (143, 11, 30, 3, 'ZZZZ');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (144, 11, 31, 0, 'ZZZZZZ');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (145, 11, 32, 3, 'ZZZ');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (146, 11, 33, 2, 'Z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (147, 11, 34, 1, 'ZZZ');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (148, 11, 35, 0, 'ZZ');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (149, 11, 36, 1, 'ZZ');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (150, 11, 37, 1, 'ZZ');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (151, 11, 38, 0, 'ZZZZZZZZ');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (152, 11, 39, 1, 'Z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (153, 11, 40, 2, 'Z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (154, 11, 41, 1, 'ZZ');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (155, 11, 42, 1, 'ZZ');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (156, 11, 43, 2, 'ZZ');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (157, 11, 44, 1, 'ZZ');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (158, 11, 45, 1, 'ZZZ');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (159, 11, 46, 1, 'ZZZZ');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (160, 12, 65, 3, 'zzzz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (161, 12, 66, 2, 'zz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (162, 12, 67, 2, 'zz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (163, 12, 68, 2, 'zzzz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (164, 12, 69, 2, 'zzzzzzzzzz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (165, 12, 70, 3, 'zzz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (166, 12, 71, 2, 'zzzz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (167, 12, 72, 3, 'zzz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (168, 12, 73, 2, 'zz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (169, 12, 74, 1, 'zz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (170, 12, 75, 0, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (171, 12, 76, 0, 'zzz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (172, 12, 77, 0, 'zzz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (173, 12, 78, 0, 'zzz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (174, 12, 79, 0, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (175, 12, 80, 1, 'zzz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (176, 12, 81, 2, 'zzz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (177, 12, 82, 2, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (178, 12, 83, 1, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (179, 12, 84, 0, 'zz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (180, 12, 85, 1, 'zz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (181, 12, 86, 1, 'zz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (182, 12, 87, 0, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (183, 12, 88, 1, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (184, 12, 89, 1, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (185, 12, 90, 1, 'zz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (186, 12, 91, 1, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (187, 12, 92, 3, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (188, 12, 93, 3, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (189, 12, 94, 2, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (190, 12, 95, 1, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (191, 12, 96, 0, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (192, 12, 97, 0, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (193, 12, 98, 0, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (194, 12, 99, 0, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (195, 13, 152, 2, 'zzzzzz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (196, 13, 153, 3, 'zzzzzz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (197, 13, 154, 4, 'zzz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (198, 13, 155, 4, 'zzzz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (199, 13, 156, 5, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (200, 13, 157, 5, 'zzzz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (201, 13, 158, 1, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (202, 13, 159, 1, 'zzz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (203, 14, 47, 2, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (204, 14, 48, 2, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (205, 14, 49, 2, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (206, 14, 50, 2, 'zzzzzzz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (207, 14, 51, 0, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (208, 14, 52, 2, 'zz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (209, 14, 53, 2, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (210, 14, 54, 2, 'zz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (211, 14, 55, 2, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (212, 14, 56, 2, '<zz');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (213, 14, 57, 2, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (214, 14, 58, 2, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (215, 14, 59, 2, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (216, 14, 60, 2, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (217, 14, 61, 2, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (218, 14, 62, 2, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (219, 14, 63, 2, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (220, 14, 64, 2, 'z');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (221, 15, 100, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (222, 15, 101, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (223, 15, 102, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (224, 15, 103, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (225, 15, 104, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (226, 15, 105, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (227, 15, 106, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (228, 15, 107, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (229, 15, 108, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (230, 15, 109, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (231, 15, 110, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (232, 15, 111, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (233, 15, 112, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (234, 15, 113, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (235, 15, 114, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (236, 15, 115, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (237, 15, 116, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (238, 15, 117, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (239, 15, 118, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (240, 15, 119, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (241, 15, 120, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (242, 15, 121, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (243, 15, 122, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (244, 15, 123, 2, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (245, 16, 152, 5, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (246, 16, 153, 4, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (247, 16, 154, 5, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (248, 16, 155, 4, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (249, 16, 156, 4, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (250, 16, 157, 4, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (251, 16, 158, 3, '');
INSERT INTO `evaluation_scores` (`id`, `evaluation_id`, `rubric_criterion_id`, `score`, `observation`) VALUES (252, 16, 159, 3, '');

DROP TABLE IF EXISTS `evaluation_types`;
CREATE TABLE `evaluation_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `sort_order` int NOT NULL,
  `scale_labels` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_evaluation_types_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `evaluation_types` (`id`, `code`, `name`, `is_active`, `sort_order`, `scale_labels`) VALUES (4, 'steam_exposicion', 'Evaluacion de la Exposicion del Proyecto (Desafio STEAM)', 1, 3, '{"3": "Logrado", "2": "Parcialmente logrado", "1": "No logrado", "0": "Ausente"}');
INSERT INTO `evaluation_types` (`id`, `code`, `name`, `is_active`, `sort_order`, `scale_labels`) VALUES (5, 'modelo_negocio_exposicion', 'Evaluacion de la Exposicion del Modelo de Negocios', 1, 4, '{"3": "Logrado", "2": "Parcialmente logrado", "1": "No logrado", "0": "Ausente"}');
INSERT INTO `evaluation_types` (`id`, `code`, `name`, `is_active`, `sort_order`, `scale_labels`) VALUES (6, 'steam_informe_bitacora', 'Evaluacion del Informe Escrito y Bitacora del Proyecto (Desafio STEAM)', 1, 5, '{"3": "Logrado", "2": "Parcialmente logrado", "1": "No logrado", "0": "Ausente"}');
INSERT INTO `evaluation_types` (`id`, `code`, `name`, `is_active`, `sort_order`, `scale_labels`) VALUES (7, 'modelo_negocio_documento', 'Evaluacion del Documento Escrito del Modelo de Negocios', 1, 6, '{"3": "Logrado", "2": "Parcialmente logrado", "1": "No logrado", "0": "Ausente"}');
INSERT INTO `evaluation_types` (`id`, `code`, `name`, `is_active`, `sort_order`, `scale_labels`) VALUES (8, 'plan_negocio_documento', 'Evaluacion del Documento Escrito del Plan de Negocios', 1, 7, '{"3": "Logrado", "2": "Parcialmente logrado", "1": "No logrado", "0": "Ausente"}');
INSERT INTO `evaluation_types` (`id`, `code`, `name`, `is_active`, `sort_order`, `scale_labels`) VALUES (9, 'english_project_performance', 'Assessment Rubric for English Project Performance', 1, 8, '{"5": "Exceptional", "4": "Very Good", "3": "Average", "2": "Below Average", "1": "Unsatisfactory"}');
INSERT INTO `evaluation_types` (`id`, `code`, `name`, `is_active`, `sort_order`, `scale_labels`) VALUES (11, 'escrito', 'Escrito', 1, 1, NULL);
INSERT INTO `evaluation_types` (`id`, `code`, `name`, `is_active`, `sort_order`, `scale_labels`) VALUES (12, 'exposicion', 'Exposicion', 1, 2, NULL);

DROP TABLE IF EXISTS `evaluations`;
CREATE TABLE `evaluations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `judge_id` int NOT NULL,
  `project_id` int NOT NULL,
  `evaluation_type` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `criteria_1` int DEFAULT NULL,
  `criteria_2` int DEFAULT NULL,
  `criteria_3` int DEFAULT NULL,
  `criteria_4` int DEFAULT NULL,
  `comments` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime NOT NULL,
  `recommendations` text COLLATE utf8mb4_unicode_ci,
  `max_score` int DEFAULT NULL,
  `percentage` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_eval_type_per_judge_project` (`judge_id`,`project_id`,`evaluation_type`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `evaluations_ibfk_1` FOREIGN KEY (`judge_id`) REFERENCES `judges` (`id`),
  CONSTRAINT `evaluations_ibfk_2` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `evaluations` (`id`, `judge_id`, `project_id`, `evaluation_type`, `criteria_1`, `criteria_2`, `criteria_3`, `criteria_4`, `comments`, `created_at`, `recommendations`, `max_score`, `percentage`) VALUES (6, 11, 14, 'steam_exposicion', 3, 2, 2, 1, 'intermedio', '2026-03-16 22:20:00', 'mejorar TODO', 111, 76.58);
INSERT INTO `evaluations` (`id`, `judge_id`, `project_id`, `evaluation_type`, `criteria_1`, `criteria_2`, `criteria_3`, `criteria_4`, `comments`, `created_at`, `recommendations`, `max_score`, `percentage`) VALUES (7, 11, 5, 'modelo_negocio_exposicion', 0, 1, 1, 1, 'muy mal', '2026-03-16 22:20:41', 'todo esta muy feo', 54, 61.11);
INSERT INTO `evaluations` (`id`, `judge_id`, `project_id`, `evaluation_type`, `criteria_1`, `criteria_2`, `criteria_3`, `criteria_4`, `comments`, `created_at`, `recommendations`, `max_score`, `percentage`) VALUES (8, 11, 5, 'modelo_negocio_documento', 3, 2, 2, 2, 'muy bueno', '2026-03-16 22:21:10', 'nada todo bueno', 72, 95.83);
INSERT INTO `evaluations` (`id`, `judge_id`, `project_id`, `evaluation_type`, `criteria_1`, `criteria_2`, `criteria_3`, `criteria_4`, `comments`, `created_at`, `recommendations`, `max_score`, `percentage`) VALUES (9, 11, 14, 'steam_informe_bitacora', 3, 3, 3, 2, '7/10', '2026-03-16 22:21:53', 'ok', 105, 74.29);
INSERT INTO `evaluations` (`id`, `judge_id`, `project_id`, `evaluation_type`, `criteria_1`, `criteria_2`, `criteria_3`, `criteria_4`, `comments`, `created_at`, `recommendations`, `max_score`, `percentage`) VALUES (11, 1, 14, 'steam_exposicion', 3, 3, 2, 1, 'Ooooooooojkgaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', '2026-03-16 22:26:22', 'Viva el maicra mae', 111, 34.23);
INSERT INTO `evaluations` (`id`, `judge_id`, `project_id`, `evaluation_type`, `criteria_1`, `criteria_2`, `criteria_3`, `criteria_4`, `comments`, `created_at`, `recommendations`, `max_score`, `percentage`) VALUES (12, 1, 14, 'steam_informe_bitacora', 3, 2, 2, 2, 'efewaqgf', '2026-03-16 22:27:22', 'fwqfwqfqfqf', 105, 40.95);
INSERT INTO `evaluations` (`id`, `judge_id`, `project_id`, `evaluation_type`, `criteria_1`, `criteria_2`, `criteria_3`, `criteria_4`, `comments`, `created_at`, `recommendations`, `max_score`, `percentage`) VALUES (13, 1, 14, 'english_project_performance', 2, 3, 4, 4, 'qwafafwaf', '2026-03-16 22:27:46', 'fawfwafwaf', 40, 62.5);
INSERT INTO `evaluations` (`id`, `judge_id`, `project_id`, `evaluation_type`, `criteria_1`, `criteria_2`, `criteria_3`, `criteria_4`, `comments`, `created_at`, `recommendations`, `max_score`, `percentage`) VALUES (14, 1, 5, 'modelo_negocio_exposicion', 2, 2, 2, 2, 'eawgteygg', '2026-03-16 22:28:19', 'wgwegwgwg', 54, 62.96);
INSERT INTO `evaluations` (`id`, `judge_id`, `project_id`, `evaluation_type`, `criteria_1`, `criteria_2`, `criteria_3`, `criteria_4`, `comments`, `created_at`, `recommendations`, `max_score`, `percentage`) VALUES (15, 1, 5, 'modelo_negocio_documento', 2, 2, 2, 2, '', '2026-03-16 22:28:42', '', 72, 66.67);
INSERT INTO `evaluations` (`id`, `judge_id`, `project_id`, `evaluation_type`, `criteria_1`, `criteria_2`, `criteria_3`, `criteria_4`, `comments`, `created_at`, `recommendations`, `max_score`, `percentage`) VALUES (16, 11, 14, 'english_project_performance', 5, 4, 5, 4, '', '2026-03-16 22:39:20', '', 40, 80.0);

DROP TABLE IF EXISTS `judges`;
CREATE TABLE `judges` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active_user` tinyint(1) NOT NULL,
  `is_admin` tinyint(1) NOT NULL DEFAULT '0',
  `department` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `job_title` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `must_change_password` tinyint(1) NOT NULL DEFAULT '0',
  `last_login_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `judges` (`id`, `full_name`, `email`, `password_hash`, `is_active_user`, `is_admin`, `department`, `job_title`, `phone`, `must_change_password`, `last_login_at`) VALUES (1, 'Juez Demo', 'juez1@expotecnica.local', 'scrypt:32768:8:1$YYKLVXpZoWhTm0KQ$ca1aaa14838038751172da74442aab466a5c2dddb974cac08c8e3e6fe1e56e4a79a7f7fb86e71a24600c5ba0b3715e9e0512767b5ce80256b0c2f7477cbd9c32', 1, 0, NULL, NULL, NULL, 0, '2026-03-16 22:25:56');
INSERT INTO `judges` (`id`, `full_name`, `email`, `password_hash`, `is_active_user`, `is_admin`, `department`, `job_title`, `phone`, `must_change_password`, `last_login_at`) VALUES (2, 'Administrador', 'admin@expotecnica.local', 'scrypt:32768:8:1$i64p34kJolniU051$1a2d2161cef21477db03521670d1511eac338c037634550f68b71e7c7aaaed6a247b4a8642fc980b6cad9417cb7ee8b1c2571755c974614503bbb46bb348dff1', 1, 1, NULL, NULL, NULL, 0, '2026-03-16 22:37:32');
INSERT INTO `judges` (`id`, `full_name`, `email`, `password_hash`, `is_active_user`, `is_admin`, `department`, `job_title`, `phone`, `must_change_password`, `last_login_at`) VALUES (11, 'Juez 2', 'juez2@expotecnica.local', 'scrypt:32768:8:1$YJn5dnRuphIYh7ds$a34d6f534a36318d8458494ea2988dc643d1f943290bffea4ec14539885035fa7524e28031e2e9fa03ab7533e85aa186bd3dfd2706ad12d5b9557c14ee0b7862', 1, 0, NULL, NULL, NULL, 0, '2026-03-16 22:38:17');

DROP TABLE IF EXISTS `levels`;
CREATE TABLE `levels` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` int NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_levels_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `levels` (`id`, `code`, `name`, `sort_order`, `is_active`) VALUES (1, '7', 'Septimo', 7, 1);
INSERT INTO `levels` (`id`, `code`, `name`, `sort_order`, `is_active`) VALUES (2, '8', 'Octavo', 8, 1);
INSERT INTO `levels` (`id`, `code`, `name`, `sort_order`, `is_active`) VALUES (3, '9', 'Noveno', 9, 1);
INSERT INTO `levels` (`id`, `code`, `name`, `sort_order`, `is_active`) VALUES (4, '10', 'Decimo', 10, 1);
INSERT INTO `levels` (`id`, `code`, `name`, `sort_order`, `is_active`) VALUES (5, '11', 'Undecimo', 11, 1);
INSERT INTO `levels` (`id`, `code`, `name`, `sort_order`, `is_active`) VALUES (6, '12', 'Duodecimo', 12, 1);

DROP TABLE IF EXISTS `project_member_changes`;
CREATE TABLE `project_member_changes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `project_id` int NOT NULL,
  `member_id` int DEFAULT NULL,
  `action` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `details` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_project_member_changes_project_id` (`project_id`),
  KEY `ix_project_member_changes_member_id` (`member_id`),
  CONSTRAINT `project_member_changes_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`),
  CONSTRAINT `project_member_changes_ibfk_2` FOREIGN KEY (`member_id`) REFERENCES `project_members` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `project_member_changes` (`id`, `project_id`, `member_id`, `action`, `details`, `created_at`) VALUES (1, 5, NULL, 'created', 'Integrante agregado: #3 Jeshua', '2026-03-11 20:46:33');
INSERT INTO `project_member_changes` (`id`, `project_id`, `member_id`, `action`, `details`, `created_at`) VALUES (4, 5, NULL, 'deleted', 'Integrante eliminado: #3 Jeshua', '2026-03-16 19:11:04');
INSERT INTO `project_member_changes` (`id`, `project_id`, `member_id`, `action`, `details`, `created_at`) VALUES (5, 5, NULL, 'deleted', 'Integrante eliminado: #2 Caleb', '2026-03-16 19:11:32');
INSERT INTO `project_member_changes` (`id`, `project_id`, `member_id`, `action`, `details`, `created_at`) VALUES (6, 5, 14, 'created', 'Integrante agregado: #2 Caleb', '2026-03-16 19:12:43');

DROP TABLE IF EXISTS `project_members`;
CREATE TABLE `project_members` (
  `id` int NOT NULL AUTO_INCREMENT,
  `project_id` int NOT NULL,
  `full_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `photo_url` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `student_number` int NOT NULL DEFAULT '1',
  `identity_number` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `gender` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `specialty` varchar(140) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `section_name` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `has_dining_scholarship` tinyint(1) NOT NULL DEFAULT '0',
  `phone` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `participates_in_english` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `ix_project_members_project_id` (`project_id`),
  CONSTRAINT `project_members_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `project_members` (`id`, `project_id`, `full_name`, `role`, `photo_url`, `created_at`, `student_number`, `identity_number`, `birth_date`, `gender`, `specialty`, `section_name`, `has_dining_scholarship`, `phone`, `email`, `participates_in_english`) VALUES (6, 5, 'Cruz', 'El Segundon al mando', 'uploads/members/1abe016fa20a420a9cee0f5a1303e9c2.jpg', '2026-03-11 14:17:52', 1, '', NULL, 'masculino', 'Especialidad 1', '10-1', 1, '', '', 0);
INSERT INTO `project_members` (`id`, `project_id`, `full_name`, `role`, `photo_url`, `created_at`, `student_number`, `identity_number`, `birth_date`, `gender`, `specialty`, `section_name`, `has_dining_scholarship`, `phone`, `email`, `participates_in_english`) VALUES (14, 5, 'Caleb', NULL, NULL, '2026-03-16 19:12:43', 2, '123456', '2026-03-05', 'masculino', 'Especialidad 1', '11-1', 1, '4548148', 'caleb@gmail.com', 0);
INSERT INTO `project_members` (`id`, `project_id`, `full_name`, `role`, `photo_url`, `created_at`, `student_number`, `identity_number`, `birth_date`, `gender`, `specialty`, `section_name`, `has_dining_scholarship`, `phone`, `email`, `participates_in_english`) VALUES (15, 12, 'Isaac Mora García', NULL, NULL, '2026-03-16 22:04:24', 1, '121223123', '1999-12-12', 'therian', 'Especialidad 1', '12-1', 0, '87844767', 'moraisaac130410@gmail.com', 0);
INSERT INTO `project_members` (`id`, `project_id`, `full_name`, `role`, `photo_url`, `created_at`, `student_number`, `identity_number`, `birth_date`, `gender`, `specialty`, `section_name`, `has_dining_scholarship`, `phone`, `email`, `participates_in_english`) VALUES (16, 13, 'qweqe', NULL, NULL, '2026-03-16 22:05:47', 1, '4324234', '0234-04-23', 'therian', 'Taller 1', '9-1', 0, '87844767', 'moraisaac130410@gmail.com', 0);
INSERT INTO `project_members` (`id`, `project_id`, `full_name`, `role`, `photo_url`, `created_at`, `student_number`, `identity_number`, `birth_date`, `gender`, `specialty`, `section_name`, `has_dining_scholarship`, `phone`, `email`, `participates_in_english`) VALUES (17, 14, 'Pablo', NULL, NULL, '2026-03-16 22:08:11', 1, '4324234', '0234-04-23', 'masculino', 'Taller 1', '7-1', 1, '87844767', 'moraisaac130410@gmail.com', 1);

DROP TABLE IF EXISTS `projects`;
CREATE TABLE `projects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `team_name` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `representative_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `representative_email` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `representative_phone` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `institution_name` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `grade_level` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `specialty` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `advisor_name` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `advisor_email` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `advisor_phone` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `project_objective` text COLLATE utf8mb4_unicode_ci,
  `expected_impact` text COLLATE utf8mb4_unicode_ci,
  `required_resources` text COLLATE utf8mb4_unicode_ci,
  `consent_terms` tinyint(1) NOT NULL DEFAULT '0',
  `registration_date` date DEFAULT NULL,
  `advisor_identity` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `requirements_summary` text COLLATE utf8mb4_unicode_ci,
  `requirements_other` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `section_id` int DEFAULT NULL,
  `specialty_id` int DEFAULT NULL,
  `workshop_id` int DEFAULT NULL,
  `project_document_path` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `project_logo_path` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `logistics_status` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'inscrito',
  `logistics_notes` text COLLATE utf8mb4_unicode_ci,
  `logistics_document_ok` tinyint(1) NOT NULL DEFAULT '0',
  `logistics_logo_ok` tinyint(1) NOT NULL DEFAULT '0',
  `logistics_photos_ok` tinyint(1) NOT NULL DEFAULT '0',
  `campaign_id` int DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `projects` (`id`, `title`, `team_name`, `representative_name`, `representative_email`, `category`, `description`, `created_at`, `representative_phone`, `institution_name`, `grade_level`, `specialty`, `advisor_name`, `advisor_email`, `advisor_phone`, `project_objective`, `expected_impact`, `required_resources`, `consent_terms`, `registration_date`, `advisor_identity`, `requirements_summary`, `requirements_other`, `section_id`, `specialty_id`, `workshop_id`, `project_document_path`, `project_logo_path`, `logistics_status`, `logistics_notes`, `logistics_document_ok`, `logistics_logo_ok`, `logistics_photos_ok`, `campaign_id`, `is_active`) VALUES (1, 'FiveSolutions', '10-3', 'Erick Sevilla', 'vegabryan@gmail.com', 'emprendimiento', 'No entiendo como no gano', '2026-03-10 17:26:23', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'inscrito', NULL, 0, 0, 0, NULL, 1);
INSERT INTO `projects` (`id`, `title`, `team_name`, `representative_name`, `representative_email`, `category`, `description`, `created_at`, `representative_phone`, `institution_name`, `grade_level`, `specialty`, `advisor_name`, `advisor_email`, `advisor_phone`, `project_objective`, `expected_impact`, `required_resources`, `consent_terms`, `registration_date`, `advisor_identity`, `requirements_summary`, `requirements_other`, `section_id`, `specialty_id`, `workshop_id`, `project_document_path`, `project_logo_path`, `logistics_status`, `logistics_notes`, `logistics_document_ok`, `logistics_logo_ok`, `logistics_photos_ok`, `campaign_id`, `is_active`) VALUES (5, 'InnovaMind', '11-3', 'Caleb Mesén', 'caleb@gmail.com', 'emprendimiento', 'Este casi gana', '2026-03-11 14:17:52', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'uploads/projects/logos/700b6397ca4d48029eed4766209c7cc5.png', 'revision_logistica', '', 0, 1, 0, NULL, 1);
INSERT INTO `projects` (`id`, `title`, `team_name`, `representative_name`, `representative_email`, `category`, `description`, `created_at`, `representative_phone`, `institution_name`, `grade_level`, `specialty`, `advisor_name`, `advisor_email`, `advisor_phone`, `project_objective`, `expected_impact`, `required_resources`, `consent_terms`, `registration_date`, `advisor_identity`, `requirements_summary`, `requirements_other`, `section_id`, `specialty_id`, `workshop_id`, `project_document_path`, `project_logo_path`, `logistics_status`, `logistics_notes`, `logistics_document_ok`, `logistics_logo_ok`, `logistics_photos_ok`, `campaign_id`, `is_active`) VALUES (12, 'brayanduro', 'Equipo ExpoTEC', 'Isaac Mora García', 'moraisaac130410@gmail.com', 'emprendimiento', 'Proyecto registrado por formulario ExpoTEC-1.', '2026-03-16 22:04:24', '87844767', 'CTP Roberto Gamboa Valverde', '12', 'Especialidad 1', 'bahsdad', 'grcastro@desamparados.go.cr', NULL, NULL, NULL, '', 1, '2005-12-12', '34242434234324', 'corriente', '', 6, 1, NULL, 'uploads/projects/documents/e2b2b141f50d481283b0f6ae6c965973.pdf', NULL, 'inscrito', NULL, 0, 0, 0, 2, 1);
INSERT INTO `projects` (`id`, `title`, `team_name`, `representative_name`, `representative_email`, `category`, `description`, `created_at`, `representative_phone`, `institution_name`, `grade_level`, `specialty`, `advisor_name`, `advisor_email`, `advisor_phone`, `project_objective`, `expected_impact`, `required_resources`, `consent_terms`, `registration_date`, `advisor_identity`, `requirements_summary`, `requirements_other`, `section_id`, `specialty_id`, `workshop_id`, `project_document_path`, `project_logo_path`, `logistics_status`, `logistics_notes`, `logistics_document_ok`, `logistics_logo_ok`, `logistics_photos_ok`, `campaign_id`, `is_active`) VALUES (13, 'steam therian', 'Equipo ExpoTEC', 'qweqe', 'moraisaac130410@gmail.com', 'steam', 'Proyecto registrado por formulario ExpoTEC-1.', '2026-03-16 22:05:47', '87844767', 'CTP Roberto Gamboa Valverde', '9', 'Taller 1', 'bahsdad', 'grcastro@desamparados.go.cr', NULL, NULL, NULL, '', 1, '1211-12-12', '34242434234324', 'internet', '', 3, NULL, 1, 'uploads/projects/documents/753e692e70354ab79e54f8111d367d09.pdf', NULL, 'inscrito', NULL, 0, 0, 0, 2, 1);
INSERT INTO `projects` (`id`, `title`, `team_name`, `representative_name`, `representative_email`, `category`, `description`, `created_at`, `representative_phone`, `institution_name`, `grade_level`, `specialty`, `advisor_name`, `advisor_email`, `advisor_phone`, `project_objective`, `expected_impact`, `required_resources`, `consent_terms`, `registration_date`, `advisor_identity`, `requirements_summary`, `requirements_other`, `section_id`, `specialty_id`, `workshop_id`, `project_document_path`, `project_logo_path`, `logistics_status`, `logistics_notes`, `logistics_document_ok`, `logistics_logo_ok`, `logistics_photos_ok`, `campaign_id`, `is_active`) VALUES (14, 'Fast', 'Equipo ExpoTEC', 'Pablo', 'moraisaac130410@gmail.com', 'steam', 'Proyecto registrado por formulario ExpoTEC-1.', '2026-03-16 22:08:11', '87844767', 'CTP Roberto Gamboa Valverde', '7', 'Taller 1', 'bahsdad', 'grcastro@desamparados.go.cr', NULL, NULL, NULL, 'balabalñad', 1, '2000-08-21', '34242434234324', 'corriente', '', 1, NULL, 1, 'uploads/projects/documents/a1a6e661c9844999a2b542179693e0f3.pdf', NULL, 'inscrito', NULL, 0, 0, 0, 2, 1);

DROP TABLE IF EXISTS `rubric_criteria`;
CREATE TABLE `rubric_criteria` (
  `id` int NOT NULL AUTO_INCREMENT,
  `evaluation_type_id` int NOT NULL,
  `name` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `min_score` int NOT NULL,
  `max_score` int NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `sort_order` int NOT NULL,
  `section_name` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `section_sort_order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `ix_rubric_criteria_evaluation_type_id` (`evaluation_type_id`),
  CONSTRAINT `rubric_criteria_ibfk_1` FOREIGN KEY (`evaluation_type_id`) REFERENCES `evaluation_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=172 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (10, 4, 'Define el problema de forma precisa.', 0, 3, 1, 1, 'I. Identificacion y formulacion del problema', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (11, 4, 'Plantea alternativas de solucion que contemplen conceptos teoricos practicos atinentes al problema.', 0, 3, 1, 2, 'I. Identificacion y formulacion del problema', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (12, 4, 'Propone objetivos vinculados con la busqueda de soluciones al problema planteado.', 0, 3, 1, 3, 'I. Identificacion y formulacion del problema', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (13, 4, 'Evidencia el impacto del proyecto a nivel social, cientifico o tecnologico, tanto a corto como largo plazo.', 0, 3, 1, 4, 'I. Identificacion y formulacion del problema', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (14, 4, 'Demuestra capacidad para expresar ideas con seguridad y defender el proyecto planteado.', 0, 3, 1, 5, 'I. Identificacion y formulacion del problema', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (15, 4, 'Demuestra en su elaboracion una linea de investigacion y desarrollo coherente y clara.', 0, 3, 1, 6, 'II. Investigacion y desarrollo', 2);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (16, 4, 'Argumenta, desde la implementacion del proyecto, el analisis e interpretacion de los datos recopilados.', 0, 3, 1, 7, 'II. Investigacion y desarrollo', 2);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (17, 4, 'Evidencia la gestion de recursos y busqueda de apoyo para la elaboracion del proyecto.', 0, 3, 1, 8, 'II. Investigacion y desarrollo', 2);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (18, 4, 'Demuestra originalidad y autoria propia del proyecto expuesto.', 0, 3, 1, 9, 'II. Investigacion y desarrollo', 2);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (19, 4, 'Aplica la normativa vigente en el contexto del proyecto.', 0, 3, 1, 10, 'II. Investigacion y desarrollo', 2);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (20, 4, 'Se evidencia la factibilidad e implementacion comercial o industrial del proyecto, a futuro.', 0, 3, 1, 11, 'II. Investigacion y desarrollo', 2);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (21, 4, 'Presenta una linea de trabajo de investigacion y desarrollo coherente y clara.', 0, 3, 1, 12, 'III. Prototipo', 3);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (22, 4, 'Da respuesta a la necesidad u objetivos planteados.', 0, 3, 1, 13, 'III. Prototipo', 3);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (23, 4, 'Evidencia el uso optimo de los recursos disponibles para su construccion.', 0, 3, 1, 14, 'III. Prototipo', 3);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (24, 4, 'Demuestra precision tecnica en la elaboracion y funcionamiento del prototipo.', 0, 3, 1, 15, 'III. Prototipo', 3);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (25, 4, 'Respeta las normativas de seguridad y otras vigentes en su construccion y desempeno.', 0, 3, 1, 16, 'III. Prototipo', 3);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (26, 4, 'Muestra actualidad tecnologica en el campo de trabajo seleccionado.', 0, 3, 1, 17, 'III. Prototipo', 3);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (27, 4, 'Evidencia el funcionamiento correcto segun la solucion planteada en el proyecto.', 0, 3, 1, 18, 'III. Prototipo', 3);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (28, 4, 'Demuestra creatividad e innovacion al crear el prototipo.', 0, 3, 1, 19, 'III. Prototipo', 3);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (29, 4, 'Evidencia apropiacion y dominio del tema del proyecto.', 0, 3, 1, 20, 'IV. Exposicion del proyecto', 4);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (30, 4, 'Demuestra claridad y coherencia en la exposicion del proyecto ante el panel de jueces.', 0, 3, 1, 21, 'IV. Exposicion del proyecto', 4);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (31, 4, 'Utiliza lenguaje tecnico acorde con el nivel academico y el campo de desarrollo del proyecto.', 0, 3, 1, 22, 'IV. Exposicion del proyecto', 4);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (32, 4, 'Argumenta de forma solida y fundamentada su propuesta de proyecto.', 0, 3, 1, 23, 'IV. Exposicion del proyecto', 4);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (33, 4, 'Emplea recursos afines con el tema del proyecto.', 0, 3, 1, 24, 'IV. Exposicion del proyecto', 4);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (34, 4, 'Describe la metodologia utilizada para la implementacion, evaluacion y perfeccionamiento de la solucion propuesta.', 0, 3, 1, 25, 'IV. Exposicion del proyecto', 4);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (35, 4, 'Presenta resultados consistentes con los objetivos y solucion al problema planteado.', 0, 3, 1, 26, 'IV. Exposicion del proyecto', 4);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (36, 4, 'Brinda conclusiones precisas y objetivas basadas en los resultados obtenidos.', 0, 3, 1, 27, 'IV. Exposicion del proyecto', 4);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (37, 4, 'Denota colaboracion y comunicacion efectiva del estudiante o integrantes del equipo.', 0, 3, 1, 28, 'IV. Exposicion del proyecto', 4);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (38, 4, 'Demuestra capacidad de recibir, analizar y aplicar sugerencias para mejorar el proyecto.', 0, 3, 1, 29, 'IV. Exposicion del proyecto', 4);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (39, 4, 'Se evidencia congruencia entre lo expuesto y el informe escrito.', 0, 3, 1, 30, 'V. Documentacion del proyecto', 5);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (40, 4, 'Evidencia el uso de lenguaje tecnico afin al tema del proyecto.', 0, 3, 1, 31, 'V. Documentacion del proyecto', 5);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (41, 4, 'Estipula los procedimientos tecnicos utilizados.', 0, 3, 1, 32, 'V. Documentacion del proyecto', 5);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (42, 4, 'La bitacora detalla en forma cronologica los procesos de investigacion.', 0, 3, 1, 33, 'V. Documentacion del proyecto', 5);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (43, 4, 'La bitacora detalla en forma cronologica los procesos de implementacion.', 0, 3, 1, 34, 'V. Documentacion del proyecto', 5);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (44, 4, 'La bitacora detalla en forma cronologica los procesos de experimentacion.', 0, 3, 1, 35, 'V. Documentacion del proyecto', 5);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (45, 4, 'Contiene informacion relevante para la exposicion del proyecto.', 0, 3, 1, 36, 'V. Documentacion del proyecto', 5);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (46, 4, 'Utiliza el cartel o recursos audiovisuales como apoyo para la exposicion.', 0, 3, 1, 37, 'V. Documentacion del proyecto', 5);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (47, 5, 'Define de forma precisa la operacion basica de la potencial empresa.', 0, 3, 1, 1, 'Evaluacion de la Exposicion del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (48, 5, 'Plantea las alternativas de solucion que la empresa brindara al problema o necesidad detectada.', 0, 3, 1, 2, 'Evaluacion de la Exposicion del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (49, 5, 'Describe los productos o servicios ofrecidos que brindan valor a los clientes.', 0, 3, 1, 3, 'Evaluacion de la Exposicion del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (50, 5, 'Evidencia el impacto de la potencial empresa desde diversos ambitos, tanto a corto como a largo plazo.', 0, 3, 1, 4, 'Evaluacion de la Exposicion del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (51, 5, 'Argumenta las diferencias que ofrece la potencial empresa con la competencia.', 0, 3, 1, 5, 'Evaluacion de la Exposicion del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (52, 5, 'Demuestra un buen entendimiento del mercado, la competencia y aspectos financieros.', 0, 3, 1, 6, 'Evaluacion de la Exposicion del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (53, 5, 'Argumenta con solidez que hace unico al negocio y por que constituye una buena oportunidad.', 0, 3, 1, 7, 'Evaluacion de la Exposicion del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (54, 5, 'Demuestra gestion de los recursos de forma sostenible y responsable.', 0, 3, 1, 8, 'Evaluacion de la Exposicion del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (55, 5, 'Demuestra claridad y coherencia en la exposicion del plan de negocios ante el panel de jueces.', 0, 3, 1, 9, 'Evaluacion de la Exposicion del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (56, 5, 'Utiliza lenguaje tecnico acorde con el nivel academico y el campo del negocio.', 0, 3, 1, 10, 'Evaluacion de la Exposicion del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (57, 5, 'Evidencia capacidad de comunicacion oral y dominio de la propuesta de valor.', 0, 3, 1, 11, 'Evaluacion de la Exposicion del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (58, 5, 'Define los canales mediante los cuales hara llegar a los clientes la propuesta de valor.', 0, 3, 1, 12, 'Evaluacion de la Exposicion del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (59, 5, 'Caracteriza el segmento de clientes (necesidades, comportamientos y atributos).', 0, 3, 1, 13, 'Evaluacion de la Exposicion del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (60, 5, 'Expone una propuesta innovadora y creativa con respecto al mercado.', 0, 3, 1, 14, 'Evaluacion de la Exposicion del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (61, 5, 'Describe las demandas del segmento de clientes y el seguimiento para asegurar la calidad de los bienes o servicios ofrecidos.', 0, 3, 1, 15, 'Evaluacion de la Exposicion del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (62, 5, 'Expone las fuentes de ingresos y estructura de costos.', 0, 3, 1, 16, 'Evaluacion de la Exposicion del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (63, 5, 'Explica los canales utilizados para dar a conocer su modelo de negocios.', 0, 3, 1, 17, 'Evaluacion de la Exposicion del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (64, 5, 'Describe las alianzas estrategicas de su propuesta de valor.', 0, 3, 1, 18, 'Evaluacion de la Exposicion del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (65, 6, 'Delimita los antecedentes del problema o necesidad por solventar.', 0, 3, 1, 1, 'I. Introduccion', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (66, 6, 'Evidencia claridad en la definicion del problema.', 0, 3, 1, 2, 'I. Introduccion', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (67, 6, 'Fundamenta la relevancia o utilidad potencial del proyecto.', 0, 3, 1, 3, 'I. Introduccion', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (68, 6, 'Define los criterios tecnicos utilizados para la solucion del problema.', 0, 3, 1, 4, 'I. Introduccion', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (69, 6, 'Evidencia la viabilidad del proyecto.', 0, 3, 1, 5, 'I. Introduccion', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (70, 6, 'Emplea variedad de fuentes de informacion confiables para sustentar el proyecto.', 0, 3, 1, 6, 'II. Marco teorico', 2);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (71, 6, 'Incluye citas bibliograficas relevantes, de forma critica dentro del texto, que documentan la investigacion y desarrollo del proyecto.', 0, 3, 1, 7, 'II. Marco teorico', 2);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (72, 6, 'Emplea fuentes bibliograficas actualizadas, segun el tema abordado en el proyecto.', 0, 3, 1, 8, 'II. Marco teorico', 2);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (73, 6, 'Define terminos o conceptos relevantes para la investigacion y desarrollo del proyecto.', 0, 3, 1, 9, 'II. Marco teorico', 2);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (74, 6, 'Sintetiza la informacion existente del tema en estudio.', 0, 3, 1, 10, 'II. Marco teorico', 2);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (75, 6, 'Evidencia la organizacion logica de la informacion recopilada.', 0, 3, 1, 11, 'II. Marco teorico', 2);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (76, 6, 'Presenta el objetivo general y al menos dos objetivos especificos.', 0, 3, 1, 12, 'III. Objetivos', 3);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (77, 6, 'Se plantean de forma clara, precisa y segun estructura requerida.', 0, 3, 1, 13, 'III. Objetivos', 3);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (78, 6, 'Evidencia relacion con la propuesta de solucion planteada.', 0, 3, 1, 14, 'III. Objetivos', 3);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (79, 6, 'Presenta las etapas del proyecto en el cronograma.', 0, 3, 1, 15, 'IV. Metodologia', 4);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (80, 6, 'Cumple con las etapas establecidas en el cronograma.', 0, 3, 1, 16, 'IV. Metodologia', 4);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (81, 6, 'Describe paso a paso los procedimientos y tecnicas utilizadas para la investigacion y desarrollo.', 0, 3, 1, 17, 'IV. Metodologia', 4);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (82, 6, 'Describe los recursos utilizados para la implementacion del proyecto.', 0, 3, 1, 18, 'IV. Metodologia', 4);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (83, 6, 'Evidencia procesos de mejora continua durante la investigacion y desarrollo del proyecto.', 0, 3, 1, 19, 'IV. Metodologia', 4);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (84, 6, 'Evidencia el desarrollo de ideas novedosas o la aplicacion creativa de conocimientos.', 0, 3, 1, 20, 'IV. Metodologia', 4);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (85, 6, 'Fundamenta los calculos requeridos para las demostraciones.', 0, 3, 1, 21, 'IV. Metodologia', 4);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (86, 6, 'Incluye disenos y esquemas claros en relacion con el desarrollo del prototipo.', 0, 3, 1, 22, 'IV. Metodologia', 4);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (87, 6, 'Muestra concordancia entre los resultados obtenidos y los objetivos planteados.', 0, 3, 1, 23, 'V. Discusion de los resultados y conclusiones', 5);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (88, 6, 'Presenta los datos mediante tablas, diagramas, figuras, graficos, entre otros.', 0, 3, 1, 24, 'V. Discusion de los resultados y conclusiones', 5);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (89, 6, 'Evidencia la interpretacion de los resultados desde una vision analitica y reflexiva.', 0, 3, 1, 25, 'V. Discusion de los resultados y conclusiones', 5);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (90, 6, 'Demuestra resultados aplicables y utiles en la vida real.', 0, 3, 1, 26, 'V. Discusion de los resultados y conclusiones', 5);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (91, 6, 'Presenta coherencia entre los disenos y esquemas con respecto al prototipo desarrollado.', 0, 3, 1, 27, 'V. Discusion de los resultados y conclusiones', 5);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (92, 6, 'Plantea conclusiones relevantes en relacion con los objetivos trazados, analisis de datos y prototipado.', 0, 3, 1, 28, 'V. Discusion de los resultados y conclusiones', 5);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (93, 6, 'Concluye sobre el impacto ambiental, social o economico de la implementacion del proyecto.', 0, 3, 1, 29, 'V. Discusion de los resultados y conclusiones', 5);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (94, 6, 'Presenta una organizacion clara y logica, en congruencia con la estructura dada en los lineamientos.', 0, 3, 1, 30, 'VI. Estructura y formato del proyecto', 6);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (95, 6, 'Presenta el documento en formato de doble columna (IEEE, articulo de revista).', 0, 3, 1, 31, 'VI. Estructura y formato del proyecto', 6);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (96, 6, 'Presenta el listado de referencias citadas en el documento, segun formato APA vigente.', 0, 3, 1, 32, 'VI. Estructura y formato del proyecto', 6);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (97, 6, 'Evidencia el proceso de investigacion y desarrollo realizado.', 0, 3, 1, 33, 'VII. Bitacora', 7);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (98, 6, 'Cumple con el formato solicitado, segun los lineamientos de la ExpoTECNICA.', 0, 3, 1, 34, 'VII. Bitacora', 7);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (99, 6, 'Presenta relacion con el informe escrito.', 0, 3, 1, 35, 'VII. Bitacora', 7);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (100, 7, 'Describe de forma clara y precisa los antecedentes que fundamentan la propuesta de valor.', 0, 3, 1, 1, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (101, 7, 'Explica con solidez que hace unico al negocio y por que es atractivo.', 0, 3, 1, 2, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (102, 7, 'Describe las actividades clave que la empresa implementa para ofrecer una propuesta de valor.', 0, 3, 1, 3, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (103, 7, 'Describe de forma detallada el producto o servicio propuesto que brinda valor a los clientes.', 0, 3, 1, 4, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (104, 7, 'Detalla como los productos o servicios ofrecidos se diferencian de la competencia.', 0, 3, 1, 5, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (105, 7, 'Emplea lenguaje tecnico acorde con el nivel academico y el campo del negocio.', 0, 3, 1, 6, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (106, 7, 'Define los canales mediante los cuales hara llegar a los clientes la propuesta de valor.', 0, 3, 1, 7, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (107, 7, 'Caracteriza ampliamente el segmento de clientes (necesidades, comportamientos y atributos).', 0, 3, 1, 8, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (108, 7, 'Presenta los elementos diferenciadores que facilitan la decision de compra del cliente.', 0, 3, 1, 9, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (109, 7, 'Describe las demandas del segmento de clientes y el seguimiento para asegurar la calidad de los bienes o servicios ofrecidos.', 0, 3, 1, 10, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (110, 7, 'Presenta las estrategias para el acercamiento al cliente, ya sea durante el proceso de atencion o de servicio.', 0, 3, 1, 11, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (111, 7, 'Presenta datos sobre clientes, tendencias y oportunidades.', 0, 3, 1, 12, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (112, 7, 'Incluye estrategias de promocion, precios, distribucion y posicionamiento.', 0, 3, 1, 13, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (113, 7, 'Presenta la estructura de costos, gastos e ingresos.', 0, 3, 1, 14, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (114, 7, 'Incluye los canales para la distribucion del producto hasta el cliente y su promocion, incorporando el uso de nuevas tecnologias.', 0, 3, 1, 15, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (115, 7, 'Detalla las alianzas estrategicas y aportes a su propuesta de valor.', 0, 3, 1, 16, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (116, 7, 'Presenta una organizacion clara y logica del documento, en congruencia con la estructura dada en los lineamientos.', 0, 3, 1, 17, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (117, 7, 'Presenta el listado de referencias citadas en el documento, segun formato APA vigente.', 0, 3, 1, 18, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (118, 7, 'Cumple con el formato establecido.', 0, 3, 1, 19, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (119, 7, 'Justifica de forma solida la viabilidad y pertinencia del negocio.', 0, 3, 1, 20, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (120, 7, 'Identifica la situacion de mercado, sociedad o industria que se aborda en la propuesta de negocio.', 0, 3, 1, 21, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (121, 7, 'Argumenta la necesidad o problema que resuelve la propuesta de negocio.', 0, 3, 1, 22, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (122, 7, 'Determina aspectos sociales, economicos, tecnologicos o ambientales que resuelve la propuesta de negocio.', 0, 3, 1, 23, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (123, 7, 'Plantea los objetivos del negocio enfatizando en su viabilidad, escalabilidad y sostenibilidad.', 0, 3, 1, 24, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (124, 8, 'Explica con solidez que hace unico al negocio y por que es atractivo.', 0, 3, 1, 1, 'Evaluacion del Documento Escrito del Plan de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (125, 8, 'Describe las actividades clave que la empresa implementa para ofrecer una propuesta de valor.', 0, 3, 1, 2, 'Evaluacion del Documento Escrito del Plan de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (126, 8, 'Evidencia la identificacion de los equipos y recursos necesarios para llevar a cabo las operaciones de la empresa.', 0, 3, 1, 3, 'Evaluacion del Documento Escrito del Plan de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (127, 8, 'Describe de forma detallada el producto o servicio propuesto que brinda valor a los clientes.', 0, 3, 1, 4, 'Evaluacion del Documento Escrito del Plan de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (128, 8, 'Detalla como los productos o servicios ofrecidos se diferencian de la competencia.', 0, 3, 1, 5, 'Evaluacion del Documento Escrito del Plan de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (129, 8, 'Emplea lenguaje tecnico acorde con el nivel academico y el campo del negocio.', 0, 3, 1, 6, 'Evaluacion del Documento Escrito del Plan de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (130, 8, 'Define los canales mediante los cuales hara llegar a los clientes la propuesta de valor.', 0, 3, 1, 7, 'Evaluacion del Documento Escrito del Plan de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (131, 8, 'Caracteriza ampliamente el segmento de clientes (necesidades, comportamientos y atributos).', 0, 3, 1, 8, 'Evaluacion del Documento Escrito del Plan de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (132, 8, 'Presenta los elementos diferenciadores que facilitan la decision de compra del cliente.', 0, 3, 1, 9, 'Evaluacion del Documento Escrito del Plan de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (133, 8, 'Describe las demandas del segmento de clientes y el seguimiento para asegurar la calidad de los bienes o servicios ofrecidos.', 0, 3, 1, 10, 'Evaluacion del Documento Escrito del Plan de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (134, 8, 'Presenta las estrategias para el acercamiento al cliente, ya sea durante el proceso de atencion o de servicio.', 0, 3, 1, 11, 'Evaluacion del Documento Escrito del Plan de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (135, 8, 'Presenta datos sobre clientes, tendencias y oportunidades.', 0, 3, 1, 12, 'Evaluacion del Documento Escrito del Plan de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (136, 8, 'Incluye los canales para la distribucion del producto hasta el cliente y su promocion, incorporando el uso de nuevas tecnologias.', 0, 3, 1, 13, 'Evaluacion del Documento Escrito del Plan de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (137, 8, 'Presenta la estructura de costos, gastos e ingresos.', 0, 3, 1, 14, 'Evaluacion del Documento Escrito del Plan de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (138, 8, 'Incluye los canales para la distribucion del producto hasta el cliente y su promocion, incorporando el uso de nuevas tecnologias.', 0, 3, 1, 15, 'Evaluacion del Documento Escrito del Plan de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (139, 8, 'Determina el mercado meta y su alineacion con la propuesta de valor del negocio.', 0, 3, 1, 16, 'Evaluacion del Documento Escrito del Plan de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (140, 8, 'Presenta el modelo de negocio integrando los nueve modulos basicos que definen la operacion de la empresa, segun lo expuesto en la fase institucional.', 0, 3, 1, 17, 'Evaluacion del Documento Escrito del Plan de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (141, 8, 'Presenta el analisis de la viabilidad financiera incluyendo ingresos, costos, gastos y utilidades esperadas.', 0, 3, 1, 18, 'Evaluacion del Documento Escrito del Plan de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (142, 8, 'Presenta el analisis de las fuentes de financiamiento y su impacto en la permanencia del negocio.', 0, 3, 1, 19, 'Evaluacion del Documento Escrito del Plan de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (143, 8, 'Evidencia una relacion realista entre las proyecciones e indicadores financieros.', 0, 3, 1, 20, 'Evaluacion del Documento Escrito del Plan de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (144, 8, 'Evidencia cumplimiento de la normativa vigente en apego a la forma juridica, organizacional y seguridad social.', 0, 3, 1, 21, 'Evaluacion del Documento Escrito del Plan de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (145, 8, 'Detalla las alianzas estrategicas y aportes a su propuesta de valor.', 0, 3, 1, 22, 'Evaluacion del Documento Escrito del Plan de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (146, 8, 'Presenta una organizacion clara y logica del documento, en congruencia con la estructura dada en los lineamientos.', 0, 3, 1, 23, 'Evaluacion del Documento Escrito del Plan de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (147, 8, 'Presenta el listado de referencias citadas en el documento, segun formato APA vigente.', 0, 3, 1, 24, 'Evaluacion del Documento Escrito del Plan de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (148, 8, 'Cumple con el formato establecido.', 0, 3, 1, 25, 'Evaluacion del Documento Escrito del Plan de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (149, 8, 'Justifica de forma solida la viabilidad y pertinencia del negocio.', 0, 3, 1, 26, 'Evaluacion del Documento Escrito del Plan de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (150, 8, 'Identifica la situacion de mercado, sociedad o industria que se aborda en la propuesta de negocio.', 0, 3, 1, 27, 'Evaluacion del Documento Escrito del Plan de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (151, 8, 'Argumenta la necesidad o problema que resuelve la propuesta de negocio.', 0, 3, 1, 28, 'Evaluacion del Documento Escrito del Plan de Negocios', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (152, 9, 'Organization of Ideas', 1, 5, 1, 1, 'Use of Language', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (153, 9, 'Vocabulary', 1, 5, 1, 2, 'Use of Language', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (154, 9, 'Sentence Structure and Grammar', 1, 5, 1, 3, 'Use of Language', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (155, 9, 'Pronunciation', 1, 5, 1, 4, 'Use of Language', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (156, 9, 'Content', 1, 5, 1, 5, 'Use of Language', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (157, 9, 'Conclusion', 1, 5, 1, 6, 'Use of Language', 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (158, 9, 'Verbal', 1, 5, 1, 7, 'Delivery', 2);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (159, 9, 'Nonverbal', 1, 5, 1, 8, 'Delivery', 2);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (164, 11, 'Dominio del tema', 1, 25, 1, 1, NULL, 0);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (165, 11, 'Metodologia', 1, 25, 1, 2, NULL, 0);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (166, 11, 'Innovacion', 1, 25, 1, 3, NULL, 0);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (167, 11, 'Impacto', 1, 25, 1, 4, NULL, 0);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (168, 12, 'Claridad', 1, 25, 1, 1, NULL, 0);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (169, 12, 'Contenido', 1, 25, 1, 2, NULL, 0);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (170, 12, 'Argumentacion', 1, 25, 1, 3, NULL, 0);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`, `section_name`, `section_sort_order`) VALUES (171, 12, 'Presentacion', 1, 25, 1, 4, NULL, 0);

DROP TABLE IF EXISTS `sections`;
CREATE TABLE `sections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `level_id` int NOT NULL,
  `name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` int NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_sections_level_id` (`level_id`),
  CONSTRAINT `sections_ibfk_1` FOREIGN KEY (`level_id`) REFERENCES `levels` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `sections` (`id`, `level_id`, `name`, `sort_order`, `is_active`) VALUES (1, 1, '7-1', 1, 1);
INSERT INTO `sections` (`id`, `level_id`, `name`, `sort_order`, `is_active`) VALUES (2, 2, '8-1', 1, 1);
INSERT INTO `sections` (`id`, `level_id`, `name`, `sort_order`, `is_active`) VALUES (3, 3, '9-1', 1, 1);
INSERT INTO `sections` (`id`, `level_id`, `name`, `sort_order`, `is_active`) VALUES (4, 4, '10-1', 1, 1);
INSERT INTO `sections` (`id`, `level_id`, `name`, `sort_order`, `is_active`) VALUES (5, 5, '11-1', 1, 1);
INSERT INTO `sections` (`id`, `level_id`, `name`, `sort_order`, `is_active`) VALUES (6, 6, '12-1', 1, 1);

DROP TABLE IF EXISTS `specialties`;
CREATE TABLE `specialties` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(140) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` int NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_specialties_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `specialties` (`id`, `name`, `sort_order`, `is_active`) VALUES (1, 'Especialidad 1', 1, 1);
INSERT INTO `specialties` (`id`, `name`, `sort_order`, `is_active`) VALUES (2, 'Especialidad 2', 2, 1);

DROP TABLE IF EXISTS `system_audit_logs`;
CREATE TABLE `system_audit_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `actor_name` varchar(140) COLLATE utf8mb4_unicode_ci NOT NULL,
  `actor_email` varchar(160) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `actor_role` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `action` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `entity` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `entity_id` int DEFAULT NULL,
  `detail` text COLLATE utf8mb4_unicode_ci,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_system_audit_logs_entity` (`entity`),
  KEY `ix_system_audit_logs_created_at` (`created_at`),
  KEY `ix_system_audit_logs_entity_id` (`entity_id`),
  KEY `ix_system_audit_logs_action` (`action`)
) ENGINE=InnoDB AUTO_INCREMENT=204 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (2, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.smtp.save', 'smtp', NULL, 'Configuracion SMTP actualizada', '127.0.0.1', NULL, '2026-03-11 20:37:14');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (3, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.project.logo_upload', 'project', 2, 'Logo actualizado', '127.0.0.1', NULL, '2026-03-11 20:38:08');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (4, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.project.logo_upload', 'project', 5, 'Logo actualizado para proyecto #5 \'InnovaMind\'', '127.0.0.1', NULL, '2026-03-11 20:41:16');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (5, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.member.create', 'project_member', 13, 'Integrante agregado: #3 \'Jeshua\' en proyecto #5 \'InnovaMind\'', '127.0.0.1', NULL, '2026-03-11 20:46:33');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (6, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.campaign.create', 'campaign', NULL, 'Campana creada: ExpoTecnica 2026 (2026-03-11 a 2026-03-25)', '127.0.0.1', NULL, '2026-03-11 21:02:00');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (7, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.campaign.update', 'campaign', 1, 'Campana actualizada: ExpoTecnica 2026', '127.0.0.1', NULL, '2026-03-11 21:02:04');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (8, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.campaign.deactivate', 'campaign', 1, 'Campana desactivada: ExpoTecnica 2026', '127.0.0.1', NULL, '2026-03-11 21:02:07');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (9, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.campaign.activate', 'campaign', 1, 'Campana activa: ExpoTecnica 2026', '127.0.0.1', NULL, '2026-03-11 21:02:08');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (10, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.institution.save', 'institution', NULL, 'Datos institucionales actualizados: CTP Roberto Gamboa Valverde', '127.0.0.1', NULL, '2026-03-11 21:10:38');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (11, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.institution.save', 'institution', NULL, 'Datos institucionales actualizados: CTP Roberto Gamboa Valverde', '127.0.0.1', NULL, '2026-03-11 21:12:04');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (12, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-11 21:14:08');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (13, 'Juez Demo', 'juez1@expotecnica.local', 'judge', 'auth.login', 'auth', 1, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-11 21:16:06');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (14, 'Juez Demo', 'juez1@expotecnica.local', 'judge', 'auth.logout', 'auth', 1, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-11 21:16:27');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (15, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-11 21:16:34');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (16, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-11 21:21:45');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (17, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-11 21:22:06');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (18, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.maintenance.save', 'system_setting', NULL, 'Mantenimiento actualizado: projects_public_enabled=0, maintenance_enabled=1', '127.0.0.1', NULL, '2026-03-11 21:22:46');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (19, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-11 21:22:47');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (20, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-11 21:22:53');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (21, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.maintenance.save', 'system_setting', NULL, 'Mantenimiento actualizado: projects_public_enabled=0, maintenance_enabled=0', '127.0.0.1', NULL, '2026-03-11 21:22:58');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (22, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-11 21:22:59');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (23, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-11 21:23:09');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (24, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.maintenance.save', 'system_setting', NULL, 'Mantenimiento actualizado: projects_public_enabled=1, maintenance_enabled=0', '127.0.0.1', NULL, '2026-03-11 21:23:19');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (25, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-11 21:23:21');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (26, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-11 21:23:33');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (27, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-11 21:28:12');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (28, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-11 21:28:49');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (29, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-11 21:29:08');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (30, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-11 21:29:22');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (31, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.maintenance.save', 'system_setting', NULL, 'Mantenimiento actualizado: maintenance_enabled=1', '127.0.0.1', NULL, '2026-03-11 21:29:35');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (32, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-11 21:29:36');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (33, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-11 21:29:46');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (34, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.maintenance.save', 'system_setting', NULL, 'Mantenimiento actualizado: maintenance_enabled=0', '127.0.0.1', NULL, '2026-03-11 21:29:50');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (35, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-11 21:29:51');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (36, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-11 21:30:06');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (37, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-11 21:30:16');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (38, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-11 21:30:22');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (39, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-11 21:30:24');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (40, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-11 21:30:32');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (41, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.maintenance.save', 'system_setting', NULL, 'Mantenimiento actualizado: maintenance_enabled=1', '127.0.0.1', NULL, '2026-03-11 21:30:37');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (42, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-11 21:30:39');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (43, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-11 21:32:10');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (44, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.maintenance.save', 'system_setting', NULL, 'Mantenimiento actualizado: maintenance_enabled=1', '127.0.0.1', NULL, '2026-03-11 21:46:25');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (45, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-11 22:00:19');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (46, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-11 22:00:27');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (47, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.maintenance.save', 'system_setting', NULL, 'Mantenimiento actualizado: maintenance_enabled=0', '127.0.0.1', NULL, '2026-03-11 22:00:52');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (48, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-11 22:00:53');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (49, 'Juez Demo', 'juez1@expotecnica.local', 'judge', 'auth.login', 'auth', 1, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-11 22:01:03');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (50, 'Juez Demo', 'juez1@expotecnica.local', 'judge', 'auth.logout', 'auth', 1, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-11 22:01:16');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (51, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-11 22:01:30');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (52, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.judge.reset_password', 'judge', 2, 'Contrasena reiniciada para juez: Administrador <admin@expotecnica.local>', '127.0.0.1', NULL, '2026-03-11 22:01:48');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (53, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.judge.reset_password', 'judge', 1, 'Contrasena reiniciada para juez: Juez Demo <juez1@expotecnica.local>', '127.0.0.1', NULL, '2026-03-11 22:01:51');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (54, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-11 22:09:25');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (55, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: admin@expotecnica.local', '127.0.0.1', NULL, '2026-03-11 22:09:38');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (56, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: admin@expotecnica.local', '127.0.0.1', NULL, '2026-03-11 22:09:44');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (57, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: admin@expotecnica.local', '127.0.0.1', NULL, '2026-03-11 22:09:53');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (58, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: admin@expotecnica.local', '127.0.0.1', NULL, '2026-03-11 22:10:10');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (59, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: admin@expotecnica.local', '127.0.0.1', NULL, '2026-03-11 22:10:31');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (60, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: juez1@expotecnica.local', '127.0.0.1', NULL, '2026-03-11 22:11:01');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (61, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: admin@expotecnica.local', '127.0.0.1', NULL, '2026-03-11 22:14:01');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (62, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: juez1@expotecnica.local', '127.0.0.1', NULL, '2026-03-11 22:14:28');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (63, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: juez1@expotecnica.local', '127.0.0.1', NULL, '2026-03-11 22:14:37');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (64, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: admin@expotecnica.local', '127.0.0.1', NULL, '2026-03-11 22:16:52');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (65, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: admin@expotecnica.local', '127.0.0.1', NULL, '2026-03-11 22:21:36');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (66, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-11 22:22:03');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (67, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-11 22:22:33');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (68, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-11 22:23:07');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (69, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: admin@expotecnica.local', '127.0.0.1', NULL, '2026-03-11 22:23:19');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (70, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-11 22:23:24');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (71, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-11 22:25:20');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (72, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-11 22:25:28');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (73, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.maintenance.save', 'system_setting', NULL, 'Mantenimiento actualizado: maintenance_enabled=1', '127.0.0.1', NULL, '2026-03-11 22:25:32');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (74, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-11 22:25:33');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (75, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-11 22:25:46');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (76, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-11 22:30:43');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (77, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: admin@expotecnica.local', '127.0.0.1', NULL, '2026-03-11 22:33:06');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (78, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-11 22:33:14');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (79, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.campaign.delete', 'campaign', 1, 'Campana eliminada: ExpoTécnica 2026', '127.0.0.1', NULL, '2026-03-11 22:33:38');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (80, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.campaign.deactivate', 'campaign', 2, 'Campana desactivada: Campaña pública 2026', '127.0.0.1', NULL, '2026-03-11 22:33:40');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (81, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-11 22:33:42');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (82, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-11 22:33:51');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (83, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.campaign.activate', 'campaign', 2, 'Campana activa: Campaña pública 2026', '127.0.0.1', NULL, '2026-03-11 22:33:56');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (84, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-11 22:34:00');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (85, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-11 22:35:50');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (86, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: admin1@expotecnica.local', '127.0.0.1', NULL, '2026-03-16 18:53:38');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (87, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: admin@expotecnica.local', '127.0.0.1', NULL, '2026-03-16 18:54:19');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (88, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-16 18:54:28');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (91, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.member.delete', 'project_member', 13, 'Integrante eliminado: #3 \'Jeshua\' de proyecto #5 \'InnovaMind\'', '127.0.0.1', NULL, '2026-03-16 19:11:04');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (92, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.member.delete', 'project_member', 5, 'Integrante eliminado: #2 \'Caleb\' de proyecto #5 \'InnovaMind\'', '127.0.0.1', NULL, '2026-03-16 19:11:32');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (93, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.member.create', 'project_member', 14, 'Integrante agregado: #2 \'Caleb\' en proyecto #5 \'InnovaMind\'', '127.0.0.1', NULL, '2026-03-16 19:12:43');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (94, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.project.delete', 'project', 2, 'Proyecto eliminado: Alohomora', '127.0.0.1', NULL, '2026-03-16 19:18:16');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (95, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.project.logistics_update', 'project', 5, 'Proyecto #5 \'InnovaMind\' => activo=True, status=revision_logistica, doc=False, logo=True, fotos=False', '127.0.0.1', NULL, '2026-03-16 19:30:07');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (96, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '192.168.60.4', NULL, '2026-03-16 19:37:25');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (97, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: admin123@gmail.com', '192.168.60.195', NULL, '2026-03-16 19:37:45');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (98, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '192.168.60.195', NULL, '2026-03-16 19:38:28');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (99, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: admin@wxpotecnica.local', '192.168.60.85', NULL, '2026-03-16 19:38:33');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (100, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '192.168.60.85', NULL, '2026-03-16 19:39:02');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (101, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '192.168.60.4', NULL, '2026-03-16 19:39:05');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (102, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: juez1@expotecnica.local', '192.168.60.4', NULL, '2026-03-16 19:39:14');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (103, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: juez1@expotecnica.local', '192.168.60.4', NULL, '2026-03-16 19:42:26');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (104, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.judge.reset_password', 'judge', 1, 'Contrasena reiniciada para juez: Juez Demo <juez1@expotecnica.local>', '127.0.0.1', NULL, '2026-03-16 19:43:08');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (105, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: juez1@expotecnica.local', '192.168.60.4', NULL, '2026-03-16 19:43:27');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (106, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.judge.create', 'judge', NULL, 'Nuevo juez creado: Juez 2 <juez2@expotecnica.local>', '127.0.0.1', NULL, '2026-03-16 19:44:06');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (107, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: juez1@expotecnica.local', '192.168.60.4', NULL, '2026-03-16 19:47:02');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (108, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: juez1@expotecnica.local', '192.168.60.4', NULL, '2026-03-16 19:47:32');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (109, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '192.168.60.4', NULL, '2026-03-16 19:47:34');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (110, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: admin@expotecnica.local', '192.168.60.87', NULL, '2026-03-16 19:49:45');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (111, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '192.168.60.93', NULL, '2026-03-16 19:49:54');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (112, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: admin@expotecnica.local', '192.168.60.87', NULL, '2026-03-16 19:50:39');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (113, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: admin@expotecnica.local', '192.168.60.87', NULL, '2026-03-16 19:51:13');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (114, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: admin@expotecnica.local', '192.168.60.87', NULL, '2026-03-16 19:51:34');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (115, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '192.168.60.87', NULL, '2026-03-16 19:52:19');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (116, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: sebastianaguero2208@gmail.com', '192.168.60.94', NULL, '2026-03-16 19:52:45');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (117, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: sss@gmail.com', '192.168.60.95', NULL, '2026-03-16 19:53:58');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (118, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '192.168.60.195', NULL, '2026-03-16 19:54:27');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (119, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.user.set_password', 'judge', 11, 'Contrasena asignada manualmente a usuario: Juez 2 <juez2@expotecnica.local>', '127.0.0.1', NULL, '2026-03-16 19:54:35');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (120, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '192.168.60.4', NULL, '2026-03-16 19:54:47');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (121, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '192.168.60.93', NULL, '2026-03-16 19:54:49');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (122, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '192.168.60.195', NULL, '2026-03-16 19:54:51');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (123, 'Juez 2', 'juez2@expotecnica.local', 'usuario', 'auth.login', 'auth', 11, 'Inicio de sesion correcto', '192.168.60.4', NULL, '2026-03-16 19:55:05');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (124, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: juez2@expotecnica.local', '192.168.60.94', NULL, '2026-03-16 19:55:14');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (125, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: juez@expotecnica.local', '192.168.60.95', NULL, '2026-03-16 19:55:14');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (126, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: jues@expotecnica.local', '192.168.60.95', NULL, '2026-03-16 19:55:23');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (127, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: jues2@expotecnica.local', '192.168.60.94', NULL, '2026-03-16 19:55:40');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (128, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: juez2@expotecnica.local', '192.168.60.95', NULL, '2026-03-16 19:55:40');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (129, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: juez2@expotecnica.local', '192.168.60.93', NULL, '2026-03-16 19:55:41');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (130, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.assignment.create', 'assignment', NULL, 'Asignacion creada: juez=Juez 2 <juez2@expotecnica.local> => proyecto=#5 \'InnovaMind\'', '127.0.0.1', NULL, '2026-03-16 19:55:49');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (131, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.assignment.create', 'assignment', NULL, 'Asignacion creada: juez=Juez 2 <juez2@expotecnica.local> => proyecto=#1 \'FiveSolutions\'', '127.0.0.1', NULL, '2026-03-16 19:56:01');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (132, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: juez2@expotecnica.local', '192.168.60.94', NULL, '2026-03-16 19:56:11');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (133, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: juez2@expotecnica.local', '192.168.60.93', NULL, '2026-03-16 19:56:16');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (134, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: juez2@expotecnica.local', '192.168.60.94', NULL, '2026-03-16 19:56:50');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (135, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: juez2@expotecnica.local', '192.168.60.94', NULL, '2026-03-16 19:57:28');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (136, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: juez2@expotecnica.local', '192.168.60.94', NULL, '2026-03-16 20:00:11');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (137, 'Juez 2', 'juez2@expotecnica.local', 'usuario', 'auth.login', 'auth', 11, 'Inicio de sesion correcto', '192.168.60.93', NULL, '2026-03-16 20:00:56');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (138, 'Juez 2', 'juez2@expotecnica.local', 'usuario', 'auth.login', 'auth', 11, 'Inicio de sesion correcto', '192.168.60.94', NULL, '2026-03-16 20:00:56');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (139, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: juez2@expotecnia.local', '192.168.60.241', NULL, '2026-03-16 20:01:04');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (140, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: jues2@expotecnica.local', '192.168.60.95', NULL, '2026-03-16 20:01:12');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (141, 'Juez 2', 'juez2@expotecnica.local', 'usuario', 'auth.login', 'auth', 11, 'Inicio de sesion correcto', '192.168.60.95', NULL, '2026-03-16 20:01:21');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (142, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: juez2@expotecnia.local', '192.168.60.241', NULL, '2026-03-16 20:01:33');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (143, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: juez1@expotecnia.local', '192.168.60.241', NULL, '2026-03-16 20:02:46');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (144, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: juez1@expotecnia.local', '192.168.60.241', NULL, '2026-03-16 20:03:19');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (145, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: admin@expotecnica.local', '192.168.60.218', NULL, '2026-03-16 20:03:28');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (146, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: quest2@expotecnica.local', '192.168.60.218', NULL, '2026-03-16 20:04:25');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (147, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: quest2@expotecnica.local', '192.168.60.218', NULL, '2026-03-16 20:04:31');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (148, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: quest2@expotecnica.local', '192.168.60.218', NULL, '2026-03-16 20:04:37');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (149, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: juez1@expotecnia.local', '192.168.60.241', NULL, '2026-03-16 20:07:13');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (150, 'Juez 2', 'juez2@expotecnica.local', 'usuario', 'auth.logout', 'auth', 11, 'Cierre de sesion', '192.168.60.94', NULL, '2026-03-16 20:07:18');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (151, 'Juez 2', 'juez2@expotecnica.local', 'usuario', 'auth.login', 'auth', 11, 'Inicio de sesion correcto', '192.168.60.94', NULL, '2026-03-16 20:07:30');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (152, 'Juez 2', 'juez2@expotecnica.local', 'usuario', 'auth.logout', 'auth', 11, 'Cierre de sesion', '192.168.60.94', NULL, '2026-03-16 20:08:44');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (153, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-16 20:42:47');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (154, 'Juez 2', 'juez2@expotecnica.local', 'usuario', 'auth.login', 'auth', 11, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-16 20:43:02');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (155, 'Juez 2', 'juez2@expotecnica.local', 'usuario', 'auth.login', 'auth', 11, 'Inicio de sesion correcto', '192.168.60.4', NULL, '2026-03-16 20:50:19');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (156, 'Juez 2', 'juez2@expotecnica.local', 'usuario', 'auth.login', 'auth', 11, 'Inicio de sesion correcto', '192.168.60.94', NULL, '2026-03-16 21:07:48');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (157, 'Juez 2', 'juez2@expotecnica.local', 'usuario', 'auth.logout', 'auth', 11, 'Cierre de sesion', '192.168.60.94', NULL, '2026-03-16 21:09:22');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (158, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '192.168.60.195', NULL, '2026-03-16 21:44:03');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (159, 'Juez 2', 'juez2@expotecnica.local', 'usuario', 'auth.logout', 'auth', 11, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-16 21:44:11');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (160, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-16 21:44:21');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (161, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '192.168.60.195', NULL, '2026-03-16 21:44:37');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (162, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.assignment.create', 'assignment', NULL, 'Asignacion creada: juez=Juez Demo <juez1@expotecnica.local> => proyecto=#5 \'InnovaMind\'', '192.168.60.195', NULL, '2026-03-16 21:45:13');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (163, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '192.168.60.178', NULL, '2026-03-16 21:45:53');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (164, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '192.168.60.178', NULL, '2026-03-16 21:47:22');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (165, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '192.168.60.195', NULL, '2026-03-16 21:47:25');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (166, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: juez2@expotecnica.loca', '192.168.60.195', NULL, '2026-03-16 21:49:26');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (167, 'Juez 2', 'juez2@expotecnica.local', 'usuario', 'auth.login', 'auth', 11, 'Inicio de sesion correcto', '192.168.60.195', NULL, '2026-03-16 21:49:40');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (168, 'Juez 2', 'juez2@expotecnica.local', 'usuario', 'auth.login', 'auth', 11, 'Inicio de sesion correcto', '192.168.60.178', NULL, '2026-03-16 21:49:47');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (169, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.user.set_password', 'judge', 1, 'Contrasena asignada manualmente a usuario: Juez Demo <juez1@expotecnica.local>', '127.0.0.1', NULL, '2026-03-16 21:58:28');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (170, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.evaluation.delete', 'evaluation', 2, 'Evaluacion eliminada: proyecto=#1 \'FiveSolutions\', juez=Juez Demo, tipo=escrito', '127.0.0.1', NULL, '2026-03-16 22:01:13');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (171, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.evaluation.delete', 'evaluation', 1, 'Evaluacion eliminada: proyecto=#1 \'FiveSolutions\', juez=Juez Demo, tipo=exposicion', '127.0.0.1', NULL, '2026-03-16 22:01:18');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (172, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.assignment.create', 'assignment', NULL, 'Asignacion creada: juez=Juez Demo <juez1@expotecnica.local> => proyecto=#12 \'brayanduro\'', '127.0.0.1', NULL, '2026-03-16 22:06:00');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (173, 'Juez 2', 'juez2@expotecnica.local', 'usuario', 'auth.login', 'auth', 11, 'Inicio de sesion correcto', '192.168.60.195', NULL, '2026-03-16 22:07:27');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (174, 'Juez 2', 'juez2@expotecnica.local', 'usuario', 'auth.logout', 'auth', 11, 'Cierre de sesion', '192.168.60.195', NULL, '2026-03-16 22:07:43');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (175, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '192.168.60.195', NULL, '2026-03-16 22:07:46');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (176, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.assignment.delete', 'assignment', 7, 'Asignacion eliminada: juez=Juez Demo <juez1@expotecnica.local> de proyecto=#12 \'brayanduro\'', '127.0.0.1', NULL, '2026-03-16 22:15:33');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (177, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.assignment.delete', 'assignment', 6, 'Asignacion eliminada: juez=Juez Demo <juez1@expotecnica.local> de proyecto=#5 \'InnovaMind\'', '127.0.0.1', NULL, '2026-03-16 22:15:35');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (178, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.assignment.delete', 'assignment', 5, 'Asignacion eliminada: juez=Juez 2 <juez2@expotecnica.local> de proyecto=#1 \'FiveSolutions\'', '127.0.0.1', NULL, '2026-03-16 22:15:36');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (179, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.assignment.delete', 'assignment', 4, 'Asignacion eliminada: juez=Juez 2 <juez2@expotecnica.local> de proyecto=#5 \'InnovaMind\'', '127.0.0.1', NULL, '2026-03-16 22:15:38');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (180, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.assignment.delete', 'assignment', 1, 'Asignacion eliminada: juez=Juez Demo <juez1@expotecnica.local> de proyecto=#1 \'FiveSolutions\'', '127.0.0.1', NULL, '2026-03-16 22:15:39');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (181, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.assignment.create', 'assignment', NULL, 'Asignacion creada: juez=Juez Demo <juez1@expotecnica.local> => proyecto=#14 \'Fast\'', '127.0.0.1', NULL, '2026-03-16 22:16:11');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (182, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.assignment.create', 'assignment', NULL, 'Asignacion creada: juez=Juez Demo <juez1@expotecnica.local> => proyecto=#5 \'InnovaMind\'', '127.0.0.1', NULL, '2026-03-16 22:16:11');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (183, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.assignment.create', 'assignment', NULL, 'Asignacion creada: juez=Juez 2 <juez2@expotecnica.local> => proyecto=#14 \'Fast\'', '127.0.0.1', NULL, '2026-03-16 22:16:26');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (184, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.assignment.create', 'assignment', NULL, 'Asignacion creada: juez=Juez 2 <juez2@expotecnica.local> => proyecto=#5 \'InnovaMind\'', '127.0.0.1', NULL, '2026-03-16 22:16:26');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (185, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-16 22:16:51');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (186, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '192.168.60.195', NULL, '2026-03-16 22:16:55');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (187, 'Juez 2', 'juez2@expotecnica.local', 'usuario', 'auth.login', 'auth', 11, 'Inicio de sesion correcto', '192.168.60.195', NULL, '2026-03-16 22:17:00');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (188, 'Juez Demo', 'juez1@expotecnica.local', 'usuario', 'auth.login', 'auth', 1, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-16 22:17:01');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (189, 'Juez Demo', 'juez1@expotecnica.local', 'usuario', 'auth.logout', 'auth', 1, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-16 22:17:43');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (190, 'Juez 2', 'juez2@expotecnica.local', 'usuario', 'auth.login', 'auth', 11, 'Inicio de sesion correcto', '192.168.60.4', NULL, '2026-03-16 22:17:59');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (191, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-16 22:18:32');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (192, 'Juez 2', 'juez2@expotecnica.local', 'usuario', 'auth.login', 'auth', 11, 'Inicio de sesion correcto', '192.168.60.178', NULL, '2026-03-16 22:24:29');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (193, 'Juez 2', 'juez2@expotecnica.local', 'usuario', 'auth.logout', 'auth', 11, 'Cierre de sesion', '192.168.60.178', NULL, '2026-03-16 22:24:42');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (194, 'Juez Demo', 'juez1@expotecnica.local', 'usuario', 'auth.login', 'auth', 1, 'Inicio de sesion correcto', '192.168.60.178', NULL, '2026-03-16 22:24:54');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (195, 'Juez 2', 'juez2@expotecnica.local', 'usuario', 'auth.login', 'auth', 11, 'Inicio de sesion correcto', '192.168.60.184', NULL, '2026-03-16 22:24:59');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (196, 'Juez 2', 'juez2@expotecnica.local', 'usuario', 'auth.logout', 'auth', 11, 'Cierre de sesion', '192.168.60.184', NULL, '2026-03-16 22:25:29');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (197, 'Juez Demo', 'juez1@expotecnica.local', 'usuario', 'auth.login', 'auth', 1, 'Inicio de sesion correcto', '192.168.60.184', NULL, '2026-03-16 22:25:56');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (198, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-16 22:37:00');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (199, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: admin@expotecnica.local', '127.0.0.1', NULL, '2026-03-16 22:37:23');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (200, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 2, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-16 22:37:32');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (201, 'Administrador', 'admin@expotecnica.local', 'admin', 'admin.evaluation.delete', 'evaluation', 10, 'Evaluacion eliminada: proyecto=#14 \'Fast\', juez=Juez 2, tipo=english_project_performance', '127.0.0.1', NULL, '2026-03-16 22:37:44');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (202, 'Administrador', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 2, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-16 22:38:05');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (203, 'Juez 2', 'juez2@expotecnica.local', 'usuario', 'auth.login', 'auth', 11, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-16 22:38:17');

DROP TABLE IF EXISTS `system_settings`;
CREATE TABLE `system_settings` (
  `key` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` text COLLATE utf8mb4_unicode_ci,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('maintenance_enabled', '1', '2026-03-11 22:25:32');
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('maintenance_image_path', '', '2026-03-11 21:28:35');
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('maintenance_message', 'Estamos cargando información de proyectos. Vuelve pronto.', '2026-03-11 22:25:32');
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('projects_public_enabled', '1', '2026-03-11 21:23:19');
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('school_address', '', '2026-03-11 21:12:04');
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('school_email', 'ctp.robertogamboavalverde@mep.go.cr', '2026-03-11 21:12:04');
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('school_logo_path', 'uploads/institution/2a6ec39bee5b46cbb8842cdbf9e121e3.jpg', '2026-03-11 21:10:38');
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('school_name', 'CTP Roberto Gamboa Valverde', '2026-03-11 21:12:04');
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('school_phone', '+506 2275-2317', '2026-03-11 21:12:04');
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('smtp_from_email', 'notificaciones@apolo.co.cr', '2026-03-11 20:37:14');
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('smtp_host', 'securemail.comredcr.com', '2026-03-11 20:37:14');
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('smtp_password', '87Acd28F00', '2026-03-11 14:51:47');
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('smtp_port', '465', '2026-03-11 20:37:14');
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('smtp_use_ssl', '1', '2026-03-11 20:37:14');
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('smtp_use_tls', '0', '2026-03-11 20:37:14');
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('smtp_username', 'notificaciones@apolo.co.cr', '2026-03-11 20:37:14');

DROP TABLE IF EXISTS `workshops`;
CREATE TABLE `workshops` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(140) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` int NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_workshops_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `workshops` (`id`, `name`, `sort_order`, `is_active`) VALUES (1, 'Taller 1', 1, 1);
INSERT INTO `workshops` (`id`, `name`, `sort_order`, `is_active`) VALUES (2, 'Taller 2', 2, 1);

SET FOREIGN_KEY_CHECKS=1;
