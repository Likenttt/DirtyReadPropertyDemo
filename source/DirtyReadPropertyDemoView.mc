import Toybox.Application;
import Toybox.Application.Properties;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class DirtyReadPropertyDemoView extends WatchUi.WatchFace {
  hidden var hourColor = 0xffffff;
  function initialize() {
    WatchFace.initialize();
    onSettingsChanged();
  }
  function getHourColor(style) {
    return style == 1 ? 0xffff00 : 0x00ffff;
  }

  /*   

    ---------------------onSettingsChanged-------------------------- The initial state
    Look style is:0
    Look the last style is:0
    ---------------------onSettingsChanged-------------------------- Change the style in app settings through simulator
    Look style is:1
    Look the last style is:0
    Look! lastStyle after set:1
    ---------------------onSettingsChanged--------------------------
    Look style is:1
    Look the last style is:0                                         In the last procedure, it should be 1 rather than 0. Just like a dirty read in a database
    Look! lastStyle after set:1 */
  function onSettingsChanged() {
    System.println(
      "---------------------onSettingsChanged--------------------------"
    );
    var style = Properties.getValue("style");
    var lastStyle = Properties.getValue("lastStyle");
    System.println("Look style is:" + style);
    System.println("Look the last style is:" + lastStyle);
    //Compare current style with the last to make sure the style change
    if (style != lastStyle) {
      hourColor = getHourColor(style);
      Properties.setValue("lastStyle", style);
      System.println(
        "Look! lastStyle after set:" + Properties.getValue("lastStyle")
      );
    }
  }

  // Load your resources here
  function onLayout(dc as Dc) as Void {
    setLayout(Rez.Layouts.WatchFace(dc));
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() as Void {}

  // Update the view
  function onUpdate(dc as Dc) as Void {
    // Get the current time and format it correctly
    var timeFormat = "$1$:$2$";
    var clockTime = System.getClockTime();
    var hours = clockTime.hour;
    hours = hours.format("%02d");
    var timeString = Lang.format(timeFormat, [
      hours,
      clockTime.min.format("%02d"),
    ]);

    // Update the view
    var view = View.findDrawableById("TimeLabel") as Text;
    view.setColor(hourColor);
    view.setText(timeString);

    // Call the parent onUpdate function to redraw the layout
    View.onUpdate(dc);
  }

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  function onHide() as Void {}

  // The user has just looked at their watch. Timers and animations may be started here.
  function onExitSleep() as Void {}

  // Terminate any active timers and prepare for slow updates.
  function onEnterSleep() as Void {}
}
