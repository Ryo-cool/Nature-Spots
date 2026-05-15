export type SeasonKey = "spring" | "summer" | "autumn" | "winter";

const MONTH_TO_SEASON: Record<number, SeasonKey> = {
  1: "winter",
  2: "winter",
  3: "spring",
  4: "spring",
  5: "spring",
  6: "summer",
  7: "summer",
  8: "summer",
  9: "autumn",
  10: "autumn",
  11: "autumn",
  12: "winter",
};

export const SEASON_KEYS: SeasonKey[] = [
  "spring",
  "summer",
  "autumn",
  "winter",
];

export const useCurrentSeason = () => {
  const getCurrentSeasonKey = (date: Date = new Date()): SeasonKey => {
    const month = date.getMonth() + 1;
    return MONTH_TO_SEASON[month] ?? "spring";
  };

  return {
    getCurrentSeasonKey,
    seasonKeys: SEASON_KEYS,
  };
};
