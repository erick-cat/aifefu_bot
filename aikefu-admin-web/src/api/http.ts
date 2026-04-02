import axios from 'axios'
import type { ApiResult } from './types'
import { ElMessage } from 'element-plus'

const TOKEN_KEY = 'aikefu_admin_token'

const http = axios.create({
  baseURL: '/api',
  timeout: 30000,
})

http.interceptors.request.use((config) => {
  const token = localStorage.getItem(TOKEN_KEY)
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

http.interceptors.response.use(
  (res) => {
    const body = res.data as ApiResult<unknown>
    if (body && typeof body.code === 'number' && body.code !== 0) {
      ElMessage.error(body.message || '请求失败')
      return Promise.reject(new Error(body.message))
    }
    return res
  },
  (err) => {
    const msg = err.response?.data?.message || err.message || '网络错误'
    ElMessage.error(msg)
    return Promise.reject(err)
  },
)

export async function unwrap<T>(p: Promise<{ data: ApiResult<T> }>): Promise<T> {
  const { data } = await p
  return data.data as T
}

export default http
