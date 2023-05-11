function addClickEventListenerOnEmojiButton(component) {
    component.el.addEventListener("click", event => {
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