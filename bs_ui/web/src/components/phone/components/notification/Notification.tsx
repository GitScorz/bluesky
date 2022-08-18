import {
  IconLookup,
  IconDefinition,
  findIconDefinition,
} from "@fortawesome/fontawesome-svg-core";
import { useCallback, useMemo } from "react";
import "./Notification.css";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { NotificationIcon } from "../../../../types/phone";
import { useRecoilState, useSetRecoilState } from "recoil";
import { notificationState } from "../../hooks/state";

export default function Notification() {
  const setActive = useSetRecoilState(notificationState.active);
  const [animation, setAnimation] = useRecoilState(notificationState.animation);

  const [notifications, setNotifications] = useRecoilState(
    notificationState.notifications
  );

  const getIcon = useCallback((icon: NotificationIcon) => {
    let iconName: IconLookup;
    let color = "#5babaa";

    switch (icon) {
      case "bell":
        iconName = { prefix: "fas", iconName: "bell" };
        break;
      case "twitter":
        iconName = { prefix: "fab", iconName: "twitter" };
        color = "#1DA1F2";
        break;
      case "group":
        iconName = { prefix: "fas", iconName: "user-group" };
        color = "#b1d8de";
        break;
      case "task":
        iconName = { prefix: "fas", iconName: "people-carry-box" };
        color = "#b1d8de";
        break;
      case "message":
        iconName = { prefix: "fas", iconName: "comment" };
        color = "#6fb559";
        break;
      case "call":
        iconName = { prefix: "fas", iconName: "phone" };
        color = "#339146";
        break;
      default:
        iconName = { prefix: "fas", iconName: "bell" };
        break;
    }

    const iconDefinition: IconDefinition = findIconDefinition(iconName);

    return {
      iconDefinition,
      color,
    };
  }, []);

  const reduceText = useCallback((text: string) => {
    // Just a simple reducer to shorten the text
    if (text.length > 42) {
      return text.substring(0, 42) + "...";
    }

    return text;
  }, []);

  // useNuiEvent("hud:phone:sendNotification", (data: NotificationProps[]) => {
  //   setAnimation(true);

  //   data.forEach((notification) => {
  //     setTimeout(() => {
  //       if (notification.static) {
  //         setNotifications([...notifications, notification]);
  //       } else {
  //         setNotifications([...notifications, notification]);
  //         setTimeout(() => {
  //           shutdownNotification(notification.id);
  //         }, 4000);
  //       }
  //     }, 500);
  //   });
  // });

  const clearNotification = useCallback(
    (id: string) => {
      setAnimation(false);
      setActive(true);
      setTimeout(() => {
        setNotifications(notifications.filter((n) => n.id !== id));
        setAnimation(true);
        setActive(false);
      }, 150);
    },
    [notifications, setNotifications, setAnimation, setActive]
  );

  return useMemo(
    () => (
      <>
        <div
          className="notification-wrapper"
          style={{
            visibility: notifications.length > 0 ? "visible" : "hidden",
          }}
        >
          {/* Reversing array */}
          {notifications
            .slice(0)
            .reverse()
            .map((notification, index) => (
              <div
                className="notification-container"
                key={index}
                style={{
                  cursor: "pointer",
                  animation: animation
                    ? "notification-open .2s ease-in-out"
                    : "notification-close .2s ease-in-out",
                }}
                onClick={() => clearNotification(notification.id)}
              >
                <div className="notification-header">
                  <div className="notification-title">
                    <div
                      className="notification-icon"
                      style={{
                        backgroundColor: getIcon(notification.icon).color,
                      }}
                    >
                      <FontAwesomeIcon
                        icon={getIcon(notification.icon).iconDefinition}
                      />
                    </div>
                    <span style={{ fontSize: ".9rem" }}>
                      {notification.title}
                    </span>
                  </div>
                  <div className="notification-time">just now</div>
                </div>
                <div className="notification-description">
                  <span>{reduceText(notification.description)}</span>
                </div>
              </div>
            ))}
        </div>
      </>
    ),
    [notifications, clearNotification, getIcon, reduceText, animation]
  );
}
