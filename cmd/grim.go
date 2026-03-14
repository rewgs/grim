package main

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/urfave/cli/v3"

	"github.com/rewgs/grim-cli/internal/project"
)

func main() {
	cmd := &cli.Command{
		Commands: []*cli.Command{
			{
				Name:  "new",
				Usage: "create a new project",
				Action: func(ctx context.Context, cmd *cli.Command) error {
					p, err := project.New()
					if err != nil {
						return err
					}
				},
			},
		},
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
