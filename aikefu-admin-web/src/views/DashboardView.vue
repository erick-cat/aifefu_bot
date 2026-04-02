<script setup lang="ts">
import { reactive, ref, onMounted } from 'vue'
import { fetchStatPage } from '@/api/admin'
import { cellText } from '@/utils/display'

const loading = ref(false)
const rows = ref<Record<string, unknown>[]>([])
const total = ref(0)
const query = reactive({ current: 1, size: 10, channel: '' })

async function load() {
  loading.value = true
  try {
    const res = await fetchStatPage({
      current: query.current,
      size: query.size,
      channel: query.channel.trim() || undefined,
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
      <el-form-item label="渠道">
        <el-input v-model="query.channel" placeholder="可选" clearable style="width: 160px" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="load">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="loading" :data="rows" border stripe style="width: 100%">
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="statDate" label="统计日" min-width="120">
        <template #default="{ row }">{{ cellText(row.statDate) }}</template>
      </el-table-column>
      <el-table-column prop="channel" label="渠道" width="100" />
      <el-table-column prop="sessionCount" label="会话数" width="90" />
      <el-table-column prop="messageCount" label="消息数" width="90" />
      <el-table-column prop="userMessageCount" label="用户消息" width="100" />
      <el-table-column prop="transferCount" label="转人工" width="90" />
      <el-table-column prop="avgResponseMs" label="平均响应(ms)" width="120" />
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
