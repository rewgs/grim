package project

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
)

// Project defines a ReaScript project as created via `grim new`.
type Project struct {
	Name           string
	Path           string
	distDir        string // the result of running `grim build`
	libDir         string // third-party libraries
	srcDir         string // source code
	testsDir       string // test files
	gitignoreFile  string // .gitignore
	grimConfigFile string // .grim.json
	readmeFile     string // .README.md
}

// New returns a newly-instantiated Project.
func New(name string, path string) *Project {
	p := Project{
		Name: name,
		Path: path,
	}

	return &p
}

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

	err := p.gitInit()
	if err != nil {
		return err
	}

	for _, dir := range dirs {
		path := filepath.Join(p.Path, dir)
		err := os.MkdirAll(path, os.ModePerm)
		if err != nil {
			return err
		}

		switch dir {
		case "lib":
			p.libDir = path
		case "src":
			p.srcDir = path
		case "tests":
			p.testsDir = path
		default:
			return fmt.Errorf("unexpected directory: %s", path)
		}
	}

	for _, file := range files {
		path := filepath.Join(p.Path, file)
		_, err := os.Create(path)
		if err != nil {
			return err
		}

		switch file {
		case ".gitignore":
			p.gitignoreFile = path
		case ".grim.json":
			p.grimConfigFile = path
		case ".README.md":
			p.readmeFile = path
		default:
			return fmt.Errorf("unexpected file: %s", path)
		}
	}

	err = p.gitInit()
	if err != nil {
		return err
	}

	err = p.initGitIgnore()
	if err != nil {
		return err
	}

	err = p.initReadme()
	if err != nil {
		return err
	}

	return nil
}

func (p *Project) gitInit() error {
	git, err := exec.LookPath("git")
	if err != nil {
		return err
	}

	cmd := exec.Command(git, "init", p.Path)
	err = cmd.Run()
	if err != nil {
		return err
	}

	return nil
}

func (p *Project) initGitIgnore() error {
	err := os.WriteFile(p.gitignoreFile, []byte("/dist/\n"), 0644)
	return err
}

func (p *Project) initReadme() error {
	err := os.WriteFile(p.readmeFile, []byte(fmt.Sprintf("# %s", p.Name)), 0644)
	return err
}
