import { extractActionAndMessageIdFromDomElementId } from "../utils"

function roundReactionPopupBorders(component) {
    const style = document.createElement("style")
    style.textContent = `
        .picker {
            border-radius: 20px;
        }
    `
    component.el.shadowRoot.appendChild(style)
}

function addClickEventListenerOnReactionsPopup(component) {
    component.el.addEventListener('emoji-click', event => {
        console.log(`emoji: ${event.detail.unicode}`)
        const messageId = extractActionAndMessageIdFromDomElementId(component.el)[1]
        component.pushEvent("handle_reaction", {"id": messageId, "content": event.detail.unicode, "shortcode": event.detail.emoji.shortcodes[0]})
        component.el.blur() 
    })
}

function addClickEventListenerOnReactionButton(component) {
    const messageId = extractActionAndMessageIdFromDomElementId(component.el)[1]
    document
        .getElementById(`reaction_button-${messageId}`)
        .addEventListener("click", event => {
            event.target.focus()
            document.getElementById(`message_reactions_popup-${messageId}`).toggleAttribute("hidden")
        })
}

function addFocusOutEventListenerOnReactionPopup(component) {
    const messageId = extractActionAndMessageIdFromDomElementId(component.el)[1]
    const reactionPopup = document.getElementById(`message_reactions_popup-${messageId}`)
    reactionPopup.addEventListener("focusout", event => {
        reactionPopup.setAttribute("hidden", "hidden")
    })
}

function addClickOffEventListenerForReactionPopup(component) {
    const messageId = extractActionAndMessageIdFromDomElementId(component.el)[1]
    const reactionButton = document.getElementById(`reaction_button-${messageId}`)
    if (reactionButton != undefined) {
        document.addEventListener("click", event => {
            const isClickInside = component.el.contains(event.target) || reactionButton.contains(event.target)
            if (!isClickInside) {
                component.el.setAttribute("hidden", "hidden")
            }
        })
    }
}

const HandleReactionPopup = {
    mounted() {
        roundReactionPopupBorders(this)
        addClickEventListenerOnReactionButton(this)
        addClickEventListenerOnReactionsPopup(this)
        addClickOffEventListenerForReactionPopup(this)
        addFocusOutEventListenerOnReactionPopup(this)
    } 
}

export { HandleReactionPopup }