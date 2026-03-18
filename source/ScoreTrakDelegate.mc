import Toybox.Lang;
import Toybox.WatchUi;

class ScoreTrakDelegate extends WatchUi.BehaviorDelegate {
    private var _view;
    function initialize(view) {
        BehaviorDelegate.initialize();
        _view = view;

    }

    function onMenu() as Boolean {
        var CurrentMenu;
        if(Application.Storage.getValue("scoring_mode") != 1){
            CurrentMenu = new Rez.Menus.MainMenu();
            if(_view.isRecording == true){CurrentMenu.getItem(3).setLabel("Activity Options");}
            else{CurrentMenu.getItem(3).setLabel("Start Activity");}
            

        WatchUi.pushView(CurrentMenu, new ScoreTrakMenuDelegate(_view, "MainMenu"), WatchUi.SLIDE_UP);
        
        } else {
            CurrentMenu = new Rez.Menus.TennisMenu();
            
            if(_view.isRecording == true){CurrentMenu.getItem(3).setLabel("Activity Options");}
            else{CurrentMenu.getItem(3).setLabel("Start Activity");}
            WatchUi.pushView(new Rez.Menus.TennisMenu(), new ScoreTrakMenuDelegate(_view, "TennisMenu"), WatchUi.SLIDE_UP);
        }


        return true;
    }

    function onPreviousPage(){
        if(Application.Storage.getValue("scoring_mode") != 2){
        if(Application.Storage.getValue("flip_score_buttons") == false){
            _view.updateHome(1);
        }
        else{
            _view.updateGuest(1);
        }

        }
        return true;
    }
    function onNextPage(){
        if(Application.Storage.getValue("scoring_mode") != 2){
        if(Application.Storage.getValue("flip_score_buttons") == false){
            _view.updateGuest(1);
        }
        else{
            _view.updateHome(1);
        }
        }
        return true;
    }
    
    function onSelect(){
        if(Application.Storage.getValue("scoring_mode") != 2){

        }
        return true;
    }
    function onBack(){
        if(_view.isRecording){
            return true;
            
            
            
        }
        
        return false;
    }

}