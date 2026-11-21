# HomeConMenu ColorWheelPanelView

Source: https://github.com/sonsongithub/ColorWheelPanelView
Revision: 9df7cbc040c17141da6261f377a31cc3b400d174
License: MIT; original notices are retained in source files.

BrightnessSliderCell retains its custom white fill and light-gray outline.
The thumb is centered on the gradient vertically and on AppKit's knob position
horizontally. Its height is 60% of the control height, with a 2:3 aspect ratio
(8 x 12 points in the existing 20-point slider). It scales down proportionally
if the system knob rectangle is smaller, allowing for the outline.
This replaces fixed subtractions of 14 points in width and 8 points in height,
which distorted the thumb and shifted its vertical center as system metrics changed.
The gradient background and slider value/tracking behavior are unchanged.
This affects both GraySliderPanelView and ColorWheelPanelView.

Validate the thumb at minimum, middle and maximum values, while dragging, and
in light/dark appearances after updates.
