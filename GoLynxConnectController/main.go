package main

import (
	"flag"
	"fmt"
	"os"
	"time"

	"github.com/peterbourgon/ff"
)

func main() {
	var config struct {
		listenAddr string
		refresh    time.Duration
		debug      bool
	}
	fs := flag.NewFlagSet("my-program", flag.ExitOnError)
	fs.StringVar(&config.listenAddr, "listen", "localhost:8080", "listen address")
	fs.DurationVar(&config.refresh, "refresh", 15*time.Second, "refresh interval")
	fs.BoolVar(&config.debug, "debug", false, "log debug information")
	_ = fs.String("config", "", "config file (optional)")

	err := ff.Parse(fs, os.Args[1:],
		ff.WithEnvVarNoPrefix(),
		ff.WithConfigFileFlag("config"),
		ff.WithConfigFileParser(ff.PlainParser),
	)
	if err != nil {
		panic(err)
	}

	fmt.Printf("listen=%s refresh=%s debug=%v\n", config.listenAddr, config.refresh, config.debug)
}
