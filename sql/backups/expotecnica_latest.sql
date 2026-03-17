-- Backup generado automaticamente por scripts/backup_db.py
-- Fecha: 2026-03-16 22:03:51
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `campaigns` (`id`, `name`, `start_date`, `end_date`, `is_active`, `notes`, `created_at`) VALUES (1, 'c1', '2026-03-16', '2026-03-19', 1, '', '2026-03-17 03:59:11');

DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rubric_1_evaluation_type_id` int DEFAULT NULL,
  `rubric_2_evaluation_type_id` int DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL,
  `sort_order` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_categories_code` (`code`),
  KEY `rubric_1_evaluation_type_id` (`rubric_1_evaluation_type_id`),
  KEY `rubric_2_evaluation_type_id` (`rubric_2_evaluation_type_id`),
  CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`rubric_1_evaluation_type_id`) REFERENCES `evaluation_types` (`id`),
  CONSTRAINT `categories_ibfk_2` FOREIGN KEY (`rubric_2_evaluation_type_id`) REFERENCES `evaluation_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `categories` (`id`, `code`, `name`, `rubric_1_evaluation_type_id`, `rubric_2_evaluation_type_id`, `is_active`, `sort_order`) VALUES (1, 'steam', 'STEAM', NULL, NULL, 1, 1);
INSERT INTO `categories` (`id`, `code`, `name`, `rubric_1_evaluation_type_id`, `rubric_2_evaluation_type_id`, `is_active`, `sort_order`) VALUES (2, 'emprendimiento', 'Emprendimiento', NULL, NULL, 1, 2);

DROP TABLE IF EXISTS `evaluation_scores`;
CREATE TABLE `evaluation_scores` (
  `id` int NOT NULL AUTO_INCREMENT,
  `evaluation_id` int NOT NULL,
  `rubric_criterion_id` int NOT NULL,
  `score` int NOT NULL,
  `observation` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_evaluation_score_criterion` (`evaluation_id`,`rubric_criterion_id`),
  KEY `ix_evaluation_scores_evaluation_id` (`evaluation_id`),
  KEY `ix_evaluation_scores_rubric_criterion_id` (`rubric_criterion_id`),
  CONSTRAINT `evaluation_scores_ibfk_1` FOREIGN KEY (`evaluation_id`) REFERENCES `evaluations` (`id`),
  CONSTRAINT `evaluation_scores_ibfk_2` FOREIGN KEY (`rubric_criterion_id`) REFERENCES `rubric_criteria` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `evaluation_types`;
CREATE TABLE `evaluation_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `scale_labels` text COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) NOT NULL,
  `sort_order` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_evaluation_types_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `evaluation_types` (`id`, `code`, `name`, `scale_labels`, `is_active`, `sort_order`) VALUES (1, 'escrito', 'Escrito', NULL, 1, 1);
INSERT INTO `evaluation_types` (`id`, `code`, `name`, `scale_labels`, `is_active`, `sort_order`) VALUES (2, 'exposicion', 'Exposicion', NULL, 1, 2);
INSERT INTO `evaluation_types` (`id`, `code`, `name`, `scale_labels`, `is_active`, `sort_order`) VALUES (3, 'steam_exposicion', 'Evaluacion de la Exposicion del Proyecto (Desafio STEAM)', '{"3": "Logrado", "2": "Parcialmente logrado", "1": "No logrado", "0": "Ausente"}', 1, 3);
INSERT INTO `evaluation_types` (`id`, `code`, `name`, `scale_labels`, `is_active`, `sort_order`) VALUES (4, 'modelo_negocio_exposicion', 'Evaluacion de la Exposicion del Modelo de Negocios', '{"3": "Logrado", "2": "Parcialmente logrado", "1": "No logrado", "0": "Ausente"}', 1, 4);
INSERT INTO `evaluation_types` (`id`, `code`, `name`, `scale_labels`, `is_active`, `sort_order`) VALUES (5, 'steam_informe_bitacora', 'Evaluacion del Informe Escrito y Bitacora del Proyecto (Desafio STEAM)', '{"3": "Logrado", "2": "Parcialmente logrado", "1": "No logrado", "0": "Ausente"}', 1, 5);
INSERT INTO `evaluation_types` (`id`, `code`, `name`, `scale_labels`, `is_active`, `sort_order`) VALUES (6, 'modelo_negocio_documento', 'Evaluacion del Documento Escrito del Modelo de Negocios', '{"3": "Logrado", "2": "Parcialmente logrado", "1": "No logrado", "0": "Ausente"}', 1, 6);
INSERT INTO `evaluation_types` (`id`, `code`, `name`, `scale_labels`, `is_active`, `sort_order`) VALUES (7, 'plan_negocio_documento', 'Evaluacion del Documento Escrito del Plan de Negocios', '{"3": "Logrado", "2": "Parcialmente logrado", "1": "No logrado", "0": "Ausente"}', 1, 7);
INSERT INTO `evaluation_types` (`id`, `code`, `name`, `scale_labels`, `is_active`, `sort_order`) VALUES (8, 'english_project_performance', 'Assessment Rubric for English Project Performance', '{"5": "Exceptional", "4": "Very Good", "3": "Average", "2": "Below Average", "1": "Unsatisfactory"}', 1, 8);

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
  `recommendations` text COLLATE utf8mb4_unicode_ci,
  `max_score` int DEFAULT NULL,
  `percentage` float DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_eval_type_per_judge_project` (`judge_id`,`project_id`,`evaluation_type`),
  KEY `project_id` (`project_id`),
  KEY `ix_evaluations_evaluation_type` (`evaluation_type`),
  CONSTRAINT `evaluations_ibfk_1` FOREIGN KEY (`judge_id`) REFERENCES `judges` (`id`),
  CONSTRAINT `evaluations_ibfk_2` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `judges`;
