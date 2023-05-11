/**
const emojiButton = document.getElementById("emoji_button")

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
**/

function addClickEventListenerOnEmojiButton(component) {
    component.el.addEventListener("click", event => {
        console.log(event.target)
        event.target.focus()
        document.getElementById("emoji_popup").toggleAttribute("hidden")
    })
}

function addClickEventListenerOnEmojiPopup(component) {
    const emojiPicker = document.querySelector('emoji-picker')
    emojiPicker.addEventListener('emoji-click', event => {
        document.getElementById("message_textarea").value += event.detail.unicode
        component.el.blur()
    })
}

function addFocusOutEventListenerOnEmojiPopup() {
    const emojiPicker = document.querySelector('emoji-picker')
    emojiPicker.addEventListener("focusout", event => {
        emojiPicker.setAttribute("hidden", "hidden")
    })
}

function addPointerLeaveEventListenerOnEmojiPopup() {
    const emojiPicker = document.querySelector('emoji-picker')
    emojiPicker.addEventListener("pointerleave", event => {
        emojiPicker.setAttribute("hidden", "hidden")
    })
}

const OpenEmojiPopup = {
    mounted() {
        addClickEventListenerOnEmojiButton(this)
        addClickEventListenerOnEmojiPopup(this)
        addFocusOutEventListenerOnEmojiPopup()
        addPointerLeaveEventListenerOnEmojiPopup()
    }
}

export { OpenEmojiPopup }