import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Application;

class ScoreTrakView extends WatchUi.View {
    public var home_score = 0;
    public var guest_score = 0;
    public var JCENTER;
    public var SCREEN_WIDTH;
    public var SCREEN_HEIGHT;

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));

        // Graphics Constant var declaration

        JCENTER = Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;
        SCREEN_WIDTH = dc.getWidth();
        SCREEN_HEIGHT = dc.getHeight();

        // Check if scores are not null, then load into memory

        if(Application.Storage.getValue("home_score") != null and Application.Storage.getValue("guest_score") != null){
        home_score = Application.Storage.getValue("home_score");
        guest_score = Application.Storage.getValue("guest_score");
        }
        else{
            home_score = 0;
            guest_score = 0;
        }
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        

    }

    // Update the view
// Update the view
    function onUpdate(dc as Dc) as Void {
        // 1. Find the Score labels by the IDs we set in the XML
        var home_label = View.findDrawableById("HomeScore") as WatchUi.Text;
        var guest_label = WatchUi.Text;
        guest_label = View.findDrawableById("GuestScore") as WatchUi.Text;

        // 2. Update the text of those labels with formatted scores
        // Using .format("%02d") ensures 4 becomes "04"
        home_label.setText(home_score.format("%02d"));
        guest_label.setText(guest_score.format("%02d"));


        // 3. Call the parent onUpdate. 
        // This automatically clears the screen and draws everything in your XML layout.
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }
    function updateHome(value){
        home_score += value;
        Application.Storage.setValue("home_score",home_score);
        return true;
        

    }
    function updateGuest(value){
        guest_score += value;
        Application.Storage.setValue("guest_score",home_score);
        return true;
    }
    function resetScores(){
        home_score = 0;
        Application.Storage.setValue("home_score",0);
        guest_score = 0;
        Application.Storage.setValue("guest_score",0);

    }

}
