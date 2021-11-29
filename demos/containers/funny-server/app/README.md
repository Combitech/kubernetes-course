# Example app Python

A funny web server serving jokes from [pyjokes](https://pypi.org/project/pyjokes/)

## Prerequisites

* python 3
* pip

## Install 3rd party dependencies

### Create virtual environment (optional but recommended)

```shell
python3 -m venv .venv
source .venv/bin/activate
```

### Install dependencies

```shell
pip3 install -r requirements.txt
```

## Run

```shell
python3 app.py
```

> Watch output for URL to open in your browser

Abort via `Ctrl-C`

## Configuration options

Look at the top of [app.py](./app.py) for what can be configured via environment variables.

> 💡***Example***
>
> ```console
> $ BG_COLOR=green python3 app.py 
> Serving green stuff at http://localhost:8080
> ```
