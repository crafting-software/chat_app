import { extractActionAndMessageIdFromDomElementId } from "../utils"

const SetUsernameOnRoomJoinFromList = {
    mounted() {
        const roomId = extractActionAndMessageIdFromDomElementId(this.el)[1]
        document.getElementById("room_list_join_button-" + roomId).addEventListener("click", (event) => {
            const username = this.el.value
            localStorage.setItem("username", username)
        })
    }
}

const SetUsernameOnRoomJoinThroughLink = {
    mounted() {
        document.getElementById("room_join_button").addEventListener("click", (event) => {
            const username = this.el.value
            localStorage.setItem("username", username)
        })
    }
}

const SaveUsernameAtRoomCreation = {
    mounted() {
        document.getElementById("create-new-room-button").addEventListener("click", (event) => {
            const username = this.el.value
            localStorage.setItem("username", username)
        })
    }
}

export { SetUsernameOnRoomJoinThroughLink, SetUsernameOnRoomJoinFromList, SaveUsernameAtRoomCreation }