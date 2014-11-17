# kicker

Kicks stopped fleet services into starting again.

Any service not having 'hc' in it will be kicked, hc
being healthcheck.

TODO: Should expand out the rules or make the
services to be kicked to be configurable. This might
kick oneshot services when they are not needed.

## fleetctl.go / start.go / stop.go

these are modified copies of taken from
the primary fleet codebase. They have been modified
solely to strip out the main function and
the various commands provided in the command line.
