// リクエスト型
export interface CreateSpotRequest {
  name: string
  description: string
  location: string
  images?: File[]
}

export interface UpdateSpotRequest {
  name?: string
  description?: string
  location?: string
  images?: File[]
}

// レスポンス型
export interface SpotResponse {
  id: number
  name: string
  description: string
  location: string
  images: {
    id: number
    url: string
    thumbnail_url: string
  }[]
  user: {
    id: number
    name: string
  }
  createdAt: string
  updatedAt: string
}

export interface SpotsListResponse {
  spots: SpotResponse[]
  meta: {
    currentPage: number
    totalPages: number
    totalCount: number
  }
}

export interface SpotDetailResponse extends SpotResponse {
  comments: {
    id: number
    content: string
    user: {
      id: number
      name: string
    }
    createdAt: string
  }[]
  likes: {
    id: number
    userId: number
  }[]
}
