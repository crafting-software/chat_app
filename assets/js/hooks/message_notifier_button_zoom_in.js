const ZoomInAnimationTrigger = {
    mounted() {
        this.el.addEventListener("click", () => {
            const chatbox = document.getElementById("chatbox")
            const messageElementHeight = document.querySelector(".message").offsetHeight

            chatbox.scroll({
                top: chatbox.scrollHeight - messageElementHeight,
                behavior: "smooth"
            })
        })
    }
}

export { ZoomInAnimationTrigger }