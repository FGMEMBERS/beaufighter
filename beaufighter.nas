init = func {
  setprop ("/autopilot/locks/heading" , "none" );
  setprop ("/autopilot/locks/altitude" , "none" );

  if (getprop("/controls/engines/engine[0]/on-startup-running") == 1) {
    setprop("/consumables/fuel/tank[1]/selected",1);
    setprop("/controls/engines/engine[0]/magnetos",3);
    setprop("/controls/engines/engine[0]/coolflap-auto",1);
#    setprop("/controls/engines/engine[0]/radlever",1);
    setprop("/engines/engine[0]/oil-visc",1);
    setprop("/engines/engine[0]/rpm",800);
    setprop("/engines/engine[0]/engine-running",1);
	}
  if (getprop("/controls/engines/engine[1]/on-startup-running") == 1) {
    setprop("/consumables/fuel/tank[3]/selected",1);
    setprop("/controls/engines/engine[1]/magnetos",3);
    setprop("/controls/engines/engine[1]/coolflap-auto",1);
#    setprop("/controls/engines/engine[1]/radlever",1);
    setprop("/engines/engine[1]/oil-visc",1);
    setprop("/engines/engine[1]/rpm",800);
    setprop("/engines/engine[1]/engine-running",1);
	}
}
setlistener("/controls/fuel/switch-position-port", func(n) {
	position=n.getValue();
    setprop("/consumables/fuel/tank[0]/selected",0);
    setprop("/consumables/fuel/tank[1]/selected",0);
    if(position >= 0.0){
		setprop("/consumables/fuel/tank[" ~ position ~ "]/selected",1);
		setprop("/engines/engine[0]/out-of-fuel",0);
        };    
    },1);
setlistener("/controls/fuel/switch-position-starb", func(n) {
	position=n.getValue();
    setprop("/consumables/fuel/tank[2]/selected",0);
    setprop("/consumables/fuel/tank[3]/selected",0);
    if(position >= 2.0){
		setprop("/consumables/fuel/tank[" ~ position ~ "]/selected",1);
		setprop("/engines/engine[0]/out-of-fuel",0);
        };    
    },1);

#	setlistener("/sim/model/beaufighter/weapons/impact/Torpedo", func(n) {
#		var node = props.globals.getNode(n.getValue(), 1);
#		var impact = geo.Coord.new().set_latlon(
#				node.getNode("impact/latitude-deg").getValue(),
#				node.getNode("impact/longitude-deg").getValue(),
#				node.getNode("impact/elevation-m").getValue());

#		geo.put_model("Aircraft/bo105/Models/hot.ac", impact,
		#geo.put_model("Models/Power/coolingtower.xml", impact,
#				node.getNode("impact/heading-deg").getValue(),
#				node.getNode("impact/pitch-deg").getValue(),
#				node.getNode("impact/roll-deg").getValue());
#		screen.log.write(sprintf("%.3f km",
#				geo.aircraft_position().distance_to(impact) / 1000), 1, 0.9, 0.9);


#	});

#	setlistener("/sim/model/beaufighter/weapons/impact/rp", func(n) {
#		var node = props.globals.getNode(n.getValue(), 1);
#		var impact = geo.Coord.new().set_latlon(
#				node.getNode("impact/latitude-deg").getValue(),
#				node.getNode("impact/longitude-deg").getValue(),
#				node.getNode("impact/elevation-m").getValue());

#		geo.put_model("Aircraft/beaufighter/Models/explode.osg", impact,
#				node.getNode("impact/heading-deg").getValue(),
#				node.getNode("impact/pitch-deg").getValue(),
#				node.getNode("impact/roll-deg").getValue());
#	});

main_loop = func {
  cview = getprop("/sim/current-view/view-number");
    if (cview >= 7) {
      aphmode = getprop ("/autopilot/locks/heading");
      apvmode = getprop ("/autopilot/locks/altitude");
#      print (aphmode);
#      print (apvmode);
      if (aphmode == "none" ) {
        setprop ("/autopilot/locks/heading", "wing-leveler");
        setprop ("/autopilot/htempmode", 1 );
      }
      if (apvmode == "none" ) {
        setprop ("/autopilot/locks/altitude", "vertical-speed-hold");
        setprop ("autopilot/vtempmode" , 1 );
      }


    } else {
      htempmode = getprop ("/autopilot/htempmode");
      vtempmode = getprop ("/autopilot/vtempmode");
      if (htempmode == 1) {
        setprop ("/autopilot/locks/heading" , "none" );
        setprop ("/autopilot/htempmode" , 0);
      }
      if (vtempmode == 1) {
        setprop ("/autopilot/locks/altitude" , "none" );
        setprop ("/autopilot/vtempmode" , 0);
      }
    }
    settimer(main_loop, 0.01);
} 



