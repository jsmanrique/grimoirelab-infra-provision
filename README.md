# GrimoireLab Infrastructure Provision

Set of tools and scripts to set up and deploy GrimoireLab infrastructure in cloud
providers.

The process is divided in 2 main parts:
1. Set up a machine in a cloud provider where you have already a configured account:
```
terraform init
...
terraform apply -auto-approve -var name=<GIVE_IT_A_NAME>
```
2. Deploy GrimoireLab software and configuration files to run an analysis. By default, settings are under [grimoirelab-settings](grimoirelab-settings) folder. So, once you have them ready:
```
cd ansible
ansible-playbook -i <IP>, deploy.yml
```

More details, in the following sections. Let's have fun!

## Requirements

* [Ansible](https://www.ansible.com/) (for cloud environment set up)
* [Terraform](https://www.terraform.io/) (for remote software management)
* An account set up in one cloud provider, including SSH access, access tokens, 
or whatever mechanisms they provide. By now, this project has support for:
  * Digital Ocean
  * Google Cloud Platform

# Step 1: Clone the repository and set up your cloud provider account

Clone it into your laptop / machine. I've only tested it in Linux, so I cannot promise it'll work the same in MacOS or MS Windows. It will create a folder called `grimoirelab-infra-provision`.

Setup your working environment based on your cloud provider:
* [Digital Ocean](do/README.md)
* [Google Cloud Platform](gcp/README.md)

# Step 2: Deploy and manage GrimoireLab in your cloud infrastructure

We already have a machine ready *somewhere*. Let's say *somewhere* is the `public_ip`
noted by Terraform. Now it's time to set up our GrimoireLab software environment.

First of all, we need to get settings files ready for the deployment. By default,
there are in [grimoirelab-settings](grimoirelab-settings). Edit them to fit with
your needs.

**IMPORTANT**: Don't forget to fill `api_token` fields with your token, or API Key, in
`setup.cfg` if you plan to gather data from GitHub, GitLab, or Meetup, for example.

Once ready, execute `deploy.yml` playbook over the `public_ip`:
* If your cloud infrastructure expects a `root` user, then run:
```
cd ansible
ansible-playbook -i <PUBLIC_IP>, deploy.yml
```
* If your cloud infrastructure expects a `<USERNAME>` user, then run:
```
cd ansible
ansible-playbook -i <PUBLIC_IP>, deploy.yml -e "user=<USERNAME>"
```

**IMPORTANT**: Don't forget the comma (`,`) after the `<PUBLIC_IP>`!


During the process, Ansible might ask for permission to continue connecting.
Just say `yes`:

```
PLAY [all] *********************************************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************************************************************************************************************************
The authenticity of host '157.245.85.159 (157.245.85.159)' can't be established.
ECDSA key fingerprint is SHA256:ZUgT5c0kUQmdhH9kELDk+c7fJpWhaEZq6o6PsdUAxes.
Are you sure you want to continue connecting (yes/no)? yes
ok: [157.245.85.159]
```

Ansible will show each step executed. The `Start GrimoireLab containers` might 
take a while. The final output might look like this:
```
PLAY [all] ***********************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [157.245.85.159]

TASK [Clone GrimoireLab repo] ****************************************************************************************************************************************************************
changed: [157.245.85.159]

TASK [Set down running GrimoireLab containers] ***********************************************************************************************************************************************
changed: [157.245.85.159]

TASK [Upload new GrimoireLab settings] *******************************************************************************************************************************************************
changed: [157.245.85.159] => (item=setup.cfg)
changed: [157.245.85.159] => (item=projects.json)

TASK [Start GrimoireLab containers] **********************************************************************************************************************************************************
changed: [157.245.85.159]

TASK [debug] *********************************************************************************************************************************************************************************
ok: [157.245.85.159] => {
    "output": {
        "changed": true,
        "cmd": [
            "docker-compose",
            "up",
            "-d"
        ],
        "delta": "0:01:03.795886",
        "end": "2019-09-23 09:25:07.491730",
        "failed": false,
        "rc": 0,
        "start": "2019-09-23 09:24:03.695844",
        "stderr": "Creating network \"grimoirelab-for-demos_default\" with the default driver\nPulling mariadb (mariadb:10.0)...\nPulling hatstall (grimoirelab/hatstall:latest)...\nPulling elasticsearch (docker.elastic.co/elasticsearch/elasticsearch-oss:6.1.4)...\nPulling kibiter (bitergia/kibiter:optimized-v6.1.4-1)...\nPulling redis (redis:)...\nPulling mordred (bitergia/mordred:grimoirelab-0.2.27)...\nCreating grimoirelab-for-demos_elasticsearch_1 ... \r\nCreating grimoirelab-for-demos_redis_1         ... \r\nCreating grimoirelab-for-demos_mariadb_1       ... \r\n\u001b[2A\u001b[2K\rCreating grimoirelab-for-demos_redis_1         ... \u001b[32mdone\u001b[0m\r\u001b[2B\u001b[3A\u001b[2K\rCreating grimoirelab-for-demos_elasticsearch_1 ... \u001b[32mdone\u001b[0m\r\u001b[3BCreating grimoirelab-for-demos_kibiter_1       ... \r\n\u001b[2A\u001b[2K\rCreating grimoirelab-for-demos_mariadb_1       ... \u001b[32mdone\u001b[0m\r\u001b[2BCreating grimoirelab-for-demos_hatstall_1      ... \r\nCreating grimoirelab-for-demos_mordred_1       ... \r\n\u001b[3A\u001b[2K\rCreating grimoirelab-for-demos_kibiter_1       ... \u001b[32mdone\u001b[0m\r\u001b[3B\u001b[1A\u001b[2K\rCreating grimoirelab-for-demos_mordred_1       ... \u001b[32mdone\u001b[0m\r\u001b[1B\u001b[2A\u001b[2K\rCreating grimoirelab-for-demos_hatstall_1      ... \u001b[32mdone\u001b[0m\r\u001b[2B",
        "stderr_lines": [
            "Creating network \"grimoirelab-for-demos_default\" with the default driver",
            "Pulling mariadb (mariadb:10.0)...",
            "Pulling hatstall (grimoirelab/hatstall:latest)...",
            "Pulling elasticsearch (docker.elastic.co/elasticsearch/elasticsearch-oss:6.1.4)...",
            "Pulling kibiter (bitergia/kibiter:optimized-v6.1.4-1)...",
            "Pulling redis (redis:)...",
            "Pulling mordred (bitergia/mordred:grimoirelab-0.2.27)...",
            "Creating grimoirelab-for-demos_elasticsearch_1 ... ",
            "Creating grimoirelab-for-demos_redis_1         ... ",
            "Creating grimoirelab-for-demos_mariadb_1       ... ",
            "\u001b[2A\u001b[2K",
            "Creating grimoirelab-for-demos_redis_1         ... \u001b[32mdone\u001b[0m",
            "\u001b[2B\u001b[3A\u001b[2K",
            "Creating grimoirelab-for-demos_elasticsearch_1 ... \u001b[32mdone\u001b[0m",
            "\u001b[3BCreating grimoirelab-for-demos_kibiter_1       ... ",
            "\u001b[2A\u001b[2K",
            "Creating grimoirelab-for-demos_mariadb_1       ... \u001b[32mdone\u001b[0m",
            "\u001b[2BCreating grimoirelab-for-demos_hatstall_1      ... ",
            "Creating grimoirelab-for-demos_mordred_1       ... ",
            "\u001b[3A\u001b[2K",
            "Creating grimoirelab-for-demos_kibiter_1       ... \u001b[32mdone\u001b[0m",
            "\u001b[3B\u001b[1A\u001b[2K",
            "Creating grimoirelab-for-demos_mordred_1       ... \u001b[32mdone\u001b[0m",
            "\u001b[1B\u001b[2A\u001b[2K",
            "Creating grimoirelab-for-demos_hatstall_1      ... \u001b[32mdone\u001b[0m",
            "\u001b[2B"
        ],
        "stdout": "10.0: Pulling from library/mariadb\nDigest: sha256:6d782a4be2f66ff527e0243fed2bdc704fd827b8a39503db6e5ed613f0eb0145\nStatus: Downloaded newer image for mariadb:10.0\nlatest: Pulling from grimoirelab/hatstall\nDigest: sha256:2285d245a89c5ae35eb5cb946916ea06e52ed5211e2440626d22715baafda789\nStatus: Downloaded newer image for grimoirelab/hatstall:latest\n6.1.4: Pulling from elasticsearch/elasticsearch-oss\nDigest: sha256:4f2bd6a008c41d83aeb8e5ac95412d47b667d21d4df7c67c41b9baec15a78164\nStatus: Downloaded newer image for docker.elastic.co/elasticsearch/elasticsearch-oss:6.1.4\noptimized-v6.1.4-1: Pulling from bitergia/kibiter\nDigest: sha256:8c2235225ef9277078063174a3b2cf208a6f8dfc86f80afc51582f0267e7a59a\nStatus: Downloaded newer image for bitergia/kibiter:optimized-v6.1.4-1\nlatest: Pulling from library/redis\nDigest: sha256:5dcccb533dc0deacce4a02fe9035134576368452db0b4323b98a4b2ba2d3b302\nStatus: Downloaded newer image for redis:latest\ngrimoirelab-0.2.27: Pulling from bitergia/mordred\nDigest: sha256:ca309c9c9e80f5f65096361555f28e2daf7ffdbb329ebd6328d25342e4844e15\nStatus: Downloaded newer image for bitergia/mordred:grimoirelab-0.2.27",
        "stdout_lines": [
            "10.0: Pulling from library/mariadb",
            "Digest: sha256:6d782a4be2f66ff527e0243fed2bdc704fd827b8a39503db6e5ed613f0eb0145",
            "Status: Downloaded newer image for mariadb:10.0",
            "latest: Pulling from grimoirelab/hatstall",
            "Digest: sha256:2285d245a89c5ae35eb5cb946916ea06e52ed5211e2440626d22715baafda789",
            "Status: Downloaded newer image for grimoirelab/hatstall:latest",
            "6.1.4: Pulling from elasticsearch/elasticsearch-oss",
            "Digest: sha256:4f2bd6a008c41d83aeb8e5ac95412d47b667d21d4df7c67c41b9baec15a78164",
            "Status: Downloaded newer image for docker.elastic.co/elasticsearch/elasticsearch-oss:6.1.4",
            "optimized-v6.1.4-1: Pulling from bitergia/kibiter",
            "Digest: sha256:8c2235225ef9277078063174a3b2cf208a6f8dfc86f80afc51582f0267e7a59a",
            "Status: Downloaded newer image for bitergia/kibiter:optimized-v6.1.4-1",
            "latest: Pulling from library/redis",
            "Digest: sha256:5dcccb533dc0deacce4a02fe9035134576368452db0b4323b98a4b2ba2d3b302",
            "Status: Downloaded newer image for redis:latest",
            "grimoirelab-0.2.27: Pulling from bitergia/mordred",
            "Digest: sha256:ca309c9c9e80f5f65096361555f28e2daf7ffdbb329ebd6328d25342e4844e15",
            "Status: Downloaded newer image for bitergia/mordred:grimoirelab-0.2.27"
        ]
    }
}

PLAY RECAP ***********************************************************************************************************************************************************************************
157.245.85.159             : ok=6    changed=4    unreachable=0    failed=0
```

Once ready, your GrimoireLab infra would be ready in:
* Dashboard: `http://<PUBLIC_IP>:5601`
* HatStall (the identities and affilition management web interface): `http://<PUBLIC_IP>:8000`

## Update GrimoireLab settings

There are several tasks you might need to perform once we have your GrimoireLab
infrastructure running:
* Update repositories or data sources
* Update organizations
* Update repos, data sources, and organizations

### Update repositories or data sources

Edit the files in [grimoirelab-settings](grimoirelab-settings) and execute:
```
cd ansible
ansible-playbook -i <PUBLIC_IP>, update.yml -e "update_orgs=false"
```

**IMPORTANT**: Remember to add `user=<USERNAME>` if needed to the `-e` parameter

### Update organizations

By default, I am using the `organizations.json` file hosted in 
[this side project](https://gitlab.com/jsmanrique/grimoirelab-organizationsdb).
Submit a merge request with the organizations you would like to edit (add, or modify),
and once approved, execute:
```
cd ansible
ansible-playbook -i <PUBLIC_IP>, update.yml -e "update_settings=false"
```

**IMPORTANT**: Remember to add `user=<USERNAME>` if needed to the `-e` parameter

### Update all the settings

Basically, you need to execute previous actions (edit files, and submit merge 
request) and to execute:
```
cd ansible
ansible-playbook -i <PUBLIC_IP>, update.yml
```

**IMPORTANT**: Remember to add `user=<USERNAME>` if needed to the `-e` parameter

## Customize your GrimoireLab deployment

By default, this project is using the `docker-compose.yml` file described
in this [side project](https://gitlab.com/jsmanrique/grimoirelab-for-demos). If
you want to try other deployment configurations, you might need to edit vars listed
in [ansible/group_vars/all/main.yml](ansible/group_vars/all/main.yml), or manage
the extra vars through the command line.

# License

GPLv3