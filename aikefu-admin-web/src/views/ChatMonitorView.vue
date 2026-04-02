<script setup lang="ts">
import { reactive, ref, onMounted } from 'vue'
import { fetchChatSessions, fetchChatMessages } from '@/api/admin'
import { cellText } from '@/utils/display'

const loading = ref(false)
const rows = ref<Record<string, unknown>[]>([])
const total = ref(0)
const query = reactive({ current: 1, size: 10, userId: '' as string, channel: '' })

const msgVisible = ref(false)
const activeSessionId = ref<number | null>(null)
const msgLoading = ref(false)
const msgRows = ref<Record<string, unknown>[]>([])
const msgTotal = ref(0)
const msgQuery = reactive({ current: 1, size: 10 })

async function load() {
  loading.value = true
  try {
    const uid = query.userId.trim()
    const res = await fetchChatSessions({
      current: query.current,
      size: query.size,
      userId: uid ? Number(uid) : undefined,
      channel: query.channel.trim() || undefined,
    })
    rows.value = res.records
    total.value = res.total
  } finally {
    loading.value = false
  }
}

async function openMessages(sid: number) {
  activeSessionId.value = sid
  msgQuery.current = 1
  msgVisible.value = true
  await loadMessages()
}

async function loadMessages() {
  if (activeSessionId.value == null) return
  msgLoading.value = true
  try {
    const res = await fetchChatMessages({
      sessionId: activeSessionId.value,
      current: msgQuery.current,
      size: msgQuery.size,
    })
    msgRows.value = res.records
    msgTotal.value = res.total
  } finally {
    msgLoading.value = false
  }
}

onMounted(load)
</script>

<template>
  <el-card shadow="never">
    <el-form :inline="true" @submit.prevent="load">
      <el-form-item label="用户ID">
        <el-input v-model="query.userId" placeholder="可选" clearable style="width: 140px" />
      </el-form-item>
      <el-form-item label="渠道">
        <el-input v-model="query.channel" placeholder="可选" clearable style="width: 120px" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="load">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="loading" :data="rows" border stripe style="width: 100%">
      <el-table-column prop="id" label="会话ID" width="100" />
      <el-table-column prop="userId" label="用户ID" width="100" />
      <el-table-column prop="channel" label="渠道" width="90" />
      <el-table-column prop="status" label="状态" width="80" />
      <el-table-column prop="title" label="标题" min-width="160" show-overflow-tooltip />
      <el-table-column prop="startedAt" label="开始时间" min-width="160">
        <template #default="{ row }">{{ cellText(row.startedAt) }}</template>
      </el-table-column>
      <el-table-column label="操作" width="110" fixed="right">
        <template #default="{ row }">
          <el-button type="primary" link @click="openMessages(Number(row.id))">消息</el-button>
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

    <el-dialog v-model="msgVisible" title="会话消息" width="800px" destroy-on-close>
      <el-table v-loading="msgLoading" :data="msgRows" border stripe max-height="420">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="roleType" label="角色" width="100" />
        <el-table-column prop="content" label="内容" min-width="200" show-overflow-tooltip />
        <el-table-column prop="tokenUsage" label="Token" width="80" />
        <el-table-column prop="createdAt" label="时间" min-width="160">
          <template #default="{ row }">{{ cellText(row.createdAt) }}</template>
        </el-table-column>
      </el-table>
      <div style="margin-top: 12px; display: flex; justify-content: flex-end">
        <el-pagination
          v-model:current-page="msgQuery.current"
          v-model:page-size="msgQuery.size"
          :total="msgTotal"
          :page-sizes="[10, 20, 50]"
          layout="total, sizes, prev, pager, next"
          @current-change="loadMessages"
          @size-change="
            () => {
              msgQuery.current = 1
              loadMessages()
            }
          "
        />
      </div>
    </el-dialog>
  </el-card>
</template>
