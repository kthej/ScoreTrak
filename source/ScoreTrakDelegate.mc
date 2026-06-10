import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application;


class ScoreTrakDelegate extends WatchUi.BehaviorDelegate {
    private var _view;
    function initialize(view) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    function onMenu() as Boolean {
        var CurrentMenu;

        if (_view.scoring_mode != 1 and _view.scoring_mode != 2) {
            CurrentMenu = new Rez.Menus.MainMenu();

            CurrentMenu.getItem(0).setSubLabel(_view.home_score.toString());
            CurrentMenu.getItem(1).setSubLabel(_view.guest_score.toString());

            if (_view.isRecording == true) {
                CurrentMenu.getItem(3).setLabel("Activity Options");
            } else {
                CurrentMenu.getItem(3).setLabel("Start Activity");
            }

            WatchUi.pushView(
                CurrentMenu,
                new ScoreTrakMenuDelegate(_view, "MainMenu"),
                WatchUi.SLIDE_UP
            );

        } else if(_view.scoring_mode == 1){ // Tennis

            var TennisMenu = new Rez.Menus.TennisMenu();
            // CurrentMenu.getItem(0).setSubLabel(_view.home_score.toString());
            // CurrentMenu.getItem(1).setSubLabel(_view.guest_score.toString());
            if (_view.isRecording == true) {
                TennisMenu.getItem(3).setLabel("Activity Options");
            } else {
                TennisMenu.getItem(3).setLabel("Start Activity");
            }
            WatchUi.pushView(
                TennisMenu,
                new ScoreTrakMenuDelegate(_view, "TennisMenu"),
                WatchUi.SLIDE_UP
            );
            
        } else if(_view.scoring_mode == 2){

            var GolfMenu = new Rez.Menus.GolfMenu();

            if (_view.isRecording == true) {

                GolfMenu.getItem(3).setLabel("Activity Options");
            } else {
                GolfMenu.getItem(3).setLabel("Start Activity");
            }
            WatchUi.pushView(
                GolfMenu,
                new ScoreTrakMenuDelegate(_view, "GolfMenu"),
                WatchUi.SLIDE_UP
            );
        }

        return true;
    }

    function onPreviousPage() {

        if (Application.Storage.getValue("scoring_mode") != 2) {
            if (Application.Storage.getValue("flip_score_buttons") == false) {
                _view.updateHome(1);
            } else {
                _view.updateGuest(1);
            }
        }
        else{
            if (Application.Storage.getValue("flip_score_buttons") == true) {
                _view.changePlayerIndex(-1);
            } else {
                _view.changePlayerIndex(1);
            }
            
        }
        return true;
    }
    function onNextPage() {
        if (Application.Storage.getValue("scoring_mode") != 2) {
            if (Application.Storage.getValue("flip_score_buttons") == false) {
                _view.updateGuest(1);
            } else {
                _view.updateHome(1);
            }
        } else{
            if (Application.Storage.getValue("flip_score_buttons") == true) {
                _view.changePlayerIndex(1);
            } else {
                _view.changePlayerIndex(-1);
            }
            
        }
        return true;
    }

    function onSelect() {
        if (Application.Storage.getValue("scoring_mode") == 2) {
            _view.updatePlayerScore(1);
        }
        if(_view.serve_tracking == true){
            if(_view.serve_switch_toggle == 0 and _view.serve_tracking == true){
                _view.serve_switch_toggle = 2;
            }
            else if(_view.serve_switch_toggle == 2 and _view.serve_tracking == true){
                _view.serve_switch_toggle = 0;
            }
            WatchUi.requestUpdate();
        }
        return true;
    }
    function onBack() {
        if (_view.isRecording) {
            return true;
        }

        return false;
    }
}
