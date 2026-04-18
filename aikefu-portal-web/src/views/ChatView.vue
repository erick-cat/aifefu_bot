<script setup lang="ts">
import { nextTick, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ChatDotRound, RefreshRight, SwitchButton } from '@element-plus/icons-vue'
import { useUserStore } from '@/stores/user'
import * as chatApi from '@/api/chat'
import { fetchProductDetail, type ShopProduct } from '@/api/product'

const SESSION_KEY = 'portal_chat_session_id'
const PRODUCT_CTX_KEY = 'portal_chat_product_id'

const route = useRoute()
const router = useRouter()
const user = useUserStore()

interface Bubble {
  role: 'user' | 'assistant'
  content: string
}

const messages = ref<Bubble[]>([])
const input = ref('')
const loading = ref(false)
const sessionId = ref<number | null>(null)
const listRef = ref<HTMLElement | null>(null)
const product = ref<ShopProduct | null>(null)
const productId = ref<number | null>(null)

function parseRouteProductId(): number | null {
  const q = route.query.productId
  if (q === undefined || q === null || q === '') return null
  const n = Number(Array.isArray(q) ? q[0] : q)
  return Number.isFinite(n) ? n : null
}

async function syncProductContext() {
  const pid = parseRouteProductId()
  const prev = sessionStorage.getItem(PRODUCT_CTX_KEY)
  productId.value = pid
  if (pid !== null) {
    const prevNum = prev ? Number(prev) : null
    if (prevNum !== pid) {
      sessionId.value = null
      sessionStorage.removeItem(SESSION_KEY)
    }
    sessionStorage.setItem(PRODUCT_CTX_KEY, String(pid))
    try {
      product.value = await fetchProductDetail(pid)
      messages.value = [
        {
          role: 'assistant',
          content: `您正在咨询商品「${product.value.name}」。我可回答与该商品的价格、规格、库存、类型等相关问题；其他商品或订单问题请返回商品列表或联系人工。`,
        },
      ]
    } catch {
      product.value = null
      messages.value = [{ role: 'assistant', content: '商品信息加载失败，请返回商品列表重试。' }]
    }
  } else {
    sessionStorage.removeItem(PRODUCT_CTX_KEY)
    sessionStorage.removeItem(SESSION_KEY)
    sessionId.value = null
    product.value = null
    await initGeneralWelcome()
  }
}

async function initGeneralWelcome() {
  await user.loadProfile()
  const sid = sessionStorage.getItem(SESSION_KEY)
  if (sid) {
    sessionId.value = Number(sid)
    messages.value = [
      {
        role: 'assistant',
        content: '欢迎回来。您可以继续上次会话提问，或点击「新对话」重新开始。',
      },
    ]
  } else {
    messages.value = [
      {
        role: 'assistant',
        content: `您好${user.user?.nickname ? '，' + user.user.nickname : ''}！我是店铺智能客服，会结合店铺政策与知识库为您解答；从「商品列表」进入可仅咨询单件商品。`,
      },
    ]
  }
}

onMounted(async () => {
  await user.loadProfile()
  const pid = parseRouteProductId()
  if (pid !== null) {
    await syncProductContext()
  } else {
    await initGeneralWelcome()
  }
})

watch(
  () => route.query.productId,
  async () => {
    await syncProductContext()
  },
)

watch(
  messages,
  async () => {
    await nextTick()
    listRef.value?.scrollTo({ top: listRef.value.scrollHeight, behavior: 'smooth' })
  },
  { deep: true },
)

function newChat() {
  sessionId.value = null
  sessionStorage.removeItem(SESSION_KEY)
  const pid = parseRouteProductId()
  if (pid !== null && product.value) {
    messages.value = [
      {
        role: 'assistant',
        content: `已开始针对「${product.value.name}」的新对话，请直接提问。`,
      },
    ]
  } else {
    messages.value = [
      {
        role: 'assistant',
        content: '已开始新对话。请直接输入您的问题。',
      },
    ]
  }
}

