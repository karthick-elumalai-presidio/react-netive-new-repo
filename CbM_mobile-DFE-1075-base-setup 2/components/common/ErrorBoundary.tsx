import React, { Component, ReactNode } from 'react';
import { View, Text, TouchableOpacity, ScrollView } from 'react-native';

interface Props {
  children: ReactNode;
}

interface State {
  hasError: boolean;
  error: Error | null;
}

export class ErrorBoundary extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, errorInfo: React.ErrorInfo) {
    console.error('Error Boundary caught:', error, errorInfo);

    // TODO: Log to error service in production
    // if (!__DEV__) {
    //   Sentry.captureException(error);
    // }
  }

  resetError = () => {
    this.setState({ hasError: false, error: null });
  };

  render() {
    if (this.state.hasError && this.state.error) {
      // DEVELOPMENT BUILD - Show detailed error
      if (__DEV__) {
        return (
          <View className="flex-1 bg-red-50 p-6">
            <View className="flex-1">
              <Text className="mb-4 text-2xl font-bold text-red-600">💥 Error Caught</Text>

              <Text className="mb-2 text-base font-semibold text-gray-800">
                {this.state.error.name}
              </Text>

              <Text className="mb-4 text-sm text-gray-700">{this.state.error.message}</Text>

              <Text className="mb-2 text-xs font-semibold text-gray-600">Stack Trace:</Text>

              <ScrollView className="mb-4 flex-1 rounded-lg bg-gray-900 p-3">
                <Text className="font-mono text-xs text-green-400">{this.state.error.stack}</Text>
              </ScrollView>
            </View>

            <TouchableOpacity onPress={this.resetError} className="rounded-lg bg-red-600 py-4">
              <Text className="text-center text-base font-semibold text-white">Try Again</Text>
            </TouchableOpacity>
          </View>
        );
      }

      // PRODUCTION BUILD - Show user-friendly error
      return (
        <View className="flex-1 items-center justify-center bg-white px-8">
          <Text className="mb-6 text-6xl">😕</Text>

          <Text className="mb-3 text-center text-2xl font-bold text-gray-900">
            Something went wrong
          </Text>

          <Text className="mb-8 text-center text-base text-gray-600">
            {"We're sorry for the inconvenience. Please try again."}
          </Text>

          <TouchableOpacity onPress={this.resetError} className="rounded-lg bg-blue-600 px-8 py-4">
            <Text className="text-base font-semibold text-white">Try Again</Text>
          </TouchableOpacity>
        </View>
      );
    }

    return this.props.children;
  }
}
