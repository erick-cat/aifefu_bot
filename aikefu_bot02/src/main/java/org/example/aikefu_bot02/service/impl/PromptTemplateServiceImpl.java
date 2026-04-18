package org.example.aikefu_bot02.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.example.aikefu_bot02.entity.PromptTemplate;
import org.example.aikefu_bot02.mapper.PromptTemplateMapper;
import org.example.aikefu_bot02.service.PromptTemplateService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

/**
* @author 24229
* @description 针对表【prompt_template(Prompt模板)】的数据库操作Service实现
* @createDate 2026-04-01 13:50:55
*/
@Service
public class PromptTemplateServiceImpl extends ServiceImpl<PromptTemplateMapper, PromptTemplate>
		implements PromptTemplateService {

	@Override
	public String getEnabledContentBySceneCode(String sceneCode) {
		if (!StringUtils.hasText(sceneCode)) {
			return "";
		}
		PromptTemplate one = lambdaQuery()
				.eq(PromptTemplate::getSceneCode, sceneCode.trim())
				.eq(PromptTemplate::getStatus, 0)
				.orderByDesc(PromptTemplate::getId)
				.last("LIMIT 1")
				.one();
		if (one == null || !StringUtils.hasText(one.getContent())) {
			return "";
		}
		return one.getContent().trim();
	}
}




