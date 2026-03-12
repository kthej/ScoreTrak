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
        if(Application.Storage.getValue("flip_score_buttons") == false){
            _view.updateHome(1);
        }
        else{
            _view.updateGuest(1);
        }
        
        WatchUi.requestUpdate();
        return true;
    }
    function onNextPage(){
        if(Application.Storage.getValue("flip_score_buttons") == false){
            _view.updateGuest(1);
        }
        else{
            _view.updateHome(1);
        }
        WatchUi.requestUpdate();
        return true;
    }

}