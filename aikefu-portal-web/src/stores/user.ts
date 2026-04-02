import { defineStore } from 'pinia'
import { ref } from 'vue'
import * as authApi from '@/api/auth'
import { TOKEN_KEY } from '@/api/http'

export const useUserStore = defineStore('portalUser', () => {
  const token = ref(localStorage.getItem(TOKEN_KEY) || '')
  const user = ref<authApi.CustomerUserVO | null>(null)

  function setSession(t: string, u: authApi.CustomerUserVO) {
    token.value = t
    user.value = u
    localStorage.setItem(TOKEN_KEY, t)
  }

  function clear() {
    token.value = ''
    user.value = null
    localStorage.removeItem(TOKEN_KEY)
  }

  async function login(username: string, password: string) {
    const vo = await authApi.login({ username, password })
    setSession(vo.token, vo.user)
  }

  async function register(payload: {
    username: string
    password: string
    nickname?: string
    email?: string
    phone?: string
  }) {
    const vo = await authApi.register(payload)
    setSession(vo.token, vo.user)
  }

  async function loadProfile() {
    if (!token.value) return
    try {
      user.value = await authApi.fetchMe()
    } catch {
      clear()
    }
  }

  function logout() {
    clear()
  }

  return { token, user, setSession, clear, login, register, loadProfile, logout }
})
