import { MessageSettings } from "./hooks/message_settings"
import { HandleTimestampTimezone } from "./hooks/handle_timestamp_timezone"
import { CaptureKeyPress } from "./hooks/capture_key_press"
import { OpenEmojiPopup } from "./hooks/open_emoji_popup"
import { TypingIndicatorMechanism } from "./hooks/typing_indicator_mechanism"
import { ScrollingMechanism } from "./hooks/scrolling_mechanism"
import { NotifierButtonPress } from "./hooks/message_notifier_button"
import { HandleReactionPopup } from "./hooks/handle_reaction_popup"
import { ShowUsersReactionsList } from "./hooks/show_users_reactions_list"

let Hooks = {
    MessageSettings,
    HandleTimestampTimezone,
    CaptureKeyPress,
    OpenEmojiPopup,
    TypingIndicatorMechanism,
    ScrollingMechanism,
    NotifierButtonPress,
    HandleReactionPopup,
    ShowUsersReactionsList
}

export { Hooks }