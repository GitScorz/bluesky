let Notification: Notification;

on('Vehicles:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents() {
  Notification = global.exports['bs_base'].FetchComponent('Notification')
}

on('Core:Shared:Ready', function() {
  global.exports['bs_base'].RequestDependencies('Vehicles', [
    'Notification',
  ], (error: any[]) => {
    if (error.length > 0) return;
    RetrieveComponents();
  });
});


RegisterCommand('test', function() {
  Notification.SendAlert("test");
}, false)