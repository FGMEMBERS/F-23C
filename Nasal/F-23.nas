# PHD's TC range switch (hard coded range in nautical miles)
# ----------------------------------------------------------
var PHD_TCrange_sw = func {
	var prop = props.globals.getNode(arg[0], 1);
	var pr = prop.getValue();
	var target = props.globals.getNode("/sim/model/F-23C/instrumentation/PHD/TCrange", 1);
	if (arg[1] == 1) {
		if (pr == 0) {
			prop.setDoubleValue(1);
			target.setDoubleValue(5);
		} elsif (pr == 1) {
			prop.setDoubleValue(2);
			target.setDoubleValue(1.5);
		}
	} else {
		if (pr == 1) {
			prop.setDoubleValue(0);
			target.setDoubleValue(10);
		} elsif (pr == 2) {
			prop.setDoubleValue(1);
			target.setDoubleValue(5);
		}
	}
}



##### Terrain Follow Switch and Prty toggle switch
#
var ter_follow = func(number){

var terflw = getprop("controls/switches/terrain-follow");
var terflwmap = getprop("controls/switches/terrain-follow-map");

if(terflw == 1) {
	if(terflwmap == 0) {
	setprop("autopilot/locks/altitude", "agl-hold");
        setprop("controls/switches/terrain-follow-map-enabled", 0);#triggers the submodels radarpulse off

} elsif (terflwmap == 1) {
	setprop("autopilot/locks/altitude", "vertical-speed-hold");
        setprop("controls/switches/terrain-follow-map-enabled", 1);#triggers the submodels radarpulse on
}
} elsif(terflw == 0) {
	setprop("autopilot/locks/altitude", "");
        setprop("controls/switches/terrain-follow-map-enabled", 0);
}
} # End Function

#
##### Terrain Avoid Switch
#
var ter_avoid_switch = func {
var   tas = getprop("controls/switches/terrain-avoid");
var   rs = getprop("controls/switches/terrain-avoid-rng");

if (tas == 1) {
    if (rs == 0) {
    setprop("controls/switches/terrain-avoid-rng-25", 1);
    setprop("controls/switches/terrain-avoid-rng-50", 0);
  } elsif (rs == 1) {
    setprop("controls/switches/terrain-avoid-rng-25", 0);
    setprop("controls/switches/terrain-avoid-rng-50", 1);
     }
} else {
   setprop("controls/switches/terrain-avoid-rng-25", 0);
   setprop("controls/switches/terrain-avoid-rng-50", 0);
}
}
#
##### Terrain Avoid Toggle Radar Dist Switch
#
var radar_switch = func {
var rs = getprop("controls/switches/terrain-avoid-rng");
var tas = getprop("controls/switches/terrain-avoid");
   if(tas == 1) {
   if(rs == 0) {
   setprop("controls/switches/terrain-avoid-rng-25", 1);
   setprop("controls/switches/terrain-avoid-rng-50", 0);
} elsif (rs == 1) {
   setprop("controls/switches/terrain-avoid-rng-50", 1);
   setprop("controls/switches/terrain-avoid-rng-25", 0);
}
}
}

#
##### Terrain Avoid Toggle Radar Clearance
#
var radar_clrpln = func {

var rcs = getprop("controls/switches/terrain-avoid-clrpln");

if(rcs == 0) {
setprop("controls/switches/terrain-avoid-clr1000", 0);
}
if(rcs == 0.25) {
setprop("controls/switches/terrain-avoid-clr1000", 100);
}
if(rcs == 0.5) {
setprop("controls/switches/terrain-avoid-clr1000", 300);
}
if(rcs == 0.75) {
setprop("controls/switches/terrain-avoid-clr1000", 500);
}
if(rcs == 1.0) {
setprop("controls/switches/terrain-avoid-clr1000", 1000);
}

}

#
##### Terrain Follow Radar Clearance
#
var radar_setclr = func(number) {

var sclr = getprop("controls/switches/terrain-follow-setclr");
var oldclr = getprop("controls/switches/terrain-follow-clr");
if((number == 1) and (oldclr < 2000)) {
var newclr = (oldclr + 200);
setprop("controls/switches/terrain-follow-clr", newclr);
setprop("autopilot/settings/target-agl-ft", newclr);
} elsif((number == 0) and (oldclr > 0)) {
var newclr = (oldclr - 200);
setprop("controls/switches/terrain-follow-clr", newclr);
setprop("autopilot/settings/target-agl-ft", newclr);
}
}
#

