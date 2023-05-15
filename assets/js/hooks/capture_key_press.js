const CaptureKeyPress = {
    mounted() {
        this.el.addEventListener("keydown", event => {
            if (event.which === 13 && !event.shiftKey) {
                const textareaElement = document.getElementById("message_textarea") 
                this.pushEvent("save_message", {"text": textareaElement.value})
                textareaElement.value = ""
                textareaElement.blur()
            } else {
                this.pushEvent("user_typing_indication", {})
            }
        })

        this.el.addEventListener("blur", async (event) => {
            setTimeout(() => {
                this.pushEvent("user_typing_indication_ended", {})
            }, 2000)
        })
    }
}

export { CaptureKeyPress }