<script setup lang="ts">
import { reactive, ref, onMounted } from 'vue'
import { fetchPromptPage } from '@/api/admin'
import { cellText } from '@/utils/display'

const loading = ref(false)
const rows = ref<Record<string, unknown>[]>([])
const total = ref(0)
const query = reactive({ current: 1, size: 10, sceneCode: '' })
const detailVisible = ref(false)
const detailRow = ref<Record<string, unknown> | null>(null)

async function load() {
  loading.value = true
  try {
    const res = await fetchPromptPage({
      current: query.current,
      size: query.size,
      sceneCode: query.sceneCode.trim() || undefined,
    })
    rows.value = res.records
    total.value = res.total
  } finally {
    loading.value = false
  }
}

function openDetail(row: Record<string, unknown>) {
  detailRow.value = row
  detailVisible.value = true
}

onMounted(load)
</script>

<template>
  <el-card shadow="never">
    <el-form :inline="true" @submit.prevent="load">
      <el-form-item label="场景编码">
        <el-input v-model="query.sceneCode" placeholder="可选" clearable style="width: 200px" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="load">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="loading" :data="rows" border stripe style="width: 100%">
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="sceneCode" label="场景" width="120" />
      <el-table-column prop="name" label="名称" min-width="140" show-overflow-tooltip />
      <el-table-column prop="status" label="状态" width="80" />
      <el-table-column prop="updatedAt" label="更新时间" min-width="160">
        <template #default="{ row }">{{ cellText(row.updatedAt) }}</template>
      </el-table-column>
      <el-table-column label="操作" width="100" fixed="right">
        <template #default="{ row }">
          <el-button type="primary" link @click="openDetail(row)">内容</el-button>
        </template>
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
    <el-dialog v-model="detailVisible" title="Prompt 内容" width="720px" destroy-on-close>
      <el-descriptions v-if="detailRow" :column="1" border>
        <el-descriptions-item label="占位变量">{{ cellText(detailRow.variablesJson) }}</el-descriptions-item>
        <el-descriptions-item label="正文">
          <pre style="white-space: pre-wrap; margin: 0; font-size: 13px">{{ cellText(detailRow.content) }}</pre>
        </el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </el-card>
</template>
