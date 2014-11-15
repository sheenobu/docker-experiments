Object.values = function (obj) {
    var vals = [];
    for( var key in obj ) {
        if ( obj.hasOwnProperty(key) ) {
            vals.push(obj[key]);
        }
    }
    return vals;
}

$(function() {
  $.getJSON("/unitStates", function(states) {

    states = groupStatesByName(states);

    $.getJSON("/units", function(data) {

      data = normalizeUnits(data,states);

      $.each(data, function(idx,d) {
        $("#units").append(renderGroupRow(idx,d));
      });
    });
  });
});

function groupStatesByName(states) {
  var ret = {};
  $.each(states,function(idx,state) {
    ret[state['name']] = state;
  });
  return ret;
}

function renderGroupRow(idx, data) {
  return (
    "<tr>" +
      "<td>" +
        idx +
      "</td>" +
      "<td>" +
        renderServer(idx,data) +
      "</td>" +
    "</tr>"
  );
}

function renderServer(idx, data) {
  return (
    "<table style='width: 100%'>" +
      "<thead>" +
        "<tr>" +
          "<th style='width:400px;'>Unit</th>" +
          "<th style='width:150px;'>Machine</th>" +
        "</tr>" +
      "</thead>" +
      "<tbody>" +
         ($.map(Object.values(data.endpoints),renderServerRow)).join("") +
         ($.map(Object.values(data.instances),renderServerRow)).join("") +
      "</tbody>" +
    "</table>"
  );
}

function stateOfUnit(unit) {
    return (unit['state']['systemdLoadState'] + "/" +
    unit['state']['systemdActiveState'] + "/" +
    unit['state']['systemdSubState']);
}

function renderServerRow(data) {


  var state = data.instance['currentState'];

  if(data.instance['state'] != undefined) {
    state =  state + "/" + data.instance['state']['systemdActiveState'];
    state =  state + "/" + data.instance['state']['systemdSubState'];
  }

  var name = "Service: " + data.instance['description'] + " - " + state;
  if(data.sidekick != undefined) {
    name = name + "<br/><br/>Sidekicks:";
    name = name + "<br/>" + "- " + data.sidekick['description'];
    name = name + " - " + stateOfUnit(data.sidekick)
  }

  if(data.healthcheck != undefined) {
    name = name + "<br/><br/>Healthcheck: ";
    if(data.healthcheck.timer != undefined) {
      name = name + "<br/>" + "- " + data.healthcheck.timer['description'] + " - " +
              stateOfUnit(data.healthcheck.timer)
    }
    if(data.healthcheck.service != undefined) {
      name = name + "<br/>" + "- " + data.healthcheck.service['description'] + " - " +
              stateOfUnit(data.healthcheck.service)
    }
  }

  var machineID = "-";
  if(data.instance['machineID'] != undefined) {
    machineID = data.instance['machineID'].substring(0,7);
  }

  return (
    "<tr>" +
      "<td>" +
        name +
      "</td>" +
      "<td>" +
        machineID +
      "</td>" +
    "</tr>"
  );
}

function normalizeUnits(data,states) {

  var groups = {};

  $.each(data, function(idx, unit) {

    var unitName = unit['name'];
    unit['state'] = states[unitName];

    var splitted = unit['name'].split(".");

    groupName = splitted[0];

    var serviceType = "service";

    if(splitted.length == 3) {
      serviceType = splitted[1];
    }

    if(groupName.contains("@")) {
      groupName = groupName.split("@")[0];
    }

    if(serviceType.contains("@")) {
      serviceType = serviceType.split("@")[0];
    }

    if(groups[groupName] == undefined) {
      groups[groupName] = {
        endpoints: {},
        instances: {},
        healthchecks: {}
      };
    }

    unit['type'] = serviceType;

    var instanceName = groupName;
    if(unitName.contains('@')) {
      instanceName = unitName.split("@")[1].split(".")[0];
    }


    if(serviceType == 'sk') {
      serviceType = 'sidekick';

      if(groups[groupName].instances[instanceName] == undefined) {
        groups[groupName].instances[instanceName] = {};
      }

      groups[groupName].instances[instanceName].sidekick = unit;
    }else if(serviceType == 'service') {

      if(groups[groupName].instances[instanceName] == undefined) {
        groups[groupName].instances[instanceName] = {};
      }

      groups[groupName].instances[instanceName].instance = unit;
    }else if(serviceType == 'endpoint') {

      if(groups[groupName].endpoints[instanceName] == undefined) {
        groups[groupName].endpoints[instanceName] = {};
      }

      groups[groupName].endpoints[instanceName].instance = unit;

    }else if(serviceType == 'hc') {
        serviceType = 'healthcheck';

        if(groups[groupName].instances[instanceName] == undefined) {
          groups[groupName].instances[instanceName] = {};
        }

        if(groups[groupName].instances[instanceName].healthcheck == undefined) {
          groups[groupName].instances[instanceName].healthcheck = {}
        }

        if(unitName.endsWith("timer")) {
          groups[groupName].instances[instanceName].healthcheck.timer = unit;
        }else{
          groups[groupName].instances[instanceName].healthcheck.service = unit;
        }
    }

    $.each(unit['options'], function(idx, item) {
      if(item['section'] === 'Unit' && item['name'] == 'Description') {
        unit['description'] = item['value'].replace("%i","")
      }
    });

  });

  return groups;
}