##### Terrain Avoidance Radar Pulse (inspired from vulcanb2)
#

settimer(func {

  # Add listener for radar pulse contactm0d
  setlistener("sim/radar/teravd/contactm0d", func(n) {
    var contactm0d = n.getValue();
#    var solid = getprop(contactm0d ~ "/material/solid");
    
#    if (solid)
#    {
      var long = getprop(contactm0d ~ "/impact/longitude-deg");
      var lat = getprop(contactm0d ~ "/impact/latitude-deg");
      var elev_m = getprop(contactm0d ~ "/impact/elevation-m");
      var spd = getprop(contactm0d ~ "/impact/speed-mps");
      var time = getprop(contactm0d ~ "/sim/time/elapsed-sec");
      var elev_ft = int(elev_m * 3.28);
      var dist_ft = int(spd * time * 3.28);
      setprop("instrumentation/teravd/elevationm0d", elev_ft);
      setprop("instrumentation/teravd/distancem0d", dist_ft);

    settimer(teravd_m0d, 0);

#    }
  });
}, 0);

settimer(func {

  # Add listener for radar pulse contactm4d
  setlistener("sim/radar/teravd/contactm4d", func(n) {
    var contactm4d = n.getValue();
#    var solid = getprop(contactm4d ~ "/material/solid");
    
#    if (solid)
#    {
      var long = getprop(contactm4d ~ "/impact/longitude-deg");
      var lat = getprop(contactm4d ~ "/impact/latitude-deg");
      var elev_m = getprop(contactm4d ~ "/impact/elevation-m");
      var spd = getprop(contactm4d ~ "/impact/speed-mps");
      var time = getprop(contactm4d ~ "/sim/time/elapsed-sec");
      var elev_ft = int(elev_m * 3.28);
      var dist_ft = int(spd * time * 3.28);
      setprop("instrumentation/teravd/elevationm4d", elev_ft);
      setprop("instrumentation/teravd/distancem4d", dist_ft);

     settimer(teravd_m4d, 0);

#    }
  });
}, 0);

settimer(func {

  # Add listener for radar pulse contactm20d
  setlistener("sim/radar/teravd/contactm20d", func(n) {
    var contactm20d = n.getValue();
#    var solid = getprop(contactm20d ~ "/material/solid");
    
#    if (solid)
#    {
      var long = getprop(contactm20d ~ "/impact/longitude-deg");
      var lat = getprop(contactm20d ~ "/impact/latitude-deg");
      var elev_m = getprop(contactm20d ~ "/impact/elevation-m");
      var spd = getprop(contactm20d ~ "/impact/speed-mps");
      var time = getprop(contactm20d ~ "/sim/time/elapsed-sec");
      var elev_ft = int(elev_m * 3.28);
      var dist_ft = int(spd * time * 3.28);
      setprop("instrumentation/teravd/elevationm20d", elev_ft);
      setprop("instrumentation/teravd/distancem20d", dist_ft);

     settimer(teravd_m20d, 0);

#    }
  });
}, 0);


# control alt while climb and trigger end of climb

var teravd_m0d = func {
var calt = getprop("position/altitude-ft");
var cspd = getprop("velocities/groundspeed-kt");
var talt = getprop("autopilot/settings/target-altitude-ft");
var tvfpm = getprop("autopilot/settings/vertical-speed-fpm");
var rdist25 = getprop("controls/switches/terrain-avoid-rng-25");
var rdist50  = getprop("controls/switches/terrain-avoid-rng-50");

var elem0d = getprop("instrumentation/teravd/elevationm0d");
var distm0d = getprop("instrumentation/teravd/distancem0d");
var clr = getprop("controls/switches/terrain-avoid-clr1000");

if (rdist25 = 1) {
  var rdist = 15000;
  } elsif (rdist50 = 1) {
  var rdist = 30000;
}
var daltm0d = ((elem0d + clr) - calt);

if ((distm0d < rdist) and (daltm0d > 0)) {
  var talt = calt + daltm0d;
  var itime = distm0d / (cspd * 1.6878);
  var tvfpm = int((daltm0d) / (itime / 2)) * 60;
  setprop("instrumentation/teravd/target-vfpm", tvfpm);
  setprop("instrumentation/teravd/target-alt", talt);
  setprop("controls/switches/terra-report", 1);
  settimer(setvfpm, 0);
}
}


