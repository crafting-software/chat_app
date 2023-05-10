const textareaElement = document.getElementById("message_textarea")
const emojiButton = document.getElementById("emoji_button")
const emojiPopup = document.querySelector('emoji-picker')

if (emojiPopup != null) {
    window.onclick = event => {
        ids = ["emoji_button", "emoji_popup"]
        if (!ids.includes(event.target.id))
            emojiPopup.setAttribute("hidden", "hidden")
    }

    emojiButton.addEventListener("click", event => {
        emojiPopup.toggleAttribute("hidden")
    })

    emojiPopup.addEventListener('emoji-click', event => {
        textareaElement.value += event.detail.unicode
        emojiPopup.setAttribute("hidden", "hidden")
    })
}