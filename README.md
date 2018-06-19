# Kaggle

Here we are testing using the Kaggle API to generate datasets. We would want to
be able to do this automatically for a [Dinosaur Dataset](https://vsoch.github.io/datasets)
from the Stanford Research Computer Center.

## Build

To build the container

```bash
docker build -t vanessa/kaggle .
```

## Enter the Container

Shell into it interactively. Notice that we are binding our kaggle API credentials
to root's home so they are discovered by the client.

```bash
docker run -v /home/vanessa/.kaggle:/root/.kaggle -it vanessa/kaggle bash
```

If you want to also bind some directory with data files (for your dataset) you can do that
with another volume:

```bash
docker run -v /home/vanessa/.kaggle:/root/.kaggle -v $HOME/code-images:/tmp/data -it vanessa/kaggle bash
```

## Usage
The script [create_dataset.py](create_dataset.py) is located in the working directory
you shell into, and the usage accepts the arguments you would expect to generate 
a dataset.

```bash
# python create_dataset.py 
usage: create_dataset.py [-h] --username USERNAME --title TITLE
                         [--id KAGGLE_ID] [--keywords KEYWORDS]
                         [--files [FILES [FILES ...]]]

Dinosaur Kaggle Dataseet Creator

optional arguments:
  -h, --help            show this help message and exit
  --username USERNAME   the kaggle username (in the url)
  --title TITLE, -t TITLE
                        title for the dataset username/TITLE
  --id KAGGLE_ID        The user or organization to upload to.
  --keywords KEYWORDS, -k KEYWORDS
                        comma separated (no spaces) keywords for dataset
  --files [FILES [FILES ...]], -f [FILES [FILES ...]]
                        dataset files
usage: create_dataset.py [-h] --username USERNAME --title TITLE
                         [--id KAGGLE_ID] [--keywords KEYWORDS]
                         [--files [FILES [FILES ...]]]
create_dataset.py: error: the following arguments are required: --username, --title/-t
```

It's easier to see an example. I had my data files (.tar.gz files) in `/tmp/data/ARCHIVE`,
so first I prepared a space separated list of fullpaths to them:

```bash

# Prepare a space separated list of fullpaths to data files
uploads=$(find /tmp/data/ARCHIVE -type f | paste -d -s)

/tmp/data/ARCHIVE/cs.tar.gz /tmp/data/ARCHIVE/m.tar.gz /tmp/data/ARCHIVE/js.tar.gz /tmp/data/ARCHIVE/md.tar.gz /tmp/data/ARCHIVE/map.tar.gz /tmp/data/ARCHIVE/css.tar.gz /tmp/data/ARCHIVE/go.tar.gz /tmp/data/ARCHIVE/json.tar.gz /tmp/data/ARCHIVE/r.tar.gz /tmp/data/ARCHIVE/html.tar.gz /tmp/data/ARCHIVE/cc.tar.gz /tmp/data/ARCHIVE/txt.tar.gz /tmp/data/ARCHIVE/csv.tar.gz /tmp/data/ARCHIVE/c.tar.gz /tmp/data/ARCHIVE/f90.tar.gz /tmp/data/ARCHIVE/xml.tar.gz /tmp/data/ARCHIVE/java.tar.gz /tmp/data/ARCHIVE/dat.tar.gz /tmp/data/ARCHIVE/cpp.tar.gz /tmp/data/ARCHIVE/py.tar.gz /tmp/data/ARCHIVE/create_archives.sh.tar.gz /tmp/data/ARCHIVE/cxx.tar.gz

```

and I wanted to upload them to a new dataset called `vanessa/code-images`. My arguments are thus the following:

 - **username** your kaggle username, or the name of an organization that the dataset will belong to
 - **title** the title to give the dataset (put in quotes if you have spaces)
 - **name** the name of the dataset itself (no spaces or special characters, and good practice to put in quotes)
 - **keywords** comma separated list of keywords (no spaces!)
 - **files** full paths to the data files to upload

My command looked like this:

```bash

python create_dataset.py --keywords software,languages --files $uploads --title "Zenodo Code Images" --name "code-images" --username stanfordcompute

```

It will generate a temporary directory with a data package:

```bash
Data package template written to: /tmp/tmp3559572b/datapackage.json
```

And add your fields to it, for example, here is how my temporary folder was filled:


```bash

$ ls /tmp/tmp3559572b/
c.tar.gz    css.tar.gz  datapackage.json  java.tar.gz  map.tar.gz  txt.tar.gz
cc.tar.gz   csv.tar.gz  f90.tar.gz        js.tar.gz    md.tar.gz   xml.tar.gz
cpp.tar.gz  cxx.tar.gz  go.tar.gz         json.tar.gz  py.tar.gz
cs.tar.gz   dat.tar.gz  html.tar.gz       m.tar.gz     r.tar.gz

```

And then it will show you the metadata file:

```bash

{
 "title": "Zenodo Code Images",
 "id": "stanfordcompute/code-images",
 "licenses": [
  {
   "name": "other"
  }
 ],
 "keywords": [
  "software",
  "languages"
 ],
 "resources": [
  {
   "path": "cs.tar.gz",
   "description": "cs.tar.gz, part of Zenodo Code Images Dataset, 6/2018, MIT License"
  },
  {
   "path": "m.tar.gz",
   "description": "m.tar.gz, part of Zenodo Code Images Dataset, 6/2018, MIT License"
  },
  {
   "path": "js.tar.gz",
   "description": "js.tar.gz, part of Zenodo Code Images Dataset, 6/2018, MIT License"
  },
...

  {
   "path": "cxx.tar.gz",
   "description": "cxx.tar.gz, part of Zenodo Code Images Dataset, 6/2018, MIT License"
  }
 ]
}


```

At this point you will see your files start to upload, and it will show a URL when finished!
Note that the dataset takes some time to process, so you might get a 404 for a bit while this
is happening.

```bash
Starting upload for file cs.tar.gz
100%|███████████████████████████████████████| 49.3M/49.3M [01:13<00:00, 708kB/s]
Upload successful: cs.tar.gz (49MB)
Starting upload for file m.tar.gz
...
Upload successful: cxx.tar.gz (57MB)
The following URL will be available after processing (10-15 minutes)
https://www.kaggle.com/stanfordcompute/code-images

result
https://www.kaggle.com/stanfordcompute/code-images
```

Since there is a lot of additional metadata and description / helpers needed on your
part for the dataset, it's recommended (and essential) to go to the URL when it's available
and do things like add an image, description, examples, etc.

## Development
It's nice to develop in the container, and the easiest way to do that is to bind the 
present working directory (with the dataset generation script) to `/code` in the container.
That way, you can work in a local text editor, and changes you make to the file persist
in the container.

```bash
docker run -v /home/vanessa/.kaggle:/root/.kaggle -v $PWD/:/code -v $HOME/code-images:/tmp/data -it vanessa/kaggle bash
```

Have a question or want to contribute? You can [open an issue](https://www.github.com/vsoch/kaggle/issues) or 
pull request.
