import Toybox.Lang;
import Toybox.WatchUi;

class ScoreTrakDelegate extends WatchUi.BehaviorDelegate {
    private var _view;
    function initialize(view) {
        BehaviorDelegate.initialize();
        _view = view;

    }

    function onMenu() as Boolean {
        
        WatchUi.pushView(new Rez.Menus.MainMenu(), new ScoreTrakMenuDelegate(_view), WatchUi.SLIDE_UP);
        return true;
    }

    function onPreviousPage(){
        _view.updateHome(1);
        WatchUi.requestUpdate();
        return true;
    }
    function onNextPage(){
        _view.updateGuest(1);
        WatchUi.requestUpdate();
        return true;
    }

}