$(document).ready(function(){
  window.addEventListener('message', function(event){
    const item = event.data;

    if (item.runProgress === true) {
      const message = item.textsent;
      const fadeTimer = item.fadesent ? item.fadesent : 7500;
      const colorSent = item.colorsent;

      $('#colorsent' + colorSent).css('display', 'none');
      let element = $(`<div id="colorsent${colorSent}" class="notification-bg normal" style="display:none">${message}</div>`);

      if (colorSent == 2) {
        element = $(`<div id="colorsent${colorSent}" class="notification-bg red" style="display:none">${message}</div>`); 
      }
      
      $('.notify-wrap').prepend(element);
      $(element).fadeIn(500);
      
      setTimeout(function(){
         $(element).fadeOut(fadeTimer-(fadeTimer / 2));
      }, fadeTimer / 2);

      setTimeout(function(){
        $(element).css('display', 'none');
      }, fadeTimer);
    }
  });
});
