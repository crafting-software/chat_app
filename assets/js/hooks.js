import { MessageSettings } from "./hooks/message_settings"
import { HandleTimestampTimezone } from "./hooks/handle_timestamp_timezone"
import { CaptureKeyPress } from "./hooks/capture_key_press"
import { OpenEmojiPopup } from "./hooks/open_emoji_popup"
import { TypingIndicatorMechanism } from "./hooks/typing_indicator_mechanism"
import { ScrollingMechanism } from "./hooks/scrolling_mechanism"
import { NotifierButtonPress } from "./hooks/message_notifier_button"

let Hooks = {
    MessageSettings,
    HandleTimestampTimezone,
    CaptureKeyPress,
    OpenEmojiPopup,
    TypingIndicatorMechanism,
    ScrollingMechanism,
    NotifierButtonPress
}

export { Hooks }