// apiService.ts
import axios, { AxiosInstance, AxiosRequestConfig } from 'axios';
import { API_BASE_URL } from '@/services/api/apiConfig';

/**
 * API Service for making HTTP requests
 * Provides a clean, modular interface for all API operations
 */
class ApiService {
  private api: AxiosInstance;

  constructor() {
    this.api = axios.create({
      baseURL: API_BASE_URL,
      headers: {
        'Content-Type': 'application/json',
      },
      timeout: 30000, // 30 seconds
    });
  }

  /**
   * Get the axios instance for custom configurations
   */
  getInstance(): AxiosInstance {
    return this.api;
  }

  /**
   * GET request
   * @param url - Endpoint URL
   * @param config - Optional axios request config
   * @returns Promise with response data
   */
  async get<T>(url: string, config?: AxiosRequestConfig): Promise<T> {
    const response = await this.api.get<T>(url, config);
    return response.data;
  }

  /**
   * POST request
   * @param url - Endpoint URL
   * @param data - Request payload
   * @param config - Optional axios request config
   * @returns Promise with response data
   */
  async post<T>(url: string, data?: any, config?: AxiosRequestConfig): Promise<T> {
    const response = await this.api.post<T>(url, data, config);
    return response.data;
  }

  /**
   * PUT request
   * @param url - Endpoint URL
   * @param data - Request payload
   * @param config - Optional axios request config
   * @returns Promise with response data
   */
  async put<T>(url: string, data?: any, config?: AxiosRequestConfig): Promise<T> {
    const response = await this.api.put<T>(url, data, config);
    return response.data;
  }

  /**
   * PATCH request
   * @param url - Endpoint URL
   * @param data - Request payload
   * @param config - Optional axios request config
   * @returns Promise with response data
   */
  async patch<T>(url: string, data?: any, config?: AxiosRequestConfig): Promise<T> {
    const response = await this.api.patch<T>(url, data, config);
    return response.data;
  }

  /**
   * DELETE request
   * @param url - Endpoint URL
   * @param config - Optional axios request config
   * @returns Promise with response data
   */
  async delete<T>(url: string, config?: AxiosRequestConfig): Promise<T> {
    const response = await this.api.delete<T>(url, config);
    return response.data;
  }

  /**
   * Make a request with custom config
   * @param config - Full axios request config
   * @returns Promise with response data
   */
  async request<T>(config: AxiosRequestConfig): Promise<T> {
    const response = await this.api.request<T>(config);
    return response.data;
  }
}

// Export singleton instance
export const apiService = new ApiService();

// Export class for creating additional instances if needed
export default ApiService;
