package main


import (
  "github.com/coreos/fleet/job"
  "github.com/coreos/fleet/log"
  "os"
)

/*
   Copyright 2014 CoreOS, Inc.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/



func runStopUnit(args []string) (exit int) {
units, err := findUnits(args)
if err != nil {
stderr("%v", err)
return 1
}
stopping := make([]string, 0)
for _, u := range units {
if !suToGlobal(u) {
if job.JobState(u.CurrentState) == job.JobStateInactive {
stderr("Unable to stop unit %s in state %s", u.Name, job.JobStateInactive)
return 1
} else if job.JobState(u.CurrentState) == job.JobStateLoaded {
log.V(1).Infof("Unit(%s) already %s, skipping.", u.Name, job.JobStateLoaded)
continue
}
}
log.V(1).Infof("Setting target state of Unit(%s) to %s", u.Name, job.JobStateLoaded)
cAPI.SetUnitTargetState(u.Name, string(job.JobStateLoaded))
if suToGlobal(u) {
stdout("Triggered global unit %s stop", u.Name)
} else {
stopping = append(stopping, u.Name)
}
}
if !sharedFlags.NoBlock {
errchan := waitForUnitStates(stopping, job.JobStateLoaded, sharedFlags.BlockAttempts, os.Stdout)
for err := range errchan {
stderr("Error waiting for units: %v", err)
exit = 1
}
} else {
for _, name := range stopping {
stdout("Triggered unit %s stop", name)
}
}
return
}
