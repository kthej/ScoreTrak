import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Application;

class ScoreTrakMenuDelegate extends WatchUi.Menu2InputDelegate {
private var _view;
private var _menu_id;

function initialize(view, menuId) {
    Menu2InputDelegate.initialize();
    _view = view;
    _menu_id = menuId;
}

function onSelect(item as WatchUi.MenuItem) as Void {
    var id = item.getId();

// Main Sport Menus

// Default

    if (_menu_id.equals("MainMenu")){

        if (id == :home_minus) {
            _view.updateHome(-1);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.requestUpdate();
            System.println("Home -1");
            
        } else if (id == :guest_minus) {

            _view.updateGuest(-1);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.requestUpdate();
            System.println("Guest -1");

        } else if(id == :reset_scores){

            _view.resetScores();
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.requestUpdate();
            System.println("Reset Scores");

        } else if(id ==:start_activity) {

            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.requestUpdate();
            System.println("Start Activity");

        } else if(id ==:change_sport) {

            var SportMenu = new Rez.Menus.SportMenu();
            WatchUi.pushView(
                SportMenu, 
                new ScoreTrakMenuDelegate(_view, "SportMenu"), 
                WatchUi.SLIDE_UP
                );
            System.println("Change Sport");

        } else if(id ==:advanced_settings) {

            var AdvancedMenu = new Rez.Menus.AdvancedMenu();
            WatchUi.pushView(
                AdvancedMenu, 
                new ScoreTrakMenuDelegate(_view, "AdvancedMenu"), 
                WatchUi.SLIDE_UP
                );
        }
        
    } else if (_menu_id.equals("TennisMenu")){

        if (id == :home_minus) {
            _view.updateHome(-1);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.requestUpdate();
            System.println("Home Minus");
            
        } else if (id == :guest_minus) {

            _view.updateGuest(-1);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.requestUpdate();
            System.println("Guest Minus");

        } else if(id == :reset_scores){

            _view.resetScores();
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.requestUpdate();
            System.println("Reset Scores");

        } else if(id ==:start_activity) {

            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.requestUpdate();
            System.println("Start Activity");

        } else if(id ==:change_sport) {

            var SportMenu = new Rez.Menus.SportMenu();
            WatchUi.pushView(
                SportMenu, 
                new ScoreTrakMenuDelegate(_view, "SportMenu"), 
                WatchUi.SLIDE_UP
                );
            System.println("Change Sport");

        } else if(id ==:advanced_settings) {

            var AdvancedMenu = new Rez.Menus.AdvancedMenu();
            WatchUi.pushView(
                AdvancedMenu, 
                new ScoreTrakMenuDelegate(_view, "AdvancedMenu"), 
                WatchUi.SLIDE_UP
                );
        }





// Sport Selection Menu

    } else if (_menu_id.equals("SportMenu")) {

        var sportName = item.getLabel();
        _view.active_sport = sportName;
        Application.Storage.setValue("active_sport",sportName);

        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        _view.resetScores();
        WatchUi.requestUpdate();
        System.println("Changed Sport");

    } else if(_menu_id.equals("AdvancedMenu")) {

        if(id ==:rename_home){
        var picker = new WatchUi.TextPicker("");
        var delegate = new ScoreTrakTextDelegate(_view.method(:setHomeName));
        WatchUi.pushView(picker, delegate, WatchUi.SLIDE_UP);
        
        } else if(id==:rename_guest) {
             
        var picker = new WatchUi.TextPicker("");
        var delegate = new ScoreTrakTextDelegate(_view.method(:setGuestName));
        WatchUi.pushView(picker, delegate, WatchUi.SLIDE_UP);

        } else if(id==:rename_custom_sport) {

        var picker = new WatchUi.TextPicker("");
        var delegate = new ScoreTrakTextDelegate(_view.method(:setCustomSportName));
        WatchUi.pushView(picker, delegate, WatchUi.SLIDE_UP);

        } else if(id==:reset_names) {

            _view.resetNames();
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.popView(WatchUi.SLIDE_DOWN);

        } else if(id==:time_format) {

            if (Application.Storage.getValue("is24Hour") == true) {
                Application.Storage.setValue("is24Hour",false);
                WatchUi.requestUpdate();
            } else {
                Application.Storage.setValue("is24Hour",true);
                WatchUi.requestUpdate();
                
            }

            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        
        } else if(id==:flip_score_buttons) {

            if (Application.Storage.getValue("flip_score_buttons") == false){
                Application.Storage.setValue("flip_score_buttons",true);
            }
            else{
                Application.Storage.setValue("flip_score_buttons",false);
            }

            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.popView(WatchUi.SLIDE_DOWN);

        }
    }

}

// End Class ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}