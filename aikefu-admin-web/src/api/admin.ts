import http, { unwrap } from './http'
import type { ApiResult, PageResult } from './types'

export interface LoginBody {
  username: string
  password: string
}

export interface LoginVO {
  token: string
  username: string
  realName: string
}

export function login(body: LoginBody) {
  return unwrap(http.post<ApiResult<LoginVO>>('/admin/auth/login', body))
}

export function fetchKnowledgePage(params: { current: number; size: number; title?: string }) {
  return unwrap(http.get<ApiResult<PageResult<Record<string, unknown>>>>('/admin/knowledge-documents/page', { params }))
}

export function fetchSensitivePage(params: { current: number; size: number; word?: string }) {
  return unwrap(http.get<ApiResult<PageResult<Record<string, unknown>>>>('/admin/sensitive-words/page', { params }))
}

export function fetchPromptPage(params: { current: number; size: number; sceneCode?: string }) {
  return unwrap(http.get<ApiResult<PageResult<Record<string, unknown>>>>('/admin/prompt-templates/page', { params }))
}

export function fetchLlmPage(params: { current: number; size: number; configName?: string }) {
  return unwrap(http.get<ApiResult<PageResult<Record<string, unknown>>>>('/admin/llm-model-configs/page', { params }))
}

export function fetchStatPage(params: { current: number; size: number; channel?: string }) {
  return unwrap(http.get<ApiResult<PageResult<Record<string, unknown>>>>('/admin/stat-daily/page', { params }))
}

export function fetchChatSessions(params: {
  current: number
  size: number
  userId?: number
  channel?: string
}) {
  return unwrap(http.get<ApiResult<PageResult<Record<string, unknown>>>>('/admin/chat-sessions/page', { params }))
}

export function fetchChatMessages(params: { sessionId: number; current: number; size: number }) {
  return unwrap(http.get<ApiResult<PageResult<Record<string, unknown>>>>('/admin/chat-messages/page', { params }))
}

export function fetchCustomerUsersPage(params: { current: number; size: number; username?: string }) {
  return unwrap(http.get<ApiResult<PageResult<Record<string, unknown>>>>('/admin/customer-users/page', { params }))
}

export function fetchShopProductPage(params: {
  current: number
  size: number
  name?: string
  status?: number
}) {
  return unwrap(http.get<ApiResult<PageResult<Record<string, unknown>>>>('/admin/shop-products/page', { params }))
}

export function createShopProduct(body: Record<string, unknown>) {
  return unwrap(http.post<ApiResult<Record<string, unknown>>>('/admin/shop-products', body))
}

export function updateShopProduct(id: number, body: Record<string, unknown>) {
  return unwrap(http.put<ApiResult<Record<string, unknown>>>(`/admin/shop-products/${id}`, body))
}

export function deleteShopProduct(id: number) {
  return unwrap(http.delete<ApiResult<unknown>>(`/admin/shop-products/${id}`))
}
