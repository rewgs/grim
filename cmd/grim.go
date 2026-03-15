package main

import (
	"context"
	"errors"
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
					if !cmd.Args().Present() {
						return errors.New("new requires the following arguments: <name>, <path>")
					}

					name := cmd.Args().Get(0)
					if name == "" {
						return errors.New("new requires the following arguments: <name>, <path>")
					}

					path := cmd.Args().Get(1)
					if path == "" {
						return errors.New("new requires the following arguments: <name>, <path>")
					}

					p := project.New(name, path)
					err := p.Create()
					if err != nil {
						return err
					}
					return nil
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
