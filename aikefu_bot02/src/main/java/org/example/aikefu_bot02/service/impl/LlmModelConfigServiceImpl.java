package org.example.aikefu_bot02.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.example.aikefu_bot02.entity.LlmModelConfig;
import org.example.aikefu_bot02.service.LlmModelConfigService;
import org.example.aikefu_bot02.mapper.LlmModelConfigMapper;
import org.springframework.stereotype.Service;

/**
* @author 24229
* @description 针对表【llm_model_config(LLM与Embedding配置)】的数据库操作Service实现
* @createDate 2026-04-01 13:50:55
*/
@Service
public class LlmModelConfigServiceImpl extends ServiceImpl<LlmModelConfigMapper, LlmModelConfig>
    implements LlmModelConfigService{

}




