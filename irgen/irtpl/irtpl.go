package irtpl

import (
	"embed"
	"encoding/hex"
	"html/template"
	"io/fs"
	"path"
	"strings"
	"sync"

	"github.com/holiman/uint256"
)

//go:embed *.ll
var templateFiles embed.FS
var templateCache = make(map[string]*template.Template)
var templateCacheMux = &sync.RWMutex{}
var templateFuncs = template.FuncMap{
	"llhexrev": func(data []byte) string {
		var b strings.Builder
		for i := len(data) - 1; i >= 0; i-- {
			b.WriteString("\\" + hex.EncodeToString([]byte{data[i]}))
		}
		return b.String()
	},
	"u256": func(data []byte) string {
		val := uint256.NewInt(0).SetBytes(data)
		return val.String()
	},
	"hex": func(data []byte) string {
		return hex.EncodeToString(data)
	},
	"add": func(a, b uint64) uint64 { return a + b },
	"sub": func(a, b uint64) uint64 { return a - b },
	"mul": func(a, b uint64) uint64 { return a * b },
	"max": func(a, b uint64) uint64 {
		if a > b {
			return a
		}
		return b
	},
	"loop": func(count uint64) []uint64 {
		var items []uint64
		for i := uint64(0); i < count; i++ {
			items = append(items, i)
		}
		return items
	},
	"arrstr": func(arr []string, index uint64) string {
		return arr[index]
	},
}

func GetTemplate(files ...string) *template.Template {
	name := strings.Join(files, "-")

	templateCacheMux.RLock()
	if templateCache[name] != nil {
		defer templateCacheMux.RUnlock()
		return templateCache[name]
	}
	templateCacheMux.RUnlock()

	tmpl := template.New(name).Funcs(templateFuncs)
	tmpl = template.Must(parseTemplateFiles(tmpl, readFileFS(templateFiles), files...))
	templateCacheMux.Lock()
	defer templateCacheMux.Unlock()
	templateCache[name] = tmpl
	return templateCache[name]
}

func readFileFS(fsys fs.FS) func(string) (string, []byte, error) {
	return func(file string) (name string, b []byte, err error) {
		name = path.Base(file)
		b, err = fs.ReadFile(fsys, file)
		return
	}
}

func parseTemplateFiles(t *template.Template, readFile func(string) (string, []byte, error), filenames ...string) (*template.Template, error) {
	for _, filename := range filenames {
		name, b, err := readFile(filename)
		if err != nil {
			return nil, err
		}
		s := string(b)
		var tmpl *template.Template
		if t == nil {
			t = template.New(name)
		}
		if name == t.Name() {
			tmpl = t
		} else {
			tmpl = t.New(name)
		}
		_, err = tmpl.Parse(s)
		if err != nil {
			return nil, err
		}
	}
	return t, nil
}
