<script setup lang="ts">
import { reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import PortalNav from '@/components/PortalNav.vue'
import { useUserStore } from '@/stores/user'

const route = useRoute()
const router = useRouter()
const user = useUserStore()
const loading = ref(false)
const form = reactive({ username: '', password: '' })

async function submit() {
  loading.value = true
  try {
    await user.login(form.username, form.password)
    ElMessage.success('登录成功')
    sessionStorage.removeItem('portal_chat_session_id')
    const redirect = (route.query.redirect as string) || '/products'
    router.replace(redirect)
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="page">
    <PortalNav />
    <div class="shell">
      <div class="panel">
        <h1>欢迎回来</h1>
        <p class="hint">登录后即可使用智能客服咨询。</p>
        <el-form label-position="top" class="form" @submit.prevent="submit">
          <el-form-item label="用户名" required>
            <el-input v-model="form.username" autocomplete="username" />
          </el-form-item>
          <el-form-item label="密码" required>
            <el-input v-model="form.password" type="password" show-password autocomplete="current-password" />
          </el-form-item>
          <el-button type="primary" native-type="submit" class="submit" :loading="loading" round>登录</el-button>
        </el-form>
        <p class="switch">
          还没有账号？
          <router-link to="/register">免费注册</router-link>
        </p>
      </div>
    </div>
  </div>
</template>

<style scoped>
.page {
  min-height: 100vh;
  background: var(--bg);
}
.shell {
  display: flex;
  justify-content: center;
  padding: 48px 24px 80px;
}
.panel {
  width: 100%;
  max-width: 400px;
  padding: 40px;
  border-radius: 20px;
  background: var(--surface);
  border: 1px solid rgba(255, 255, 255, 0.08);
  box-shadow: 0 24px 80px rgba(0, 0, 0, 0.45);
}
.panel h1 {
  margin: 0 0 8px;
  font-size: 1.65rem;
}
.hint {
  margin: 0 0 24px;
  font-size: 0.88rem;
  color: var(--text-muted);
}
.form :deep(.el-form-item__label) {
  color: var(--text-muted);
}
.submit {
  width: 100%;
  margin-top: 8px;
  height: 44px;
  font-size: 1rem;
}
.switch {
  margin: 24px 0 0;
  text-align: center;
  font-size: 0.9rem;
  color: var(--text-muted);
}
.switch a {
  color: var(--accent);
  text-decoration: none;
}
.switch a:hover {
  text-decoration: underline;
}
</style>
