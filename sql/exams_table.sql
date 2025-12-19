-- 考试表创建脚本
USE `exam_system`;

-- 删除现有的exam表（如果存在）
DROP TABLE IF EXISTS `exams`;

-- 创建新的考试表
CREATE TABLE `exams` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `title` VARCHAR(200) NOT NULL COMMENT '考试标题',
  `description` TEXT COMMENT '考试描述',
  `duration` INT NOT NULL COMMENT '考试时长（分钟）',
  `start_time` DATETIME NOT NULL COMMENT '开始时间',
  `end_time` DATETIME NOT NULL COMMENT '结束时间',
  `total_score` INT DEFAULT 100 COMMENT '总分',
  `pass_score` INT DEFAULT 60 COMMENT '及格分数',
  `status` VARCHAR(20) DEFAULT 'draft' COMMENT '状态：draft草稿, published已发布, ended已结束',
  `teacher_id` INT NOT NULL COMMENT '创建教师ID',
  `create_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  INDEX `idx_teacher` (`teacher_id`),
  INDEX `idx_status` (`status`),
  INDEX `idx_time` (`start_time`, `end_time`),
  FOREIGN KEY (`teacher_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='考试表';

-- 创建考试试题关联表
DROP TABLE IF EXISTS `exam_questions`;
CREATE TABLE `exam_questions` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `exam_id` INT NOT NULL COMMENT '考试ID',
  `question_id` INT NOT NULL COMMENT '试题ID',
  `question_order` INT DEFAULT 0 COMMENT '试题顺序',
  `score` INT DEFAULT 0 COMMENT '试题分值',
  `create_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_exam` (`exam_id`),
  INDEX `idx_question` (`question_id`),
  FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='考试试题关联表';

-- 创建学生考试记录表
DROP TABLE IF EXISTS `student_exams`;
CREATE TABLE `student_exams` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `student_id` INT NOT NULL COMMENT '学生ID',
  `exam_id` INT NOT NULL COMMENT '考试ID',
  `start_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '开始考试时间',
  `end_time` TIMESTAMP NULL COMMENT '提交时间',
  `status` VARCHAR(20) DEFAULT 'in_progress' COMMENT '状态：in_progress进行中, submitted已提交, scored已评分',
  `score` DECIMAL(5,2) DEFAULT 0 COMMENT '得分',
  `answers` TEXT COMMENT '答案（JSON格式）',
  `create_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `update_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_student` (`student_id`),
  INDEX `idx_exam` (`exam_id`),
  INDEX `idx_status` (`status`),
  FOREIGN KEY (`student_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学生考试记录表';

-- 插入示例试验数据
INSERT INTO `exams` (title, description, duration, start_time, end_time, total_score, pass_score, status, teacher_id) VALUES
('Java程序设计期中考试', 'Java语言基础、面向对象编程、异常处理等内容', 120,
 '2024-12-01 09:00:00', '2024-12-01 11:30:00', 100, 60, 'published', 2),

('数据结构期末考试', '线性表、树、图、排序算法等核心内容', 150,
 '2024-12-15 14:00:00', '2024-12-15 17:00:00', 100, 60, 'published', 2),

('数据库原理测试', '关系数据库理论、SQL语言、数据库设计', 90,
 '2024-11-25 10:00:00', '2024-11-25 11:45:00', 100, 60, 'published', 2),

('Web前端开发练习', 'HTML5、CSS3、JavaScript基础测试', 60,
 '2024-12-10 15:00:00', '2024-12-10 16:15:00', 100, 60, 'published', 2);

-- 为考试添加试题（关联questions表中的试题）
INSERT INTO `exam_questions` (exam_id, question_id, question_order, score) VALUES
-- Java程序设计考试
(1, 1, 1, 20),
(1, 2, 2, 25),
(1, 3, 3, 30),
(1, 7, 4, 25),

-- 数据结构考试
(2, 2, 1, 25),
(2, 4, 2, 20),
(2, 8, 3, 30),
(2, 9, 4, 25),

-- 数据库原理测试
(3, 3, 1, 30),
(3, 5, 2, 20),
(3, 10, 3, 50),

-- Web前端开发练习
(4, 6, 1, 25),
(4, 11, 2, 30),
(4, 12, 3, 45);