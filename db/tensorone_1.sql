use devops_platform;


CREATE TABLE IF NOT EXISTS`users` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(128),
  `email` varchar(128),
  `phone` varchar(128) COMMENT '手机号'
);

CREATE TABLE IF NOT EXISTS `packages` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `filename` varchar(512) COMMENT 'eg. cudnn-linux-x86_64-9.0.0.312_cuda12-archive.tar.xz',
  `relative_path` varchar(1024) COMMENT 'eg. cudnn/cudnn-linux-x86_64-9.0.0.312_cuda12-archive.tar.xz',
  `size` bigint COMMENT 'in byte, like  884762828',
  `created_at` timestamp COMMENT 'eg. 2023-09-29T23:47:15',
  `md5` varchar(512) COMMENT 'eg. 2d66eca078f49f9bb88f60cbc8ffdaed',
  `type` varchar(256) COMMENT '软件包类型, 可以是conda, cudnn 等',
  `package` varchar(256) COMMENT 'eg. anaconda',
  `version` varchar(256) COMMENT 'eg. 9.0.0.312_cuda12, 或者以日期标注 eg. "23.10.0"'
);

CREATE TABLE IF NOT EXISTS `roles` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `role_name` varchar(256)
);


CREATE TABLE IF NOT EXISTS `operators` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(256),
  `role_id` int,
  `opt_version` varchar(512) COMMENT '该operator的版本号, 默认是0',
  `pkg_version` varchar(128) COMMENT 'role 的某个版本, 例如指定是535',
  `created_at` timestamp DEFAULT (now()),
  `updated_at` timestamp,
  `created_by` int COMMENT '操作人的user_id',
  `updated_by` int COMMENT '操作人的user_id',
  `original_opt_id` int COMMENT '原始operator的id',
  `is_deleted` bool,
  `is_latest` bool
);


CREATE TABLE IF NOT EXISTS `variables` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `role_id` int,
  `action_type` varchar(255) COMMENT '动作的类型,例如cuda, driver, fabric',
  `var_name` varchar(255) COMMENT 'eg. local_nvidia_driver_path, local_cuda_driver_path, local_fabric_path'
);

CREATE TABLE IF NOT EXISTS `role_variable` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `pkg_version` varchar(255) COMMENT 'eg. 535 550',
  `varible_id` int,
  `variable_values` varchar(255) COMMENT 'eg. /data/fileserver/pkg/cuda/cuda_12.3.1_545.23.08_linux.run ',
  `opt_version` varchar(512),
  `package_id` int
);



CREATE TABLE IF NOT EXISTS `opertor_label` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `operator_id` int,
  `label_id` int
);

CREATE TABLE IF NOT EXISTS `shells` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(255) COMMENT 'eg. single_nccl_test',
  `keywords` varchar(255) COMMENT '识别是否是下发给ansible主控机的指令, eg "esingle_nccl_test.sh" ',
  `shell_template` text COMMENT '例如单机nccl测试为 ./script/set_multi_env.sh 												  ./script/single_nccl_test.sh <note_pool> 												  cat /tmp/single-nccl-test-<node_pool>.md'
);

CREATE TABLE IF NOT EXISTS `playbook_task` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(256),
  `created_at` timestamp DEFAULT (now()),
  `updated_at` timestamp,
  `created_by` int,
  `updated_by` int,
  `version` int COMMENT 'task的version,新创建时是0, 每次修改自增1',
  `original_task_id` int COMMENT '最初版本的该task的主键id',
  `playbook_script` text,
  `is_latest` bool,
  `is_deleted` bool
);

CREATE TABLE IF NOT EXISTS `task_operator` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `task_id` int COMMENT '当前版本的task的id',
  `operator_id` int,
  `sequence` int COMMENT 'operator的顺序号',
  `created_at` timestamp DEFAULT (now()),
  `created_by` int,
  `task_version` int,
  `is_latest` bool,
  `is_deleted` bool
);

CREATE TABLE IF NOT EXISTS `shell_task` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `shell_id` int,
  `params` varchar(256) COMMENT '例如是趣玩科技 qwkj',
  `content` text COMMENT '例如  ./script/set_multi_env.sh 						  ./script/single_nccl_test.sh qwkj 						 cat /tmp/single-nccl-test-qwkj.md',
  `version` int,
  `is_latest` bool,
  `created_by` int,
  `created_at` timestamp
);

