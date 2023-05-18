import { extractActionAndMessageIdFromDomElementId } from "../utils"

function addBlurEventListener(component) {
    component.el.addEventListener("blur", event => {
        console.log("blur: left the reaction popup")
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
        component.pushEvent("add_reaction", {"id": messageId, "content": event.detail.unicode})
        component.el.blur() 
    })
}

const HandleReactionPopup = {
    mounted() {
        roundReactionPopupBorders(this)
        addBlurEventListener(this)
        addClickEventListenerOnReactionsPopup(this)
    } 
}

export { HandleReactionPopup }