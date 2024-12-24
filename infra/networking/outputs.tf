

output "task_sg_id" {
    value = aws_security_group.app_ecs_task_sg.id
}

output "subnet_ids"{
    value = aws_subnet.app_private.*.id
}

output "tg_arn"{
    value = aws_lb_target_group.app_lb_tg.arn
}

output "api_tg_arn"{
    value = aws_lb_target_group.api_lb_tg.arn
}




output "tg_name"{
    value = aws_lb_target_group.app_lb_tg.name
}




output "listener_arn"{
    value = aws_lb_listener.app_lb_listener.arn
}


output "lb_name"{
    value = aws_lb.app_lb.name
}


output "lb_dns"{
    value = aws_lb.app_lb.dns_name
}

output "api_lb_dns"{
    value = aws_lb.api_lb.dns_name
}

output vpc_id {
    value = aws_vpc.appvpc.id
}

output lb_sg_id {
    value = aws_security_group.app_lb_sg.id
}

output mongo_sg_id{
    value = aws_security_group.mongo_task_sg.id
}