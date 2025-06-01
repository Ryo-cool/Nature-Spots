import type { SpotResponse, SpotDetailResponse } from "../api/spot";
import type { BaseProps } from "./common";

// スポットカード用のprops
export interface SpotCardProps extends BaseProps {
  spot: SpotResponse;
  showActions?: boolean;
  onEdit?: (spot: SpotResponse) => void;
  onDelete?: (spotId: number) => void;
  onLike?: (spotId: number) => void;
}

// スポット詳細用のprops
export interface SpotDetailProps extends BaseProps {
  spot: SpotDetailResponse;
  isOwner: boolean;
  onEdit?: (spot: SpotDetailResponse) => void;
  onDelete?: (spotId: number) => void;
  onLike?: (spotId: number) => void;
  onComment?: (comment: { content: string }) => void;
}

// スポットフォーム用のprops
export interface SpotFormProps extends BaseProps {
  initialValues?: Partial<SpotResponse>;
  onSubmit: (values: FormData) => Promise<void>;
  submitLabel?: string;
  loading?: boolean;
}

// スポット画像ギャラリー用のprops
export interface SpotGalleryProps extends BaseProps {
  images: SpotResponse["images"];
  editable?: boolean;
  onImageUpload?: (files: File[]) => void;
  onImageDelete?: (imageId: number) => void;
}

// スポットコメント用のprops
export interface SpotCommentProps extends BaseProps {
  comment: SpotDetailResponse["comments"][0];
  onDelete?: (commentId: number) => void;
}

// スポット検索フォーム用のprops
export interface SpotSearchProps extends BaseProps {
  onSearch: (query: string) => void;
  initialQuery?: string;
  loading?: boolean;
}

// スポットフィルター用のprops
export interface SpotFilterProps extends BaseProps {
  onFilter: (filters: {
    location?: string;
    date?: string;
    category?: string;
  }) => void;
  activeFilters?: {
    location?: string;
    date?: string;
    category?: string;
  };
}
