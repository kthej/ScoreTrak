import Toybox.Lang;
import Toybox.WatchUi;

class ScoreTrakDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.VersusMenu(), new ScoreTrakMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}