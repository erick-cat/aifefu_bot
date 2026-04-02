<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import PortalNav from '@/components/PortalNav.vue'
import { fetchProductPage, type ShopProduct } from '@/api/product'

const router = useRouter()
const loading = ref(false)
const list = ref<ShopProduct[]>([])
const total = ref(0)
const page = ref({ current: 1, size: 12 })

async function load() {
  loading.value = true
  try {
    const res = await fetchProductPage({
      current: page.value.current,
      size: page.value.size,
    })
    list.value = res.records as ShopProduct[]
    total.value = res.total
  } finally {
    loading.value = false
  }
}

function goConsult(p: ShopProduct) {
  router.push({ path: '/chat', query: { productId: String(p.id) } })
}

onMounted(load)
</script>

<template>
  <div class="page">
    <PortalNav />
    <div class="wrap">
      <header class="hero">
        <h1>商品列表</h1>
        <p>点击「咨询该商品」进入专属客服，机器人仅围绕该商品作答。</p>
      </header>
      <el-skeleton v-if="loading" :rows="6" animated />
      <div v-else class="grid">
        <article v-for="p in list" :key="p.id" class="card" @click="goConsult(p)">
          <div class="img-wrap">
            <el-image :src="p.imageUrl || ''" fit="cover" class="img">
              <template #error>
                <div class="img-ph">无图</div>
              </template>
            </el-image>
          </div>
          <div class="body">
            <span class="type">{{ p.type || '商品' }}</span>
            <h2>{{ p.name }}</h2>
            <p class="spec">{{ p.specs || '—' }}</p>
            <div class="row">
              <span class="price">¥{{ p.price }}</span>
              <span class="stock">库存 {{ p.stock }}</span>
            </div>
            <el-button type="primary" round class="btn" @click.stop="goConsult(p)">咨询该商品</el-button>
          </div>
        </article>
      </div>
      <div v-if="!loading && list.length === 0" class="empty">暂无上架商品</div>
      <div v-if="total > page.size" class="pager">
        <el-pagination
          v-model:current-page="page.current"
          :page-size="page.size"
          :total="total"
          layout="prev, pager, next"
          @current-change="load"
        />
      </div>
    </div>
  </div>
</template>

<style scoped>
.page {
  min-height: 100vh;
  background: var(--bg);
  color: var(--text);
}
.wrap {
  max-width: 1120px;
  margin: 0 auto;
  padding: 32px 24px 64px;
}
.hero {
  margin-bottom: 28px;
}
.hero h1 {
  margin: 0 0 8px;
  font-size: 1.75rem;
}
.hero p {
  margin: 0;
  color: var(--text-muted);
  font-size: 0.95rem;
}
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
  gap: 20px;
}
.card {
  border-radius: 16px;
  overflow: hidden;
  background: var(--surface);
  border: 1px solid rgba(255, 255, 255, 0.06);
  cursor: pointer;
  transition:
    transform 0.2s,
    border-color 0.2s;
}
.card:hover {
  transform: translateY(-4px);
  border-color: rgba(94, 234, 212, 0.25);
}
.img-wrap {
  aspect-ratio: 1;
  background: rgba(0, 0, 0, 0.25);
}
.img {
  width: 100%;
  height: 100%;
}
.img-ph {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  color: var(--text-muted);
  font-size: 0.85rem;
}
.body {
  padding: 16px;
}
.type {
  font-size: 0.75rem;
  color: var(--accent);
}
.body h2 {
  margin: 6px 0 8px;
  font-size: 1.05rem;
  line-height: 1.35;
}
.spec {
  margin: 0 0 12px;
  font-size: 0.82rem;
  color: var(--text-muted);
  line-height: 1.45;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.row {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
  margin-bottom: 12px;
}
.price {
  font-size: 1.2rem;
  font-weight: 700;
  color: #fcd34d;
}
.stock {
  font-size: 0.82rem;
  color: var(--text-muted);
}
.btn {
  width: 100%;
}
.empty {
  text-align: center;
  padding: 48px;
  color: var(--text-muted);
}
.pager {
  display: flex;
  justify-content: center;
  margin-top: 32px;
}
</style>