fire_MG = func {
 if (getprop("/controls/armament/master-arm") == 1)  {
		if (getprop("sim/current-view/view-number") == 8) {
			setprop("/controls/armament/trigger2", 1);
		} else {
     setprop("/controls/armament/trigger", 1);
     } 
	}
}
stop_MG = func {
     setprop("/controls/armament/trigger", 0); 
     setprop("/controls/armament/trigger2", 0);
}

drop_torp = func {
 if (getprop("/controls/armament/master-arm") == 1)  {
  rcount=getprop("/sim/weight[0]/weight-lb");
  if(rcount > 49){
     setprop("/controls/armament/station/release-all", 1);
     setprop("/sim/weight[0]/selected","none");
     } 
 }
}

fire_rp = func {
 if (getprop("/controls/armament/master-arm") == 1)  {
  rcount=getprop("/sim/weight[1]/weight-lb");
  if(rcount > 20){
    if(rcount == 260)  {
     setprop("/controls/armament/pair1", 1)
     } else {
      if(rcount == 200)  {
      setprop("/controls/armament/pair2", 1)
      } else {
        if(rcount == 140)  {
        setprop("/controls/armament/pair3", 1)
        } else {
          if(rcount == 80)  {
          setprop("/controls/armament/pair4", 1)
          }
        }
      }
    }
  setprop("sim/weight[1]/weight-lb", rcount - 60.0);
  setprop("sim/weight[2]/weight-lb", rcount - 60.0);
  }
 }
}


toggle_fdoor = func {
  canopy = aircraft.door.new ("/controls/doors/fdoor/",3);
  if(getprop("//controls/doors/fdoor/position-norm") > 0) {
      canopy.close();
  } else {

      canopy.open();
  }
}


toggle_rdoor = func {
  canopy = aircraft.door.new ("/controls/doors/rdoor/",3);
  if(getprop("//controls/doors/rdoor/position-norm") > 0) {
      canopy.close();
  } else {

      canopy.open();
  }
}


toggle_cdoor = func {
  canopy = aircraft.door.new ("/controls/doors/cdoor/",3);
  if(getprop("//controls/doors/cdoor/position-norm") > 0) {
      canopy.close();
  } else {

      canopy.open();
  }
}


toggle_gunsight = func {
  canopy = aircraft.door.new ("/controls/switches/gun-sight-stow/",3);
  if(getprop("//controls/switches/gun-sight-stow/position-norm") > 0) {
      canopy.close();
  } else {

      canopy.open();
  }



  if(getprop("controls/switches/gun-sight-stow") > 0) {
    interpolate("controls/switches/gun-sight-stow", 0, 2);
  } else {
    interpolate("controls/switches/gun-sight-stow", 1, 2);
  }
}


fuel_jettison = func(side) {
  remaining_inner = getprop("consumables/fuel/tank["~side~"]/level-gal_us");
  remaining_outer = getprop("consumables/fuel/tank["~(side+1)~"]/level-gal_us");
  interpolate("consumables/fuel/tank["~side~"]/level-gal_us", (remaining_inner-20),5);
  interpolate("consumables/fuel/tank["~(side+1)~"]/level-gal_us", (remaining_outer-15),5);
}

view_fwd = func {
	curview = getprop ("sim/current-view/view-number");
	if (curview == 7) {
		setprop ("sim/current-view/view-number", 0 );
		} else {
		setprop ("sim/current-view/view-number", curview + 1);
		}	
	}
view_back = func {
	curview = getprop ("sim/current-view/view-number");
	if (curview == 0) {
		setprop ("sim/current-view/view-number", 7 );
		} else {
		setprop ("sim/current-view/view-number", curview - 1);
		}	
	}


var flash_trigger = props.globals.getNode("controls/armament/trigger", 0);
aircraft.light.new("sim/model/beaufighter/lighting/flash-lu", [0.05, 0.052], flash_trigger);
aircraft.light.new("sim/model/beaufighter/lighting/flash-ld", [0.052, 0.05], flash_trigger);
aircraft.light.new("sim/model/beaufighter/lighting/flash-ru", [0.051, 0.051], flash_trigger);
aircraft.light.new("sim/model/beaufighter/lighting/flash-rd", [0.0505, 0.0505], flash_trigger);

aircraft.livery.init("Aircraft/beaufighter/Models/Liveries", "sim/model/livery/name");

var logo_dialog = gui.OverlaySelector.new("Select Logo", "Aircraft/Generic/Logos", "sim/model/logo/name", nil, "sim/multiplay/generic/string");

aircraft.steering.init();