function logout() {
  user.logout()
  sessionStorage.removeItem(SESSION_KEY)
  sessionStorage.removeItem(PRODUCT_CTX_KEY)
  router.push('/')
}

async function send() {
  const text = input.value.trim()
  if (!text || loading.value) return
  loading.value = true
  input.value = ''
  messages.value.push({ role: 'user', content: text })
  try {
    const pid = parseRouteProductId()
    const res = await chatApi.sendChat({
      content: text,
      sessionId: sessionId.value ?? undefined,
      channel: 'web',
      productId: pid ?? undefined,
    })
    sessionId.value = res.sessionId
    sessionStorage.setItem(SESSION_KEY, String(res.sessionId))
    messages.value.push({ role: 'assistant', content: res.reply })
  } catch {
    messages.value.pop()
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="chat-page">
    <header class="chat-head">
      <div class="head-left">
        <span class="logo-dot" />
        <div class="titles">
          <h1>智能客服聊天机器人</h1>
          <span class="sub">Powered by DeepSeek · 服务端 aikefu_bot02</span>
        </div>
      </div>
      <div class="head-actions">
        <router-link to="/products" class="link-products">商品列表</router-link>
        <span class="who">{{ user.user?.nickname || user.user?.username }}</span>
        <el-button :icon="RefreshRight" round @click="newChat">新对话</el-button>
        <el-button :icon="SwitchButton" round @click="logout">退出</el-button>
      </div>
    </header>

    <div v-if="product" class="product-bar">
      <el-image :src="product.imageUrl || ''" class="thumb" fit="cover" referrerpolicy="no-referrer">
        <template #error><div class="thumb-ph" /></template>
      </el-image>
      <div class="pinfo">
        <strong>{{ product.name }}</strong>
        <span>¥{{ product.price }} · 库存 {{ product.stock }} · {{ product.type || '商品' }}</span>
      </div>
    </div>

    <main class="chat-body">
      <div ref="listRef" class="msg-list">
        <div
          v-for="(m, i) in messages"
          :key="i"
          class="row"
          :class="m.role === 'user' ? 'is-user' : 'is-bot'"
        >
          <div class="avatar">{{ m.role === 'user' ? '我' : 'AI' }}</div>
          <div class="bubble">{{ m.content }}</div>
        </div>
        <div v-if="loading" class="row is-bot typing">
          <div class="avatar">AI</div>
          <div class="bubble dim typing-bubble">
            <span class="typing-label">正在回复</span>
            <span class="typing-dot"></span>
            <span class="typing-dot"></span>
            <span class="typing-dot"></span>
          </div>
        </div>
      </div>
    </main>

    <footer class="composer">
      <el-input
        v-model="input"
        type="textarea"
        :rows="2"
        resize="none"
        placeholder="输入消息，Enter 发送（Shift+Enter 换行）"
        class="composer-input"
        @keydown.enter.exact.prevent="send"
      />
      <el-button type="primary" class="send-btn" round :loading="loading" :icon="ChatDotRound" @click="send">
        发送
      </el-button>
    </footer>
  </div>
</template>

<style scoped>
.link-products {
  font-size: 0.88rem;
  color: var(--accent);
  text-decoration: none;
  margin-right: 8px;
}
.link-products:hover {
  text-decoration: underline;
}
.product-bar {
  display: flex;
  align-items: center;
  gap: 14px;
  max-width: 880px;
  width: 100%;
  margin: 0 auto;
  padding: 12px 24px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.06);
  background: rgba(255, 255, 255, 0.03);
}
.thumb {
  width: 52px;
  height: 52px;
  border-radius: 10px;
  flex-shrink: 0;
}
.thumb-ph {
  width: 52px;
  height: 52px;
  border-radius: 10px;
  background: rgba(255, 255, 255, 0.06);
}
.pinfo {
  display: flex;
  flex-direction: column;
  gap: 4px;
  font-size: 0.85rem;
  color: var(--text-muted);
}
.pinfo strong {
  color: var(--text);
  font-size: 0.95rem;
}
.chat-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background: radial-gradient(ellipse 80% 60% at 50% -20%, rgba(99, 102, 241, 0.22), transparent),
    var(--bg);
  color: var(--text);
}
.chat-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 24px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.06);
  backdrop-filter: blur(12px);
  background: rgba(8, 10, 18, 0.85);
  flex-shrink: 0;
}
.head-left {
  display: flex;
  align-items: center;
  gap: 14px;
}
.logo-dot {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background: linear-gradient(135deg, #5eead4, #818cf8);
  box-shadow: 0 0 16px rgba(94, 234, 212, 0.5);
}
.titles h1 {
  margin: 0;
  font-size: 1.15rem;
  font-weight: 600;
}
.sub {
  display: block;
  font-size: 0.75rem;
  color: var(--text-muted);
  margin-top: 2px;
}
.head-actions {
  display: flex;
  align-items: center;
  gap: 10px;
}
.who {
  font-size: 0.88rem;
  color: var(--accent);
  margin-right: 8px;
  max-width: 140px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.chat-body {
  flex: 1;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  min-height: 0;
}
.msg-list {
  flex: 1;
  overflow-y: auto;
  padding: 24px;
  max-width: 880px;
  width: 100%;
  margin: 0 auto;
  box-sizing: border-box;
}
.row {
  display: flex;
  gap: 12px;
  margin-bottom: 18px;
  align-items: flex-start;
}
.row.is-user {
  flex-direction: row-reverse;
}
.avatar {
  flex-shrink: 0;
  width: 36px;
  height: 36px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.75rem;
  font-weight: 600;
}
.is-user .avatar {
  background: linear-gradient(135deg, #6366f1, #8b5cf6);
}
.is-bot .avatar {
  background: rgba(94, 234, 212, 0.15);
  color: var(--accent);
  border: 1px solid rgba(94, 234, 212, 0.35);
}
.bubble {
  max-width: min(680px, 88%);
  padding: 12px 16px;
  border-radius: 14px;
  line-height: 1.72;
  font-size: 0.95rem;
  white-space: pre-wrap;
  word-break: break-word;
}
.is-user .bubble {
  background: linear-gradient(135deg, rgba(99, 102, 241, 0.35), rgba(139, 92, 246, 0.25));
  border: 1px solid rgba(255, 255, 255, 0.08);
}
.is-bot .bubble {
  background: var(--surface);
  border: 1px solid rgba(255, 255, 255, 0.06);
}
.bubble.dim {
  opacity: 0.75;
  font-style: italic;
}
.typing-bubble {
  min-width: 120px;
  display: inline-flex;
  align-items: center;
  gap: 2px;
}
.typing-label {
  margin-right: 4px;
}
.typing-dot {
  width: 5px;
  height: 5px;
  border-radius: 50%;
  background: var(--accent);
  opacity: 0.35;
  animation: typing-bounce 1s ease-in-out infinite;
}
.typing-dot:nth-child(2) {
  animation-delay: 0.15s;
}
.typing-dot:nth-child(3) {
  animation-delay: 0.3s;
}
.typing-dot:nth-child(4) {
  animation-delay: 0.45s;
}
@keyframes typing-bounce {
  0%,
  100% {
    opacity: 0.25;
    transform: translateY(0);
  }
  50% {
    opacity: 1;
    transform: translateY(-3px);
  }
}
.composer {
  flex-shrink: 0;
  padding: 16px 24px 28px;
  max-width: 880px;
  width: 100%;
  margin: 0 auto;
  box-sizing: border-box;
  display: flex;
  gap: 12px;
  align-items: flex-end;
}
.composer-input {
  flex: 1;
}
.composer-input :deep(.el-textarea__inner) {
  border-radius: 14px;
  background: rgba(255, 255, 255, 0.04);
  border: 1px solid rgba(255, 255, 255, 0.1);
  color: var(--text);
  padding: 12px 14px;
}
.send-btn {
  height: 44px;
  padding: 0 22px;
}
</style>
