#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#

import argparse
import configparser
import requests
import time
import json

def parse_args(args):
	parser = argparse.ArgumentParser(description = 'Create a projects.json file for a GitHub organization')
	parser.add_argument('-o', '--organization', dest = 'organization', required = True, help = 'GitHub Organization')
	
	return parser.parse_args()

def create_organization_dict(name):
    """ Create a projects dictionary for a given GitHub 
        organization, where each repository is described 
        as a single project ('project') with a git 
        and github issues and pull requests repositories
        {"organization": {
            "git" : ["http://github.com/name/project1.git", 
                    "http://github.com/name/project2.git",
                    ...
                    "http://github.com/name/projectN.git"],
            "github": ["http://github.com/name/project",
                      "http://github.com/name/project",
                      ...
                      "http://github.com/name/projectN"]
            },
         ...
        }
    """
    query = "org:{}".format(name)
    page = 1
    
    projects = {}
    
    r = requests.get('https://api.github.com/search/repositories?q={}&page={}'.format(query, page))
    items = r.json()['items']
    
    git = []
    github = []
    projects[name] = {"git":git, "github":github}
    while len(items) > 0:
        time.sleep(5)
        for item in items:
            projects[name]['git'].append(item['clone_url'])
            projects[name]['github'].append(item['html_url'])
        page += 1
        r = requests.get('https://api.github.com/search/repositories?q={}&page={}'.format(query, page))
        try:
            items = r.json()['items']
        except:
            print('Error getting the repos list')
            print(r.json())
    
    
    return projects


def main(args):
	args = parse_args(args)
	p = create_organization_dict(args.organization)
	with open('projects-'+args.organization+'.json', 'w') as f:
		json.dump(p,f, sort_keys=True, indent=4)
	print('projects-'+args.organization+'.json file created')

if __name__ == '__main__':
	import sys
	main(sys.argv[1:])
