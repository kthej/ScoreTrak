import Toybox.WatchUi;
import Toybox.Lang;

class ScoreTrakTextDelegate extends WatchUi.TextPickerDelegate {
    private var _callback as (Method(text as String) as Void);

    // We pass the specific function we want to trigger at the end
    function initialize(callback as (Method(text as String) as Void)) {
        TextPickerDelegate.initialize();
        _callback = callback;
    }

    function onTextEntered(text, changed) {
        if (changed) {
            _callback.invoke(text); // This "returns" the text to your chosen function
        }
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        System.println("Text input successfully");
        return true;
    }
}
class ConfirmationDelegate extends WatchUi.ConfirmationDelegate {
    private var _view;
    function initialize(view) {
        ConfirmationDelegate.initialize();
        _view = view;
    }

    function onResponse(response) {
        if (response == WatchUi.CONFIRM_NO) {
            _view.saveChoice(false);
            return true;
        } else {
            _view.saveChoice(true);
            return true;
        }
    }
}
