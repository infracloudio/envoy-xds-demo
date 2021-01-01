package domainsreader

import (
	"encoding/csv"
	log "github.com/sirupsen/logrus"
	"io"
	"io/ioutil"
	"strings"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func ReadFile() [][]string {
	dat, err := ioutil.ReadFile("domains.csv")
	check(err)
	r := csv.NewReader(strings.NewReader(string(dat)))
	var domains [][]string
	for {
		record, err := r.Read()
		if err == io.EOF {
			break
		}
		if err != nil {
			log.Fatal(err)
		}
		if record[0] == "domain_name" {
			continue
		}
		domains = append(domains, record)
	}
	return domains
}
