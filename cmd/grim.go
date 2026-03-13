package main

import (
	"context"
	"log"
	"os"

	"github.com/urfave/cli/v3"
)

func main() {
	cmd := &cli.Command{
		Name:  "grim",
		Usage: "ReaScript helper tool",
		Action: func(context.Context, *cli.Command) error {
			fmt.Println("Testing 1 2 3")
			return nil
		},
	}

	if err := cmd.Run(context.Background(), os.Args); err != nil {
		log.Fatal(err)
	}
}
