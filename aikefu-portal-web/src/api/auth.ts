import http, { unwrap } from './http'
import type { ApiResult } from './types'

export interface CustomerUserVO {
  id: number
  username: string
  nickname: string | null
  email: string | null
  phone: string | null
  avatarUrl: string | null
  status: number
}

export interface LoginVO {
  token: string
  user: CustomerUserVO
}

export function register(body: {
  username: string
  password: string
  nickname?: string
  email?: string
  phone?: string
}) {
  return unwrap(http.post<ApiResult<LoginVO>>('/v1/customer/auth/register', body))
}

export function login(body: { username: string; password: string }) {
  return unwrap(http.post<ApiResult<LoginVO>>('/v1/customer/auth/login', body))
}

export function fetchMe() {
  return unwrap(http.get<ApiResult<CustomerUserVO>>('/v1/customer/auth/me'))
}
