import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application;

class ScoreTrakLeaderboardDelegate extends WatchUi.BehaviorDelegate {
    private var _view;
    function initialize(view) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    function onMenu() as Boolean {

        return true;
    }

    function onPreviousPage() {

        return true;
    }
    function onNextPage() {

        return true;
    }

    function onSelect() {
        return true;
    }
    function onBack() { return false; }
}
