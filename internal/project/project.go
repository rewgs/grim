package project

import (
	"os"
	"path/filepath"
)

// Project defines a ReaScript project as created via `grim new`.
type Project struct {
	Name string
	Path string
}

// New returns a newly-instantiated Project.
func New(name string) (*Project, error) {
	p := Project{
		Name: name,
	}

	return &p, nil
}

// The file hierarchy of new ReaScript project created by `grim` consists of the following:
//
//	dist/           - The result of `grim build`
//	lib/            - Libraries to use with `src`
//	    grim/       - The grim ReaScript library source code
//	src/            - source code
//	    .gitkeep
//	tests/          - test files
//	    .gitkeep
//	.git            - git repo is already initialized
//	.gitignore      - Ignores `dist` and `lib` by default
//	.grim.json      - Settings for `grim`
//	.README.md
func (p *Project) Create() error {
	var dirs = []string{
		"lib",
		"src",
		"tests",
	}

	var files = []string{
		".gitignore",
		".grim.json",
		".README.md",
	}

	for _, dir := range dirs {
		path := filepath.Join(p.Path, dir)
		err := os.MkdirAll(path, os.ModePerm)
		if err != nil {
			return err
		}
	}

	for _, file := range files {
		path := filepath.Join(p.Path, file)
		_, err := os.Create(path)
		if err != nil {
			return err
		}
	}

	return nil
}
