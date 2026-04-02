<script setup lang="ts">
import { reactive, ref, onMounted } from 'vue'
import { fetchCustomerUsersPage } from '@/api/admin'
import { cellText } from '@/utils/display'

const loading = ref(false)
const rows = ref<Record<string, unknown>[]>([])
const total = ref(0)
const query = reactive({ current: 1, size: 10, username: '' })

async function load() {
  loading.value = true
  try {
    const res = await fetchCustomerUsersPage({
      current: query.current,
      size: query.size,
      username: query.username.trim() || undefined,
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
      <el-form-item label="用户名">
        <el-input v-model="query.username" placeholder="可选" clearable style="width: 200px" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="load">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="loading" :data="rows" border stripe style="width: 100%">
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="username" label="用户名" min-width="120" />
      <el-table-column prop="nickname" label="昵称" min-width="120" />
      <el-table-column prop="phone" label="手机" width="120" />
      <el-table-column prop="email" label="邮箱" min-width="160" show-overflow-tooltip />
      <el-table-column prop="status" label="状态" width="80" />
      <el-table-column prop="createdAt" label="注册时间" min-width="160">
        <template #default="{ row }">{{ cellText(row.createdAt) }}</template>
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
