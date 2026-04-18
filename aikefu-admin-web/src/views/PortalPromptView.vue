<script setup lang="ts">
import { reactive, ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { fetchPromptPage, createPromptTemplate, updatePromptTemplate } from '@/api/admin'

const SCENE = 'portal_customer_chat'

const loading = ref(false)
const saving = ref(false)
const recordId = ref<number | null>(null)

const form = reactive({
  name: '门户智能客服对话',
  content: '',
  status: 0,
})

const defaultContent = `回复时语气自然、口语化，像真人客服在微信里打字，少用「一、二、三」罗列或公文腔。
每条回复优先在三五句内说清要点；复杂问题可先给结论再补一句细节。
不要复述用户整句话，不要每条都以「您好」「感谢您的提问」开头；适度使用「您」「我们」即可。
信息不足时直接追问必要信息，勿堆砌套话。禁用「作为 AI 模型」「根据您的描述」等机械表述。`

async function load() {
  loading.value = true
  try {
    const res = await fetchPromptPage({ current: 1, size: 1, sceneCode: SCENE })
    const row = res.records[0] as Record<string, unknown> | undefined
    if (row && row.id != null) {
      recordId.value = Number(row.id)
      form.name = String(row.name ?? form.name)
      form.content = String(row.content ?? '')
      form.status = Number(row.status ?? 0)
    } else {
      recordId.value = null
      form.name = '门户智能客服对话'
      form.content = defaultContent
      form.status = 0
    }
  } finally {
    loading.value = false
  }
}

async function save() {
  if (!form.content.trim()) {
    ElMessage.warning('请填写提示词正文')
    return
  }
  saving.value = true
  try {
    const body: Record<string, unknown> = {
      sceneCode: SCENE,
      name: form.name.trim() || '门户智能客服对话',
      content: form.content.trim(),
      status: form.status,
      currentVersion: 1,
    }
    if (recordId.value != null) {
      await updatePromptTemplate(recordId.value, body)
      ElMessage.success('已保存，C 端新对话将使用此风格')
    } else {
      await createPromptTemplate(body)
      ElMessage.success('已创建并启用')
    }
    await load()
  } finally {
    saving.value = false
  }
}

onMounted(load)
</script>

<template>
  <el-card v-loading="loading" shadow="never">
    <template #header>
      <div class="hdr">
        <span>门户对话提示词</span>
        <el-text type="info" size="small">场景编码 {{ SCENE }}，仅影响 C 端聊天（DeepSeek 系统提示中会追加「对话风格」块）</el-text>
      </div>
    </template>
    <el-alert type="success" :closable="false" show-icon class="tip">
      在此调整语气与篇幅，可减轻模型回答生硬、套话多等问题；与「模型配置」中的 temperature 配合效果更佳。
    </el-alert>
    <el-form label-width="100px" style="margin-top: 16px; max-width: 920px">
      <el-form-item label="模板名称">
        <el-input v-model="form.name" placeholder="展示用名称" />
      </el-form-item>
      <el-form-item label="状态">
        <el-radio-group v-model="form.status">
          <el-radio :label="0">启用</el-radio>
          <el-radio :label="1">停用</el-radio>
        </el-radio-group>
        <el-text type="warning" size="small" style="margin-left: 12px">停用后 C 端不再注入本段，仅保留 application 中的语气补充</el-text>
      </el-form-item>
      <el-form-item label="提示词正文">
        <el-input v-model="form.content" type="textarea" :rows="14" placeholder="描述期望的对话风格、篇幅、禁用表述等" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" :loading="saving" @click="save">保存</el-button>
        <el-button @click="load">重新加载</el-button>
      </el-form-item>
    </el-form>
  </el-card>
</template>

<style scoped>
.hdr {
  display: flex;
  flex-direction: column;
  gap: 6px;
}
.tip {
  margin-bottom: 0;
}
</style>
