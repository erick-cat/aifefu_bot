<script setup lang="ts">
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'

const route = useRoute()
const router = useRouter()
const user = useUserStore()

const active = computed(() => route.path)

function logout() {
  user.logout()
  router.push('/login')
}
</script>

<template>
  <el-container class="layout">
    <el-aside width="220px" class="aside">
      <div class="logo">智能客服 · 管理后台</div>
      <el-menu :default-active="active" router>
        <el-menu-item index="/dashboard">数据概览</el-menu-item>
        <el-menu-item index="/knowledge">知识库</el-menu-item>
        <el-menu-item index="/sensitive">敏感词</el-menu-item>
        <el-menu-item index="/prompt">Prompt 模板</el-menu-item>
        <el-menu-item index="/llm">模型配置</el-menu-item>
        <el-menu-item index="/chat">会话监控</el-menu-item>
        <el-menu-item index="/customers">C端用户</el-menu-item>
        <el-menu-item index="/shop-products">商品管理</el-menu-item>
      </el-menu>
    </el-aside>
    <el-container>
      <el-header class="header">
        <span class="title">{{ route.meta.title || '' }}</span>
        <el-button type="primary" link @click="logout">退出</el-button>
      </el-header>
      <el-main class="main">
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<style scoped>
.layout {
  min-height: 100vh;
}
.aside {
  border-right: 1px solid var(--el-border-color);
}
.logo {
  padding: 16px;
  font-weight: 600;
  color: var(--el-text-color-primary);
  border-bottom: 1px solid var(--el-border-color);
}
.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid var(--el-border-color);
}
.title {
  font-size: 16px;
}
.main {
  background: var(--el-fill-color-light);
}
</style>
