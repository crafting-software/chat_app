let passwordInput = document.getElementById("password-input");
let passwordLabel = document.getElementById("password-label");
let isPublicCheckbox = document.getElementById("is_public");

isPublicCheckbox.addEventListener("click", function() {
  if (this.checked) {
    passwordInput.classList.remove("hidden");
    passwordLabel.classList.remove("hidden");
  } else {
    passwordInput.classList.add("hidden");
    passwordLabel.classList.add("hidden");
  }
});