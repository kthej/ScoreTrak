import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Application;
import Toybox.Timer;
import Toybox.Activity;
import Toybox.ActivityRecording;
import Toybox.Attention;
import Toybox.Lang;
import Toybox.Math;

// Function to take integer seconds and return the proper time string format

function formatIntegerTime(time) {

    var hours = time / 3600;
    var minutes = (time % 3600) / 60;
    var seconds = time % 60;

    if (time <= 3600) {
        return Lang.format("$1$:$2$", [minutes.format("%02d"), seconds.format("%02d")]);
    } else if (time >= 3600) {
        return Lang.format("$1$:$2$:$3$", [hours.format("%02d"), minutes.format("%02d"), seconds.format("%02d")]);
    } else {
        return null;
    }
}
// Function that removes space and turns to newline

function formatSportName(name) {
    if (name == null) {
        return "";
    }

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

    // public var group_scores = Array[10];
    // public var group_names = Array[10];

    // Constants

    public var JCENTER;
    public var JLEFT;
    public var SCREEN_WIDTH;
    public var SCREEN_HEIGHT;
    public var SUB_SCREEN_X;
    public var SUB_SCREEN_Y;
    public var SUB_SCREEN_R;

    // Watch Setup
    public var instinct = false;

    // Scoring modes
    public var scoring_mode;
    public var active_player;

    /*
0 is default
1 is tennis
2 is group
3 is target
*/
    public var player_names as Lang.Array = [
        "Player 1", "Player 2", "Player 3", "Player 4", "Player 5", "Player 6", "Player 7", "Player 8", "Player 9",
        "Player 10"
    ] as Lang.Array;
    public var player_scores as Lang.Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    public var active_group_player;
    public var previous_player;
    public var next_player;
    public var amount_of_players;

    public var is24hour;
    public var flip_score_buttons;
    public var updateTimer;

    // Drawing Element Variables

    public var score_line_offset;
    public var vertical_offset;

    // Activity Recording

    public var isRecording = false;
    public var recordingState = 0;
    /*
0 is null
1 is paused
2 is recording
*/
    public var activitySession;
    public var activity_profile;
    public var sub_activity_profile;

    // Serve Tracking

    public var serve_tracking = true;
    public var serve_switch_toggle = 0;

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

        if (Application.Storage.getValue("flip_score_buttons") == null) {
            Application.Storage.setValue("flip_score_buttons", false);
        } else {
            flip_score_buttons = Application.Storage.getValue("flip_score_buttons");
        }

        // Active Sport

        if (Application.Storage.getValue("active_sport") != null) {
            active_sport = Application.Storage.getValue("active_sport");
        } else {
            Application.Storage.setValue("active_sport", "Score Keeper");
            active_sport = Application.Storage.getValue("active_sport");
        }
        // Layout Mode

        if (Application.Storage.getValue("scoring_mode") == null) {
            Application.Storage.setValue("scoring_mode", 0);
        }
        scoring_mode = Application.Storage.getValue("scoring_mode");

        // Home and Guest Names

        if (Application.Storage.getValue("home_name") != null) {
            home_name = Application.Storage.getValue("home_name");
        } else {
            home_name = "HOME";
            Application.Storage.setValue("home_name", "HOME");
        }

        if (Application.Storage.getValue("guest_name") != null) {
            guest_name = Application.Storage.getValue("guest_name");
        } else {
            guest_name = "GUEST";
            Application.Storage.setValue("guest_name", "GUEST");
        }

        // 12/24 Hour

        if (Application.Storage.getValue("is24Hour") == null) {
            Application.Storage.setValue("is24Hour", false);
        }

        // Home and Guest Scores

        if (Application.Storage.getValue("home_score") != null and Application.Storage.getValue("guest_score") !=
            null) {
            home_score = Application.Storage.getValue("home_score");
            guest_score = Application.Storage.getValue("guest_score");
        } else {
            home_score = 0;
            guest_score = 0;
        }

        // group sport memory allocation
        if (Application.Storage.getValue("player_names") != null) {
            player_names = Application.Storage.getValue("player_names") as Lang.Array;
        } else {
            player_names = [
                "Player 1", "Player 2", "Player 3", "Player 4", "Player 5", "Player 6", "Player 7", "Player 8",
                "Player 9", "Player 10"
            ] as Lang.Array;
        }

        if (Application.Storage.getValue("player_scores") != null) {
            player_scores = Application.Storage.getValue("player_scores") as Lang.Array;
        } else {
            player_scores = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0] as Lang.Array;
        }

        if (Application.Storage.getValue("active_group_player") != null) {
            active_group_player = Application.Storage.getValue("active_group_player");
        } else {
            active_group_player = 0;
        }

        if (Application.Storage.getValue("previous_player") != null) {
            previous_player = Application.Storage.getValue("previous_player");
        } else {
            previous_player = 9;
        }

        if (Application.Storage.getValue("next_player") != null) {
            next_player = Application.Storage.getValue("next_player");
        } else {
            next_player = 1;
        }

        if (Application.Storage.getValue("amount_of_players") != null) {
            amount_of_players = Application.Storage.getValue("amount_of_players");
        } else {
            amount_of_players = 10;
        }

        // ensure group sport indexes are correctly set by calling update with 0 as argument
        changePlayerIndex(0);
        // Constants

        JCENTER = Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;
        JLEFT = Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER;

        SCREEN_WIDTH = dc.getWidth();
        SCREEN_HEIGHT = dc.getHeight();

        if (System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_SEMI_OCTAGON) {
            instinct = true;
            SUB_SCREEN_X = WatchUi.getSubscreen().x + WatchUi.getSubscreen().width / 2;
            SUB_SCREEN_Y = WatchUi.getSubscreen().y + WatchUi.getSubscreen().height / 2;
            SUB_SCREEN_R = WatchUi.getSubscreen().width / 2;
        }

        // Set labels from xml

        home_score_label = View.findDrawableById("HomeScore") as WatchUi.Text;
        home_label = View.findDrawableById("HomeLabel") as WatchUi.Text;
        guest_score_label = View.findDrawableById("GuestScore") as WatchUi.Text;
        guest_label = View.findDrawableById("GuestLabel") as WatchUi.Text;
        time_label = View.findDrawableById("TimeLabel") as WatchUi.Text;
        sport_label = View.findDrawableById("SportLabel") as WatchUi.Text;
        active_sport = Application.Storage.getValue("active_sport");
        // SETTINGS
    }

    function onUpdate(dc as Dc) as Void {
        time = System.getClockTime();
        // System.print(active_sport);

        // Update the labels
        if (sport_label == "Table Tennis") {
            if (((home_score + guest_score + serve_switch_toggle) / 2) % 2 == 0) {
                home_label.setColor(Graphics.COLOR_BLACK);
                home_label.setBackgroundColor(Graphics.COLOR_WHITE);
                guest_label.setColor(Graphics.COLOR_WHITE);
                guest_label.setBackgroundColor(Graphics.COLOR_BLACK);
            } else {
                home_label.setColor(Graphics.COLOR_WHITE);
                home_label.setBackgroundColor(Graphics.COLOR_BLACK);
                guest_label.setColor(Graphics.COLOR_BLACK);
                guest_label.setBackgroundColor(Graphics.COLOR_WHITE);
            }
        } else {
            home_label.setColor(Graphics.COLOR_WHITE);
            home_label.setBackgroundColor(Graphics.COLOR_BLACK);
            guest_label.setColor(Graphics.COLOR_WHITE);
            guest_label.setBackgroundColor(Graphics.COLOR_BLACK);
        }

        if (scoring_mode == 2) {
            home_score_label.setText("");
            home_label.setText("");

            guest_score_label.setText("");
            guest_label.setText("");
        } else if (scoring_mode == 1) {

            // 1. Clamp values for logic stability


            if (home_score < 0) {
                home_score = 0;
            }
            if (guest_score < 0) {
                guest_score = 0;
            }

            // Cap at 4 (Advantage state). Anything higher should have triggered a Game Win.
            if (home_score > 4) {
                home_score = 4;
            }
            if (guest_score > 4) {
                guest_score = 4;
            }

            // 2. Deuce and Advantage Logic
            if (home_score >= 3 && guest_score >= 3) {
                if (home_score == guest_score) {
                    // Both at 3 or both at 4 (after back-to-back AD)
                    home_score = 3;
                    guest_score = 3;
                    home_score_label.setText("40");
                    guest_score_label.setText("40");
                } else if (home_score > guest_score) {
                    home_score_label.setText("AD");
                    guest_score_label.setText("40");
                } else {
                    home_score_label.setText("40");
                    guest_score_label.setText("AD");
                }
            } else {
                // Standard Scoring
                var strings = ["0", "15", "30", "40", "AD", "GAME"];
                home_score_label.setText(strings[home_score]);
                guest_score_label.setText(strings[guest_score]);
            }

            home_label.setText(home_name);
            guest_label.setText(guest_name);
        } else {
            home_score_label.setText(home_score.format("%02d"));
            home_label.setText(home_name);
            guest_score_label.setText(guest_score.format("%02d"));
            guest_label.setText(guest_name);
        }

        if (Application.Storage.getValue("is24Hour") == true) {
            time_string = Lang.format("$1$:$2$", [
                time.hour.format("%02d"),
                time.min.format("%02d"),
            ]);
        } else {
            var hour = time.hour % 12;
            if (hour == 0) {
                hour = 12;
            }
            time_string = Lang.format("$1$:$2$", [
                hour.format("%d"),
                time.min.format("%02d"),
            ]);
        }
        time_label.setText(time_string);

        // Dc Element Drawing

        View.onUpdate(dc); // dc elements are drawn after labels from xml
        // Circle Outline to determine recording mode 
        if (recordingState == 2 and !instinct){
        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(SCREEN_WIDTH/25);
        dc.drawCircle(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, SCREEN_WIDTH / 2);
        } else if (recordingState == 1 and !instinct){
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(SCREEN_WIDTH/25);
        dc.drawCircle(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, SCREEN_WIDTH / 2);
        }

        if (scoring_mode != 2) {
            // Default layout, not group mode

            score_line_offset = SCREEN_HEIGHT / 6;
            vertical_offset = 0;

            if (instinct) {
                sport_label.setText(formatSportName(active_sport));
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                dc.setPenWidth(3);
                dc.drawLine(0, SCREEN_HEIGHT * 0.58, SCREEN_WIDTH, SCREEN_HEIGHT * 0.58);
                dc.drawLine(0, SCREEN_HEIGHT * 0.84, SCREEN_WIDTH, SCREEN_HEIGHT * 0.84);
                dc.drawLine(SCREEN_WIDTH / 2, SCREEN_HEIGHT * 0.63, SCREEN_WIDTH / 2, SCREEN_HEIGHT * 0.79);
                dc.fillCircle(SUB_SCREEN_X, SUB_SCREEN_Y, SUB_SCREEN_R);
                dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
                dc.drawText(SUB_SCREEN_X, SUB_SCREEN_Y, Graphics.FONT_MEDIUM, time_string, JCENTER);
                // Show timer while recording
                if (isRecording == true) {

                    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                    dc.drawText(SCREEN_WIDTH / 2, SCREEN_HEIGHT * 0.9, Graphics.FONT_TINY,
                                formatIntegerTime(Activity.getActivityInfo().timerTime / 1000), JCENTER);
                }
            } else {
                sport_label.setText(active_sport);

                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

                dc.setPenWidth(5);

                dc.drawLine(0, SCREEN_HEIGHT / 2 - score_line_offset + vertical_offset, SCREEN_WIDTH,
                            SCREEN_HEIGHT / 2 - score_line_offset + vertical_offset);

                dc.drawLine(0, SCREEN_HEIGHT / 2 + score_line_offset + vertical_offset, SCREEN_WIDTH,
                            SCREEN_HEIGHT / 2 + score_line_offset + vertical_offset);

                dc.drawLine(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 - score_line_offset * 0.75 + vertical_offset,
                            SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 + score_line_offset * 0.75 + vertical_offset);
                // Show timer while recording
                if (isRecording == true) {

                    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                    dc.drawText(SCREEN_WIDTH / 2, SCREEN_HEIGHT * 0.7, Graphics.FONT_TINY,
                                formatIntegerTime(Activity.getActivityInfo().timerTime / 1000), JCENTER);
                }


            }
            // Tennis Mode Games
            if (scoring_mode == 1 and!instinct) {
            }

            // GROUP MODE
            // //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        } else {

            if (instinct) {
                vertical_offset = -SCREEN_HEIGHT / 10;
                sport_label.setText(formatSportName(active_sport));
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

                dc.drawText(SCREEN_WIDTH * 0.3, SCREEN_HEIGHT / 2 - vertical_offset, Graphics.FONT_MEDIUM,
                            player_names[active_group_player], JCENTER);
                dc.drawText(SCREEN_WIDTH * 0.8, SCREEN_HEIGHT / 2 - vertical_offset, Graphics.FONT_MEDIUM,
                            player_scores[active_group_player].toString(), JCENTER);

                dc.drawText(SCREEN_WIDTH * 0.3, SCREEN_HEIGHT / 2 + vertical_offset, Graphics.FONT_XTINY,
                            Lang.format("$1$ / $2$", [(active_group_player + 1), (amount_of_players)]), JCENTER);

                dc.setPenWidth(3);
                dc.drawLine(0, SCREEN_HEIGHT * 0.58 + vertical_offset, SCREEN_WIDTH,
                            SCREEN_HEIGHT * 0.58 + vertical_offset);
                dc.drawLine(0, SCREEN_HEIGHT * 0.84 + vertical_offset, SCREEN_WIDTH,
                            SCREEN_HEIGHT * 0.84 + vertical_offset);
                dc.drawLine(SCREEN_WIDTH * 0.6, SCREEN_HEIGHT * 0.58 + vertical_offset, SCREEN_WIDTH * 0.6,
                            SCREEN_HEIGHT * 0.84 + vertical_offset);

                // dc.drawLine(SCREEN_WIDTH/2, SCREEN_HEIGHT*.63 + vertical_offset, SCREEN_WIDTH/2, SCREEN_HEIGHT*.79 +
                // vertical_offset);
                dc.fillCircle(SUB_SCREEN_X, SUB_SCREEN_Y, SUB_SCREEN_R);
                dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
                dc.drawText(SUB_SCREEN_X, SUB_SCREEN_Y, Graphics.FONT_MEDIUM, time_string, JCENTER);
                // Draw Timer on Screen if activity is recording
                if (isRecording == true) {
                    System.print("Showing Timer");
                    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                    dc.drawText(SCREEN_WIDTH / 2, SCREEN_HEIGHT * 0.9, Graphics.FONT_TINY,
                                formatIntegerTime(Activity.getActivityInfo().timerTime / 1000), JCENTER);
                }

                // Non Instinct Group Mode
            } else {
                score_line_offset = SCREEN_HEIGHT / 10;
                vertical_offset = 0;
                // var separation_offset = SCREEN_HEIGHT/6;
                sport_label.setText(active_sport);

                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                dc.drawText(SCREEN_WIDTH * 0.3, SCREEN_HEIGHT / 2 - vertical_offset, Graphics.FONT_LARGE,
                            player_names[active_group_player], JCENTER);
                dc.drawText(SCREEN_WIDTH * 0.8, SCREEN_HEIGHT / 2 - vertical_offset, Graphics.FONT_LARGE,
                            player_scores[active_group_player].toString(), JCENTER);

                dc.drawText(SCREEN_WIDTH * 0.3, SCREEN_HEIGHT * 0.3 - vertical_offset, Graphics.FONT_XTINY,
                            Lang.format("$1$ / $2$", [(active_group_player + 1), (amount_of_players)]), JCENTER);

                dc.setPenWidth(5);
                dc.drawLine(0, SCREEN_HEIGHT / 2 - score_line_offset + vertical_offset, SCREEN_WIDTH,
                            SCREEN_HEIGHT / 2 - score_line_offset + vertical_offset);
                dc.drawLine(0, SCREEN_HEIGHT / 2 + score_line_offset + vertical_offset, SCREEN_WIDTH,
                            SCREEN_HEIGHT / 2 + score_line_offset + vertical_offset);
                // Show timer while recording
                if (isRecording == true) {

                    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                    dc.drawText(SCREEN_WIDTH / 2, SCREEN_HEIGHT * 0.7, Graphics.FONT_TINY,
                                formatIntegerTime(Activity.getActivityInfo().timerTime / 1000), JCENTER);
                }
                // dc.drawLine(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - score_line_offset*0.75 + vertical_offset,
                // SCREEN_WIDTH/2, SCREEN_HEIGHT/2 + score_line_offset*0.75 + vertical_offset);
            }
        }
    }

    function onTimer() as Void { WatchUi.requestUpdate(); }

    // Input handled functions, called from Delegate

    function updateHome(value) {
        home_score += value;
        WatchUi.requestUpdate();
        return true;
    }

    function updateGuest(value) {
        guest_score += value;
        WatchUi.requestUpdate();
        return true;
    }

    function resetScores() {
        home_score = 0;
        guest_score = 0;
        player_scores = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        Application.Storage.setValue("home_score", 0);
        Application.Storage.setValue("guest_score", 0);
        Application.Storage.setValue("player_scores", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
    }

    function setHomeName(text) {
        home_name = text;
        Application.Storage.setValue("home_name", text);
        WatchUi.requestUpdate();
        System.print(home_name);
    }

    function setGuestName(text) {
        guest_name = text;
        Application.Storage.setValue("guest_name", text);
        WatchUi.requestUpdate();
        System.print(guest_name);
    }
    function resetNames() {
        home_name = "HOME";
        guest_name = "GUEST";
        Application.Storage.setValue("home_name", "HOME");
        Application.Storage.setValue("guest_name", "GUEST");
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    function changePlayerIndex(amount) {

        active_group_player += amount;
        previous_player = active_group_player - 1;
        next_player = active_group_player + 1;

        if (active_group_player == 0) {
            previous_player = amount_of_players - 1;
            next_player = 1;
        } else if (active_group_player == amount_of_players - 1) {
            previous_player = amount_of_players - 2;
            next_player = 0;
        } else if (active_group_player < 0) {
            active_group_player = amount_of_players - 1;
            previous_player = amount_of_players - 2;
            next_player = 0;
        } else if (active_group_player >= amount_of_players) {
            active_group_player = 0;
            previous_player = amount_of_players - 1;
            next_player = 1;
        }

        WatchUi.requestUpdate();
    }
    function updatePlayerScore(value) {
        player_scores[active_group_player] += value;
        WatchUi.requestUpdate();
    }

    function changeAmountOfPlayers(value) { // use a menu to ensure it won't be more than 10
    }
    /*
function setCustomSportName(text){
}
*/
    function startSound() {
        if (Attention has :vibrate) {

            var vibeProfile = [new Attention.VibeProfile(100, 1000)];
            Attention.vibrate(vibeProfile);
        }
        if (Attention has :playTone) {
            // Standard system start tone
            Attention.playTone(Attention.TONE_START);
        }
    }

    function stopSound() {
        if (Attention has :vibrate) {

            var vibeProfile = [new Attention.VibeProfile(100, 1000)];
            Attention.vibrate(vibeProfile);
        }
        if (Attention has :playTone) {
            // Standard system stop tone
            Attention.playTone(Attention.TONE_STOP);
        }
    }

    function startRecording() {
        activity_profile = Activity.SPORT_GENERIC;
        sub_activity_profile = Activity.SUB_SPORT_GENERIC;

        switch (active_sport) {
            // Team Sports
            case "American Football":
                activity_profile = Activity.SPORT_AMERICAN_FOOTBALL;
                break;
            case "Baseball":
                activity_profile = Activity.SPORT_BASEBALL;
                break;
            case "Basketball":
                activity_profile = Activity.SPORT_BASKETBALL;
                break;
            case "Cricket":
                activity_profile = Activity.SPORT_CRICKET;
                break;
            case "Field Hockey":
                activity_profile = Activity.SPORT_HOCKEY;
                break;
            case "Gaming":
                activity_profile = Activity.SPORT_VIDEO_GAMING;

                break;
            case "Ice Hockey":
                activity_profile = Activity.SPORT_HOCKEY;
                break;
            case "Lacrosse":
                activity_profile = Activity.SPORT_LACROSSE;
                break;
            case "Rugby":
                activity_profile = Activity.SPORT_RUGBY;
                break;
            case "Soccer":
                activity_profile = Activity.SPORT_SOCCER;
                break;
            case "Softball":
                activity_profile = Activity.SPORT_SOFTBALL_FAST_PITCH;
                break;
            case "Ultimate Disc":
                // activity_profile = Activity.SPORT_TEAM_SPORT;
                // sub_activity_profile = Activity.SUB_SPORT_ULTIMATE;

                // Had to reverse-engineer the FIT file from the watch to make sure that it was the correct sport
                // profile
                activity_profile = 69;
                sub_activity_profile = 92;
                break;

            case "Volleyball":
                activity_profile = Activity.SPORT_VOLLEYBALL;
                break;

            // Racket Sports
            case "Badminton":
                activity_profile = Activity.SPORT_RACKET;
                sub_activity_profile = Activity.SUB_SPORT_BADMINTON;
                break;
            case "Padel":
                activity_profile = Activity.SPORT_RACKET;
                sub_activity_profile = Activity.SUB_SPORT_PADEL;
                break;
            case "Pickleball":
                activity_profile = Activity.SPORT_RACKET;
                sub_activity_profile = Activity.SUB_SPORT_PICKLEBALL;
                break;
            case "Platform Tennis":
                activity_profile = Activity.SPORT_RACKET;
                sub_activity_profile = Activity.SUB_SPORT_PLATFORM;
                break;
            case "Racquetball":
                activity_profile = Activity.SPORT_RACKET;
                sub_activity_profile = Activity.SUB_SPORT_RACQUETBALL;
                break;
            case "Squash":
                activity_profile = Activity.SPORT_RACKET;
                sub_activity_profile = Activity.SUB_SPORT_SQUASH;
                break;
            case "Table Tennis":
                activity_profile = Activity.SPORT_RACKET;
                sub_activity_profile = Activity.SUB_SPORT_TABLE_TENNIS;
                break;
            case "Tennis":
                activity_profile = Activity.SPORT_TENNIS;
                break;

            // Group / Other Sports
            case "Golf":
                activity_profile = Activity.SPORT_GOLF;
                break;
            case "Mini Golf":
                activity_profile = Activity.SPORT_GOLF;
                break;
            case "Disc Golf":
                activity_profile = Activity.SPORT_DISC_GOLF;
                break;

            default:
                activity_profile = Activity.SPORT_GENERIC;
                sub_activity_profile = Activity.SUB_SPORT_GENERIC;
                break;
        }

        if (Toybox has :ActivityRecording) {
            startSound();
            if (activitySession == null) {
                activitySession = ActivityRecording.createSession({ :name => "ScoreTrak",
                    :sport => activity_profile,
                    :subSport => sub_activity_profile,
                });
                System.print(Lang.format("$1$ $2$", [
                    activity_profile,
                    sub_activity_profile,
                ]));
                activitySession.start();
                isRecording = true;
                recordingState = 2;
            }
        }
    }

    function pauseActivity() {
        stopSound();
        activitySession.stop();
        isRecording = true;
        recordingState = 1;
    }
    function resumeActivity() {
        startSound();
        activitySession.start();
        isRecording = true;
        recordingState = 2;
    }

    function saveChoice(shouldSave) {
        if (shouldSave) {
            if (activitySession != null) {
                stopSound();
                activitySession.stop();
            }
            activitySession.save();
        } else {
            if (activitySession != null) {
                stopSound();
                activitySession.stop();
            }
            activitySession.discard();
        }

        activitySession = null;
        isRecording = false;
        recordingState = 0;
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
        // WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

    // End main view class //////////////////////////////////////////////////////////////////////////////////////
}

class LeaderboardView extends WatchUi.View {
    var _view;

    function initialize(view) {
        View.initialize();
        _view = view; // Reference to access player_scores
    }

    function onUpdate(dc) {
        // Drawing logic for scores
        dc.setColor(Graphics.COLOR_BLACK,Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(0,0,dc.getWidth(),dc.getHeight());
        dc.setColor(Graphics.COLOR_WHITE,Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            (dc.getWidth()/2),
            (dc.getHeight()*0.125),
            Graphics.FONT_SMALL,
            "Leaderboard",
            Graphics.TEXT_JUSTIFY_CENTER
            );
    }
}