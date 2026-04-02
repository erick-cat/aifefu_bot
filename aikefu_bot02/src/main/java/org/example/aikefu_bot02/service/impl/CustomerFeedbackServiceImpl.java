package org.example.aikefu_bot02.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.example.aikefu_bot02.entity.CustomerFeedback;
import org.example.aikefu_bot02.service.CustomerFeedbackService;
import org.example.aikefu_bot02.mapper.CustomerFeedbackMapper;
import org.springframework.stereotype.Service;

/**
* @author 24229
* @description 针对表【customer_feedback(用户评价)】的数据库操作Service实现
* @createDate 2026-04-01 13:50:55
*/
@Service
public class CustomerFeedbackServiceImpl extends ServiceImpl<CustomerFeedbackMapper, CustomerFeedback>
    implements CustomerFeedbackService{

}




