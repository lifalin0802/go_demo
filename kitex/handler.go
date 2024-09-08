package main

import (
	"context"
	api "kitex/kitex_gen/api"
	job "kitex/kitex_gen/path/to/your/package/job"
)

// EchoImpl implements the last service interface defined in the IDL.
type EchoImpl struct{}

// Echo implements the EchoImpl interface.
func (s *EchoImpl) Echo(ctx context.Context, req *api.Request) (resp *api.Response, err error) {
	// TODO: Your code here...
	return &api.Response{Message: req.Message}, nil
}

// CreateJob implements the JobServiceImpl interface.
func (s *JobServiceImpl) CreateJob(ctx context.Context, req *job.Job) (resp *job.CreateJobResp, err error) {
	// TODO: Your code here...
	return
}
