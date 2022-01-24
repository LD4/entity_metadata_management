document.addEventListener('DOMContentLoaded', () => {
  (document.querySelectorAll('.iiif-notification .delete') || []).forEach(($delete) => {
    const $notification = $delete.closest(".iiif-notification");

    $delete.addEventListener('click', () => {
      $notification.parentNode.removeChild($notification);
    });
  });
});
