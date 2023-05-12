const TypingIndicatorMechanism = {
    mounted() {
        this.handleEvent("animate_typing_indicator", event => {
            if (event.status) {
                this.el.classList = []
                this.el.classList.add("opened_typing_indicator")
            }
        })
    }
}

export { TypingIndicatorMechanism }