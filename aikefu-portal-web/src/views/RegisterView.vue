<script setup lang="ts">
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import PortalNav from '@/components/PortalNav.vue'
import { useUserStore } from '@/stores/user'

const router = useRouter()
const user = useUserStore()
const loading = ref(false)
const form = reactive({
  username: '',
  password: '',
  password2: '',
  nickname: '',
  email: '',
  phone: '',
})

async function submit() {
  if (form.password !== form.password2) {
    ElMessage.warning('两次输入的密码不一致')
    return
  }
  loading.value = true
  try {
    await user.register({
      username: form.username,
      password: form.password,
      nickname: form.nickname || undefined,
      email: form.email || undefined,
      phone: form.phone || undefined,
    })
    ElMessage.success('注册成功，已为您登录')
    sessionStorage.removeItem('portal_chat_session_id')
    router.replace('/products')
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
        <h1>创建账号</h1>
        <p class="hint">用户名 3～32 位，仅字母、数字、下划线；密码至少 6 位。</p>
        <el-form label-position="top" class="form" @submit.prevent="submit">
          <el-form-item label="用户名" required>
            <el-input v-model="form.username" maxlength="32" show-word-limit placeholder="例如 zhang_san" />
          </el-form-item>
          <el-form-item label="密码" required>
            <el-input v-model="form.password" type="password" show-password placeholder="至少 6 位" />
          </el-form-item>
          <el-form-item label="确认密码" required>
            <el-input v-model="form.password2" type="password" show-password />
          </el-form-item>
          <el-form-item label="昵称（可选）">
            <el-input v-model="form.nickname" maxlength="64" placeholder="默认同用户名" />
          </el-form-item>
          <el-form-item label="邮箱（可选）">
            <el-input v-model="form.email" type="email" />
          </el-form-item>
          <el-form-item label="手机（可选）">
            <el-input v-model="form.phone" />
          </el-form-item>
          <el-button type="primary" native-type="submit" class="submit" :loading="loading" round>
            注册并进入咨询
          </el-button>
        </el-form>
        <p class="switch">
          已有账号？
          <router-link to="/login">去登录</router-link>
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
  max-width: 440px;
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
  line-height: 1.5;
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
