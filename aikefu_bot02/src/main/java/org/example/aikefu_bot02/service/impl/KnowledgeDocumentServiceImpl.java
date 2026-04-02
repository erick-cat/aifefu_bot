package org.example.aikefu_bot02.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.example.aikefu_bot02.entity.KnowledgeDocument;
import org.example.aikefu_bot02.mapper.KnowledgeDocumentMapper;
import org.example.aikefu_bot02.service.KnowledgeDocumentService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

/**
* @author 24229
* @description 针对表【knowledge_document(知识文档)】的数据库操作Service实现
* @createDate 2026-04-01 13:50:55
*/
@Service
public class KnowledgeDocumentServiceImpl extends ServiceImpl<KnowledgeDocumentMapper, KnowledgeDocument>
		implements KnowledgeDocumentService {

	/** 状态：1 已发布（与表注释一致） */
	private static final int STATUS_PUBLISHED = 1;

	@Override
	public List<KnowledgeDocument> searchPublishedMatchingUserText(String userText, int limit) {
		if (!StringUtils.hasText(userText)) {
			return List.of();
		}
		String trimmed = userText.trim();
		final String likePattern = trimmed.length() > 120 ? trimmed.substring(0, 120) : trimmed;
		LambdaQueryWrapper<KnowledgeDocument> qw = new LambdaQueryWrapper<>();
		qw.eq(KnowledgeDocument::getStatus, STATUS_PUBLISHED);
		qw.and(w -> w.like(KnowledgeDocument::getTitle, likePattern).or().like(KnowledgeDocument::getContent, likePattern));
		qw.orderByDesc(KnowledgeDocument::getUpdatedAt);
		qw.last("LIMIT " + Math.max(1, limit));
		return list(qw);
	}

	@Override
	public List<KnowledgeDocument> listLatestPublished(int limit) {
		LambdaQueryWrapper<KnowledgeDocument> qw = new LambdaQueryWrapper<>();
		qw.eq(KnowledgeDocument::getStatus, STATUS_PUBLISHED);
		qw.orderByDesc(KnowledgeDocument::getUpdatedAt);
		qw.last("LIMIT " + Math.max(1, limit));
		return list(qw);
	}
}




