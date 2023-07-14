import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Time.Gregorian;

class OWatchView extends WatchUi.WatchFace {

    var lastDateString = null;
    var lastTimeBatteryChecked = 0;
    const twoHoursInSeconds = 60 * 60 * 2;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        var dateView = View.findDrawableById("DateLabel") as Text;
        var timeView = View.findDrawableById("TimeLabel") as Text;
        var batteryView = View.findDrawableById("BatteryLabel") as Text;

        var now = Time.now();
        var dateTime = Gregorian.info(now, Time.FORMAT_SHORT);

        // Update date only if it hasn't been set or only on midnight
        if(lastDateString == null || (dateTime.hour == 0 && dateTime.min == 0)){
            // System.println("Updating date because it was either never set or it's midnight...");
            lastDateString = Lang.format(
                "$1$/$2$",
                [
                    dateTime.month.format("%02d"),
                    dateTime.day.format("%02d")
                ]
            );
            dateView.setText(lastDateString);
        }

        // Update time every minute as onUpdate runs.
        var timeString = Lang.format("$1$:$2$", [dateTime.hour, dateTime.min.format("%02d")]);
        timeView.setText(timeString);


        // Update battery every two hours.
        if((now.value() - lastTimeBatteryChecked) > twoHoursInSeconds){
            // System.println("Updating battery becuase it was either never set or two hours has passed...");
            var sysStats = System.getSystemStats();
            batteryView.setText(Lang.format( "$1$%", [sysStats.battery.format( "%2d" )]));
            lastTimeBatteryChecked = now.value();
        }

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
