const container = document.querySelector('#container');
const rooms = document.querySelector('#divrooms');
const gradient = document.querySelector('#gradient');

if (container != null) {
  container.addEventListener('scroll', function() {
    const wrapperHeight = container.offsetHeight;
    const contentHeight = rooms.offsetHeight;
    const scrollPosition = container.scrollTop;
    if (scrollPosition + wrapperHeight >= contentHeight) {
      gradient.style.display = 'none';
    } else {
      gradient.style.display = 'block';
    }
  });
}