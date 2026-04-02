import { defineStore } from 'pinia'
import { ref } from 'vue'

const TOKEN_KEY = 'aikefu_admin_token'

export const useUserStore = defineStore('user', () => {
  const token = ref(localStorage.getItem(TOKEN_KEY) || '')

  function setToken(t: string) {
    token.value = t
    if (t) localStorage.setItem(TOKEN_KEY, t)
    else localStorage.removeItem(TOKEN_KEY)
  }

  function logout() {
    setToken('')
  }

  return { token, setToken, logout }
})
