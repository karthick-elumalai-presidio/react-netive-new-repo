import { Text, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useTranslation } from 'react-i18next';

export default function Home() {
  const { t } = useTranslation();
  return (
    <View className="flex flex-1 bg-primary">
      <SafeAreaView>
        <Text className="p-3 text-center text-xl font-bold text-foreground">
          {t('welcomeToApp')}
        </Text>
      </SafeAreaView>
    </View>
  );
}
