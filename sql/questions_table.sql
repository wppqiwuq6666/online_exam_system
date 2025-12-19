-- 试题表创建脚本
USE `exam_system`;

-- 删除现有的question表（如果存在）
DROP TABLE IF EXISTS `questions`;

-- 创建新的试题表
CREATE TABLE `questions` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `title` TEXT NOT NULL COMMENT '题干',
  `type` VARCHAR(20) NOT NULL COMMENT '题型：single(单选), multiple(多选), essay(主观)',
  `options` TEXT COMMENT '选项，JSON格式或纯文本格式',
  `answer` TEXT NOT NULL COMMENT '正确答案',
  `analysis` TEXT COMMENT '答案解析',
  `difficulty` INT NOT NULL DEFAULT 1 COMMENT '难度：1-简单 2-中等 3-困难',
  `subject` VARCHAR(100) NOT NULL COMMENT '科目',
  `teacher_id` INT NOT NULL COMMENT '创建教师ID',
  `create_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  INDEX `idx_teacher` (`teacher_id`),
  INDEX `idx_subject` (`subject`),
  INDEX `idx_type` (`type`),
  INDEX `idx_difficulty` (`difficulty`),
  FOREIGN KEY (`teacher_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='试题表';

-- 插入示例试题数据
INSERT INTO `questions` (title, type, options, answer, analysis, difficulty, subject, teacher_id) VALUES
-- 单选题示例
('Java中，以下哪个是基本数据类型？', 'single',
'A. String\nB. Integer\nC. int\nD. Object',
'C',
'Java的基本数据类型有8种：byte、short、int、long、float、double、char、boolean。String、Integer、Object都是引用类型。',
1, 'Java程序设计', 2),

('以下哪个排序算法的时间复杂度平均为O(n log n)？', 'single',
'A. 冒泡排序\nB. 快速排序\nC. 选择排序\nD. 插入排序',
'B',
'快速排序、归并排序、堆排序的平均时间复杂度都是O(n log n)，而冒泡排序、选择排序、插入排序的平均时间复杂度是O(n²)。',
2, '数据结构', 2),

('数据库中，用来保证数据完整性的约束是？', 'single',
'A. PRIMARY KEY\nB. FOREIGN KEY\nC. UNIQUE\nD. 以上都是',
'D',
'PRIMARY KEY保证实体完整性，FOREIGN KEY保证参照完整性，UNIQUE保证域完整性，这些都是保证数据完整性的约束。',
1, '数据库原理', 2),

-- 多选题示例
('以下哪些是面向对象编程的特征？', 'multiple',
'A. 封装\nB. 继承\nC. 多态\nD. 结构化',
'ABC',
'面向对象编程的三大特征是封装、继承和多态。结构化是面向过程编程的特点。',
2, 'Java程序设计', 2),

('TCP协议的特点包括？', 'multiple',
'A. 面向连接\nB. 可靠传输\nC. 流量控制\nD. 无连接',
'ABC',
'TCP是面向连接的、可靠的传输协议，具有流量控制和拥塞控制功能。无连接是UDP的特点。',
2, '计算机网络', 2),

-- 主观题示例
('请简述快速排序算法的基本思想和步骤。', 'essay',
'',
'1. 选择基准元素\n2. 分区操作\n3. 递归排序左右子数组\n4. 合并结果',
'快速排序的基本思想：通过一趟排序将待排记录分隔成独立的两部分，其中一部分记录的关键字均比另一部分的关键字小，则可分别对这两部分记录继续进行排序，以达到整个序列有序。',
3, '数据结构', 2),

('解释什么是数据库的事务，以及事务的ACID特性。', 'essay',
'',
'原子性、一致性、隔离性、持久性',
'事务是数据库管理系统执行过程中的一个逻辑单位，由一个或多个SQL语句组成。ACID特性：\n1. 原子性(Atomicity)：事务中的操作要么都执行，要么都不执行\n2. 一致性(Consistency)：事务执行前后数据库状态保持一致\n3. 隔离性(Isolation)：多个并发事务互不干扰\n4. 持久性(Durability)：事务一旦提交，其结果永久保存',
3, '数据库原理', 2),

('比较HTTP和HTTPS协议的区别。', 'essay',
'',
'安全性、端口、证书、性能等',
'主要区别：\n1. 安全性：HTTPS使用SSL/TLS加密，HTTP是明文传输\n2. 端口：HTTPS使用443端口，HTTP使用80端口\n3. 证书：HTTPS需要SSL证书，HTTP不需要\n4. 性能：HTTPS由于加密解密过程，性能略低于HTTP\n5. 成本：HTTPS需要购买SSL证书',
2, 'Web前端开发', 2);