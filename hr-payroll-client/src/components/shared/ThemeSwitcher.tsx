import { Check } from 'lucide-react';
import { themes } from '@/lib/themes';
import { useTheme } from '@/contexts/ThemeContext';
import { cn } from '@/lib/utils';

export function ThemeSwitcher() {
  const { theme, setTheme } = useTheme();

  return (
    <div className="flex items-center gap-1" aria-label="Choose theme">
      {themes.map((t) => {
        const active = theme === t.id;
        return (
          <button
            key={t.id}
            onClick={() => setTheme(t.id)}
            title={t.name}
            aria-pressed={active}
            className={cn(
              'relative h-6 w-6 rounded-full border-2 transition-transform hover:scale-110 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2',
              active ? 'border-foreground/60 scale-110' : 'border-transparent'
            )}
            style={{ backgroundColor: t.swatch }}
          >
            {active && (
              <Check
                className="absolute inset-0 m-auto h-3 w-3 text-white drop-shadow"
                strokeWidth={3}
              />
            )}
            <span className="sr-only">{t.name}</span>
          </button>
        );
      })}
    </div>
  );
}
