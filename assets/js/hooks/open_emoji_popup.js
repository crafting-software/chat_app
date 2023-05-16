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

function addClickOffEventListenerForEmojiPopup(component) {
    const emojiPicker = document.querySelector('emoji-picker')
    if (emojiPicker != undefined && component.el != undefined) {
        document.addEventListener("click", event => {
            const isClickInside = emojiPicker.contains(event.target) || component.el.contains(event.target)
            if (!isClickInside) {
                emojiPicker.setAttribute("hidden", "hidden")
            }
        })
    }
}

function roundEmojiPopupBorders() {
    const emojiPicker = document.querySelector("emoji-picker")
    if (emojiPicker != undefined) {
        const style = document.createElement("style")
        style.textContent = `
            .picker {
                border-radius: 20px;
            }
        `
        emojiPicker.shadowRoot.appendChild(style)
    }
}

const OpenEmojiPopup = {
    mounted() {
        roundEmojiPopupBorders()
        addClickEventListenerOnEmojiButton(this)
        addClickEventListenerOnEmojiPopup(this)
        addClickOffEventListenerForEmojiPopup(this)
        addFocusOutEventListenerOnEmojiPopup()
    }
}

export { OpenEmojiPopup }