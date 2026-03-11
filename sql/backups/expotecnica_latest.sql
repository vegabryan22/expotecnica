-- Backup generado automaticamente por scripts/backup_db.py
-- Fecha: 2026-03-11 16:58:36
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `judges` (`id`, `full_name`, `email`, `password_hash`, `is_active_user`, `is_admin`) VALUES (1, 'Juez Demo', 'juez1@expotecnica.local', 'scrypt:32768:8:1$UoWjHHXaO0R0lh9K$752abb7830d7037a5cf116883a1f839a3a7522cbdad89c172ee1eaa9513b6c20d8acf02c007c56d87bc6cd6e8e334e81a434c315b07c09cec04c6cecbddf216f', 1, 0);
INSERT INTO `judges` (`id`, `full_name`, `email`, `password_hash`, `is_active_user`, `is_admin`) VALUES (2, 'Administrador', 'admin@expotecnica.local', 'scrypt:32768:8:1$i64p34kJolniU051$1a2d2161cef21477db03521670d1511eac338c037634550f68b71e7c7aaaed6a247b4a8642fc980b6cad9417cb7ee8b1c2571755c974614503bbb46bb348dff1', 1, 1);

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
  CONSTRAINT `project_member_changes_ibfk_2` FOREIGN KEY (`member_id`) REFERENCES `project_members` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `project_member_changes` (`id`, `project_id`, `member_id`, `action`, `details`, `created_at`) VALUES (1, 5, 13, 'created', 'Integrante agregado: #3 Jeshua', '2026-03-11 20:46:33');

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
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `project_members` (`id`, `project_id`, `full_name`, `role`, `photo_url`, `created_at`, `student_number`, `identity_number`, `birth_date`, `gender`, `specialty`, `section_name`, `has_dining_scholarship`, `phone`, `email`) VALUES (5, 5, 'Caleb', 'The Boss', 'uploads/members/892e803fc0fc48788c9dc16fe67d50b8.jpg', '2026-03-11 14:17:52', 2, '', NULL, 'masculino', 'Especialidad 1', '10-1', 1, '', '');
INSERT INTO `project_members` (`id`, `project_id`, `full_name`, `role`, `photo_url`, `created_at`, `student_number`, `identity_number`, `birth_date`, `gender`, `specialty`, `section_name`, `has_dining_scholarship`, `phone`, `email`) VALUES (6, 5, 'Cruz', 'El Segundon al mando', 'uploads/members/1abe016fa20a420a9cee0f5a1303e9c2.jpg', '2026-03-11 14:17:52', 1, '', NULL, 'masculino', 'Especialidad 1', '10-1', 1, '', '');
INSERT INTO `project_members` (`id`, `project_id`, `full_name`, `role`, `photo_url`, `created_at`, `student_number`, `identity_number`, `birth_date`, `gender`, `specialty`, `section_name`, `has_dining_scholarship`, `phone`, `email`) VALUES (13, 5, 'Jeshua', NULL, 'uploads/members/7d9d0099023c4742a0610e117b20de09.jpg', '2026-03-11 20:46:33', 3, '', NULL, 'masculino', 'Especialidad 1', '10-1', 1, '', '');

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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `projects` (`id`, `title`, `team_name`, `representative_name`, `representative_email`, `category`, `description`, `created_at`, `representative_phone`, `institution_name`, `grade_level`, `specialty`, `advisor_name`, `advisor_email`, `advisor_phone`, `project_objective`, `expected_impact`, `required_resources`, `consent_terms`, `registration_date`, `advisor_identity`, `requirements_summary`, `requirements_other`, `section_id`, `specialty_id`, `workshop_id`, `project_document_path`, `project_logo_path`, `logistics_status`, `logistics_notes`, `logistics_document_ok`, `logistics_logo_ok`, `logistics_photos_ok`, `campaign_id`) VALUES (1, 'FiveSolutions', '10-3', 'Erick Sevilla', 'vegabryan@gmail.com', 'emprendimiento', 'No entiendo como no gano', '2026-03-10 17:26:23', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'inscrito', NULL, 0, 0, 0, NULL);
INSERT INTO `projects` (`id`, `title`, `team_name`, `representative_name`, `representative_email`, `category`, `description`, `created_at`, `representative_phone`, `institution_name`, `grade_level`, `specialty`, `advisor_name`, `advisor_email`, `advisor_phone`, `project_objective`, `expected_impact`, `required_resources`, `consent_terms`, `registration_date`, `advisor_identity`, `requirements_summary`, `requirements_other`, `section_id`, `specialty_id`, `workshop_id`, `project_document_path`, `project_logo_path`, `logistics_status`, `logistics_notes`, `logistics_document_ok`, `logistics_logo_ok`, `logistics_photos_ok`, `campaign_id`) VALUES (2, 'Alohomora', '9-5', 'Sebastian Navarro', 'vegabryan@hotmail.com', 'steam', 'Este si gano', '2026-03-11 13:17:21', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'uploads/projects/logos/7db2b333e63c488d88b96d5d62aac79f.jpg', 'inscrito', NULL, 0, 1, 0, NULL);
INSERT INTO `projects` (`id`, `title`, `team_name`, `representative_name`, `representative_email`, `category`, `description`, `created_at`, `representative_phone`, `institution_name`, `grade_level`, `specialty`, `advisor_name`, `advisor_email`, `advisor_phone`, `project_objective`, `expected_impact`, `required_resources`, `consent_terms`, `registration_date`, `advisor_identity`, `requirements_summary`, `requirements_other`, `section_id`, `specialty_id`, `workshop_id`, `project_document_path`, `project_logo_path`, `logistics_status`, `logistics_notes`, `logistics_document_ok`, `logistics_logo_ok`, `logistics_photos_ok`, `campaign_id`) VALUES (5, 'InnovaMind', '11-3', 'Caleb Mesén', 'caleb@gmail.com', 'emprendimiento', 'Este casi gana', '2026-03-11 14:17:52', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'uploads/projects/logos/700b6397ca4d48029eed4766209c7cc5.png', 'inscrito', NULL, 0, 1, 0, NULL);

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
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
