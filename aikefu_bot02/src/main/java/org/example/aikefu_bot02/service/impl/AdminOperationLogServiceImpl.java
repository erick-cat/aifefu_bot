package org.example.aikefu_bot02.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.example.aikefu_bot02.entity.AdminOperationLog;
import org.example.aikefu_bot02.service.AdminOperationLogService;
import org.example.aikefu_bot02.mapper.AdminOperationLogMapper;
import org.springframework.stereotype.Service;

/**
* @author 24229
* @description 针对表【admin_operation_log(管理端操作日志)】的数据库操作Service实现
* @createDate 2026-04-01 13:50:54
*/
@Service
public class AdminOperationLogServiceImpl extends ServiceImpl<AdminOperationLogMapper, AdminOperationLog>
    implements AdminOperationLogService{

}




