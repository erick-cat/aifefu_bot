<script setup lang="ts">
import { reactive, ref } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { login } from '@/api/admin'
import { useUserStore } from '@/stores/user'

const router = useRouter()
const route = useRoute()
const user = useUserStore()
const loading = ref(false)
const form = reactive({ username: 'admin', password: 'password' })

async function onSubmit() {
  loading.value = true
  try {
    const vo = await login({ username: form.username, password: form.password })
    user.setToken(vo.token)
    ElMessage.success('登录成功')
    const redirect = (route.query.redirect as string) || '/'
    router.replace(redirect)
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="login-wrap">
    <el-card class="card" shadow="hover">
      <h2>管理员登录</h2>
      <p class="tip">默认账号与数据库 admin_user 一致（示例密码 password）</p>
      <el-form :model="form" label-width="72px" @submit.prevent="onSubmit">
        <el-form-item label="用户名">
          <el-input v-model="form.username" autocomplete="username" />
        </el-form-item>
        <el-form-item label="密码">
          <el-input v-model="form.password" type="password" show-password autocomplete="current-password" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" native-type="submit" :loading="loading" style="width: 100%">登录</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<style scoped>
.login-wrap {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
}
.card {
  width: 400px;
}
h2 {
  margin: 0 0 8px;
  text-align: center;
}
.tip {
  font-size: 12px;
  color: var(--el-text-color-secondary);
  margin-bottom: 16px;
  text-align: center;
}
</style>
