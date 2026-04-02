import http, { unwrap } from './http'
import type { ApiResult } from './types'

export interface ChatSendResponse {
  sessionId: number
  reply: string
  userMessageId: number
  assistantMessageId: number
}

export function sendChat(body: {
  content: string
  sessionId?: number
  channel?: string
  /** 从商品页进入时携带，服务端将会话限定为该商品 */
  productId?: number
}) {
  return unwrap(http.post<ApiResult<ChatSendResponse>>('/v1/chat/messages', body))
}
