package main

import (
  "fmt"
  "time"
  "strings"
  "github.com/coreos/fleet/job"
)

func main() {
  fmt.Printf("--kicker--\n")

  for {
    api, _ := getRegistryClient()
    cAPI = api // inject into the main fleetctl client we've imported.

    unitStates, _ := api.UnitStates()

    for i := range unitStates {
      state := unitStates[i]

      if state.SystemdLoadState != "loaded" {
        fmt.Printf("marking %s as 'loaded'\n", state.Name)
        err := api.SetUnitTargetState(state.Name,string(job.JobStateLoaded))
        if err != nil {
          fmt.Printf("%s\n", err)
        }
      }

      b := (state.SystemdSubState != "running"  &&
            state.SystemdSubState != "waiting" &&
            !strings.Contains(state.Name,"hc@"))

      if b {
        runStopUnit([]string{state.Name})
        runStartUnit([]string{state.Name})
      }else if state.SystemdActiveState == "failed" {
        runStopUnit([]string{state.Name})
        runStartUnit([]string{state.Name})
      }

    }
    time.Sleep(5 * time.Second)
  }
}
