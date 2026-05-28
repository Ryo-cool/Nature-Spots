import type { User } from "~/types";

// 通知種別
export type NotificationAction = "review_posted" | "followed" | "announcement";

// notifiable（関連オブジェクト）の判別ユニオン
export interface ReviewNotifiable {
  type: "review";
  id: number;
  spot_id: number;
  title: string;
}

export interface RelationshipNotifiable {
  type: "relationship";
  user_id: number;
}

export interface AnnouncementNotifiable {
  type: "announcement";
  id: number;
  title: string;
  body: string;
}

export type Notifiable =
  | ReviewNotifiable
  | RelationshipNotifiable
  | AnnouncementNotifiable;

// 通知本体
export interface AppNotification {
  id: number;
  action: NotificationAction;
  read: boolean;
  created_at: string;
  actor: User | null;
  notifiable: Notifiable | null;
}

// ページネーション情報
export interface NotificationPagination {
  current_page: number;
  per_page: number;
  total_pages: number;
  total_count: number;
}

// GET /api/v1/notifications のレスポンス
export interface NotificationListResponse {
  notifications: AppNotification[];
  unread_count: number;
  pagination: NotificationPagination;
}

// 未読数のレスポンス
export interface UnreadCountResponse {
  unread_count: number;
}

// 既読化のレスポンス
export interface MarkReadResponse {
  notification: AppNotification;
  unread_count: number;
}