var teravd_m4d = func {
#var cpitch = getprop("orientation/pitch-deg");
var calt = getprop("position/altitude-ft");
var cspd = getprop("velocities/groundspeed-kt");
var talt = getprop("autopilot/settings/target-altitude-ft");
var tvfpm = getprop("autopilot/settings/vertical-speed-fpm");
var rdist25 = getprop("controls/switches/terrain-avoid-rng-25");
var rdist50  = getprop("controls/switches/terrain-avoid-rng-50");

var elem4d = getprop("instrumentation/teravd/elevationm4d");
var distm4d = getprop("instrumentation/teravd/distancem4d");
var clr = getprop("controls/switches/terrain-avoid-clr1000");

var evfpm = getprop("instrumentation/teravd/target-vfpm");
var etalt = getprop("instrumentation/teravd/target-alt");

if (rdist25 = 1) {
  var rdist = 15000;
  } elsif (rdist50 = 1) {
  var rdist = 30000;
}

var daltm4d = ((elem4d + clr) - calt);

if ((distm4d < rdist) and (daltm4d > 0)) {
var talt = calt + daltm4d;
var itime = distm4d / (cspd * 1.6878);
var tvfpm = int((daltm4d) / ((itime * 2) / 3)) * 60;

if (etalt < talt) {
  setprop("instrumentation/teravd/target-alt", talt);
}
if (evfpm < tvfpm) {
  setprop("instrumentation/teravd/target-vfpm", tvfpm);
}
setprop("controls/switches/terra-report", 1);
settimer(setvfpm, 0);
}
}

var teravd_m20d = func {
var calt = getprop("position/altitude-ft");
var cspd = getprop("velocities/groundspeed-kt");
var talt = getprop("autopilot/settings/target-altitude-ft");
var tvfpm = getprop("autopilot/settings/vertical-speed-fpm");
var rdist25 = getprop("controls/switches/terrain-avoid-rng-25");
var rdist50  = getprop("controls/switches/terrain-avoid-rng-50");

var evfpm = getprop("instrumentation/teravd/target-vfpm");
var etalt = getprop("instrumentation/teravd/target-alt");

var elem20d = getprop("instrumentation/teravd/elevationm20d");
var distm20d = getprop("instrumentation/teravd/distancem20d");
var clr = getprop("controls/switches/terrain-avoid-clr1000");
var prty = getprop("controls/switches/terrain-follow-map-enabled");

if (rdist25 = 1) {
var rdist2 = 15000;
} elsif (rdist50 = 1) {
  var rdist2 = 30000;
}

var daltm20d = ((elem20d + clr) - calt);

if ((distm20d < rdist2) and (daltm20d > 0)) {
  var talt = calt + daltm20d;
  var itime = distm20d / (cspd * 1.6878);
  var tvfpm = int((daltm20d) / (itime / 2)) * 60;

if (etalt < talt) {
  setprop("instrumentation/teravd/target-alt", talt);
}
if (evfpm < tvfpm) {
  setprop("instrumentation/teravd/target-vfpm", tvfpm);
}
setprop("controls/switches/terra-report", 1);
settimer(setvfpm, 0);
}

}


var setvfpm = func {
var calt = getprop("position/altitude-ft");
var talt = getprop("instrumentation/teravd/target-alt");
var tvfpm = getprop("instrumentation/teravd/target-vfpm");

setprop("controls/switches/apmode/alt-hold", 0);
setprop("controls/switches/apmode/ptch-hold", 0);
setprop("controls/switches/apmode/vfpm-hold", 0);
setprop("autopilot/settings/vertical-speed-fpm", tvfpm);
setprop("autopilot/locks/altitude", "vertical-speed-hold");
if (calt > talt) {
  setprop("autopilot/settings/vertical-speed-fpm", 0);
  setprop("controls/switches/terra-report", 0);
  setprop("instrumentation/teravd/target-vfpm", 0);
  setprop("instrumentation/teravd/target-alt", 0);
  #settimer(aglreinit, 0);
} else {
  settimer(setvfpm, 0.5);
  }
}


# reinit previous flight params
#var aglreinit = func {
#var terflw = getprop("controls/switches/terrain-follow");
#setprop("controls/switches/terra-report", 0);
#if(terflw == 1) {
#  setprop("autopilot/locks/altitude", "vertical-speed-hold");
#} elsif {
#  setprop("autopilot/locks/altitude", "vertical-speed-hold");
  #setprop("autopilot/locks/altitude", "altitude-hold");
# }
#}
### end of terrain avoidance behaviour #########################

