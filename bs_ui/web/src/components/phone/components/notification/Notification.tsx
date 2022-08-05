import {
  IconLookup,
  IconDefinition,
  findIconDefinition
} from '@fortawesome/fontawesome-svg-core'
import { useState } from 'react';
import { useNuiEvent } from '../../../../hooks/useNuiEvent';
import { debugData } from '../../../../utils/debugData';
import './Notification.css';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { fetchNui } from '../../../../utils/fetchNui';

// debugData<UI.Phone.NotificationProps[]>([
//   {
//     action: 'hud:phone:sendNotification',
//     data: [
//       {
//         id: "testasd2",
//         static: false,
//         title: '@JONH_DOE',
//         description: 'First',
//         icon: "bell"
//       },
//     ]
//   }
// ])

export default function Notification() {
  const [animation, setAnimation] = useState(false);
  const [notifications, setNotifications] = useState<UI.Phone.NotificationProps[]>([]);

  const getIcon = (icon: UI.Phone.NotificationIcon) => {
    let iconName: IconLookup;
    let color = '#5babaa';

    switch (icon) {
      case 'bell':
        iconName = { prefix: 'fas', iconName: 'bell' };
        break;
      case 'twitter':
        iconName = { prefix: 'fab', iconName: 'twitter' };
        color = "#1DA1F2";
        break;
      case 'group':
        iconName = { prefix: 'fas', iconName: 'user-group' };
        color = "#b1d8de";
        break;
      case 'task':
        iconName = { prefix: 'fas', iconName: 'people-carry-box' };
        color = "#b1d8de";
        break;
      case 'message':
        iconName = { prefix: 'fas', iconName: 'comment' };
        color = "#6fb559";
        break;
      case 'call':
        iconName = { prefix: 'fas', iconName: 'phone' };
        color = "#339146";
        break;
      default:
        iconName = { prefix: 'fas', iconName: 'bell' };
        break;
    }

    const iconDefinition: IconDefinition = findIconDefinition(iconName);

    return {
      iconDefinition, 
      color
    };
  }

  const reduce = (text: string) => { // Just a simple reducer to shorten the text
    if (text.length > 42) {
      return text.substring(0, 42) + '...';
    }

    return text;
  }

  useNuiEvent('hud:phone:sendNotification', (data: UI.Phone.NotificationProps[]) => {
    setAnimation(true);

    data.forEach((notification) => {
      setTimeout(() => {
        if (notification.static) {
          setNotifications([...notifications, notification]);
        } else {
          setNotifications([...notifications, notification]);
          setTimeout(() => {
            shutdownNotification(notification.id);
          }, 4000);
        }
      }, 500);
    });
  });

  const shutdownNotification = (id: string) => {
    setAnimation(false);
    setTimeout(() => {
      notifications.forEach((notification, index) => {
        if (notification.id === id) {
          setNotifications([...notifications, ...notifications.splice(index, 1)]);
        }
      });
      if (notifications.length === 0) {
        fetchNui('hud:phone:shutdownNotification', {});
      }
    }, 150)
  }

  // Man idk i did it this way, make better :\

  return (
    <div className="notification-wrapper" style={{ visibility: notifications.length > 0 ? "visible" : "hidden" }}>
      {/* Reversing array */}
      {notifications.slice(0).reverse().map((notification, index) => (
        <div className="notification-container"
          key={index}
          style={{
            cursor: 'pointer',
            animation: animation ? 'notification-open .2s ease-in-out' : 'notification-close .2s ease-in-out',
          }}
          onClick={() => shutdownNotification(notification.id)}>
          <div className="notification-header">
            <div className="notification-title">
              <div className="notification-icon" style={{ 
                backgroundColor: getIcon(notification.icon).color,
              }}>
                <FontAwesomeIcon icon={getIcon(notification.icon).iconDefinition} />
              </div>
              <span style={{ fontSize: '.9rem' }}>{notification.title}</span>
            </div>
            <div className="notification-time">just now</div>
          </div>
          <div className="notification-description">
            <span>{reduce(notification.description)}</span>
          </div>
        </div>
      ))}
    </div>
  )
}
