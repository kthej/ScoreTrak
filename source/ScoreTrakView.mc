import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Application;
import Toybox.Timer;

//Function that removes space and turns to newline

function formatSportName(name) {
    if (name == null) { return ""; }
    
    while (name.find(" ") != null) {
        var index = name.find(" ");
        name = name.substring(0, index) + "\n" + name.substring(index + 1, name.length());
    }
    return name;
}

class ScoreTrakView extends WatchUi.View {
// Begin Class ////////////////////////////////////////////////////////////////////////////////////

// Main App Variables

public var home_score = 0;
public var home_name;
public var guest_score = 0;
public var guest_name;
public var active_sport;

// Labels

public var sport_label;
public var home_score_label;
public var home_label;
public var guest_score_label;
public var guest_label;
public var time_label;
public var time_string;
public var time;

// Special Mode Variables

public var tennis_games;
public var tennis_matches;
public var golf_holes;
public var game_goal;
public var scoring_mode;

// Constants

public var JCENTER;
public var SCREEN_WIDTH;
public var SCREEN_HEIGHT;
public var SUB_SCREEN_X;
public var SUB_SCREEN_Y;
public var SUB_SCREEN_R;


// Watch Setup
public var instinct = false;
public var is_24_hour;
public var flip_score_buttons;
public var updateTimer;


// Drawing Element Variables

public var score_line_offset;
public var vertical_offset;

// Activity Recording

public var isRecording = false;

function initialize() {
    View.initialize();
    updateTimer = new Timer.Timer();
    updateTimer.start(method(:onTimer), 1000, true);
}


function onLayout(dc as Dc) as Void {

 // Get layout from xml

    setLayout(Rez.Layouts.MainLayout(dc));

// First time startup, check if storage values are null, if null, set values.

// Flip Score 

    if(Application.Storage.getValue("flip_score_buttons") == null){
        Application.Storage.setValue("flip_score_buttons",false);
    } else {
    flip_score_buttons = Application.Storage.getValue("flip_score_buttons");
    }

// Active Sport

    if (Application.Storage.getValue("active_sport") != null){

        active_sport = Application.Storage.getValue("active_sport");

    } else {

        Application.Storage.setValue("active_sport","Score Keeper");
        active_sport = Application.Storage.getValue("active_sport");
        
    }

// Home and Guest Names

    if(Application.Storage.getValue("home_name") != null){
    home_name = Application.Storage.getValue("home_name");
    } else {
        home_name = "HOME";
    }

    if(Application.Storage.getValue("guest_name") != null){
    guest_name = Application.Storage.getValue("guest_name");
    } else {
        guest_name = "GUEST";
    }

// 12/24 Hour

    if (Application.Storage.getValue("is24Hour") == null){
        Application.Storage.setValue("is24Hour",false);
    }

// Home and Guest Scores

    if(Application.Storage.getValue("home_score") != null and Application.Storage.getValue("guest_score") != null){

    home_score = Application.Storage.getValue("home_score");
    guest_score = Application.Storage.getValue("guest_score");

    } else {

        home_score = 0;
        guest_score = 0;

    }


// Constants

    JCENTER = Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;
    SCREEN_WIDTH = dc.getWidth();
    SCREEN_HEIGHT = dc.getHeight();

    if(System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_SEMI_OCTAGON){

        instinct = true;
        SUB_SCREEN_X = WatchUi.getSubscreen().x + WatchUi.getSubscreen().width/2;
        SUB_SCREEN_Y = WatchUi.getSubscreen().y + WatchUi.getSubscreen().height/2;
        SUB_SCREEN_R = WatchUi.getSubscreen().width/2;

    }

// Set labels from xml

    home_score_label = View.findDrawableById("HomeScore") as WatchUi.Text;
    home_label = View.findDrawableById("HomeLabel") as WatchUi.Text;
    guest_score_label = View.findDrawableById("GuestScore") as WatchUi.Text;
    guest_label = View.findDrawableById("GuestLabel") as WatchUi.Text;
    time_label = View.findDrawableById("TimeLabel") as WatchUi.Text;
    sport_label = View.findDrawableById("SportLabel") as WatchUi.Text;
    active_sport = Application.Storage.getValue("active_sport");

// Get scoring mode

    if(Application.Storage.getValue("scoring_mode") == null){

        scoring_mode = "default";
        Application.Storage.setValue("scoring_mode","default");
    }
}

function onUpdate(dc as Dc) as Void {
    time = System.getClockTime();

// Update the labels

    if(scoring_mode == "tennis"){

        home_score_label.setText(home_score.format("%02d"));
        home_label.setText(home_name);
        guest_score_label.setText(guest_score.format("%02d"));
        guest_label.setText(guest_name);
        
    }else if(scoring_mode == "group"){
        

    }else{
        home_score_label.setText(home_score.format("%02d"));
        home_label.setText(home_name);
        guest_score_label.setText(guest_score.format("%02d"));
        guest_label.setText(guest_name);
        
    }
        

    if (Application.Storage.getValue("is24Hour") == true) {
        time_string = Lang.format("$1$:$2$", [
            time.hour.format("%02d"),
            time.min.format("%02d")
        ]);

    } else {

        var hour = time.hour % 12;
        if (hour == 0) {
            hour = 12;
        }
        time_string = Lang.format("$1$:$2$", [
            hour.format("%d"),
            time.min.format("%02d")
        ]);
    }
    time_label.setText(time_string);

//Instinct shape vs circle handling. Only instinct watch shape gets special treatment due to asymmetrical screen design

    View.onUpdate(dc); // dc elements are drawn after labels from xml
    if(scoring_mode == "default"){

        score_line_offset = dc.getHeight()/6;
        vertical_offset = 0;

        if (instinct){

            sport_label.setText(formatSportName(active_sport));
            dc.setColor(Graphics.COLOR_WHITE,Graphics.COLOR_TRANSPARENT);
            dc.setPenWidth(3);
            dc.drawLine(0,dc.getHeight()*0.58,dc.getWidth(),dc.getHeight()*0.58);
            dc.drawLine(0,dc.getHeight()*0.84,dc.getWidth(),dc.getHeight()*0.84);
            dc.drawLine(dc.getWidth()/2, dc.getHeight()*.63, dc.getWidth()/2, dc.getHeight()*.79);
            dc.fillCircle(SUB_SCREEN_X,SUB_SCREEN_Y,SUB_SCREEN_R);
            dc.setColor(Graphics.COLOR_BLACK,Graphics.COLOR_TRANSPARENT);
            dc.drawText(SUB_SCREEN_X,SUB_SCREEN_Y,Graphics.FONT_MEDIUM,time_string,JCENTER);
            
        } else {


            sport_label.setText(active_sport);

            dc.setColor(Graphics.COLOR_WHITE,
            Graphics.COLOR_TRANSPARENT);

            dc.setPenWidth(5);

            dc.drawLine(
                0,
                dc.getHeight()/2 - score_line_offset + vertical_offset,
                dc.getWidth(),
                dc.getHeight()/2 - score_line_offset + vertical_offset
            );

            dc.drawLine(
                0,
                dc.getHeight()/2 + score_line_offset + vertical_offset,
                dc.getWidth(),
                dc.getHeight()/2 + score_line_offset + vertical_offset
            );
            
            dc.drawLine(
                dc.getWidth()/2,
                dc.getHeight()/2 - score_line_offset*0.75  + vertical_offset,
                dc.getWidth()/2,
                dc.getHeight()/2 + score_line_offset*0.75 + vertical_offset
            );
            
        }
    } else if (scoring_mode == "group") {

        score_line_offset = dc.getHeight()/6;
        vertical_offset = 0;

        if (instinct){

            sport_label.setText(formatSportName(active_sport));
            dc.setColor(Graphics.COLOR_WHITE,Graphics.COLOR_TRANSPARENT);
            dc.setPenWidth(3);
            dc.drawLine(0,dc.getHeight()*0.58 + vertical_offset,dc.getWidth(),dc.getHeight()*0.58 + vertical_offset);
            dc.drawLine(0,dc.getHeight()*0.84 + vertical_offset,dc.getWidth(),dc.getHeight()*0.84 + vertical_offset);
            dc.drawLine(dc.getWidth()/2, dc.getHeight()*.63 + vertical_offset, dc.getWidth()/2, dc.getHeight()*.79 + vertical_offset);
            dc.fillCircle(SUB_SCREEN_X,SUB_SCREEN_Y,SUB_SCREEN_R);
            dc.setColor(Graphics.COLOR_BLACK,Graphics.COLOR_TRANSPARENT);
            dc.drawText(SUB_SCREEN_X,SUB_SCREEN_Y,Graphics.FONT_MEDIUM,time_string,JCENTER);
            
        } else {

            sport_label.setText(active_sport);

            dc.setColor(Graphics.COLOR_WHITE,
            Graphics.COLOR_TRANSPARENT);

            dc.setPenWidth(5);

            dc.drawLine(
                0,
                dc.getHeight()/2 - score_line_offset + vertical_offset,
                dc.getWidth(),
                dc.getHeight()/2 - score_line_offset + vertical_offset
            );

            dc.drawLine(
                0,
                dc.getHeight()/2 + score_line_offset + vertical_offset,
                dc.getWidth(),
                dc.getHeight()/2 + score_line_offset + vertical_offset
            );
            
            dc.drawLine(
                dc.getWidth()/2,
                dc.getHeight()/2 - score_line_offset*0.75  + vertical_offset,
                dc.getWidth()/2,
                dc.getHeight()/2 + score_line_offset*0.75 + vertical_offset
            );
            
        }

    }
}

function onTimer() as Void{
    WatchUi.requestUpdate();
}

// Input handled functions, called from Delegate

function updateHome(value){
    home_score += value;
    WatchUi.requestUpdate();
    return true;
}

function updateGuest(value){
    guest_score += value;
    WatchUi.requestUpdate();
    return true;
}

function resetScores(){
    home_score = 0;
    guest_score = 0;
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

/*
function setCustomSportName(text){
    
}
*/

// End class //////////////////////////////////////////////////////////////////////////////////////
}
