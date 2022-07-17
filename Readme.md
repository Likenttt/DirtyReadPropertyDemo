# A demo for a garmin bug suspect

## How do we reproduce this bug suspect?

I have two property style and lastStyle.

My code will check the value for **style** comparing to **lastStyle** [1].

If not equal, the style will take effect and update lastStyle to the value same with style[2].

Otherwise, do nothing.

code:

```js
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
```

## Key issue?

If I start my project and make some property changes.

```
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
Look! lastStyle after set:1
```
