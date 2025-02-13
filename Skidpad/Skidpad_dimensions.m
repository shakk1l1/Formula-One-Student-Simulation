% File containing the geoemtrical data of the skidpad:

skidpad = struct;
skidpad.dimensions.ditance_c = 18.25;
skidpad.dimensions.diam_in = 15.25;
skidpad.dimensions.diam_ext = 21.25;
skidpad.dimensions.width = 3;
skidpad.dimensions.unit = 'm';

theta = linspace(0,2*pi, 100);

skidpad.upper_internal.x = skidpad.dimensions.diam_in/2*cos(theta);
skidpad.upper_internal.y = 18.25/2 + skidpad.dimensions.diam_in/2*sin(theta);

skidpad.lower_internal.x = skidpad.dimensions.diam_in/2 * cos(theta);
skidpad.lower_internal.y = -18.25/2 + skidpad.dimensions.diam_in/2*sin(theta);

plot(skidpad.lower_internal.x, skidpad.lower_internal.y, skidpad.upper_internal.x, skidpad.upper_internal.y)