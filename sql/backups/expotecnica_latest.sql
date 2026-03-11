-- Backup generado automaticamente por scripts/backup_db.py
-- Fecha: 2026-03-11 10:19:52
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `assignments` (`id`, `judge_id`, `project_id`) VALUES (1, 1, 1);
INSERT INTO `assignments` (`id`, `judge_id`, `project_id`) VALUES (2, 1, 2);

DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `sort_order` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_categories_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `categories` (`id`, `code`, `name`, `is_active`, `sort_order`) VALUES (1, 'steam', 'STEAM', 1, 1);
INSERT INTO `categories` (`id`, `code`, `name`, `is_active`, `sort_order`) VALUES (2, 'emprendimiento', 'Emprendimiento', 1, 2);

DROP TABLE IF EXISTS `evaluation_types`;
CREATE TABLE `evaluation_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `sort_order` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_evaluation_types_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `evaluation_types` (`id`, `code`, `name`, `is_active`, `sort_order`) VALUES (1, 'escrito', 'Escrito', 1, 1);
INSERT INTO `evaluation_types` (`id`, `code`, `name`, `is_active`, `sort_order`) VALUES (2, 'exposicion', 'Exposicion', 1, 2);

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
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_eval_type_per_judge_project` (`judge_id`,`project_id`,`evaluation_type`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `evaluations_ibfk_1` FOREIGN KEY (`judge_id`) REFERENCES `judges` (`id`),
  CONSTRAINT `evaluations_ibfk_2` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `judges` (`id`, `full_name`, `email`, `password_hash`, `is_active_user`, `is_admin`) VALUES (1, 'Juez Demo', 'juez1@expotecnica.local', 'scrypt:32768:8:1$xGfpP0SO0jsZVoKz$53ba77facb3be623d7342fac698a082643eaddee65a40de65075be8b21e9527805044f404637b78954731d0303443cc9b868adc5c2ac8e3f47c973e1611f0b7b', 1, 0);
INSERT INTO `judges` (`id`, `full_name`, `email`, `password_hash`, `is_active_user`, `is_admin`) VALUES (2, 'Administrador', 'admin@expotecnica.local', 'scrypt:32768:8:1$JUkS3sFx3Q0ZCjcV$c46a595165dd7f745c524df71235ae2ff8af334e842358a206858da91ab286b5f5cbc7d8c5fc30c393951e9b75889a023d9e1d1ccf61c054ad1c3486cf513cf8', 1, 1);

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
  PRIMARY KEY (`id`),
  KEY `ix_project_members_project_id` (`project_id`),
  CONSTRAINT `project_members_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `project_members` (`id`, `project_id`, `full_name`, `role`, `photo_url`, `created_at`, `student_number`, `identity_number`, `birth_date`, `gender`, `specialty`, `section_name`, `has_dining_scholarship`, `phone`, `email`) VALUES (5, 5, 'Caleb', 'The Boss', 'uploads/members/93b8e475d6dd4166a5c87c3c3812901b.png', '2026-03-11 14:17:52', 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL);
INSERT INTO `project_members` (`id`, `project_id`, `full_name`, `role`, `photo_url`, `created_at`, `student_number`, `identity_number`, `birth_date`, `gender`, `specialty`, `section_name`, `has_dining_scholarship`, `phone`, `email`) VALUES (6, 5, 'Cruz', 'El Segundon al mando', 'uploads/members/20173cc40e59459998b6868fe52babbc.png', '2026-03-11 14:17:52', 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL);

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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `projects` (`id`, `title`, `team_name`, `representative_name`, `representative_email`, `category`, `description`, `created_at`, `representative_phone`, `institution_name`, `grade_level`, `specialty`, `advisor_name`, `advisor_email`, `advisor_phone`, `project_objective`, `expected_impact`, `required_resources`, `consent_terms`, `registration_date`, `advisor_identity`, `requirements_summary`, `requirements_other`) VALUES (1, 'FiveSolutions', '10-3', 'Erick Sevilla', 'vegabryan@gmail.com', 'emprendimiento', 'No entiendo como no gano', '2026-03-10 17:26:23', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `projects` (`id`, `title`, `team_name`, `representative_name`, `representative_email`, `category`, `description`, `created_at`, `representative_phone`, `institution_name`, `grade_level`, `specialty`, `advisor_name`, `advisor_email`, `advisor_phone`, `project_objective`, `expected_impact`, `required_resources`, `consent_terms`, `registration_date`, `advisor_identity`, `requirements_summary`, `requirements_other`) VALUES (2, 'Alohomora', '9-5', 'Sebastian Navarro', 'vegabryan@hotmail.com', 'steam', 'Este si gano', '2026-03-11 13:17:21', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `projects` (`id`, `title`, `team_name`, `representative_name`, `representative_email`, `category`, `description`, `created_at`, `representative_phone`, `institution_name`, `grade_level`, `specialty`, `advisor_name`, `advisor_email`, `advisor_phone`, `project_objective`, `expected_impact`, `required_resources`, `consent_terms`, `registration_date`, `advisor_identity`, `requirements_summary`, `requirements_other`) VALUES (5, 'InnovaMind', '11-3', 'Caleb Mesén', 'caleb@gmail.com', 'emprendimiento', 'Este casi gana', '2026-03-11 14:17:52', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL);

DROP TABLE IF EXISTS `rubric_criteria`;
CREATE TABLE `rubric_criteria` (
  `id` int NOT NULL AUTO_INCREMENT,
  `evaluation_type_id` int NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `min_score` int NOT NULL,
  `max_score` int NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `sort_order` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_rubric_criteria_evaluation_type_id` (`evaluation_type_id`),
  CONSTRAINT `rubric_criteria_ibfk_1` FOREIGN KEY (`evaluation_type_id`) REFERENCES `evaluation_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (1, 1, 'Dominio del tema', 1, 25, 1, 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (2, 1, 'Metodologia', 1, 25, 1, 2);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (3, 1, 'Innovacion', 1, 25, 1, 3);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (4, 1, 'Impacto', 1, 25, 1, 4);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (5, 2, 'Claridad', 1, 25, 1, 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (6, 2, 'Contenido', 1, 25, 1, 2);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (7, 2, 'Argumentacion', 1, 25, 1, 3);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (8, 2, 'Presentacion', 1, 25, 1, 4);

DROP TABLE IF EXISTS `system_settings`;
CREATE TABLE `system_settings` (
  `key` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` text COLLATE utf8mb4_unicode_ci,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('smtp_from_email', 'notificaciones@apolo.co.cr', '2026-03-11 14:51:47');
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('smtp_host', 'securemail.comredcr.com', '2026-03-11 14:51:47');
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('smtp_password', '87Acd28F00', '2026-03-11 14:51:47');
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('smtp_port', '465', '2026-03-11 14:51:47');
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('smtp_use_ssl', '1', '2026-03-11 14:51:47');
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('smtp_use_tls', '1', '2026-03-11 14:51:47');
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('smtp_username', 'notificaciones@apolo.co.cr', '2026-03-11 14:51:47');

SET FOREIGN_KEY_CHECKS=1;
