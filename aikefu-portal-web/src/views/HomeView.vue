<script setup lang="ts">
import PortalNav from '@/components/PortalNav.vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'

const router = useRouter()
const user = useUserStore()
</script>

<template>
  <div class="page">
    <PortalNav />
    <section class="hero">
      <div class="orb orb-a" />
      <div class="orb orb-b" />
      <div class="hero-content">
        <p class="eyebrow">企业级 · 全渠道智能客服</p>
        <h1>
          用对话连接每一次
          <span class="hl">服务与信任</span>
        </h1>
        <p class="sub">
          注册账号后，即可体验基于大模型的智能咨询：7×24 即时响应，多轮上下文理解，让问题止于机器人、复杂场景平滑转人工。
        </p>
        <div class="cta-row">
          <button v-if="user.token" type="button" class="btn-primary" @click="router.push('/products')">浏览商品并咨询</button>
          <template v-else>
            <button type="button" class="btn-primary" @click="router.push('/register')">立即注册</button>
            <button type="button" class="btn-ghost" @click="router.push('/login')">已有账号登录</button>
          </template>
        </div>
        <div class="stats">
          <div class="stat">
            <strong>秒级</strong>
            <span>首响时间</span>
          </div>
          <div class="stat">
            <strong>多轮</strong>
            <span>上下文记忆</span>
          </div>
          <div class="stat">
            <strong>安全</strong>
            <span>会话可追溯</span>
          </div>
        </div>
      </div>
    </section>

    <section class="features">
      <h2>全流程体验</h2>
      <p class="feat-sub">从注册登录到发起咨询，与后台 DeepSeek 大模型服务无缝衔接。</p>
      <div class="grid">
        <article class="card">
          <div class="icon">①</div>
          <h3>快速注册</h3>
          <p>用户名 + 密码即可开通，支持邮箱与手机扩展信息。</p>
        </article>
        <article class="card">
          <div class="icon">②</div>
          <h3>安全登录</h3>
          <p>JWT 无状态鉴权，咨询页自动携带身份，会话归属清晰。</p>
        </article>
        <article class="card">
          <div class="icon">③</div>
          <h3>智能咨询</h3>
          <p>大模型生成回复，支持同一会话连续追问与「新对话」重置。</p>
        </article>
      </div>
    </section>

    <footer class="foot">
      <span>© 智能客服用户门户 · 与 aikefu 管理端、服务端配套使用</span>
    </footer>
  </div>
</template>

<style scoped>
.page {
  min-height: 100vh;
  background: var(--bg);
  color: var(--text);
}
.hero {
  position: relative;
  overflow: hidden;
  padding: 72px 24px 96px;
  max-width: 1120px;
  margin: 0 auto;
}
.orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(80px);
  opacity: 0.45;
  pointer-events: none;
}
.orb-a {
  width: 420px;
  height: 420px;
  background: #6366f1;
  top: -120px;
  right: -80px;
}
.orb-b {
  width: 360px;
  height: 360px;
  background: #14b8a6;
  bottom: 40px;
  left: -100px;
}
.hero-content {
  position: relative;
  max-width: 720px;
}
.eyebrow {
  font-size: 0.85rem;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--accent);
  margin: 0 0 16px;
}
h1 {
  font-size: clamp(2rem, 4.5vw, 3.1rem);
  line-height: 1.15;
  font-weight: 700;
  margin: 0 0 20px;
  letter-spacing: -0.02em;
}
.hl {
  display: inline-block;
  background: linear-gradient(120deg, #5eead4, #a5b4fc);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}
.sub {
  font-size: 1.05rem;
  line-height: 1.75;
  color: var(--text-muted);
  margin: 0 0 32px;
  max-width: 560px;
}
.cta-row {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  margin-bottom: 48px;
}
.stats {
  display: flex;
  gap: 40px;
  flex-wrap: wrap;
}
.stat {
  display: flex;
  flex-direction: column;
  gap: 4px;
}
.stat strong {
  font-size: 1.35rem;
  color: #fff;
}
.stat span {
  font-size: 0.85rem;
  color: var(--text-muted);
}
.features {
  max-width: 1120px;
  margin: 0 auto;
  padding: 48px 24px 80px;
}
.features h2 {
  font-size: 1.75rem;
  margin: 0 0 8px;
  text-align: center;
}
.feat-sub {
  text-align: center;
  color: var(--text-muted);
  margin: 0 0 40px;
  font-size: 0.95rem;
}
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
  gap: 20px;
}
.card {
  padding: 28px;
  border-radius: 16px;
  background: var(--surface);
  border: 1px solid rgba(255, 255, 255, 0.06);
  transition: transform 0.25s, border-color 0.25s;
}
.card:hover {
  transform: translateY(-4px);
  border-color: rgba(94, 234, 212, 0.25);
}
.card .icon {
  font-size: 1.5rem;
  margin-bottom: 12px;
  opacity: 0.9;
}
.card h3 {
  margin: 0 0 10px;
  font-size: 1.1rem;
}
.card p {
  margin: 0;
  font-size: 0.92rem;
  line-height: 1.65;
  color: var(--text-muted);
}
.foot {
  text-align: center;
  padding: 32px 24px 48px;
  font-size: 0.85rem;
  color: var(--text-muted);
  border-top: 1px solid rgba(255, 255, 255, 0.06);
}
</style>
