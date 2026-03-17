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
    function onStop(state as Dictionary?) as Void {
        Application.Storage.setValue("home_score",view.home_score);
        Application.Storage.setValue("guest_score",view.guest_score);
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
