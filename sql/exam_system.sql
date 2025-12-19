-- exam_system database and basic tables
CREATE DATABASE IF NOT EXISTS `exam_system` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `exam_system`;

-- users table
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `username` VARCHAR(50) NOT NULL,
  `password` VARCHAR(100) NOT NULL,
  `role` VARCHAR(20) NOT NULL,
  `display_name` VARCHAR(100),
  UNIQUE KEY `uk_user` (`username`, `role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- sample exam table
DROP TABLE IF EXISTS `exam`;
CREATE TABLE `exam` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `title` VARCHAR(200) NOT NULL,
  `description` TEXT,
  `start_time` DATETIME,
  `end_time` DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- sample question table (simplified)
DROP TABLE IF EXISTS `question`;
CREATE TABLE `question` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `exam_id` INT,
  `type` VARCHAR(20) COMMENT 'single/multiple/subjective',
  `content` TEXT,
  `options` TEXT COMMENT 'json array for choices',
  `answer` TEXT,
  FOREIGN KEY (`exam_id`) REFERENCES `exam` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- class table
DROP TABLE IF EXISTS `class`;
CREATE TABLE `class` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `class_name` VARCHAR(100) NOT NULL COMMENT '班级名称',
  `grade` VARCHAR(50) NOT NULL COMMENT '年级',
  `teacher_name` VARCHAR(100) COMMENT '班主任姓名',
  `description` TEXT COMMENT '班级描述',
  `student_count` INT DEFAULT 0 COMMENT '学生人数',
  `created_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `uk_class` (`class_name`, `grade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- insert default users
INSERT INTO `user` (username, password, role, display_name) VALUES
('admin','123456','admin','系统管理员'),
('teacher','123456','teacher','教师用户'),
('student','123456','student','学生用户');

-- course table
DROP TABLE IF EXISTS `course`;
CREATE TABLE `course` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `course_name` VARCHAR(200) NOT NULL COMMENT '课程名称',
  `course_code` VARCHAR(50) NOT NULL COMMENT '课程代码',
  `description` TEXT COMMENT '课程描述',
  `teacher_name` VARCHAR(100) COMMENT '授课教师',
  `credit` INT DEFAULT 3 COMMENT '学分',
  `semester` VARCHAR(50) NOT NULL COMMENT '学期',
  `status` VARCHAR(20) DEFAULT 'active' COMMENT '课程状态：active/inactive',
  `created_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `uk_course` (`course_name`, `semester`),
  UNIQUE KEY `uk_course_code` (`course_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- insert sample classes
INSERT INTO `class` (class_name, grade, teacher_name, description, student_count) VALUES
('计算机科学与技术1班', '2024级', '张老师', '计算机科学与技术专业第一班级，专注于软件工程方向', 45),
('计算机科学与技术2班', '2024级', '李老师', '计算机科学与技术专业第二班级，专注于人工智能方向', 42),
('软件工程1班', '2024级', '王老师', '软件工程专业第一班级，注重实践能力培养', 38),
('网络工程1班', '2024级', '刘老师', '网络工程专业第一班级，网络安全方向', 35),
('数据科学1班', '2023级', '陈老师', '数据科学与大数据技术专业，数据分析和挖掘', 40);

-- score table
DROP TABLE IF EXISTS `score`;
CREATE TABLE `score` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `student_id` INT NOT NULL COMMENT '学生ID',
  `course_id` INT NOT NULL COMMENT '课程ID',
  `exam_id` INT COMMENT '考试ID',
  `score` DECIMAL(5,2) NOT NULL COMMENT '得分',
  `max_score` DECIMAL(5,2) NOT NULL DEFAULT 100 COMMENT '满分',
  `status` VARCHAR(20) DEFAULT 'pending' COMMENT '状态：passed/failed/pending',
  `exam_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '考试时间',
  `created_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_student` (`student_id`),
  INDEX `idx_course` (`course_id`),
  INDEX `idx_exam` (`exam_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- insert sample courses
INSERT INTO `course` (course_name, course_code, description, teacher_name, credit, semester, status) VALUES
('Java程序设计', 'CS101', 'Java语言基础、面向对象编程、集合框架、异常处理等', '张老师', 4, '2024年春季学期', 'active'),
('数据结构', 'CS102', '线性表、栈和队列、树、图、排序算法、查找算法', '李老师', 4, '2024年春季学期', 'active'),
('数据库原理', 'CS201', '关系数据库理论、SQL语言、数据库设计、事务管理', '王老师', 3, '2024年秋季学期', 'active'),
('Web前端开发', 'CS301', 'HTML5、CSS3、JavaScript、React框架、响应式设计', '刘老师', 3, '2024年秋季学期', 'active'),
('机器学习基础', 'CS401', '监督学习、无监督学习、深度学习入门、TensorFlow框架', '陈老师', 4, '2025年春季学期', 'active'),
('算法设计与分析', 'CS202', '分治算法、动态规划、贪心算法、回溯算法、图算法', '张老师', 3, '2024年秋季学期', 'active'),
('计算机网络', 'CS203', 'TCP/IP协议、HTTP协议、网络安全、分布式系统', '李老师', 3, '2025年春季学期', 'active'),
('操作系统', 'CS204', '进程管理、内存管理、文件系统、设备管理', '王老师', 4, '2025年秋季学期', 'inactive'),
('软件工程', 'CS302', '软件开发方法、需求分析、系统设计、测试与维护', '刘老师', 3, '2025年春季学期', 'active'),
('人工智能导论', 'CS402', '知识表示、推理机制、专家系统、自然语言处理', '陈老师', 4, '2025年秋季学期', 'active');

-- add sample users for testing scores
INSERT INTO `user` (id, username, password, role, display_name) VALUES
(4, 'student1', '123456', 'student', '张三'),
(5, 'student2', '123456', 'student', '李四'),
(6, 'student3', '123456', 'student', '王五'),
(7, 'student4', '123456', 'student', '赵六'),
(8, 'student5', '123456', 'student', '钱七');

-- insert sample scores
INSERT INTO `score` (student_id, course_id, exam_id, score, max_score, status, exam_time) VALUES
-- Java程序设计成绩
(4, 1, 1, 85.5, 100, 'passed', '2024-06-15 10:00:00'),
(5, 1, 1, 92.0, 100, 'passed', '2024-06-15 10:00:00'),
(6, 1, 1, 78.5, 100, 'passed', '2024-06-15 10:00:00'),
(7, 1, 1, 58.0, 100, 'failed', '2024-06-15 10:00:00'),
(8, 1, 1, 96.5, 100, 'passed', '2024-06-15 10:00:00'),

-- 数据结构成绩
(4, 2, 2, 88.0, 100, 'passed', '2024-06-20 14:00:00'),
(5, 2, 2, 75.5, 100, 'passed', '2024-06-20 14:00:00'),
(6, 2, 2, 95.0, 100, 'passed', '2024-06-20 14:00:00'),
(7, 2, 2, 62.0, 100, 'passed', '2024-06-20 14:00:00'),
(8, 2, 2, 89.5, 100, 'passed', '2024-06-20 14:00:00'),

-- 数据库原理成绩
(4, 3, 3, 91.5, 100, 'passed', '2024-11-10 09:00:00'),
(5, 3, 3, 83.0, 100, 'passed', '2024-11-10 09:00:00'),
(6, 3, 3, 76.5, 100, 'passed', '2024-11-10 09:00:00'),
(7, 3, 3, 55.0, 100, 'failed', '2024-11-10 09:00:00'),
(8, 3, 3, 94.0, 100, 'passed', '2024-11-10 09:00:00'),

-- Web前端开发成绩
(4, 4, 4, 79.0, 100, 'passed', '2024-11-15 14:00:00'),
(5, 4, 4, 87.5, 100, 'passed', '2024-11-15 14:00:00'),
(6, 4, 4, 93.0, 100, 'passed', '2024-11-15 14:00:00'),
(7, 4, 4, 68.0, 100, 'passed', '2024-11-15 14:00:00'),
(8, 4, 4, 82.5, 100, 'passed', '2024-11-15 14:00:00'),

-- 算法设计与分析成绩
(4, 6, 5, 85.0, 100, 'passed', '2024-11-05 10:00:00'),
(5, 6, 5, 72.5, 100, 'passed', '2024-11-05 10:00:00'),
(6, 6, 5, 96.5, 100, 'passed', '2024-11-05 10:00:00'),
(7, 6, 5, 59.5, 100, 'failed', '2024-11-05 10:00:00'),
(8, 6, 5, 88.0, 100, 'passed', '2024-11-05 10:00:00');
