import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Application;
/*
Storage Values

home_score
home_name
guest_score
guest_name
active_sport

*/
//Removes space and turns to newline
function formatSportName(name) {
    if (name == null) { return ""; }
    // Look for a space and replace it with a newline character
    while (name.find(" ") != null) {
        var index = name.find(" ");
        name = name.substring(0, index) + "\n" + name.substring(index + 1, name.length());
    }
    return name;
}

class ScoreTrakView extends WatchUi.View {
    public var home_score = 0;
    public var home_name;
    public var guest_score = 0;
    public var guest_name;
    public var active_sport;

    public var flip_score_buttons;
    public var JCENTER;
    public var SCREEN_WIDTH;
    public var SCREEN_HEIGHT;

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));

        //Storage management and checking values

        if(Application.Storage.getValue("flip_score_buttons") == null){
            Application.Storage.setValue("flip_score_buttons",false);
        }

        else{
        flip_score_buttons = Application.Storage.getValue("flip_score_buttons");
        }

        if (Application.Storage.getValue("active_sport") != null){
            active_sport = Application.Storage.getValue("active_sport");
        }
        
        if(Application.Storage.getValue("home_name") != null){
        home_name = Application.Storage.getValue("home_name");
        }
        else{
            home_name = "HOME";
        }

        if(Application.Storage.getValue("guest_name") != null){
        guest_name = Application.Storage.getValue("guest_name");
        }

        else{
            guest_name = "GUEST";
        }
        
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
        var home_score_label = View.findDrawableById("HomeScore") as WatchUi.Text;
        var home_label = View.findDrawableById("HomeLabel") as WatchUi.Text;
        var guest_score_label = View.findDrawableById("GuestScore") as WatchUi.Text;
        var guest_label = View.findDrawableById("GuestLabel") as WatchUi.Text;
        
        var sport_label = View.findDrawableById("SportLabel") as WatchUi.Text;
        active_sport = Application.Storage.getValue("active_sport");
        

        // 2. Update the text of those labels with formatted scores
        // Using .format("%02d") ensures 4 becomes "04"
        home_score_label.setText(home_score.format("%02d"));
        home_label.setText(home_name);
        guest_score_label.setText(guest_score.format("%02d"));
        guest_label.setText(guest_name);
        //Determine if device is instinct shape, use newline if is
        if (System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_SEMI_OCTAGON){
            sport_label.setText(formatSportName(active_sport));
        }
        else{
            sport_label.setText(active_sport);
        }
        



        // 3. Call the parent onUpdate. 
        // This automatically clears the screen and draws everything in your XML layout.
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // Input handled functions

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
    function setHomeName(text){
        home_name = text;
        Application.Storage.setValue("home_name",home_name);
        
    }
    function setGuestName(text){
        guest_name = text;
        Application.Storage.setValue("guest_name",guest_name);
    }
    function resetNames(){
        home_name = "HOME";
        guest_name = "GUEST";
        Application.Storage.setValue("home_name","HOME");
        Application.Storage.setValue("guest_name","GUEST");
    }
    function setCustomSportName(text){

    }

}
