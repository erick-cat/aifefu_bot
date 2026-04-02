<script setup lang="ts">
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'

const router = useRouter()
const user = useUserStore()

const isAuthed = computed(() => !!user.token)

function go(path: string) {
  router.push(path)
}

function logout() {
  user.logout()
  sessionStorage.removeItem('portal_chat_session_id')
  router.push('/')
}
</script>

<template>
  <header class="nav">
    <div class="nav-inner">
      <a class="brand" href="#" @click.prevent="go('/')">
        <span class="brand-mark" />
        <span class="brand-text">智服在线</span>
      </a>
      <nav class="links">
        <button type="button" class="link" @click="go('/')">首页</button>
        <button v-if="isAuthed" type="button" class="link" @click="go('/products')">商品列表</button>
        <template v-if="!isAuthed">
          <button type="button" class="link" @click="go('/login')">登录</button>
          <button type="button" class="btn-primary sm" @click="go('/register')">免费注册</button>
        </template>
        <template v-else>
          <button type="button" class="link" @click="go('/products')">商品与咨询</button>
          <span class="nick">{{ user.user?.nickname || user.user?.username }}</span>
          <button type="button" class="link muted" @click="logout">退出</button>
        </template>
      </nav>
    </div>
  </header>
</template>

<style scoped>
.nav {
  position: sticky;
  top: 0;
  z-index: 50;
  backdrop-filter: blur(16px);
  background: rgba(8, 10, 18, 0.72);
  border-bottom: 1px solid rgba(255, 255, 255, 0.06);
}
.nav-inner {
  max-width: 1120px;
  margin: 0 auto;
  padding: 14px 24px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.brand {
  display: flex;
  align-items: center;
  gap: 10px;
  text-decoration: none;
  color: var(--text);
  font-weight: 600;
  font-size: 1.05rem;
  letter-spacing: 0.02em;
}
.brand-mark {
  width: 28px;
  height: 28px;
  border-radius: 8px;
  background: linear-gradient(135deg, var(--accent), #818cf8);
  box-shadow: 0 0 24px rgba(94, 234, 212, 0.35);
}
.links {
  display: flex;
  align-items: center;
  gap: 8px;
}
.link {
  background: none;
  border: none;
  color: var(--text-muted);
  font-size: 0.95rem;
  padding: 8px 14px;
  border-radius: 8px;
  cursor: pointer;
  transition: color 0.2s, background 0.2s;
}
.link:hover {
  color: var(--text);
  background: rgba(255, 255, 255, 0.06);
}
.link.muted {
  opacity: 0.75;
}
.btn-primary.sm {
  padding: 8px 18px;
  font-size: 0.9rem;
  border-radius: 10px;
}
.nick {
  font-size: 0.9rem;
  color: var(--accent);
  padding: 0 8px;
  max-width: 120px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
</style>
