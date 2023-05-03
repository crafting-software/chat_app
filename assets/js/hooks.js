import { OpenMessageSettings } from "./hooks/open_message_settings"
import { CloseMessageSettings } from "./hooks/close_message_settings"
import { HandleTimestampTimezone } from "./hooks/handle_timestamp_timezone"
import { OpenEmojiPopup } from "./hooks/open_emoji_popup"
import { CaptureKeyPress } from "./hooks/capture_key_press"

let Hooks = {
    OpenMessageSettings,
    CloseMessageSettings,
    HandleTimestampTimezone,
    OpenEmojiPopup,
    CaptureKeyPress
}

export { Hooks }