package org.example.aikefu_bot02.service;

import org.example.aikefu_bot02.entity.KnowledgeDocument;
import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;

/**
* @author 24229
* @description 针对表【knowledge_document(知识文档)】的数据库操作Service
* @createDate 2026-04-01 13:50:55
*/
public interface KnowledgeDocumentService extends IService<KnowledgeDocument> {

	/**
	 * 已发布文档中，标题或正文与用户输入存在模糊匹配的记录（用于客服对话上下文）。
	 */
	List<KnowledgeDocument> searchPublishedMatchingUserText(String userText, int limit);

	/**
	 * 最近更新的已发布文档（可选兜底）。
	 */
	List<KnowledgeDocument> listLatestPublished(int limit);
}
