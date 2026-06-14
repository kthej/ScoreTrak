import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class ScoreTrakApp extends Application.AppBase {
private var view;
    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    /*
    public var player_names as Lang.Array = ["Player 1", "Player 2", "Player 3", "Player 4", "Player 5", "Player 6", "Player 7", "Player 8", "Player 9", "Player 10"];
    public var player_scores as Lang.Array = [0,0,0,0,0,0,0,0,0,0];
    public var active_group_player = 0; // as index
    public var previous_player = 9; // as index
    public var next_player = 1; // as index
    public var amount_of_players = 3;// Max 10, else remaining values are not used    
    
    
    */
    function onStop(state as Dictionary?) as Void {
        Application.Storage.setValue("home_score",view.home_score);
        Application.Storage.setValue("guest_score",view.guest_score);
        Application.Storage.setValue("player_names",view.player_names);
        Application.Storage.setValue("player_scores",view.player_scores);
        Application.Storage.setValue("active_group_player", view.active_group_player);
        Application.Storage.setValue("amount_of_players",view.amount_of_players);
        Application.Storage.setValue("scoring_mode",view.scoring_mode);
        Application.Storage.setValue("active_sport", view.active_sport);
        Application.Storage.setValue("serve_tracking",view.serve_tracking);
        
        


    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates]{
        view = new ScoreTrakView();
        var delegate = new ScoreTrakDelegate(view); // Pass the view here
        
        return [ view, delegate];
    }

}

function getApp() as ScoreTrakApp {
    return Application.getApp() as ScoreTrakApp;
}
