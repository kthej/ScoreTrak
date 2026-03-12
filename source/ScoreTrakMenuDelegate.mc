import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class ScoreTrakMenuDelegate extends WatchUi.Menu2InputDelegate {
    private var _view;
    function initialize(view) {
        Menu2InputDelegate.initialize();
        _view = view;
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var id = item.getId();

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
    }

}