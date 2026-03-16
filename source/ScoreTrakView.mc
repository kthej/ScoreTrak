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
    public var is_24_hour;
    public var flip_score_buttons;


    public var active_sport;
    public var sport_label;
    public var home_score_label;
    public var home_label;
    public var guest_score_label;
    public var guest_label;
    public var time_label;
    public var time;
    public var time_string;
    

    public var JCENTER;
    public var SCREEN_WIDTH;
    public var SCREEN_HEIGHT;

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {

        setLayout(Rez.Layouts.MainLayout(dc));

        home_score_label = View.findDrawableById("HomeScore") as WatchUi.Text;
        home_label = View.findDrawableById("HomeLabel") as WatchUi.Text;
        guest_score_label = View.findDrawableById("GuestScore") as WatchUi.Text;
        guest_label = View.findDrawableById("GuestLabel") as WatchUi.Text;
        time_label = View.findDrawableById("TimeLabel") as WatchUi.Text;
        sport_label = View.findDrawableById("SportLabel") as WatchUi.Text;
        

        

        

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
        if(Application.Storage.getValue("is_24_hour") == null){
            Application.Storage.setValue("is_24_hour",true);
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
        if(Application.Storage.getValue("active_sport") == null){
            Application.Storage.setValue("active_sport","Score Keeper");
        }
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        

    }

    function onUpdate(dc as Dc) as Void {
        
    
        

        // 2. Update the text of those labels with formatted scores
        // Using .format("%02d") ensures 4 becomes "04"
        home_score_label.setText(home_score.format("%02d"));
        home_label.setText(home_name);
        guest_score_label.setText(guest_score.format("%02d"));
        guest_label.setText(guest_name);
        time = System.getClockTime();
        
        time_string = Lang.format(
            "$1$:$2$",
            [
                time.hour.format("%02d"),
                time.min.format("%02d")
            ]
        );
        time_label.setText(time_string);
        //Instinct shape vs circle shape handling


    

        // 3. Call the parent onUpdate. 
        // This automatically clears the screen and draws everything in your XML layout.
        View.onUpdate(dc);
                if (System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_SEMI_OCTAGON){
            
            sport_label.setText(formatSportName(active_sport));
            dc.setColor(Graphics.COLOR_WHITE,Graphics.COLOR_TRANSPARENT);
            dc.setPenWidth(3);
            dc.drawLine(0,dc.getHeight()*0.58,dc.getWidth(),dc.getHeight()*0.58);
            dc.drawLine(0,dc.getHeight()*0.84,dc.getWidth(),dc.getHeight()*0.84);
            dc.drawLine(dc.getWidth()/2, dc.getHeight()*.63, dc.getWidth()/2, dc.getHeight()*.79);
        }
        else{
            var score_line_offset = dc.getHeight()/6;
            sport_label.setText(active_sport);
            dc.setColor(Graphics.COLOR_WHITE,Graphics.COLOR_TRANSPARENT);
            dc.setPenWidth(5);
            dc.drawLine(0,dc.getHeight()/2 - score_line_offset,dc.getWidth(),dc.getHeight()/2 - score_line_offset);
            dc.drawLine(0,dc.getHeight()/2 + score_line_offset,dc.getWidth(),dc.getHeight()/2 + score_line_offset);
            dc.drawLine(dc.getWidth()/2, dc.getHeight()/2 - score_line_offset*0.75, dc.getWidth()/2, dc.getHeight()/2 + score_line_offset*0.75);
            // dc.drawRectangle(0,home_label.locY,dc.getWidth(),1); 
        }
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
        WatchUi.requestUpdate();
        return true;
        

    }
    function updateGuest(value){
        guest_score += value;
        Application.Storage.setValue("guest_score",guest_score);
        WatchUi.requestUpdate();
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
