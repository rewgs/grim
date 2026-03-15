package project

import (
	"testing"
)

func TestNewProject(t *testing.T) {
	path := t.TempDir()
	p := New("test", path)
	if p == nil {
		t.Fatal()
	}
}

func TestCreateProject(t *testing.T) {
	path := t.TempDir()
	p := New("test", path)
	if p == nil {
		t.Fatal()
	}

	err := p.Create()
	if err != nil {
		t.Fatal(err)
	}
}
