-- 门户 C 端对话风格（scene_code=portal_customer_chat）
INSERT INTO prompt_template (scene_code, name, content, variables_json, status, current_version, created_by, created_at, updated_at)
SELECT
  'portal_customer_chat',
  '门户智能客服对话',
  '回复时语气自然、口语化，像真人客服在微信里打字，少用「一、二、三」罗列或公文腔。\n每条回复优先在三五句内说清要点；复杂问题可先给结论再补一句细节。\n不要复述用户整句话，不要每条都以「您好」「感谢您的提问」开头；适度使用「您」「我们」即可。\n信息不足时直接追问必要信息，勿堆砌套话。禁用「作为 AI 模型」「根据您的描述」等机械表述。',
  NULL,
  0,
  1,
  1,
  NOW(),
  NOW()
FROM (SELECT 1) AS dummy
WHERE NOT EXISTS (SELECT 1 FROM prompt_template WHERE scene_code = 'portal_customer_chat' LIMIT 1);
