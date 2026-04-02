<script setup lang="ts">
import { reactive, ref, onMounted } from 'vue'
import { fetchSensitivePage } from '@/api/admin'
import { cellText } from '@/utils/display'

const loading = ref(false)
const rows = ref<Record<string, unknown>[]>([])
const total = ref(0)
const query = reactive({ current: 1, size: 10, word: '' })

async function load() {
  loading.value = true
  try {
    const res = await fetchSensitivePage({
      current: query.current,
      size: query.size,
      word: query.word.trim() || undefined,
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
      <el-form-item label="关键词">
        <el-input v-model="query.word" placeholder="可选" clearable style="width: 200px" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="load">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="loading" :data="rows" border stripe style="width: 100%">
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="word" label="词" min-width="120" show-overflow-tooltip />
      <el-table-column prop="category" label="分类" width="100" />
      <el-table-column prop="level" label="级别" width="80" />
      <el-table-column prop="handleAction" label="处理方式" width="120" />
      <el-table-column prop="updatedAt" label="更新时间" min-width="160">
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
