<script setup lang="ts">
import { reactive, ref, onMounted } from 'vue'
import { fetchLlmPage } from '@/api/admin'
import { cellText } from '@/utils/display'

const loading = ref(false)
const rows = ref<Record<string, unknown>[]>([])
const total = ref(0)
const query = reactive({ current: 1, size: 10, configName: '' })

async function load() {
  loading.value = true
  try {
    const res = await fetchLlmPage({
      current: query.current,
      size: query.size,
      configName: query.configName.trim() || undefined,
    })
    rows.value = res.records
    total.value = res.total
  } finally {
    loading.value = false
  }
}

onMounted(load)
</script>

<template>
  <el-card shadow="never">
    <el-form :inline="true" @submit.prevent="load">
      <el-form-item label="配置名">
        <el-input v-model="query.configName" placeholder="可选" clearable style="width: 200px" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="load">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="loading" :data="rows" border stripe style="width: 100%">
      <el-table-column prop="id" label="ID" width="72" />
      <el-table-column prop="configName" label="名称" min-width="140" show-overflow-tooltip />
      <el-table-column prop="provider" label="提供商" width="100" />
      <el-table-column prop="modelName" label="模型" min-width="120" show-overflow-tooltip />
      <el-table-column prop="embeddingModel" label="Embedding" min-width="120" show-overflow-tooltip />
      <el-table-column prop="temperature" label="温度" width="80">
        <template #default="{ row }">{{ cellText(row.temperature) }}</template>
      </el-table-column>
      <el-table-column prop="topP" label="top_p" width="80">
        <template #default="{ row }">{{ cellText(row.topP) }}</template>
      </el-table-column>
      <el-table-column prop="apiKeyRef" label="密钥引用" min-width="120" show-overflow-tooltip />
      <el-table-column prop="updatedAt" label="更新" min-width="150">
        <template #default="{ row }">{{ cellText(row.updatedAt) }}</template>
      </el-table-column>
    </el-table>
    <div style="margin-top: 16px; display: flex; justify-content: flex-end">
      <el-pagination
        v-model:current-page="query.current"
        v-model:page-size="query.size"
        :total="total"
        :page-sizes="[10, 20, 50]"
        layout="total, sizes, prev, pager, next"
        @current-change="load"
        @size-change="
          () => {
            query.current = 1
            load()
          }
        "
      />
    </div>
  </el-card>
</template>
