import { extractActionAndMessageIdFromDomElementId } from "../utils"

function addBlurEventListener(component) {
    component.el.addEventListener("blur", event => {
        console.log("blur: left the reaction popup")
        component.el.setAttribute("hidden", "hidden")
    })
}

function addPointerLeaveEventListener(component) {
    component.el.addEventListener("pointerleave", event => {
        component.el.setAttribute("hidden", "hidden")
    })
}

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
        component.pushEvent("handle_reaction", {"id": messageId, "content": event.detail.unicode})
        component.el.blur() 
    })
}

function addClickEventListenerOnReactionButton(component) {
    const messageId = extractActionAndMessageIdFromDomElementId(component.el)[1]
    const reactionButton = document.getElementById(`reaction_button-${messageId}`)
    reactionButton.addEventListener("click", event => {
        const popupId = "message_reactions_popup-" + messageId 
        const reactionsPopup = document.getElementById(popupId)
        reactionsPopup.removeAttribute("hidden")
        reactionsPopup.focus()
    })
}

const HandleReactionPopup = {
    mounted() {
        addClickEventListenerOnReactionButton(this)
        roundReactionPopupBorders(this)
        addBlurEventListener(this)
        addClickEventListenerOnReactionsPopup(this)
        addPointerLeaveEventListener(this)
    } 
}

export { HandleReactionPopup }