#!bin/bash 
aws ecs register-task-definition --cli-input-json file://$PWD/task-definitions.json