CREATE TABLE `judges` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `department` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `job_title` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active_user` tinyint(1) NOT NULL,
  `is_admin` tinyint(1) NOT NULL,
  `must_change_password` tinyint(1) NOT NULL,
  `last_login_at` datetime DEFAULT NULL,
  `role` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'judge',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `ix_judges_department` (`department`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `judges` (`id`, `full_name`, `email`, `department`, `job_title`, `phone`, `password_hash`, `is_active_user`, `is_admin`, `must_change_password`, `last_login_at`, `role`) VALUES (1, 'Administrador Sistema', 'admin@expotecnica.local', 'qa', NULL, NULL, 'scrypt:32768:8:1$vqsUYzMWNlO26Uat$9fcbee5bbf4930f0e8e566f75d3f85414eb49c1f04e98202b53302ab69faa8c3fcedc530ed132acdc478f1337e2a4c52aa8dbe314fdafdb012a6850124320b36', 1, 1, 0, '2026-03-17 02:11:26', 'superadmin');

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
  KEY `ix_project_member_changes_member_id` (`member_id`),
  KEY `ix_project_member_changes_project_id` (`project_id`),
  CONSTRAINT `project_member_changes_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`),
  CONSTRAINT `project_member_changes_ibfk_2` FOREIGN KEY (`member_id`) REFERENCES `project_members` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `project_members`;
CREATE TABLE `project_members` (
  `id` int NOT NULL AUTO_INCREMENT,
  `project_id` int NOT NULL,
  `student_number` int NOT NULL,
  `full_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `identity_number` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `gender` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `specialty` varchar(140) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `section_name` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `has_dining_scholarship` tinyint(1) NOT NULL,
  `participates_in_english` tinyint(1) NOT NULL,
  `phone` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `photo_url` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_project_members_project_id` (`project_id`),
  CONSTRAINT `project_members_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `projects`;
CREATE TABLE `projects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `registration_date` date DEFAULT NULL,
  `title` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `team_name` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `representative_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `representative_email` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `representative_phone` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `institution_name` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `grade_level` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `specialty` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `section_id` int DEFAULT NULL,
  `specialty_id` int DEFAULT NULL,
  `workshop_id` int DEFAULT NULL,
  `campaign_id` int DEFAULT NULL,
  `advisor_name` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `advisor_identity` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `advisor_email` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `advisor_phone` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `project_objective` text COLLATE utf8mb4_unicode_ci,
  `expected_impact` text COLLATE utf8mb4_unicode_ci,
  `required_resources` text COLLATE utf8mb4_unicode_ci,
  `requirements_summary` text COLLATE utf8mb4_unicode_ci,
  `requirements_other` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `project_document_path` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `project_logo_path` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL,
  `logistics_status` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `logistics_notes` text COLLATE utf8mb4_unicode_ci,
  `logistics_document_ok` tinyint(1) NOT NULL,
  `logistics_logo_ok` tinyint(1) NOT NULL,
  `logistics_photos_ok` tinyint(1) NOT NULL,
  `consent_terms` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_projects_logistics_status` (`logistics_status`),
  KEY `ix_projects_section_id` (`section_id`),
  KEY `ix_projects_workshop_id` (`workshop_id`),
  KEY `ix_projects_specialty_id` (`specialty_id`),
  KEY `ix_projects_category` (`category`),
  KEY `ix_projects_is_active` (`is_active`),
  KEY `ix_projects_campaign_id` (`campaign_id`),
  CONSTRAINT `projects_ibfk_1` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`),
  CONSTRAINT `projects_ibfk_2` FOREIGN KEY (`specialty_id`) REFERENCES `specialties` (`id`),
  CONSTRAINT `projects_ibfk_3` FOREIGN KEY (`workshop_id`) REFERENCES `workshops` (`id`),
  CONSTRAINT `projects_ibfk_4` FOREIGN KEY (`campaign_id`) REFERENCES `campaigns` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `rubric_criteria`;