CREATE TABLE IF NOT EXISTS `templates` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(256),
  `created_at` timestamp,
  `create_by` int
);

CREATE TABLE IF NOT EXISTS `template_task` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `template_id` int,
  `playbook_task_id` int COMMENT '如果task_type 是ansible',
  `shell_task_id` int,
  `sequence` int COMMENT '从1开始',
  `task_type` varchar(30) COMMENT 'agent or ansible'
);

CREATE TABLE IF NOT EXISTS `labels` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `k` varchar(256) COMMENT '标签的key',
  `v` varchar(256) COMMENT '标签的value'
);

CREATE TABLE IF NOT EXISTS `task_label` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `playbook_task_id` int COMMENT '只记录original_task_id即可',
  `label_id` int
);

CREATE TABLE IF NOT EXISTS `Jobs` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `job_name` varchar(256),
  `comments` varchar(256),
  `version` int,
  `is_latest` bool,
  `created_by` int,
  `created_at` timestamp,
  `updated_by` int,
  `updated_at` timestamp
);

CREATE TABLE IF NOT EXISTS `job_histories` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `job_id` int,
  `job_version` int,
  `last_executed_time` timestamp,
  `duration` int COMMENT '单位是ms',
  `status` varchar(255) COMMENT '可以是running, success, failure',
  `executed_by` int
);

CREATE TABLE IF NOT EXISTS `job_items` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `job_history_id` int,
  `template_id` int,
  `sequence` int COMMENT '从1 开始'
);

CREATE TABLE IF NOT EXISTS `job_item_nodes` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `job_item_id` int,
  `type` varchar(32) COMMENT 'node or nood_pool',
  `node_id` varchar(32) COMMENT '如果是node_pool 类型，此处可以为空',
  `node_pool_id` varchar(32) COMMENT '如果是node 类型，此处可以为空'
);

CREATE TABLE IF NOT EXISTS `job_item_histories` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `sequence` int COMMENT '从1 开始',
  `status` varchar(32) COMMENT 'success or failure',
  `item_type` varchar(32) COMMENT 'ansible or agent',
  `playbook_task_id` int,
  `shell_task_id` int,
  `executed_time` timestamp,
  `duration` int COMMENT '单位是ms',
  `ansible_output` text,
  `logs` text
);

CREATE TABLE IF NOT EXISTS `nodes` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `registered_at` timestamp,
  `ip` varchar(30),
  `node_type` varchar(10) COMMENT 'cpu or gpu',
  `gpu_type` varchar(10) COMMENT '4090, A800, H100',
  `is_locked` bool,
  `nodepool_id` int
);

CREATE TABLE IF NOT EXISTS `nodepools` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(256),
  `tenent_id` int
);

CREATE TABLE IF NOT EXISTS `node_nodepool` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `node_id` int,
  `nodepool_id` int
);

CREATE TABLE IF NOT EXISTS `tenants` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(256),
  `created_at` timestamp,
  `created_by` int,
  `updated_at` timestamp,
  `updated_by` int
);

CREATE TABLE IF NOT EXISTS `node_label` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `label_id` int,
  `node_id` int
);

CREATE TABLE IF NOT EXISTS `nodpool_label` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `label_id` int,
  `nodepool_id` int
);

ALTER TABLE `roles` COMMENT = '该表是所有role的全部枚举';

ALTER TABLE `variables` COMMENT = 'vars 所有的var_name 集合, 此表可以理解成vars 的key的枚举 ';

ALTER TABLE `labels` COMMENT = 'contains all labels for tasks,operators, nodes, nodepools';

ALTER TABLE `operators` ADD FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);

ALTER TABLE `operators` ADD FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

ALTER TABLE `operators` ADD FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);

ALTER TABLE `operators` ADD FOREIGN KEY (`original_opt_id`) REFERENCES `operators` (`id`);

ALTER TABLE `variables` ADD FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);

ALTER TABLE `Role_variable` ADD FOREIGN KEY (`varible_id`) REFERENCES `variables` (`id`);

-- ALTER TABLE `Role_variable` ADD FOREIGN KEY (`opt_version`) REFERENCES `operators` (`opt_version`);


ALTER TABLE `Role_variable` ADD FOREIGN KEY (`package_id`) REFERENCES `packages` (`id`);

