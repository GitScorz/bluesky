// Will return whether the current environment is in a regular browser
// and not CEF
export const isEnvBrowser = (): boolean => !(window as any).invokeNative

// Basic no operation function
export const noop = () => {}

export const buildRespObj = (
  data: any,
  status?: 'ok' | 'error',
  errorMsg?: string,
): ServerPromiseResp<any> => ({
  data,
  status,
  errorMsg,
});