CREATE TABLE `rubric_criteria` (
  `id` int NOT NULL AUTO_INCREMENT,
  `evaluation_type_id` int NOT NULL,
  `section_name` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `section_sort_order` int NOT NULL,
  `name` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `min_score` int NOT NULL,
  `max_score` int NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `sort_order` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_rubric_criteria_evaluation_type_id` (`evaluation_type_id`),
  CONSTRAINT `rubric_criteria_ibfk_1` FOREIGN KEY (`evaluation_type_id`) REFERENCES `evaluation_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=159 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (1, 1, NULL, 0, 'Dominio del tema', 1, 25, 1, 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (2, 1, NULL, 0, 'Metodologia', 1, 25, 1, 2);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (3, 1, NULL, 0, 'Innovacion', 1, 25, 1, 3);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (4, 1, NULL, 0, 'Impacto', 1, 25, 1, 4);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (5, 2, NULL, 0, 'Claridad', 1, 25, 1, 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (6, 2, NULL, 0, 'Contenido', 1, 25, 1, 2);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (7, 2, NULL, 0, 'Argumentacion', 1, 25, 1, 3);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (8, 2, NULL, 0, 'Presentacion', 1, 25, 1, 4);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (9, 3, 'I. Identificacion y formulacion del problema', 1, 'Define el problema de forma precisa.', 0, 3, 1, 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (10, 3, 'I. Identificacion y formulacion del problema', 1, 'Plantea alternativas de solucion que contemplen conceptos teoricos practicos atinentes al problema.', 0, 3, 1, 2);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (11, 3, 'I. Identificacion y formulacion del problema', 1, 'Propone objetivos vinculados con la busqueda de soluciones al problema planteado.', 0, 3, 1, 3);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (12, 3, 'I. Identificacion y formulacion del problema', 1, 'Evidencia el impacto del proyecto a nivel social, cientifico o tecnologico, tanto a corto como largo plazo.', 0, 3, 1, 4);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (13, 3, 'I. Identificacion y formulacion del problema', 1, 'Demuestra capacidad para expresar ideas con seguridad y defender el proyecto planteado.', 0, 3, 1, 5);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (14, 3, 'II. Investigacion y desarrollo', 2, 'Demuestra en su elaboracion una linea de investigacion y desarrollo coherente y clara.', 0, 3, 1, 6);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (15, 3, 'II. Investigacion y desarrollo', 2, 'Argumenta, desde la implementacion del proyecto, el analisis e interpretacion de los datos recopilados.', 0, 3, 1, 7);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (16, 3, 'II. Investigacion y desarrollo', 2, 'Evidencia la gestion de recursos y busqueda de apoyo para la elaboracion del proyecto.', 0, 3, 1, 8);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (17, 3, 'II. Investigacion y desarrollo', 2, 'Demuestra originalidad y autoria propia del proyecto expuesto.', 0, 3, 1, 9);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (18, 3, 'II. Investigacion y desarrollo', 2, 'Aplica la normativa vigente en el contexto del proyecto.', 0, 3, 1, 10);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (19, 3, 'II. Investigacion y desarrollo', 2, 'Se evidencia la factibilidad e implementacion comercial o industrial del proyecto, a futuro.', 0, 3, 1, 11);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (20, 3, 'III. Prototipo', 3, 'Presenta una linea de trabajo de investigacion y desarrollo coherente y clara.', 0, 3, 1, 12);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (21, 3, 'III. Prototipo', 3, 'Da respuesta a la necesidad u objetivos planteados.', 0, 3, 1, 13);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (22, 3, 'III. Prototipo', 3, 'Evidencia el uso optimo de los recursos disponibles para su construccion.', 0, 3, 1, 14);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (23, 3, 'III. Prototipo', 3, 'Demuestra precision tecnica en la elaboracion y funcionamiento del prototipo.', 0, 3, 1, 15);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (24, 3, 'III. Prototipo', 3, 'Respeta las normativas de seguridad y otras vigentes en su construccion y desempeno.', 0, 3, 1, 16);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (25, 3, 'III. Prototipo', 3, 'Muestra actualidad tecnologica en el campo de trabajo seleccionado.', 0, 3, 1, 17);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (26, 3, 'III. Prototipo', 3, 'Evidencia el funcionamiento correcto segun la solucion planteada en el proyecto.', 0, 3, 1, 18);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (27, 3, 'III. Prototipo', 3, 'Demuestra creatividad e innovacion al crear el prototipo.', 0, 3, 1, 19);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (28, 3, 'IV. Exposicion del proyecto', 4, 'Evidencia apropiacion y dominio del tema del proyecto.', 0, 3, 1, 20);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (29, 3, 'IV. Exposicion del proyecto', 4, 'Demuestra claridad y coherencia en la exposicion del proyecto ante el panel de jueces.', 0, 3, 1, 21);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (30, 3, 'IV. Exposicion del proyecto', 4, 'Utiliza lenguaje tecnico acorde con el nivel academico y el campo de desarrollo del proyecto.', 0, 3, 1, 22);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (31, 3, 'IV. Exposicion del proyecto', 4, 'Argumenta de forma solida y fundamentada su propuesta de proyecto.', 0, 3, 1, 23);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (32, 3, 'IV. Exposicion del proyecto', 4, 'Emplea recursos afines con el tema del proyecto.', 0, 3, 1, 24);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (33, 3, 'IV. Exposicion del proyecto', 4, 'Describe la metodologia utilizada para la implementacion, evaluacion y perfeccionamiento de la solucion propuesta.', 0, 3, 1, 25);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (34, 3, 'IV. Exposicion del proyecto', 4, 'Presenta resultados consistentes con los objetivos y solucion al problema planteado.', 0, 3, 1, 26);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (35, 3, 'IV. Exposicion del proyecto', 4, 'Brinda conclusiones precisas y objetivas basadas en los resultados obtenidos.', 0, 3, 1, 27);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (36, 3, 'IV. Exposicion del proyecto', 4, 'Denota colaboracion y comunicacion efectiva del estudiante o integrantes del equipo.', 0, 3, 1, 28);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (37, 3, 'IV. Exposicion del proyecto', 4, 'Demuestra capacidad de recibir, analizar y aplicar sugerencias para mejorar el proyecto.', 0, 3, 1, 29);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (38, 3, 'V. Documentacion del proyecto', 5, 'Se evidencia congruencia entre lo expuesto y el informe escrito.', 0, 3, 1, 30);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (39, 3, 'V. Documentacion del proyecto', 5, 'Evidencia el uso de lenguaje tecnico afin al tema del proyecto.', 0, 3, 1, 31);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (40, 3, 'V. Documentacion del proyecto', 5, 'Estipula los procedimientos tecnicos utilizados.', 0, 3, 1, 32);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (41, 3, 'V. Documentacion del proyecto', 5, 'La bitacora detalla en forma cronologica los procesos de investigacion.', 0, 3, 1, 33);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (42, 3, 'V. Documentacion del proyecto', 5, 'La bitacora detalla en forma cronologica los procesos de implementacion.', 0, 3, 1, 34);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (43, 3, 'V. Documentacion del proyecto', 5, 'La bitacora detalla en forma cronologica los procesos de experimentacion.', 0, 3, 1, 35);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (44, 3, 'V. Documentacion del proyecto', 5, 'Contiene informacion relevante para la exposicion del proyecto.', 0, 3, 1, 36);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (45, 3, 'V. Documentacion del proyecto', 5, 'Utiliza el cartel o recursos audiovisuales como apoyo para la exposicion.', 0, 3, 1, 37);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (46, 4, 'Evaluacion de la Exposicion del Modelo de Negocios', 1, 'Define de forma precisa la operacion basica de la potencial empresa.', 0, 3, 1, 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (47, 4, 'Evaluacion de la Exposicion del Modelo de Negocios', 1, 'Plantea las alternativas de solucion que la empresa brindara al problema o necesidad detectada.', 0, 3, 1, 2);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (48, 4, 'Evaluacion de la Exposicion del Modelo de Negocios', 1, 'Describe los productos o servicios ofrecidos que brindan valor a los clientes.', 0, 3, 1, 3);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (49, 4, 'Evaluacion de la Exposicion del Modelo de Negocios', 1, 'Evidencia el impacto de la potencial empresa desde diversos ambitos, tanto a corto como a largo plazo.', 0, 3, 1, 4);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (50, 4, 'Evaluacion de la Exposicion del Modelo de Negocios', 1, 'Argumenta las diferencias que ofrece la potencial empresa con la competencia.', 0, 3, 1, 5);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (51, 4, 'Evaluacion de la Exposicion del Modelo de Negocios', 1, 'Demuestra un buen entendimiento del mercado, la competencia y aspectos financieros.', 0, 3, 1, 6);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (52, 4, 'Evaluacion de la Exposicion del Modelo de Negocios', 1, 'Argumenta con solidez que hace unico al negocio y por que constituye una buena oportunidad.', 0, 3, 1, 7);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (53, 4, 'Evaluacion de la Exposicion del Modelo de Negocios', 1, 'Demuestra gestion de los recursos de forma sostenible y responsable.', 0, 3, 1, 8);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (54, 4, 'Evaluacion de la Exposicion del Modelo de Negocios', 1, 'Demuestra claridad y coherencia en la exposicion del plan de negocios ante el panel de jueces.', 0, 3, 1, 9);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (55, 4, 'Evaluacion de la Exposicion del Modelo de Negocios', 1, 'Utiliza lenguaje tecnico acorde con el nivel academico y el campo del negocio.', 0, 3, 1, 10);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (56, 4, 'Evaluacion de la Exposicion del Modelo de Negocios', 1, 'Evidencia capacidad de comunicacion oral y dominio de la propuesta de valor.', 0, 3, 1, 11);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (57, 4, 'Evaluacion de la Exposicion del Modelo de Negocios', 1, 'Define los canales mediante los cuales hara llegar a los clientes la propuesta de valor.', 0, 3, 1, 12);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (58, 4, 'Evaluacion de la Exposicion del Modelo de Negocios', 1, 'Caracteriza el segmento de clientes (necesidades, comportamientos y atributos).', 0, 3, 1, 13);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (59, 4, 'Evaluacion de la Exposicion del Modelo de Negocios', 1, 'Expone una propuesta innovadora y creativa con respecto al mercado.', 0, 3, 1, 14);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (60, 4, 'Evaluacion de la Exposicion del Modelo de Negocios', 1, 'Describe las demandas del segmento de clientes y el seguimiento para asegurar la calidad de los bienes o servicios ofrecidos.', 0, 3, 1, 15);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (61, 4, 'Evaluacion de la Exposicion del Modelo de Negocios', 1, 'Expone las fuentes de ingresos y estructura de costos.', 0, 3, 1, 16);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (62, 4, 'Evaluacion de la Exposicion del Modelo de Negocios', 1, 'Explica los canales utilizados para dar a conocer su modelo de negocios.', 0, 3, 1, 17);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (63, 4, 'Evaluacion de la Exposicion del Modelo de Negocios', 1, 'Describe las alianzas estrategicas de su propuesta de valor.', 0, 3, 1, 18);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (64, 5, 'I. Introduccion', 1, 'Delimita los antecedentes del problema o necesidad por solventar.', 0, 3, 1, 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (65, 5, 'I. Introduccion', 1, 'Evidencia claridad en la definicion del problema.', 0, 3, 1, 2);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (66, 5, 'I. Introduccion', 1, 'Fundamenta la relevancia o utilidad potencial del proyecto.', 0, 3, 1, 3);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (67, 5, 'I. Introduccion', 1, 'Define los criterios tecnicos utilizados para la solucion del problema.', 0, 3, 1, 4);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (68, 5, 'I. Introduccion', 1, 'Evidencia la viabilidad del proyecto.', 0, 3, 1, 5);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (69, 5, 'II. Marco teorico', 2, 'Emplea variedad de fuentes de informacion confiables para sustentar el proyecto.', 0, 3, 1, 6);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (70, 5, 'II. Marco teorico', 2, 'Incluye citas bibliograficas relevantes, de forma critica dentro del texto, que documentan la investigacion y desarrollo del proyecto.', 0, 3, 1, 7);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (71, 5, 'II. Marco teorico', 2, 'Emplea fuentes bibliograficas actualizadas, segun el tema abordado en el proyecto.', 0, 3, 1, 8);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (72, 5, 'II. Marco teorico', 2, 'Define terminos o conceptos relevantes para la investigacion y desarrollo del proyecto.', 0, 3, 1, 9);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (73, 5, 'II. Marco teorico', 2, 'Sintetiza la informacion existente del tema en estudio.', 0, 3, 1, 10);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (74, 5, 'II. Marco teorico', 2, 'Evidencia la organizacion logica de la informacion recopilada.', 0, 3, 1, 11);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (75, 5, 'III. Objetivos', 3, 'Presenta el objetivo general y al menos dos objetivos especificos.', 0, 3, 1, 12);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (76, 5, 'III. Objetivos', 3, 'Se plantean de forma clara, precisa y segun estructura requerida.', 0, 3, 1, 13);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (77, 5, 'III. Objetivos', 3, 'Evidencia relacion con la propuesta de solucion planteada.', 0, 3, 1, 14);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (78, 5, 'IV. Metodologia', 4, 'Presenta las etapas del proyecto en el cronograma.', 0, 3, 1, 15);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (79, 5, 'IV. Metodologia', 4, 'Cumple con las etapas establecidas en el cronograma.', 0, 3, 1, 16);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (80, 5, 'IV. Metodologia', 4, 'Describe paso a paso los procedimientos y tecnicas utilizadas para la investigacion y desarrollo.', 0, 3, 1, 17);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (81, 5, 'IV. Metodologia', 4, 'Describe los recursos utilizados para la implementacion del proyecto.', 0, 3, 1, 18);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (82, 5, 'IV. Metodologia', 4, 'Evidencia procesos de mejora continua durante la investigacion y desarrollo del proyecto.', 0, 3, 1, 19);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (83, 5, 'IV. Metodologia', 4, 'Evidencia el desarrollo de ideas novedosas o la aplicacion creativa de conocimientos.', 0, 3, 1, 20);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (84, 5, 'IV. Metodologia', 4, 'Fundamenta los calculos requeridos para las demostraciones.', 0, 3, 1, 21);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (85, 5, 'IV. Metodologia', 4, 'Incluye disenos y esquemas claros en relacion con el desarrollo del prototipo.', 0, 3, 1, 22);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (86, 5, 'V. Discusion de los resultados y conclusiones', 5, 'Muestra concordancia entre los resultados obtenidos y los objetivos planteados.', 0, 3, 1, 23);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (87, 5, 'V. Discusion de los resultados y conclusiones', 5, 'Presenta los datos mediante tablas, diagramas, figuras, graficos, entre otros.', 0, 3, 1, 24);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (88, 5, 'V. Discusion de los resultados y conclusiones', 5, 'Evidencia la interpretacion de los resultados desde una vision analitica y reflexiva.', 0, 3, 1, 25);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (89, 5, 'V. Discusion de los resultados y conclusiones', 5, 'Demuestra resultados aplicables y utiles en la vida real.', 0, 3, 1, 26);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (90, 5, 'V. Discusion de los resultados y conclusiones', 5, 'Presenta coherencia entre los disenos y esquemas con respecto al prototipo desarrollado.', 0, 3, 1, 27);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (91, 5, 'V. Discusion de los resultados y conclusiones', 5, 'Plantea conclusiones relevantes en relacion con los objetivos trazados, analisis de datos y prototipado.', 0, 3, 1, 28);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (92, 5, 'V. Discusion de los resultados y conclusiones', 5, 'Concluye sobre el impacto ambiental, social o economico de la implementacion del proyecto.', 0, 3, 1, 29);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (93, 5, 'VI. Estructura y formato del proyecto', 6, 'Presenta una organizacion clara y logica, en congruencia con la estructura dada en los lineamientos.', 0, 3, 1, 30);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (94, 5, 'VI. Estructura y formato del proyecto', 6, 'Presenta el documento en formato de doble columna (IEEE, articulo de revista).', 0, 3, 1, 31);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (95, 5, 'VI. Estructura y formato del proyecto', 6, 'Presenta el listado de referencias citadas en el documento, segun formato APA vigente.', 0, 3, 1, 32);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (96, 5, 'VII. Bitacora', 7, 'Evidencia el proceso de investigacion y desarrollo realizado.', 0, 3, 1, 33);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (97, 5, 'VII. Bitacora', 7, 'Cumple con el formato solicitado, segun los lineamientos de la ExpoTECNICA.', 0, 3, 1, 34);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (98, 5, 'VII. Bitacora', 7, 'Presenta relacion con el informe escrito.', 0, 3, 1, 35);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (99, 6, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1, 'Describe de forma clara y precisa los antecedentes que fundamentan la propuesta de valor.', 0, 3, 1, 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (100, 6, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1, 'Explica con solidez que hace unico al negocio y por que es atractivo.', 0, 3, 1, 2);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (101, 6, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1, 'Describe las actividades clave que la empresa implementa para ofrecer una propuesta de valor.', 0, 3, 1, 3);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (102, 6, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1, 'Describe de forma detallada el producto o servicio propuesto que brinda valor a los clientes.', 0, 3, 1, 4);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (103, 6, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1, 'Detalla como los productos o servicios ofrecidos se diferencian de la competencia.', 0, 3, 1, 5);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (104, 6, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1, 'Emplea lenguaje tecnico acorde con el nivel academico y el campo del negocio.', 0, 3, 1, 6);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (105, 6, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1, 'Define los canales mediante los cuales hara llegar a los clientes la propuesta de valor.', 0, 3, 1, 7);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (106, 6, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1, 'Caracteriza ampliamente el segmento de clientes (necesidades, comportamientos y atributos).', 0, 3, 1, 8);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (107, 6, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1, 'Presenta los elementos diferenciadores que facilitan la decision de compra del cliente.', 0, 3, 1, 9);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (108, 6, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1, 'Describe las demandas del segmento de clientes y el seguimiento para asegurar la calidad de los bienes o servicios ofrecidos.', 0, 3, 1, 10);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (109, 6, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1, 'Presenta las estrategias para el acercamiento al cliente, ya sea durante el proceso de atencion o de servicio.', 0, 3, 1, 11);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (110, 6, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1, 'Presenta datos sobre clientes, tendencias y oportunidades.', 0, 3, 1, 12);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (111, 6, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1, 'Incluye estrategias de promocion, precios, distribucion y posicionamiento.', 0, 3, 1, 13);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (112, 6, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1, 'Presenta la estructura de costos, gastos e ingresos.', 0, 3, 1, 14);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (113, 6, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1, 'Incluye los canales para la distribucion del producto hasta el cliente y su promocion, incorporando el uso de nuevas tecnologias.', 0, 3, 1, 15);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (114, 6, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1, 'Detalla las alianzas estrategicas y aportes a su propuesta de valor.', 0, 3, 1, 16);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (115, 6, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1, 'Presenta una organizacion clara y logica del documento, en congruencia con la estructura dada en los lineamientos.', 0, 3, 1, 17);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (116, 6, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1, 'Presenta el listado de referencias citadas en el documento, segun formato APA vigente.', 0, 3, 1, 18);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (117, 6, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1, 'Cumple con el formato establecido.', 0, 3, 1, 19);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (118, 6, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1, 'Justifica de forma solida la viabilidad y pertinencia del negocio.', 0, 3, 1, 20);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (119, 6, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1, 'Identifica la situacion de mercado, sociedad o industria que se aborda en la propuesta de negocio.', 0, 3, 1, 21);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (120, 6, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1, 'Argumenta la necesidad o problema que resuelve la propuesta de negocio.', 0, 3, 1, 22);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (121, 6, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1, 'Determina aspectos sociales, economicos, tecnologicos o ambientales que resuelve la propuesta de negocio.', 0, 3, 1, 23);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (122, 6, 'Evaluacion del Documento Escrito del Modelo de Negocios', 1, 'Plantea los objetivos del negocio enfatizando en su viabilidad, escalabilidad y sostenibilidad.', 0, 3, 1, 24);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (123, 7, 'Evaluacion del Documento Escrito del Plan de Negocios', 1, 'Explica con solidez que hace unico al negocio y por que es atractivo.', 0, 3, 1, 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (124, 7, 'Evaluacion del Documento Escrito del Plan de Negocios', 1, 'Describe las actividades clave que la empresa implementa para ofrecer una propuesta de valor.', 0, 3, 1, 2);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (125, 7, 'Evaluacion del Documento Escrito del Plan de Negocios', 1, 'Evidencia la identificacion de los equipos y recursos necesarios para llevar a cabo las operaciones de la empresa.', 0, 3, 1, 3);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (126, 7, 'Evaluacion del Documento Escrito del Plan de Negocios', 1, 'Describe de forma detallada el producto o servicio propuesto que brinda valor a los clientes.', 0, 3, 1, 4);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (127, 7, 'Evaluacion del Documento Escrito del Plan de Negocios', 1, 'Detalla como los productos o servicios ofrecidos se diferencian de la competencia.', 0, 3, 1, 5);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (128, 7, 'Evaluacion del Documento Escrito del Plan de Negocios', 1, 'Emplea lenguaje tecnico acorde con el nivel academico y el campo del negocio.', 0, 3, 1, 6);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (129, 7, 'Evaluacion del Documento Escrito del Plan de Negocios', 1, 'Define los canales mediante los cuales hara llegar a los clientes la propuesta de valor.', 0, 3, 1, 7);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (130, 7, 'Evaluacion del Documento Escrito del Plan de Negocios', 1, 'Caracteriza ampliamente el segmento de clientes (necesidades, comportamientos y atributos).', 0, 3, 1, 8);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (131, 7, 'Evaluacion del Documento Escrito del Plan de Negocios', 1, 'Presenta los elementos diferenciadores que facilitan la decision de compra del cliente.', 0, 3, 1, 9);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (132, 7, 'Evaluacion del Documento Escrito del Plan de Negocios', 1, 'Describe las demandas del segmento de clientes y el seguimiento para asegurar la calidad de los bienes o servicios ofrecidos.', 0, 3, 1, 10);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (133, 7, 'Evaluacion del Documento Escrito del Plan de Negocios', 1, 'Presenta las estrategias para el acercamiento al cliente, ya sea durante el proceso de atencion o de servicio.', 0, 3, 1, 11);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (134, 7, 'Evaluacion del Documento Escrito del Plan de Negocios', 1, 'Presenta datos sobre clientes, tendencias y oportunidades.', 0, 3, 1, 12);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (135, 7, 'Evaluacion del Documento Escrito del Plan de Negocios', 1, 'Incluye los canales para la distribucion del producto hasta el cliente y su promocion, incorporando el uso de nuevas tecnologias.', 0, 3, 1, 13);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (136, 7, 'Evaluacion del Documento Escrito del Plan de Negocios', 1, 'Presenta la estructura de costos, gastos e ingresos.', 0, 3, 1, 14);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (137, 7, 'Evaluacion del Documento Escrito del Plan de Negocios', 1, 'Incluye los canales para la distribucion del producto hasta el cliente y su promocion, incorporando el uso de nuevas tecnologias.', 0, 3, 1, 15);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (138, 7, 'Evaluacion del Documento Escrito del Plan de Negocios', 1, 'Determina el mercado meta y su alineacion con la propuesta de valor del negocio.', 0, 3, 1, 16);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (139, 7, 'Evaluacion del Documento Escrito del Plan de Negocios', 1, 'Presenta el modelo de negocio integrando los nueve modulos basicos que definen la operacion de la empresa, segun lo expuesto en la fase institucional.', 0, 3, 1, 17);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (140, 7, 'Evaluacion del Documento Escrito del Plan de Negocios', 1, 'Presenta el analisis de la viabilidad financiera incluyendo ingresos, costos, gastos y utilidades esperadas.', 0, 3, 1, 18);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (141, 7, 'Evaluacion del Documento Escrito del Plan de Negocios', 1, 'Presenta el analisis de las fuentes de financiamiento y su impacto en la permanencia del negocio.', 0, 3, 1, 19);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (142, 7, 'Evaluacion del Documento Escrito del Plan de Negocios', 1, 'Evidencia una relacion realista entre las proyecciones e indicadores financieros.', 0, 3, 1, 20);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (143, 7, 'Evaluacion del Documento Escrito del Plan de Negocios', 1, 'Evidencia cumplimiento de la normativa vigente en apego a la forma juridica, organizacional y seguridad social.', 0, 3, 1, 21);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (144, 7, 'Evaluacion del Documento Escrito del Plan de Negocios', 1, 'Detalla las alianzas estrategicas y aportes a su propuesta de valor.', 0, 3, 1, 22);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (145, 7, 'Evaluacion del Documento Escrito del Plan de Negocios', 1, 'Presenta una organizacion clara y logica del documento, en congruencia con la estructura dada en los lineamientos.', 0, 3, 1, 23);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (146, 7, 'Evaluacion del Documento Escrito del Plan de Negocios', 1, 'Presenta el listado de referencias citadas en el documento, segun formato APA vigente.', 0, 3, 1, 24);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (147, 7, 'Evaluacion del Documento Escrito del Plan de Negocios', 1, 'Cumple con el formato establecido.', 0, 3, 1, 25);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (148, 7, 'Evaluacion del Documento Escrito del Plan de Negocios', 1, 'Justifica de forma solida la viabilidad y pertinencia del negocio.', 0, 3, 1, 26);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (149, 7, 'Evaluacion del Documento Escrito del Plan de Negocios', 1, 'Identifica la situacion de mercado, sociedad o industria que se aborda en la propuesta de negocio.', 0, 3, 1, 27);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (150, 7, 'Evaluacion del Documento Escrito del Plan de Negocios', 1, 'Argumenta la necesidad o problema que resuelve la propuesta de negocio.', 0, 3, 1, 28);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (151, 8, 'Use of Language', 1, 'Organization of Ideas', 1, 5, 1, 1);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (152, 8, 'Use of Language', 1, 'Vocabulary', 1, 5, 1, 2);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (153, 8, 'Use of Language', 1, 'Sentence Structure and Grammar', 1, 5, 1, 3);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (154, 8, 'Use of Language', 1, 'Pronunciation', 1, 5, 1, 4);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (155, 8, 'Use of Language', 1, 'Content', 1, 5, 1, 5);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (156, 8, 'Use of Language', 1, 'Conclusion', 1, 5, 1, 6);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (157, 8, 'Delivery', 2, 'Verbal', 1, 5, 1, 7);
INSERT INTO `rubric_criteria` (`id`, `evaluation_type_id`, `section_name`, `section_sort_order`, `name`, `min_score`, `max_score`, `is_active`, `sort_order`) VALUES (158, 8, 'Delivery', 2, 'Nonverbal', 1, 5, 1, 8);

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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (1, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: admin@expotecnica.local', '127.0.0.1', NULL, '2026-03-17 01:59:45');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (2, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: admin@expotecnica.local', '127.0.0.1', NULL, '2026-03-17 01:59:51');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (3, 'Sistema', NULL, 'system', 'auth.login_failed', 'auth', NULL, 'Intento fallido para correo: admin@expotecnica.local', '127.0.0.1', NULL, '2026-03-17 02:00:01');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (4, 'Administrador Sistema', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 1, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-17 02:04:42');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (5, 'Administrador Sistema', 'admin@expotecnica.local', 'admin', 'auth.logout', 'auth', 1, 'Cierre de sesion', '127.0.0.1', NULL, '2026-03-17 02:11:13');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (6, 'Administrador Sistema', 'admin@expotecnica.local', 'admin', 'auth.login', 'auth', 1, 'Inicio de sesion correcto', '127.0.0.1', NULL, '2026-03-17 02:11:26');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (7, 'Administrador Sistema', 'admin@expotecnica.local', 'admin', 'admin.maintenance.save', 'system_setting', NULL, 'Mantenimiento actualizado: maintenance_enabled=1', '127.0.0.1', NULL, '2026-03-17 03:47:09');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (8, 'Administrador Sistema', 'admin@expotecnica.local', 'admin', 'admin.maintenance.save', 'system_setting', NULL, 'Mantenimiento actualizado: maintenance_enabled=0', '127.0.0.1', NULL, '2026-03-17 03:47:15');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (9, 'Administrador Sistema', 'admin@expotecnica.local', 'admin', 'admin.permissions.save', 'system_setting', NULL, 'Matriz de permisos por departamento actualizada', '127.0.0.1', NULL, '2026-03-17 03:57:11');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (10, 'Administrador Sistema', 'admin@expotecnica.local', 'admin', 'admin.campaign.create', 'campaign', NULL, 'Campana creada: c1 (2026-03-16 a 2026-03-19)', '127.0.0.1', NULL, '2026-03-17 03:59:11');
INSERT INTO `system_audit_logs` (`id`, `actor_name`, `actor_email`, `actor_role`, `action`, `entity`, `entity_id`, `detail`, `ip_address`, `user_agent`, `created_at`) VALUES (11, 'Administrador Sistema', 'admin@expotecnica.local', 'admin', 'admin.campaign.activate', 'campaign', 1, 'Campana activa: c1', '127.0.0.1', NULL, '2026-03-17 03:59:14');

DROP TABLE IF EXISTS `system_settings`;
CREATE TABLE `system_settings` (
  `key` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` text COLLATE utf8mb4_unicode_ci,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('maintenance_enabled', '0', '2026-03-17 03:47:15');
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('maintenance_image_path', '', '2026-03-17 01:57:13');
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('maintenance_message', 'Estamos cargando informacion de proyectos. Vuelve pronto.', '2026-03-17 03:47:15');
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('permissions_department_modules', '{"logistica": ["assignments", "overview", "projects"], "datos": ["evaluations", "overview"], "diseno": ["academic", "campaigns", "categories", "institution", "overview", "rubrics"], "qa": ["logs", "maintenance", "overview"]}', '2026-03-17 03:57:11');
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('school_address', 'Direccion institucional no configurada', '2026-03-17 01:57:13');
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('school_email', 'direccion@ctprgv.edu', '2026-03-17 01:57:13');
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('school_logo_path', '', '2026-03-17 01:57:13');
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('school_name', 'CTP Roberto Gamboa Valverde', '2026-03-17 01:57:13');
INSERT INTO `system_settings` (`key`, `value`, `updated_at`) VALUES ('school_phone', '+506 0000-0000', '2026-03-17 01:57:13');

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
