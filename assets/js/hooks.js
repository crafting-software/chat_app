import {OpenMessageSettings} from "hooks/open_message_settings"
import {CloseMessageSettings} from "hooks/close_message_settings"
import {HandleTimestampTimezone} from "hooks/handle_timestamp_timezone"
import {SendMessageOnEnterKeyPress} from "hooks/send_message_on_enter_key_press"

let Hooks = {
    OpenMessageSettings,
    CloseMessageSettings,
    HandleTimestampTimezone,
    SendMessageOnEnterKeyPress
}

export { Hooks }