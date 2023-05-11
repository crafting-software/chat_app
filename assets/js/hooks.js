import { OpenMessageSettings } from "./hooks/open_message_settings"
import { CloseMessageSettings } from "./hooks/close_message_settings"
import { HandleTimestampTimezone } from "./hooks/handle_timestamp_timezone"
import { CaptureKeyPress } from "./hooks/capture_key_press"
import { SendMessageOnEnterKeyPress } from "./hooks/send_message_on_enter_key_press"
import { OpenEmojiPopup } from "./hooks/open_emoji_popup"

let Hooks = {
    OpenMessageSettings,
    CloseMessageSettings,
    HandleTimestampTimezone,
    CaptureKeyPress,
    SendMessageOnEnterKeyPress,
    OpenEmojiPopup
}

export { Hooks }