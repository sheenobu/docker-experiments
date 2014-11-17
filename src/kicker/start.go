package main

import (
  "os"
  "github.com/coreos/fleet/job"
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


func runStartUnit(args []string) (exit int) {
if err := lazyCreateUnits(args); err != nil {
stderr("Error creating units: %v", err)
return 1
}
triggered, err := lazyStartUnits(args)
if err != nil {
stderr("Error starting units: %v", err)
return 1
}
var starting []string
for _, u := range triggered {
if suToGlobal(*u) {
stdout("Triggered global unit %s start", u.Name)
} else {
starting = append(starting, u.Name)
}
}
if !sharedFlags.NoBlock {
errchan := waitForUnitStates(starting, job.JobStateLaunched, sharedFlags.BlockAttempts, os.Stdout)
for err := range errchan {
stderr("Error waiting for units: %v", err)
exit = 1
}
} else {
for _, name := range starting {
stdout("Triggered unit %s start", name)
}
}
return
}