ALTER TABLE `opertor_label` ADD FOREIGN KEY (`operator_id`) REFERENCES `operators` (`id`);

ALTER TABLE `opertor_label` ADD FOREIGN KEY (`label_id`) REFERENCES `labels` (`id`);

ALTER TABLE `playbook_task` ADD FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

ALTER TABLE `playbook_task` ADD FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);

ALTER TABLE `playbook_task` ADD FOREIGN KEY (`original_task_id`) REFERENCES `playbook_task` (`id`);

ALTER TABLE `task_operator` ADD FOREIGN KEY (`task_id`) REFERENCES `playbook_task` (`id`);

ALTER TABLE `task_operator` ADD FOREIGN KEY (`operator_id`) REFERENCES `operators` (`id`);

ALTER TABLE `task_operator` ADD FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

-- ALTER TABLE `task_operator` ADD FOREIGN KEY (`task_version`) REFERENCES `playbook_task` (`version`);

ALTER TABLE `shell_task` ADD FOREIGN KEY (`shell_id`) REFERENCES `shells` (`id`);

ALTER TABLE `shell_task` ADD FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

ALTER TABLE `templates` ADD FOREIGN KEY (`create_by`) REFERENCES `users` (`id`);

ALTER TABLE `template_task` ADD FOREIGN KEY (`template_id`) REFERENCES `templates` (`id`);

ALTER TABLE `template_task` ADD FOREIGN KEY (`playbook_task_id`) REFERENCES `playbook_task` (`id`);

ALTER TABLE `template_task` ADD FOREIGN KEY (`shell_task_id`) REFERENCES `shell_task` (`id`);

ALTER TABLE `task_label` ADD FOREIGN KEY (`playbook_task_id`) REFERENCES `playbook_task` (`id`);

ALTER TABLE `task_label` ADD FOREIGN KEY (`label_id`) REFERENCES `labels` (`id`);

ALTER TABLE `Jobs` ADD FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

ALTER TABLE `Jobs` ADD FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);

ALTER TABLE `job_histories` ADD FOREIGN KEY (`job_id`) REFERENCES `Jobs` (`id`);

-- ALTER TABLE `job_histories` ADD FOREIGN KEY (`job_version`) REFERENCES `Jobs` (`version`);

ALTER TABLE `job_histories` ADD FOREIGN KEY (`executed_by`) REFERENCES `users` (`id`);

ALTER TABLE `job_items` ADD FOREIGN KEY (`job_history_id`) REFERENCES `job_histories` (`id`);

ALTER TABLE `job_items` ADD FOREIGN KEY (`template_id`) REFERENCES `templates` (`id`);

ALTER TABLE `job_item_nodes` ADD FOREIGN KEY (`job_item_id`) REFERENCES `job_items` (`id`);

ALTER TABLE `job_item_histories` ADD FOREIGN KEY (`playbook_task_id`) REFERENCES `playbook_task` (`id`);

ALTER TABLE `job_item_histories` ADD FOREIGN KEY (`shell_task_id`) REFERENCES `shell_task` (`id`);

ALTER TABLE `nodes` ADD FOREIGN KEY (`nodepool_id`) REFERENCES `nodepools` (`id`);

ALTER TABLE `nodepools` ADD FOREIGN KEY (`tenent_id`) REFERENCES `tenants` (`id`);

ALTER TABLE `node_nodepool` ADD FOREIGN KEY (`node_id`) REFERENCES `nodes` (`id`);

ALTER TABLE `node_nodepool` ADD FOREIGN KEY (`nodepool_id`) REFERENCES `nodepools` (`id`);

ALTER TABLE `tenants` ADD FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

ALTER TABLE `tenants` ADD FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);

ALTER TABLE `node_label` ADD FOREIGN KEY (`label_id`) REFERENCES `labels` (`id`);

ALTER TABLE `node_label` ADD FOREIGN KEY (`node_id`) REFERENCES `nodes` (`id`);

ALTER TABLE `nodpool_label` ADD FOREIGN KEY (`label_id`) REFERENCES `labels` (`id`);

ALTER TABLE `nodpool_label` ADD FOREIGN KEY (`nodepool_id`) REFERENCES `nodepools` (`id`);

-- ALTER TABLE `task_label` ADD FOREIGN KEY (`id`) REFERENCES `labels` (`k`);
