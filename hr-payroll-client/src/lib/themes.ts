export type ThemeId = 'ocean-blue' | 'teal' | 'purple';

export interface Theme {
  id: ThemeId;
  name: string;
  /** Representative swatch colour shown in the switcher */
  swatch: string;
  description: string;
}

export const themes: Theme[] = [
  {
    id: 'ocean-blue',
    name: 'Ocean Blue',
    swatch: 'oklch(0.55 0.22 240)',
    description: 'Cool, professional blue — the default.',
  },
  {
    id: 'teal',
    name: 'Teal',
    swatch: 'oklch(0.54 0.14 185)',
    description: 'Fresh teal — calm and modern.',
  },
  {
    id: 'purple',
    name: 'Purple',
    swatch: 'oklch(0.55 0.22 295)',
    description: 'Bold purple — creative and distinctive.',
  },
];

export const DEFAULT_THEME: ThemeId = 'ocean-blue';
export const THEME_STORAGE_KEY = 'hr-payroll-theme';
