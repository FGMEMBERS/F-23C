# Canvas backward support for using 3.0 API with FlightGear 2.8

(func {

# 2.8 uses multiple properties for representing a color. Also different names
# are used for the colors and no CSS syntax like #rrggbb are supported.
var color_components = ["red", "green", "blue", "alpha"];
var setColorNodes = func(obj, name, color)
{
  if( size(color) == 1 )
    color = color[0];

  if( typeof(color) != "vector" )
    debug.warn("Wrong type for color");
  else if( size(color) < 3 or size(color) > 4 )
    debug.warn("Color needs 3 or 4 values (RGB or RGBA)");
  else
  {
    var node = obj._node.getNode(name, 1);
    for(var i = 0; i < size(color_components); i += 1)
      node.getNode(color_components[i], 1)
          .setDoubleValue( i < size(color) ? color[i]
                                           : 1 ); # default alpha is 1
  }
  
  return obj;
};

Element.setColor = func setColorNodes(me, "color", arg);
Element.setColorFill = func {
  setColorNodes(me, "color-fill", arg);
  me.setBool("fill", 1);
};
Path.setColor = Element.setColor;
Path.setColorFill = Element.setColorFill;
Text.setColor = Element.setColor;
Text.setColorFill = Element.setColorFill;

# 2.8 uses multiple properties instead of a single string property
Canvas.setStrokeDashArray = func(pattern)
{
  me._node.removeChildren('stroke-dasharray');

  if( typeof(pattern) == 'vector' )
    me._node.setValues({'stroke-dasharray': pattern});
  else
    debug.warn("setStrokeDashArray: vector expected!");

  return me;
};

print("Canvas API: FlightGear 2.8 backward support loaded.");

})();
