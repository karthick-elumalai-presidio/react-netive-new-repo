import '@/global.css';
import Providers from '@/providers/Providers';

import { Stack } from 'expo-router';
import '@/i18n';

export default function Layout() {
  return (
    <Providers>
      <Stack />
    </Providers>
  );
}
