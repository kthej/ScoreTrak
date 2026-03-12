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

    if (_menu_id.equals("MainMenu")){
        if (id == :item_1) {
            _view.updateHome(-1);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.requestUpdate();
            System.println("Home -1");
        } else if (id == :item_2) {
            _view.updateGuest(-1);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.requestUpdate();
            System.println("Guest -1");
        }
        else if(id == :item_3){
            _view.resetScores();

            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.requestUpdate();
            System.println("Reset Scores");
        }
        else if(id ==:item_4){
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.requestUpdate();
            System.println("Start Activity");
        }
        else if(id ==:item_5){
            var SportMenu = new Rez.Menus.SportMenu();
            WatchUi.pushView(
                SportMenu, 
                new ScoreTrakMenuDelegate(_view, "SportMenu"), 
                WatchUi.SLIDE_UP
                );
            System.println("Change Sport");
        }
        else if(id ==:item_6){
            var AdvancedMenu = new Rez.Menus.AdvancedMenu();
            WatchUi.pushView(
                AdvancedMenu, 
                new ScoreTrakMenuDelegate(_view, "AdvancedMenu"), 
                WatchUi.SLIDE_UP
                );
        }
    }
    else if(_menu_id.equals("SportMenu")){
        var sportName = item.getLabel();
        Application.Storage.setValue("active_sport",sportName);

        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.requestUpdate();
        System.println("Changed Sport");
    }

    else if(_menu_id.equals("AdvancedMenu")){
        if(id ==:rename_home){
        var picker = new WatchUi.TextPicker("");
        var delegate = new ScoreTrakTextDelegate(_view.method(:setHomeName));
        WatchUi.pushView(picker, delegate, WatchUi.SLIDE_UP);
        }
        else if(id==:rename_guest){
        var picker = new WatchUi.TextPicker("");
        var delegate = new ScoreTrakTextDelegate(_view.method(:setGuestName));
        WatchUi.pushView(picker, delegate, WatchUi.SLIDE_UP);
        }
        else if(id==:reset_names){
            _view.resetNames();
            WatchUi.popView(WatchUi.SLIDE_UP);
            WatchUi.popView(WatchUi.SLIDE_UP);
        }
    }
    }

}