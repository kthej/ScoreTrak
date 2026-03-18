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

    if (_menu_id.equals("MainMenu") or _menu_id.equals("TennisMenu")){

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

            // Update labels for advanced menu
            AdvancedMenu.getItem(0).setSubLabel(Application.Storage.getValue("home_name"));
            AdvancedMenu.getItem(1).setSubLabel(Application.Storage.getValue("guest_name"));
            if(Application.Storage.getValue("is24Hour") == true){
            AdvancedMenu.getItem(2).setSubLabel("24-Hour");
            }
            else{
                AdvancedMenu.getItem(2).setSubLabel("12-Hour");
            }

            if(Application.Storage.getValue("flip_score_buttons") == true){
            AdvancedMenu.getItem(3).setSubLabel("True");
            }
            else{
                AdvancedMenu.getItem(3).setSubLabel("False");
            }
            
            

            // Push View

            WatchUi.pushView(
                AdvancedMenu, 
                new ScoreTrakMenuDelegate(_view, "AdvancedMenu"), 
                WatchUi.SLIDE_UP
                );

        }
/*
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
        */

// Sport Selection Menu

    } else if (_menu_id.equals("SportMenu")) {

        var sportName = item.getLabel();
        _view.active_sport = sportName;
        Application.Storage.setValue("active_sport",sportName);

        if(
            id ==:sport_tennis or
            id ==:sport_platform
            
            ){
            _view.scoring_mode = 1;
            Application.Storage.setValue("scoring_mode",1);

        }else if(
            id==:sport_mini_golf or
            id==:sport_golf or
            id==:sport_disc_golf or
            id==:sport_board_game
            
            ){
            _view.scoring_mode = 2;
            Application.Storage.setValue("scoring_mode",2);
            
        }else{
            _view.scoring_mode = 0;
            Application.Storage.setValue("scoring_mode",0);
        }
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        _view.resetScores();
        WatchUi.requestUpdate();
        System.println("Changed Sport");

// Advanced Menu ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    } else if(_menu_id.equals("AdvancedMenu")) {


        if(id ==:rename_home){
        var picker = new WatchUi.TextPicker("");
        var delegate = new ScoreTrakTextDelegate(_view.method(:setHomeName));
        WatchUi.pushView(picker, delegate, WatchUi.SLIDE_UP);
        
        item.setSubLabel(Application.Storage.getValue("home_name"));
        
             

        } else if(id == :rename_guest) {
                

                var picker = new WatchUi.TextPicker("");
                var delegate = new ScoreTrakTextDelegate(_view.method(:setGuestName));
                WatchUi.pushView(picker, delegate, WatchUi.SLIDE_UP);
                
                item.setSubLabel(Application.Storage.getValue("guest_name"));
                

        

        } else if(id==:rename_custom_sport) {

        var picker = new WatchUi.TextPicker("");
        var delegate = new ScoreTrakTextDelegate(_view.method(:setCustomSportName));
        WatchUi.pushView(picker, delegate, WatchUi.SLIDE_UP);
        

        } else if(id==:reset_names) {

            _view.resetNames();


        } else if(id==:time_format) {

            if (Application.Storage.getValue("is24Hour") == true) {
                Application.Storage.setValue("is24Hour",false);
                item.setSubLabel("12-Hour");
                
            } else {
                Application.Storage.setValue("is24Hour",true);
               item.setSubLabel("24-Hour");
            
            }
            WatchUi.requestUpdate();


        
        } else if(id==:flip_score_buttons) {

            if (Application.Storage.getValue("flip_score_buttons") == false){
                Application.Storage.setValue("flip_score_buttons",true);
                item.setSubLabel("True");
            }
            else{
                Application.Storage.setValue("flip_score_buttons",false);
                item.setSubLabel("False");
            }

            WatchUi.requestUpdate();
            

        }
    }

}

// End Class ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}