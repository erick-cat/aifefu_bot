import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '@/stores/user'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: '/login', name: 'login', component: () => import('@/views/LoginView.vue') },
    {
      path: '/',
      component: () => import('@/layouts/AdminLayout.vue'),
      meta: { requiresAuth: true },
      children: [
        { path: '', redirect: '/dashboard' },
        { path: 'dashboard', name: 'dashboard', component: () => import('@/views/DashboardView.vue'), meta: { title: '数据概览' } },
        { path: 'knowledge', name: 'knowledge', component: () => import('@/views/KnowledgeView.vue'), meta: { title: '知识库' } },
        { path: 'sensitive', name: 'sensitive', component: () => import('@/views/SensitiveView.vue'), meta: { title: '敏感词' } },
        { path: 'prompt', name: 'prompt', component: () => import('@/views/PromptView.vue'), meta: { title: 'Prompt 模板' } },
        { path: 'llm', name: 'llm', component: () => import('@/views/LlmView.vue'), meta: { title: '模型配置' } },
        { path: 'chat', name: 'chat', component: () => import('@/views/ChatMonitorView.vue'), meta: { title: '会话监控' } },
        { path: 'customers', name: 'customers', component: () => import('@/views/CustomerUserView.vue'), meta: { title: 'C 端用户' } },
        { path: 'shop-products', name: 'shop-products', component: () => import('@/views/ShopProductView.vue'), meta: { title: '商品管理' } },
      ],
    },
  ],
})

router.beforeEach((to) => {
  const store = useUserStore()
  if (to.meta.requiresAuth && !store.token) {
    return { name: 'login', query: { redirect: to.fullPath } }
  }
  if (to.name === 'login' && store.token) {
    return { path: '/' }
  }
  return true
})

export default router
