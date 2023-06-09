var lastScrollTopState = 0
const ScrollingMechanism = {
    mounted() {
        this.el.scroll({
            top: this.el.scrollHeight,
            behavior: "smooth"
        })

        this.handleEvent("new_message", (event) => {
            const messageElementHeight = document.querySelector(".message").offsetHeight
            if (this.el.scrollTop > this.el.scrollHeight - 2 * this.el.clientHeight)
                this.el.scrollTop = this.el.scrollHeight - messageElementHeight
        })
        
        this.el.addEventListener("scroll", () => { 
            const messageNotifierButton = document.getElementById("message_notifier_button")

            if (this.el.scrollTop > lastScrollTopState && this.el.scrollTop > this.el.scrollHeight - 2 * this.el.clientHeight) {
                if (!messageNotifierButton.hasAttribute("hidden")) {
                    messageNotifierButton.setAttribute("hidden", "hidden") 
                    messageNotifierButton.classList.remove("message_notifier_button_appearance")
                    messageNotifierButton.classList.add("message_notifier_button_disappearance")
                }
            } else if (this.el.scrollTop < lastScrollTopState && this.el.scrollTop < this.el.scrollHeight - 2 * this.el.clientHeight) {
                if (messageNotifierButton.hasAttribute("hidden")) {
                    messageNotifierButton.classList.remove("message_notifier_button_disappearance")
                    messageNotifierButton.removeAttribute("hidden") 
                    messageNotifierButton.classList.add("message_notifier_button_appearance")
                }
            } 

            lastScrollTopState = this.el.scrollTop <= 0 ? 0 : this.el.scrollTop
        })
    }
}

export { ScrollingMechanism }