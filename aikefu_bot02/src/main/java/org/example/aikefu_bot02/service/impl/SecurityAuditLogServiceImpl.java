package org.example.aikefu_bot02.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.example.aikefu_bot02.entity.SecurityAuditLog;
import org.example.aikefu_bot02.service.SecurityAuditLogService;
import org.example.aikefu_bot02.mapper.SecurityAuditLogMapper;
import org.springframework.stereotype.Service;

/**
* @author 24229
* @description 针对表【security_audit_log(安全审计日志)】的数据库操作Service实现
* @createDate 2026-04-01 13:50:55
*/
@Service
public class SecurityAuditLogServiceImpl extends ServiceImpl<SecurityAuditLogMapper, SecurityAuditLog>
    implements SecurityAuditLogService{

}




