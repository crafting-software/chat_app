import { extractActionAndMessageIdFromDomElementId } from "../utils"

function addPointerEventListener(component) {
    component.el.addEventListener("mouseover", event => {
        const messageId = extractActionAndMessageIdFromDomElementId(component.el)[1] 
        const usersReactionsPopup = document.getElementById("users_reaction_popup-" + messageId)
        usersReactionsPopup.removeAttribute("hidden")
    })

    component.el.addEventListener("mouseleave", event => {
        const messageId = extractActionAndMessageIdFromDomElementId(component.el)[1] 
        const usersReactionsPopup = document.getElementById("users_reaction_popup-" + messageId)
        usersReactionsPopup.setAttribute("hidden", "hidden")
    })
}

const ShowUsersReactionsList = {
    mounted() {
        addPointerEventListener(this)
    }
}

export { ShowUsersReactionsList }