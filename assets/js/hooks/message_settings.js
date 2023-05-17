import { extractActionAndMessageIdFromDomElementId } from "../utils";

function triggerMessageDeletionEvent(event, component) {
  if (event.relatedTarget != undefined) {
    elementType = event.relatedTarget.localName;
    elementAction = extractActionAndMessageIdFromDomElementId(
      event.relatedTarget
    )[0];
    if (
      elementType != undefined &&
      elementType == "button" &&
      elementAction == "delete"
    ) {
      component.pushEvent("delete_message", {
        id: extractActionAndMessageIdFromDomElementId(event.srcElement)[1],
      });
    }
  }
}

function triggerMessageEditingEvent(event, component) {
  if (event.relatedTarget != undefined) {
    elementType = event.relatedTarget.localName;
    elementAction = extractActionAndMessageIdFromDomElementId(
      event.relatedTarget
    )[0];
    if (
      elementType != undefined &&
      elementType == "button" &&
      elementAction == "edit"
    ) {
      const messageId = extractActionAndMessageIdFromDomElementId(
        event.relatedTarget
      )[1];

      const messageContainer = event.target.closest(".message");
      const messageContent = messageContainer.querySelector(".message_content");
      const originalContent = messageContent.innerText;

      const editedSuffix = '(edited)'
      const isAlreadyEdited = originalContent.endsWith(editedSuffix)

      const inputField = document.createElement("input");
      inputField.type = "text";
      inputField.value = isAlreadyEdited ? originalContent.slice(0, -editedSuffix.length) : originalContent;
      inputField.classList.add('rounded-2xl', 'bg-green-100', 'border-0', 'focus:border', 'focus:border-purple-800', 'col-span-5', 'resize-none')
      messageContent.innerHTML = "";
      messageContent.appendChild(inputField);
      inputField.focus();

      inputField.addEventListener("keydown", function (event) {
        if (event.key === "Enter") {
          event.preventDefault();

          const updatedContent = inputField.value.trim();

          if (updatedContent === "") {
            messageContent.innerText = originalContent;
          } else {
            component.pushEvent("edit_message", {
              id: messageId,
              content: updatedContent,
            });
          }
        }
      });
    }
  }
}

function addOpeningClickEventListenerOnMessageSettingsButton(component) {
  component.el.addEventListener("click", (event) => {
    event.target.focus();
    elementId =
      "settings-" +
      extractActionAndMessageIdFromDomElementId(event.srcElement)[1];
    document.getElementById(elementId).toggleAttribute("hidden");
  });
}

function addFocusOutEventListenerOnMessageSettingsButton(component) {
  component.el.addEventListener("focusout", (event) => {
    elementId =
      "settings-" +
      extractActionAndMessageIdFromDomElementId(event.srcElement)[1];
    document.getElementById(elementId).setAttribute("hidden", "hidden");
    triggerMessageDeletionEvent(event, component);
    triggerMessageEditingEvent(event, component);
  });
}

function addClickEventListenerOnMessageSettingsPopup(component) {
  const messageId = extractActionAndMessageIdFromDomElementId(component.el)[1];
  const messageSettingsPopup = document.getElementById("settings-" + messageId);
  if (messageSettingsPopup != undefined) {
    document.addEventListener("click", (event) => {
      const isClickInside =
        messageSettingsPopup.contains(event.target) ||
        component.el.contains(event.target);
      if (!isClickInside) {
        messageSettingsPopup.setAttribute("hidden", "hidden");
      } else {
        event.target.focus();
        messageSettingsPopup.removeAttribute("hidden");
      }
    });
  }
}

const MessageSettings = {
  mounted() {
    addOpeningClickEventListenerOnMessageSettingsButton(this);
    addFocusOutEventListenerOnMessageSettingsButton(this);
    addClickEventListenerOnMessageSettingsPopup(this);
  },
};

export { MessageSettings };
