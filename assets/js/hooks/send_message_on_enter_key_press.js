SendMessageOnEnterKeyPress = {
    mounted() {
        this.el.addEventListener("keydown", (event) => {
            if (event.which === 13 && !event.shiftKey) {
                textareaElement = document.getElementById("message_textarea") 
                this.pushEvent("save_message",  {"text": textareaElement.value})
                textareaElement.value = ""
                textareaElement.blur()
            } 
        })
    }
}

export { SendMessageOnEnterKeyPress }