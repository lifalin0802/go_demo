service JobService {
    // 创建 job 任务
    rpc CreateJob(Job) returns (CreateJobResp) {};

    // 查看 job 执行信息
    // rpc GetJob(GetJobReq) returns (Job) {};

    // 查看 job 执行状态
    rpc GetJobStatus(Job) returns (JobStatus) {};

    // 查看 task 执行状态
    rpc GetTaskStatus(GetTaskStatusReq) returns (TaskStatus) {};

    // 查看 operator 执行状态
    rpc GetOperatorStatus(GetOperatorStatusReq) returns (OperatorStatus) {};
}

message Empty {}