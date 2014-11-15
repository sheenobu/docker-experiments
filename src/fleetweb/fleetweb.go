package main

import (
  "fmt"
  "github.com/go-martini/martini"
  "github.com/martini-contrib/render"
)

func main() {
  fmt.Printf("--fleetweb--\n")

  api, _ := getRegistryClient()

  m := martini.Classic()
  m.Use(render.Renderer())

  m.Get("/units", func(r render.Render) {
    units, _ := api.Units()
    r.JSON(200, units)
  })

  m.Get("/units/:name", func(r render.Render, params martini.Params) {
    unit, _ := api.Unit(params["name"])
    r.JSON(200, unit)
  })

  m.Get("/unitStates", func(r render.Render) {
    unitStates, _ := api.UnitStates()
    r.JSON(200, unitStates)
  })

  m.Run()
}
