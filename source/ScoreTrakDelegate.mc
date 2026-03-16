import Toybox.Lang;
import Toybox.WatchUi;

class ScoreTrakDelegate extends WatchUi.BehaviorDelegate {
    private var _view;
    function initialize(view) {
        BehaviorDelegate.initialize();
        _view = view;

    }

    function onMenu() as Boolean {
        // var menu = new Rez.Menus.MainMenu();
        WatchUi.pushView(new Rez.Menus.MainMenu(), new ScoreTrakMenuDelegate(_view, "MainMenu"), WatchUi.SLIDE_UP);
        return true;
    }

    function onPreviousPage(){
        _view.updateHome(1);
        
        return true;
    }
    function onNextPage(){
        _view.updateGuest(1);
        
        return true;
    }

}