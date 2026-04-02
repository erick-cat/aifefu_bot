import http, { unwrap } from './http'
import type { ApiResult, PageResult } from './types'

export interface ShopProduct {
  id: number
  name: string
  specs: string | null
  price: number
  stock: number
  imageUrl: string | null
  type: string | null
  status: number
}

export function fetchProductPage(params: { current: number; size: number; type?: string }) {
  return unwrap(http.get<ApiResult<PageResult<ShopProduct>>>('/v1/products/page', { params }))
}

export function fetchProductDetail(id: number) {
  return unwrap(http.get<ApiResult<ShopProduct>>(`/v1/products/${id}`))
}
