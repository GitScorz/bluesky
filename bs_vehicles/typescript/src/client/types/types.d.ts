declare interface Notification {
  SendAlert(message: string, duration?: number): void;
  SendError(message: string, duration?: number): void;
  Clear(): void;
}
