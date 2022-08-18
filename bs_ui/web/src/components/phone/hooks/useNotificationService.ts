import { useRecoilValue, useSetRecoilState } from "recoil";
import { useNuiEvent } from "../../../hooks/useNuiEvent";
import { NotificationProps, PHONE_EVENTS } from "../../../types/phone";
import { debugData } from "../../../utils/debugData";
import { NOTIFICATION_TIMEOUT } from "../config/config";
import { notificationState } from "./state";

export const useNotificationService = () => {
  const notifications = useRecoilValue(notificationState.notifications);
  const setNotifications = useSetRecoilState(notificationState.notifications);
  const setAnimation = useSetRecoilState(notificationState.animation);
  const setActive = useSetRecoilState(notificationState.active);

  const addToNotifications = (data: NotificationProps) => {
    setTimeout(() => {
      if (data.static) {
        setAnimation(true);
        setActive(true);
        setNotifications([...notifications, data]);
      } else {
        setAnimation(true);
        setNotifications([...notifications, data]);
        setTimeout(() => {
          setAnimation(false);
          setTimeout(() => {
            setNotifications(notifications.filter(n => n.id !== data.id));
            setActive(false);
          }, 150)
        }, NOTIFICATION_TIMEOUT)
      }
    }, 500);
  }

  useNuiEvent(PHONE_EVENTS.SEND_NOTIFICATION, addToNotifications);
}

debugData<NotificationProps>([
  {
    action: PHONE_EVENTS.SEND_NOTIFICATION,
    data: {
      id: "2",
      title: "asdsads",
      description: "sadsadda",
      icon: "bell",
      static: false,
    },
  },
]);